#!/usr/bin/bash
# ------------------------------------------------------------------------------
# 変数定義
# ------------------------------------------------------------------------------
# 共通変数ファイル読込
com_env="$(cd $(dirname $0); pwd)/../conf/com_vars.sh"
if [[ -f ${com_env} ]]; then
    source ${com_env}
else
    exit 1
fi

# 共通関数ファイル読込
if [[ -f ${COMMON_FUNCTION} ]]; then
    source ${COMMON_FUNCTION}
else
    echo -e "\033[0;31mCommon function file does not exist.\033[0m\n"
    exit 2
fi

# wp post list で使用するフィールド設定
FIELDS="ID,post_name"

# ------------------------------------------------------------------------------
# メイン処理
# ------------------------------------------------------------------------------
# 実行日が第五週目かを判定する。
# ------------------------------------------------------------------------------
func_get_num_sunday $(date '+%Y:%m:%d')
if (( $? == 5 )); then
    TEXT=$(cat << EOT

第5週目のため、練習はお休みです。
※ 振替に注意してくだい。

EOT
)
    func_send_notify "${TEXT}"
    exit 0
fi

# 前回の練習日取得
check_flg=1
weight=1

while (( check_flg == 1 )); do

    # 前回練習日までのインターバルを設定する。
    (( interval = 7 * ${weight} ))

    # 1週間前の日曜日の週番号を取得する。
    func_get_num_sunday $(date '+%Y:%m:%d' --date "${interval} days ago")
    if (( $? != 5 )); then
        check_flg=0
    else
        (( weight += 1 ))
    fi
done

# 前回の練習日時を YYYY-MM-DD 形式に変換
LAST_DAT=$(printf "%04d-%02d-%02d\n" ${CHECK_YEAR} ${CHECK_MONTH} ${CHECK_DAY})
if [[ ${LAST_DAT} == "0000-00-00" ]]; then
    logger -ip cron.warn "${SCRIPT_NAME}: Getting last date has failed."
    exit 1
fi

func_send_mon_notify "Line Notify Last day is ${LAST_DAT}"

# 投稿一覧から前回練習の投稿IDを取得する。
POST_ID=$(${WP_CLI} post list --format=csv --fields=${FIELDS} | \
    awk -F',' -v LAST_DAT=${LAST_DAT} '{if($2 ~ LAST_DAT"_practice") print $1}')

if [[ -z ${POST_ID} ]]; then
    logger -ip cron.warn "${SCRIPT_NAME}: Getting ${LAST_DAT}'s post has failed."

    TEXT=$(cat << EOT

    ${LAST_DAT}の練習内容は投稿されてません💦
EOT
)
    func_send_notify "${TEXT}"
    exit 2
fi

# 投稿IDから投稿内容を取得する。
TEXT=$(cat << EOT


📝 本日の練習前にご確認ください 📝
------------------------------
$(${WP_CLI} post get ${POST_ID} --field=content | sed -e 's/<[^>]*>//g' -e 's/&nbsp;//g' -e '/紅白戦の模様/d' | sed -e '/^$/{N; /^\n$/D;}')
EOT
)

# Sticker を設定する。
STIKER=$(func_get_sticker)

# Line Notify でのメッセージ通知
STATUS=$(func_send_notify "${TEXT}" ${STIKER})
func_send_mon_notify "Line Notify status:${STATUS}"
logger -ip cron.info "${SCRIPT_NAME}:${STATUS}"

exit 0

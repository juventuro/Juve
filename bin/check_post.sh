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
FIELDS="post_name,post_modified,post_status"

# ------------------------------------------------------------------------------
# メイン処理
# ------------------------------------------------------------------------------
# 前日の日付を取得する。
CHECK_DATE=$(date '+%Y-%m-%d' --date "1 days ago")
if [[ -z ${CHECK_DATE} ]]; then
    logger -ip cron.warn "${SCRIPT_NAME}: Getting check date has failed.(${CHECK_DATE})"
#else
#    func_send_mon_notify "Check date is ${CHECK_DATE}"
fi

# 前日に投稿されたメッセージを抽出する。
#   wp post list の post_modified フィールドの更新日から取得します。
POST_URLS=$(${WP_CLI} post list --format=csv --fields=${FIELDS} | \
    awk -F',' -v CHECK_DATE=${CHECK_DATE} '{if($2 ~ CHECK_DATE && $3 == "publish") print "juventuro.com/"$1}')
if [[ -z ${POST_URLS} ]]; then
    exit 0
fi

# メッセージを追加
TEXT=$(cat << EOT

👨🏻‍💻 $(echo ${POST_URLS} | wc -w)件の投稿が追加(更新)されました。
------------------------------------
$(
    for URL in ${POST_URLS}; do
        echo ${URL}
    done
)
EOT
)

# Line Notify でのメッセージ通知
STATUS=$(func_send_notify "${TEXT}" 2 161)
#func_send_mon_notify "Line Notify status:${STATUS}"
logger -ip cron.info "${SCRIPT_NAME}:${STATUS}"

exit 0

#! /usr/bin/bash
# ------------------------------------------------------------------------------
# 共通関数定義
# ------------------------------------------------------------------------------

# エラー出力関数
function func_disp_error_msg() {
    echo -e "${ANSI_RED}${@}${ANSI_END}\n"
}

# 警告出力関数
function func_disp_warning_msg() {
    echo -e "${ANSI_YELLOW}${@}${ANSI_END}\n"
}

# ------------------------------------------------------------------------------
# LINE Notify
# ------------------------------------------------------------------------------
function func_send_notify() {
    CONTENT=${1}
    STKPKGID=${2:-1}
    STKID=${3:-106}
    curl -X POST \
        -H "Authorization: Bearer ${ACCESS_TOKEN}" \
        -F "message=${CONTENT}" \
        -F "stickerPackageId=${STKPKGID}" \
        -F "stickerId=${STKID}" \
        ${API_URL}
}

# ------------------------------------------------------------------------------
# Sticker
# ------------------------------------------------------------------------------
function func_get_sticker() {
    STK_QTY=$(echo ${STK_LIST} | wc -w)
    FIELD_NUM=$(( ${RANDOM} % ${STK_QTY} + 1 ))
    echo ${STK_LIST} | \
        cut -d' ' -f ${FIELD_NUM} | \
        sed "s|:| |g"
}

# ------------------------------------------------------------------------------
# 第何日曜日かを取得する
# ------------------------------------------------------------------------------
function func_get_num_sunday() {
    CHECK_DATE=$1

    IFS=':'
    set -- ${CHECK_DATE}
    CHECK_YEAR=$1
    CHECK_MONTH=$2
    CHECK_DAY=$3

    IFS=$' \t\n'

    RECORDS=$(cal -m ${CHECK_MONTH} ${CHECK_YEAR} | awk -v LAST_DAY=${CHECK_DAY} '{if($NF == LAST_DAY) print NR}')
    (( NUMBER = RECORDS - 2 ))
    return ${NUMBER}
}


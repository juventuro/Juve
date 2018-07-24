#!/usr/bin/bash
# ------------------------------------------------------------------------------
# 共通変数定義
# ------------------------------------------------------------------------------
export LANG=C
export SCRIPT_NAME=${0##*/}

# 共通ディレクトリ定義
# ------------------------------------------------------------------------------
SCRIPT_EXEC_BIN=${0%/*}
SCRIPT_ROOT_DIR=$(cd ${SCRIPT_EXEC_BIN}/../; pwd)
SCRIPT_CONF=${SCRIPT_ROOT_DIR}/conf
SCRIPT_BIN=${SCRIPT_ROOT_DIR}/bin

# 共通シェル定義
export COMMON_FUNCTION=${SCRIPT_BIN}/com_func.sh

# 処理用変数定義
# ------------------------------------------------------------------------------
# 実行ノード名取得
export SCRIPT_EXEC_NODE=$(uname -n)

# Wordpress関連
# ------------------------------------------------------------------------------
WP_CLI="sudo -u kusanagi -- /usr/local/bin/wp --path=/home/kusanagi/juve/DocumentRoot/"

# Line Notify
# ------------------------------------------------------------------------------
# アクセストークン
# ------------------------------------------------------------------------------
#    - 暗号化の方法
#     ACCESS_TOKEN=XXXXXXXX
#     OpenSSL_key=~/.ssh/id_rsa.pem
#     echo ${ACCESS_TOKEN} | \
#         openssl rsautl -encrypt -pubin -inkey ${OpenSSL_key} | \
#         openssl base64 -e
#
# ------------------------------------------------------------------------------
# 暗号アクセストークン
# ------------------------------------------------------------------------------
#   - モニタ用
ENC_MON_ACCESS_TOKEN=""
#   - 商用
ENC_ACCESS_TOKEN="
ND52b48n0eJnweNq/W26e4VHYa6/x3TvL9WpJ2Pe60FlAtUAf+CoWH4zpNfxyjPM
nxRWwF0L6lOJyyACm/JR2nPlKQF1zglnmk2kXqmZiCN/pnbtZCGwo57K7wEldVs5
tRifhcXOWUogQgHhN0dqcRxbrzFjLrSJ0hRIGcktvdDfaP7NoM8jWQa5Ar2jos5J
siGv/nYTNrRSQ/SrNtuGngD8yxPkyogH8Y295bjbdGFPhRG/7ibnFF8/ZHg/TFaD
R6hXuj6CMzNP8YSaztG/Yd18UZRH7+dS89HBYrBHzuCKjDoUQxgKTDue3VtnXUCV
sDu31CI/lr9Y22XlG/q13A==
"

# アクセストークン復号化
# ------------------------------------------------------------------------------
export MON_ACCESS_TOKEN=$(
    echo ${ENC_MON_ACCESS_TOKEN} | \
        openssl base64 -d | \
        openssl rsautl -decrypt -inkey ~/.ssh/id_rsa
)

export ACCESS_TOKEN=$(
    echo ${ENC_ACCESS_TOKEN} | \
        openssl base64 -d | \
        openssl rsautl -decrypt -inkey ~/.ssh/id_rsa
)
export API_URL="https://notify-api.line.me/api/notify"

# Stikerリスト
# ------------------------------------------------------------------------------
export STK_LIST="
1:2
1:107
1:114
1:407
2:31
2:34
2:504
"

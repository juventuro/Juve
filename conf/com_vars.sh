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
evgyMx+y8NfTkbxmVpvZXCq2aBU8z9TOR/tXxgOJdv1I6io1nu+SqhUg0hGV77fz
DYhxg5Z6m1fqelQKA8Ih1aLN4vP7WQQnYZYvjR9OMwK94fampKOlH1IKLKTIeVMQ
60W/GTw8RRC2tv63oYQnzuf8KLzDE27loG5Rl7p/8/oS8HxZ85QMsYdmC4GNjWuf
ZnrWUhCUDczKVXHDFh9AUN9wh65FHBDGMDtUkbbRaEpf882dIjkJy4XAuui7Nees
N4T+yp5saROT36+O/X4eRtqTMcrsk6LPPAiTBTjaXTrBGibtZIUjuHQKaPDcWxQL
C5zFMFz6Br2JIUrt1UIwtw==
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

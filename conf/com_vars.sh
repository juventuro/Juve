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
#   - 検証
# ENC_ACCESS_TOKEN="
# Uni0E6c/IENzr8pS8Zf5EUWzaNZHsIyOTwPORbsq1sVYcq26Gbq9BkcXU9+ObEqP
# f1lUbn+Zd4xCeypXDDFa+bO7QO3LITtVb0MOeKgMPl1zJxtqGV5B92rMrmvL60hU
# /sGhNm05f1Gzx2t8XQIxRb+g5OSwv9rk1vc1Q2eg9QKSoTS4EnuYy5ObPaIBcmBC
# Ek8I2opGQvcbV+t8sokrxn6z5MM512q7cVItbPblcWIRXMmo0zkCUDMIGMOydT2B
# 4qwpAFd4U/H0hVPBCynPzzHX0lsduBkAPG0MI9Pt04CdXeBxpnpLeEJN4ChqFXCK
# 3Uq3f9MQRk0LuiwLhh28Xw==
# "
#   - 商用
ENC_ACCESS_TOKEN="
u9/lWTrjx9V3PgavnWCvBjWn3IgSMCWKU2lCqT5OF/fqnuUzPDQYkcJxBYiAjnDe
5dIkEunSsaYrm0BOWi8IKwMFam2PExnjRqP+Fcv/ZPKgmBv3syQRNBuxt3vrV4U7
cHnX51DPbdpR0ukJb2/bTLEfYyghvt8CnwS8yApOEup+MtLB0R3ueo5ikEQoaDah
qXEfDyYECnivtBqkfNoYhzbz/UwTT5mXORmwpl8xMKOi+uq6UUMRWxLe4uMdQvqG
PuxM78ZHNnqCnMhKomqYKOXs7STZsVJwgZVzAoZDiFrrzjAPu4RVf6AEV8dOCTMG
/H3BmOoHgKy34xQkdf22EA==
"

export ACCESS_TOKEN=$(
    echo ${ENC_ACCESS_TOKEN} | \
        openssl base64 -d | \
        openssl rsautl -decrypt -inkey ~/.ssh/id_rsa
)
export API_URL="https://notify-api.line.me/api/notify"

# Stikerリスト
export STK_LIST="
1:2
1:107
1:114
1:407
2:31
2:34
2:504
"
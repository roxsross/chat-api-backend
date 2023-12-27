#!/bin/bash
# set -x
source ./automation/auto_config.sh
source ./automation/auto_getenv.sh

BOT_URL="https://api.telegram.org/bot5881753165:AAEjB95ZRDUW0kRMCzMA7C1yjpHemiGTpiM/sendMessage"
TELEGRAM_CHAT_ID="-1001508340482"
PARSE_MODE="Markdown"
COMMIT=$(git log -1 --pretty=format:"%s")
BUILD_STATUS="SUCCESS"

send_msg () {
    curl -s -X POST ${BOT_URL} -d chat_id=$TELEGRAM_CHAT_ID \
        -d text="$1" -d parse_mode=${PARSE_MODE}
}

send_msg "
\`------------------------------------\`
Deploy 🚀*${BUILD_STATUS}!*
\`Repo 📦:  ${REPOSITORY}\`
\`Branch 🏷:      ${BRANCH_NAME}\`
\`Version ✅:      ${VERSION}\`
\`Autor ✅:      ${GIT_USER}\`
*Commit Msg 💭:*
_${COMMIT}_
[Job Log view here 🤟](${BUILD_URL})
\`-------------------------------------\`
"
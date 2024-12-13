#!/bin/bash

# check_variable(){
#     var=$1
#     desc=$2
#     if [ -n "$var" ]; then 
#         echo $desc variable is set
#     else
#         echo $desc variable is not set
#         exit 1
#     fi
# }

    # check_variable "$GITHUB_PAT" '$GITHUB_PAT'
    # check_variable "$GITHUB_PROJECT" '$GITHUB_PROJECT'
    # check_variable "$GITHUB_PROJECT_OWNER" '$GITHUB_PROJECT_OWNER'

REPO=$GITHUB_PROJECT
OWNER=$GITHUB_PROJECT_OWNER
REPO_URL="https://github.com/${OWNER}/${REPO}"

# get runners registration token
curl_output=$(curl -s -X POST \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${GITHUB_PAT}" \
"https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token"
)
GITHUB_RUNNER_TOKEN=$(echo $curl_output | jq -r  .token)
check_variable "$GITHUB_RUNNER_TOKEN" '$GITHUB_RUNNER_TOKEN'
/home/runner/config.sh --unattended --token $GITHUB_RUNNER_TOKEN --url $REPO_URL

# configure(){
# }

# RUNNER_FILE_LOCATION="/home/runner/.runner"
# REGISTRATION_FILE_LOCATION="home/runner/.registration"
# if [ -e "$RUNNER_FILE_LOCATION" ] && [ -e "$REGISTRATION_FILE_LOCATION" ]; then
#     echo "RUNNER ALREADY CONFIGURED"
# else
#     echo "Configuring runner"
#     configure
# fi

# cleanup() {
#     echo "Removing runner..."
#     ./config.sh remove --unattended --token ${REG_TOKEN}
# }

# trap 'cleanup; exit 130' INT
# trap 'cleanup; exit 143' TERM

# Start the runner
# /home/runner/run.sh

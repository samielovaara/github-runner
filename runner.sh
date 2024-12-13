#!/bin/bash
 
set -u -e

# FUNCTIONS

print_help() {
    echo "Usage: $0 <command> [options] [arguments]"
    echo
    echo "Options:"
    echo "  --help, -h                Show this help message and exit."
    echo "  --image, -i <image>       Specify the Docker image to use."
    echo "  --command, -c <command>   Specify the Docker command to run (e.g., run, exec)."
    echo
    echo "Examples:"
    echo "  $0 --image ubuntu --command run bash"
    echo "  $0 -i nginx -c exec -it"
    exit 0
}

check_docker_image_tag_exists(){
    TAG=$1
    IMAGE_NAME="github-runner"

    # Check if the image with the specified tag exists locally
    if docker image inspect "${IMAGE_NAME}:${TAG}" &> /dev/null; then
        echo "Image ${IMAGE_NAME}:${TAG} exists locally."
        return 0
    fi

    echo "Image ${IMAGE_NAME}:${TAG} does not exist."
    exit 1
}

build() {
    PROJECT_NAME=$1

    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed. Please install Docker and try again."
        exit 1
    fi

    # Continue with the script
    echo "Docker is installed. Proceeding with the script..."
    
    docker build -t "github-runner:$PROJECT_NAME" ..

}

start(){
    PROJECT_NAME=$1
    PROJECT_OWNER=$2
    GITHUB_PAT=$3

    check_docker_image_tag_exists $PROJECT_NAME

    # get token
    curl_output=$(curl -s --fail -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_PAT}" \
    "https://api.github.com/repos/${PROJECT_OWNER}/${PROJECT_NAME}/actions/runners/registration-token"
    )
    echo "$curl_output"
    GITHUB_RUNNER_TOKEN=$(echo $curl_output | jq -r  .token)

    REPO_URL="https://github.com/${PROJECT_OWNER}/${PROJECT_NAME}"

    # ENTRYPOINT_COMMAND="./home/runner/config.sh --unattended --token $GITHUB_RUNNER_TOKEN --url $REPO_URL && ./home/runner/run.sh"
    # docker run -d --entrypoint "${ENTRYPOINT_COMMAND}" "github-runner:$PROJECT_NAME"

    ENTRYPOINT_COMMAND="/home/runner/config.sh --unattended --token $GITHUB_RUNNER_TOKEN --url $REPO_URL && /home/runner/run.sh"
    docker run -d --entrypoint "sh" "github-runner:$PROJECT_NAME" -c "$ENTRYPOINT_COMMAND"

}

stop(){
    TAG=$1
    CONTAINER_NAME=$(docker ps --filter "ancestor=github-runner:${TAG}" --format "{{.Names}}")
    echo $CONTAINER_NAME
    docker container stop $CONTAINER_NAME

    CURL_OUTPUT=$(curl -s --fail \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_PAT}" \
    https://api.github.com/repos/$PROJECT_OWNER/$PROJECT_NAME/actions/runners/remove-token
    )
    if [ $? -ne 0 ]; then
        echo "curl command failed, make sure you provided correct variables"
    fi

    GITHUB_RUNNER_TOKEN=$(echo $curl_output | jq -r  .token)
    docker run --entrypoint "/home/runner/config.sh remove --unattended --token ${GITHUB_RUNNER_TOKEN}" \
    "github-runner:${PROJECT_NAME}"
}

if [ -z "$1" ]; then
    echo "Error: No command specified."
    echo "Usage: $0 <command> [options]"
    exit 1
fi

# Capture the first argument as the command
command="$1"
shift  # Remove the first argument so that other arguments can be processed
NAME=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --help|-h)
            print_help
            ;;
        --project-name|-n)
            NAME="$2"
            shift 2
            ;;
        --project-owner|-o)
            OWNER="$2"
            shift 2
            ;;
        --github-pat|-g)
            PAT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

if [[ -z "$NAME" ]]; then
    echo "Error: --project-name is required."
    echo "Use --help for usage information."
    exit 1
fi

case "$command" in
    build)
        echo "Running 'build' command for project: $NAME"
        # Here you can call your specific build command logic
        build $NAME
        ;;
    start)
        echo "Running 'start' command for project: $NAME"
        # Here you can call your specific build command logic
        start $NAME $OWNER $PAT
        ;;
    stop)
        echo "Running 'stop' command for project: $NAME"
        # Here you can call your specific build command logic
        stop $NAME
        ;;
    *)
        echo "Unknown command: $command"
        echo "Usage: $0 <build|configure> [options]"
        exit 1
        ;;
esac

# 6. kun työntää kamaa työnnä dev haaralle. tee pul req, linkkaa pul req tuomakselle
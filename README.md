# GitHub Runner Management Script

This script provides an interface to manage self-hosted GitHub Action runners using Docker. It supports building runner images, starting runners for repositories, and stopping them.

## Prerequisites

- **Docker**: Ensure Docker is installed and running on your system.
- **GitHub Personal Access Token (PAT)**: Generate a PAT with appropriate repository permissions for managing runners.

## Usage

```bash
./runner.sh <command> [options]
```

### Commands

- **build**: Build a Docker image for the specified project.
- **start**: Start a self-hosted runner for the specified project.
- **stop**: Stop the self-hosted runner for the specified project.

### Options

- `--help, -h`: Show help message and exit.
- `--project-name, -n`: Specify the project name (required).
- `--project-owner, -o`: Specify the project owner (required for `start` and `stop`).
- `--github-pat, -g`: Specify the GitHub Personal Access Token (required for `start` and `stop`).

## Examples

### Build a Runner Image
```bash
./runner.sh build --project-name myproject
```

### Start a Runner
```bash
./runner.sh start --project-name myproject --project-owner myusername --github-pat mygithubpat
```

### Stop a Runner
```bash
./runner.sh stop --project-name myproject --project-owner myusername --github-pat mygithubpat
```

## Script Workflow

1. **Build**:
    - Verifies Docker is installed.
    - Builds a Docker image tagged with the project name.
2. **Start**:
    - Checks if the Docker image for the project exists.
    - Retrieves a registration token from GitHub for the repository.
    - Starts a Docker container as a GitHub Actions runner.
3. **Stop**:
    - Finds and stops the running container for the specified project.
    - Removes the runner from the GitHub repository.

## Notes

- Ensure your GitHub PAT has `repo` permissions for private repositories or `public_repo` for public repositories.
- Use `--help` to view usage details for any command.

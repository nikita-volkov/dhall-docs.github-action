# Copilot Instructions for dhall-docs.github-action

## Project Overview

This repository contains a GitHub Action that generates documentation for Dhall packages using the `dhall-docs` tool. The action is implemented as a Docker-based GitHub Action that can be used in workflows to automatically generate and publish Dhall documentation.

## Architecture

### Core Components

- **action.yml**: GitHub Action metadata file defining inputs, outputs, and execution method
- **docker/Dockerfile**: Docker image definition that installs dhall-docs and dependencies  
- **docker/entrypoint.bash**: Entry point script that runs dhall-docs and handles output
- **.github/workflows/release.yaml**: CI/CD pipeline for building and releasing new versions

### Action Behavior

1. Takes an optional `input` parameter (path to source directory, defaults to current directory)
2. Runs `dhall-docs` tool to generate documentation
3. Converts symlinked output to real directory structure
4. Provides command output status

## Development Workflow

### Docker Image
- Base image: Ubuntu 25.10
- Dependencies: cabal-install, libghc-zlib-dev
- dhall-docs version: 1.0.12 (installed via cabal)

### Build Process
The action uses a pre-built Docker image hosted on GitHub Container Registry. The image is built and updated through the release workflow.

### Release Process
1. Push to `major`, `minor`, or `patch` branches triggers release workflow
2. Docker image is built and pushed to GHCR
3. action.yml is updated with new image reference
4. Version is bumped and tagged
5. GitHub release is created
6. Changes are merged to master branch

## Key Files and Their Purpose

- **action.yml**: Defines the GitHub Action interface, inputs, outputs, and Docker image reference
- **docker/Dockerfile**: Sets up the runtime environment with dhall-docs and dependencies
- **docker/entrypoint.bash**: 
  - Executes dhall-docs with provided input
  - Handles symlink conversion for GitHub Actions compatibility
  - Sets appropriate output variables
- **LICENSE**: MIT license for the project

## Dependencies

### Runtime Dependencies
- dhall-docs (Haskell tool for generating Dhall documentation)
- bash (for entry point script)
- Ubuntu base system

### Build Dependencies  
- cabal-install (Haskell package manager)
- libghc-zlib-dev (GHC Zlib development libraries)

## Testing

Currently, the repository does not include automated tests. When adding tests, consider:
- Testing the Docker image builds successfully
- Validating dhall-docs execution with sample Dhall files
- Verifying output directory structure and content

## Coding Standards

### Shell Scripts
- Use `#!/bin/bash -e` for error handling
- Include comprehensive error checking and user feedback
- Use meaningful variable names and comments for complex logic

### Docker
- Use specific Ubuntu version for reproducibility
- Clean up build artifacts to minimize image size
- Copy only necessary files to container

### GitHub Actions
- Use semantic versioning for releases
- Include descriptive commit messages
- Maintain backwards compatibility in action interface

## Common Development Tasks

### Updating dhall-docs Version
1. Modify the cabal install command in Dockerfile
2. Test the build locally if possible
3. Update through the standard release process

### Modifying Entry Point Logic
1. Edit docker/entrypoint.bash
2. Ensure error handling is maintained
3. Test symlink conversion functionality
4. Verify GitHub Actions output format

### Action Interface Changes
1. Update action.yml inputs/outputs as needed
2. Maintain backwards compatibility when possible
3. Update documentation if interface changes

## Troubleshooting

### Common Issues
- **Symlink problems**: The entrypoint script includes logic to convert symlinks to real directories for GitHub Actions compatibility
- **Permission issues**: The script checks for write permissions before attempting file operations
- **Build failures**: Usually related to cabal dependencies or Ubuntu package availability

### Debugging
- Check Docker build logs for dependency installation issues
- Verify dhall-docs can process the input files
- Ensure proper file permissions in the output directory
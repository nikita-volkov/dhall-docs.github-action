# Dhall Documentation Generator Action

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-dhall%20docs-blue?colorA=24292e&colorB=0366d6)](https://github.com/marketplace/actions/dhall-docs)
[![CI](https://img.shields.io/github/actions/workflow/status/nikita-volkov/dhall-docs.github-action/release.yaml)](https://github.com/nikita-volkov/dhall-docs.github-action/actions)

A GitHub Action that generates beautiful documentation for [Dhall](https://dhall-lang.org/) packages using the `dhall-docs` tool. Perfect for automatically building and deploying Dhall package documentation to GitHub Pages.


## 📖 Real-World Example

See this action in use by the **[typeclasses.dhall](https://github.com/nikita-volkov/typeclasses.dhall)** repository, which deploys documentation to **[GitHub Pages](https://nikita-volkov.github.io/typeclasses.dhall/)**. It achieves that by using the [deploy-dhall-docs-to-github-pages](https://github.com/nikita-volkov/deploy-dhall-docs-to-github-pages.github-actions-workflow) workflow that leverages this action.

## 🚀 Quick Start

### Basic Usage

```yaml
name: Generate Dhall Documentation

on:
  push:
    branches: [ main, master ]

jobs:
  generate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Generate Dhall Documentation
        uses: nikita-volkov/dhall-docs.github-action@v0.3
        with:
          input: .                    # Path to your Dhall source files
          package-name: my-package    # Name of your package
```

### Deploy to GitHub Pages

For a complete workflow that generates documentation and deploys it to GitHub Pages, use the reusable workflow:

```yaml
name: Deploy Dhall Documentation to GitHub Pages

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build-docs:
    uses: nikita-volkov/deploy-dhall-docs-to-github-pages.github-actions-workflow/.github/workflows/main.yaml@master
    with:
      input: src                # Path to your Dhall source directory
      package-name: my-package  # Your package name
    secrets: inherit
```

## 📋 Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `input` | Path to the Dhall source directory | No | `.` (current directory) |
| `package-name` | Name of the package for documentation | No |  |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `path` | Path to the generated documentation directory |

## 🔧 Advanced Usage

### Using the Output Path

```yaml
- name: Generate Documentation
  id: docs
  uses: nikita-volkov/dhall-docs.github-action@v0.3
  with:
    input: src
    package-name: my-dhall-lib

- name: Upload Documentation Artifact
  uses: actions/upload-artifact@v4
  with:
    name: documentation
    path: ${{ steps.docs.outputs.path }}
```

### Custom Source Directory

```yaml
- name: Generate Documentation for Source Directory
  uses: nikita-volkov/dhall-docs.github-action@v0.3
  with:
    input: dhall-src
    package-name: my-custom-package
```

## 🏆 Success Stories

### typeclasses.dhall

The [**typeclasses.dhall**](https://github.com/nikita-volkov/typeclasses.dhall) repository showcases this action perfectly:

- **Repository**: https://github.com/nikita-volkov/typeclasses.dhall
- **Live Documentation**: https://nikita-volkov.github.io/typeclasses.dhall/
- **Workflow**: Automatically builds and deploys documentation on every push to master

This demonstrates how easy it is to maintain up-to-date documentation for Dhall packages using this action.

## 🛠️ How It Works

1. **Input Processing**: The action takes your Dhall source files from the specified input directory
2. **Documentation Generation**: Uses `dhall-docs` (version 1.0.12) to generate comprehensive HTML documentation
3. **Output Preparation**: Processes the generated documentation and provides the output path
4. **Integration Ready**: The output can be easily integrated with deployment actions for GitHub Pages or other hosting solutions

# Dhall Documentation Generator Action

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Dhall%20Docs%20Generator-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAM6wAADOsB5dZE0gAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAERSURBVCiRhZG/SsMxFEZPfsVJ61jbxaF0cRQRcRJ9hlYn30IHN/+9iquDCOIsblIrOjqKgy5aKoJQj4n3NQ+4fDl3OF0+fDl3ZpJdOXxUwxkFPEg7f5qGTaNOiKiqBBVvU7OiK74vVmDCNlRLSSTh1vHVj+pqN4S3NHdNWLhS9qcPwZVNy/Vf3IZ8lf8O/N0v/9Gvf3Y8lHTaS8GUXZ7lU8gNtA+gTNmZ/8t/w7m8V6U/e/hY8Uo8k1lNxvP+BMBJ6U/oT4v8R9xGlcFzr7M3VYe28vQMkGvVy6MPcQVOwPP5iGLgn5fofzR+PO3p9j0Dj4fQ7Zc9z3Hb3o5v8Gc2FHa6/yW2n8B6Cj9PfgEhp02FxfJoWAAAAABJRU5ErkJggg==)](https://github.com/marketplace/actions/dhall-docs-generator)
[![CI](https://img.shields.io/github/actions/workflow/status/nikita-volkov/dhall-docs.github-action/release.yaml)](https://github.com/nikita-volkov/dhall-docs.github-action/actions)
[![License](https://img.shields.io/github/license/nikita-volkov/dhall-docs.github-action)](LICENSE)

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

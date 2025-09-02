# Dhall Documentation GitHub Action

Generate documentation for Dhall packages using the `dhall-docs` tool.

## Usage

### Basic Usage

```yaml
- name: Generate Dhall Documentation
  id: dhall-docs
  uses: nikita-volkov/dhall-docs.github-action@v1
  with:
    input: .  # Path to source directory (optional, defaults to current directory)
    
- name: Use generated documentation
  run: |
    echo "Documentation generated at: ${{ steps.dhall-docs.outputs.path }}"
    ls -la "${{ steps.dhall-docs.outputs.path }}"
```

### Upload as Artifact

```yaml
- name: Generate Dhall Documentation
  id: dhall-docs
  uses: nikita-volkov/dhall-docs.github-action@v1
  with:
    input: ./dhall-src
    upload-artifact: 'true'
    
- name: Upload documentation
  uses: actions/upload-artifact@v3
  with:
    name: dhall-documentation
    path: ${{ steps.dhall-docs.outputs.path }}
```

### Deploy to GitHub Pages

```yaml
- name: Generate Dhall Documentation
  id: dhall-docs
  uses: nikita-volkov/dhall-docs.github-action@v1
  
- name: Deploy to GitHub Pages
  uses: peaceiris/actions-gh-pages@v3
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    publish_dir: ${{ steps.dhall-docs.outputs.path }}
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `input` | Path to source directory | No | `.` |
| `upload-artifact` | Whether to upload documentation as workflow artifact | No | `'false'` |

## Outputs

| Output | Description |
|--------|-------------|
| `path` | Path to the generated documentation directory (relative to workspace) |

## Documentation Accessibility

The generated documentation is written to the GitHub Actions workspace, making it accessible to subsequent workflow steps. The output path is relative to the workspace root, allowing other actions to easily access and process the generated documentation.

## License

MIT
# comment-lang-detector

A GitHub Action for detecting specified languages (e.g., Chinese or Japanese) in comments within code files across multiple programming languages (YAML, Go, Java, Rust). Ideal for projects aiming to adhere to internationalization standards or maintain language-specific coding guidelines.

The Comment Language Detector (CLD) is a powerful tool designed to automate the detection of specified languages within code comments across your project's repository. This tool is particularly useful for teams seeking to maintain consistency in code documentation languages or for projects that require language-specific comment checks as part of their quality assurance processes.


## Using the Comment Language Detector GitHub Action

To leverage the Comment Language Detector in your GitHub Actions workflow, you have two main approaches for installation:

### Latest Version Installation

For users looking to utilize the most recent features and updates, installing the latest version is recommended:

```shell
go install github.com/kubecub/comment-lang-detector/cmd/cld@latest
```

### Specific Version Installation

For those who prefer stability over cutting-edge changes, specifying a version ensures consistent behavior across runs:

```shell
go install github.com/kubecub/comment-lang-detector/cmd/cld@v0.1.1
```

After installation, you can set an environment variable to indicate the configuration file path:

```shell
export CLD_CONFIG_PATH="./config.yaml"
```

### Usage

The CLD tool is executed by simply calling:

```shell
cld
```

This command will check for comments in the specified languages according to the configurations set in your `.github/code-language-detector.yml` or `config.yaml` file.

### Configuration

A crucial step in utilizing the CLD tool is to correctly set up your configuration file. The default configuration file location is `.github/code-language-detector.yml`. Here is an example configuration:

```yaml
directory: ./
file_types:
  - .go
  - .yaml
  - .yml
languages:
  - Chinese
```

This configuration instructs the CLD to scan the root directory (`./`) for files with `.go`, `.yaml`, and `.yml` extensions, specifically looking for comments written in Chinese.

### Integrating with GitHub Actions

To integrate the CLD tool with GitHub Actions, follow these steps to create a custom action within your repository:

1. **Create a Workflow File**: Navigate to your repository's `.github/workflows` directory and create a new YAML file, for example, `language-check.yml`.

2. **Define the Workflow**: Inside your YAML file, define the steps to install CLD, set the configuration file, and run the detector. Here's a sample workflow:

```yaml
name: Language Check Workflow

on: [push, pull_request]

jobs:
  comment-language-detector:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2

      - name: Set up Go
        uses: actions/setup-go@v2
        with:
          go-version: '^1.20'

      - name: Install CLD
        run: |
          go install github.com/kubecub/comment-lang-detector/cmd/cld@latest
      - name: Run Comment Language Detector
        run: cld
```

Or use actions:

```yaml
- name: Code Language Detector
  uses: kubecub/comment-lang-detector@v1.0.0
```


This workflow triggers on both push events and pull requests. It checks out the code, sets up the Go environment, installs the Comment Language Detector, and runs it against the codebase according to the specified configuration.

### Conclusion

The Comment Language Detector GitHub Action provides a robust solution for automatically ensuring that code comments adhere to specified language requirements. By integrating this tool into your GitHub Actions workflow, you can enhance code quality and maintain consistency across your project's documentation efforts.


## Configuration Strategy for Code Language Detector

The Code Language Detector (CLD) Action offers a flexible approach to configuration, allowing users to specify the path to their configuration file in several ways. This ensures ease of use and adaptability to various workflows. Below is the hierarchy in which the CLD Action searches for the configuration file:

1. **Command-Line Argument**:
    - The Action first checks if the configuration file path is provided as a command-line argument (`--config`). This method is ideal for users who wish to specify a custom configuration path directly in their workflow file.

    ```yaml
    steps:
      - name: Detect specified languages in comments
        uses: kubecub/comment-lang-detector@v1
        with:
          args: --config path/to/your/config.yaml
    ```

2. **Environment Variable**:
    - If the configuration file path is not specified as a command-line argument, the Action then looks for an environment variable named `CLD_CONFIG_PATH`. This method provides a flexible way to set the configuration path without modifying the workflow file.
    
    ```yaml
    steps:
      - name: Detect specified languages in comments
        uses: kubecub/comment-lang-detector@v1
        env:
          CLD_CONFIG_PATH: path/to/your/config.yaml
    ```

3. **Default Configuration Paths**:
    - In the absence of both a command-line argument and an environment variable, the Action attempts to locate the configuration file at default paths:
        - `config.yaml`: The root directory of the repository.
        - `.github/code-language-detector.yml`: Inside the `.github` folder, allowing for a clean repository structure.
        
    The Action will search for these files in the specified order. If `config.yaml` is found, it will be used; if not, the Action will look for `.github/code-language-detector.yml`.

4. **Error on Missing Configuration**:
    - If the Action cannot locate a configuration file through any of the aforementioned methods, it will terminate with an error message. This ensures that the Action only runs when it is properly configured, preventing unexpected behavior.

### Important Notes

- **Configuration File Format**: The configuration file must be in YAML format. Ensure that your configuration adheres to the required schema, which includes the languages and programming languages to be detected, among other settings.

- **Customizing the Configuration Path**: We recommend using the command-line argument or environment variable methods for specifying the configuration path when you have multiple workflows or need to adhere to different coding standards across projects.

This configuration strategy is designed to maximize flexibility and ease of use, ensuring that users can integrate the CLD Action into their workflows efficiently and effectively.

## user

+ [https://github.com/openimsdk/open-im-server](https://github.com/openimsdk/open-im-server)
+ [https://github.com/openimsdk/openkf](https://github.com/openimsdk/openkf)
+ [https://github.com/openimsdk/chat](https://github.com/openimsdk/chat)
+ [https://github.com/kubecub/github-label-syncer/](https://github.com/kubecub/github-label-syncer/)
+ [https://github.com/openkf/openkf-server](https://github.com/openkf/openkf-server)
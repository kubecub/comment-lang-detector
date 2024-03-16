<h1 align="center" style="border-bottom: none">
    <b>
        <a href="https://nsddd.top">comment-lang-detector</a><br>
    </b>
</h1>
<h3 align="center" style="border-bottom: none">
      ⭐️  sync labels between repos and org.  ⭐️ <br>
<h3>


<p align=center>
<a href="https://goreportcard.com/report/github.com/kubecub/comment-lang-detector"><img src="https://goreportcard.com/badge/github.com/kubecub/comment-lang-detector" alt="A+"></a>
<a href="https://github.com/kubecub/comment-lang-detector/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22good+first+issue%22"><img src="https://img.shields.io/github/issues/kubecub/comment-lang-detector/good%20first%20issue?logo=%22github%22" alt="good first"></a>
<a href="https://github.com/kubecub/comment-lang-detector"><img src="https://img.shields.io/github/stars/kubecub/comment-lang-detector.svg?style=flat&logo=github&colorB=deeppink&label=stars"></a>
<a href="https://join.slack.com/t/kubecub/shared_invite/zt-1se0k2bae-lkYzz0_T~BYh3rjkvlcUqQ"><img src="https://img.shields.io/badge/Slack-100%2B-blueviolet?logo=slack&amp;logoColor=white"></a>
<a href="https://github.com/kubecub/comment-lang-detector/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-Apache--2.0-green"></a>
<a href="https://golang.org/"><img src="https://img.shields.io/badge/Language-Go-blue.svg"></a>
</p>


<p align="center">
    <a href="./README.md"><b>English</b></a> •
    <a href="./README_zh-CN.md"><b>中文</b></a>
</p>

</p>

----

## Using the Comment Language Detector GitHub Action

A GitHub Action for detecting specified languages (e.g., Chinese or Japanese) in comments within code files across multiple programming languages (YAML, Go, Java, Rust). Ideal for projects aiming to adhere to internationalization standards or maintain language-specific coding guidelines.

The Comment Language Detector (CLD) is a powerful tool designed to automate the detection of specified languages within code comments across your project's repository. This tool is particularly useful for teams seeking to maintain consistency in code documentation languages or for projects that require language-specific comment checks as part of their quality assurance processes.


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


## Local Usage Guide for Comment Language Detector

The Comment Language Detector (CLD) offers a convenient way to detect specific languages within code comments across your projects. This guide will walk you through the steps for setting up and using CLD locally on your machine.

### Step 1: Download the Latest Release

1. Visit the [releases page](https://github.com/kubecub/comment-lang-detector/releases) of the Comment Language Detector on GitHub.
2. Download the latest release suitable for your operating system (Windows, macOS, Linux).

### Step 2: Install the Binary

After downloading, you'll need to make the binary executable and move it to a location in your system's PATH to make it easily accessible from the command line.

#### For Linux and macOS:

1. Open a terminal.
2. Navigate to the download location.
3. Make the binary executable with the following command:

```bash
chmod +x cld-linux // Use cld-macos if you're on macOS
```

4. Move the binary to a location in your PATH. A common choice is `/usr/local/bin`:

```bash
sudo mv cld-linux /usr/local/bin/cld // Use cld-macos if you're on macOS
```

#### For Windows:

- Extract the downloaded ZIP file.
- Move the `cld.exe` to a directory that is part of your system's PATH.

### Step 3: Set Up Environment Variable (Optional)

You can configure CLD using environment variables or a configuration file. To set up an environment variable for the configuration path:

#### For Linux and macOS:

Open your `.bashrc`, `.zshrc`, or equivalent shell configuration file and add:

```bash
export CLD_CONFIG_PATH="/path/to/your/config.yaml"
```

Replace `"/path/to/your/config.yaml"` with the actual path to your configuration file. Then, reload your shell configuration with `source ~/.bashrc` (or equivalent).

#### For Windows:

- Open the Start Search, type in "env", and choose "Edit the system environment variables."
- In the System Properties window, click on the "Environment Variables..." button.
- In the Environment Variables window, click "New" under the "User variables" section.
- Set the variable name to `CLD_CONFIG_PATH` and the variable value to the path of your configuration file.

### Step 4: Create a Configuration File

Create a `config.yaml` file in your project directory (or the location specified in the `CLD_CONFIG_PATH` environment variable) with the following structure:

```yaml
directory: ./
file_types:
  - .go
  - .yaml
  - .yml
languages:
  - Chinese
```

### Step 5: Running CLD

With CLD installed and configured, you can now run it to detect specified languages within code comments. Open a terminal or command prompt, navigate to your project directory, and execute:

```bash
cld
```

If you've set the `CLD_CONFIG_PATH` environment variable, CLD will use the specified configuration file. Otherwise, ensure you have a `config.yaml` in your project directory or specify the configuration file path directly when running CLD.


## user

+ [https://github.com/openimsdk/open-im-server](https://github.com/openimsdk/open-im-server)
+ [https://github.com/openimsdk/openkf](https://github.com/openimsdk/openkf)
+ [https://github.com/openimsdk/chat](https://github.com/openimsdk/chat)
+ [https://github.com/kubecub/github-label-syncer/](https://github.com/kubecub/github-label-syncer/)
+ [https://github.com/openkf/openkf-server](https://github.com/openkf/openkf-server)
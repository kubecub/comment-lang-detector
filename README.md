# comment-lang-detector

A GitHub Action for detecting specified languages (e.g., Chinese or Japanese) in comments within code files across multiple programming languages (YAML, Go, Java, Rust). Ideal for projects aiming to adhere to internationalization standards or maintain language-specific coding guidelines.

## Use





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

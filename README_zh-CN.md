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


## 使用 comment-lang-detector GitHub Action

**comment-lang-detector** 是一个 GitHub Action，用于检测代码文件中注释，或者代码的指定语言（例如中文或日本语），支持多种编程语言（YAML、Go、Java、Rust）。这对于希望遵守国际化标准或维护特定语言编码准则的项目非常理想。

要在您的 GitHub Actions 工作流中使用 Comment Language Detector，您有两种主要的安装方法：

### 安装最新版本

推荐希望使用最新功能和更新的用户安装最新版本：

```shell
go install github.com/kubecub/comment-lang-detector/cmd/cld@latest
```

### 安装特定版本

对于那些更注重稳定性而不是最新变化的用户，指定版本可以确保跨运行时的一致性：

```shell
go install github.com/kubecub/comment-lang-detector/cmd/cld@v0.1.1
```

安装后，您可以设置环境变量来指示配置文件路径：

```shell
export CLD_CONFIG_PATH="./config.yaml"
```

### 配置

使用 CLD 工具的一个关键步骤是正确设置您的配置文件。默认配置文件位置是 `.github/code-language-detector.yml`。这里有一个示例配置：

```yaml
directory: ./
file_types:
  - .go
  - .yaml
  - .yml
languages:
  - Chinese
```

这个配置指示 CLD 扫描根目录（`./`）下的 `.go`、`.yaml` 和 `.yml` 扩展名的文件，特别是查找用中文编写的评论。

### 与 GitHub Actions 集成

要将 CLD 工具与 GitHub Actions 集成，请按照以下步骤在您的存储库中创建一个自定义动作：

1. **创建工作流文件**：导航到您的存储库的 `.github/workflows` 目录并创建一个新的 YAML 文件，例如 `language-check.yml`。

2. **定义工作流**：在您的 YAML 文件中，定义安装 CLD、设置配置文件和运行检测器的步骤。这里有一个示例工作流：

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

或使用 actions:

```yaml
- name: Code Language Detector
  uses: kubecub/comment-lang-detector@v1.0.0
```

此工作流在 push 事件和拉取请求上触发。它检出代码，设置 Go 环境，安装评论语言检测器，并根据指定的配置运行它。

### 结论

Comment Language Detector GitHub Action 为自动确保代码评论符合指定语言要求提供了一个强大的解决方案。通过将此工具集成到您的 GitHub Actions 工作流中，您可以提高代码质量并保持项目文档工作的一致性。

## 配置策略

Code Language Detector (CLD) Action 提供了一种灵活的配置方法，允许用户以多种方式指定配置文件的路径。这确保了易用性和适应性。以下是 CLD Action 搜索配置文件的层次结构：

1. **命令行参数**：Action 首先检查是否提供了配置文件路径作为命令行参数（`--config`）。这种方法适用于希望在其工作流文件中直接

指定自定义配置路径的用户。

2. **环境变量**：如果没有以命令行参数指定配置文件路径，则 Action 接着会查找名为 `CLD_CONFIG_PATH` 的环境变量。这种方法提供了一种灵活的方式来设置配置路径，而无需修改工作流文件。

3. **默认配置路径**：如果既没有命令行参数也没有环境变量，Action 将尝试在默认路径查找配置文件：`config.yaml`：存储库的根目录；`.github/code-language-detector.yml`：位于 `.github` 文件夹内，允许清晰的存储库结构。Action 会按照指定的顺序搜索这些文件。

4. **缺少配置时错误**：如果 Action 通过上述任何方法都无法定位到配置文件，它将终止并显示错误消息。这确保了只有在正确配置的情况下 Action 才会运行，防止出现意外行为。

### 重要说明

- **配置文件格式**：配置文件必须是 YAML 格式。确保您的配置符合要求的模式，其中包括要检测的语言和编程语言等设置。

- **自定义配置路径**：我们建议在您有多个工作流或需要遵守跨项目不同的编码标准时，使用命令行参数或环境变量方法来指定配置路径。

这种配置策略旨在最大限度地提高灵活性和易用性，确保用户能够有效地将 CLD Action 集成到他们的工作流中。

## 本地使用指南

Comment Language Detector (CLD) 提供了一种便捷的方法，可以在您的项目中检测代码评论中的特定语言。以下指南将引导您完成在本地机器上设置和使用 CLD 的步骤。

### 步骤 1：下载最新发布版

1. 访问 GitHub 上 Comment Language Detector 的[发布页面](https://github.com/kubecub/comment-lang-detector/releases)。
2. 下载适合您操作系统（Windows、macOS、Linux）的最新发布版。

### 步骤 2：安装二进制文件

下载后，您需要使二进制文件可执行，并将其移动到系统 PATH 中的位置，以便从命令行轻松访问。

#### 对于 Linux 和 macOS：

1. 打开终端。
2. 导航到下载位置。
3. 使用以下命令使二进制文件可执行：

```bash
chmod +x cld-linux // 如果你在 macOS 上，请使用 cld-macos
```

4. 将二进制文件移动到 PATH 中的位置。一个常见的选择是 `/usr/local/bin`：

```bash
sudo mv cld-linux /usr/local/bin/cld // 如果你在 macOS 上，请使用 cld-macos
```

#### 对于 Windows：

- 解压下载的 ZIP 文件。
- 将 `cld.exe` 移动到系统 PATH 的目录中。

### 步骤 3：设置环境变量（可选）

您可以使用环境变量或配置文件来配置 CLD。设置配置路径的环境变量：

#### 对于 Linux 和 macOS：

打开您的 `.bashrc`、`.zshrc` 或等效的 shell 配置文件，并添加：

```bash
export CLD_CONFIG_PATH="/path/to/your/config.yaml"
```

将 `"/path/to/your/config.yaml"` 替换为您配置文件的实际路径。然后，使用 `source ~/.bashrc`（或等效命令）重新加载您的 shell 配置。

#### 对于 Windows：

- 打开开始搜索，输入“env”，选择“编辑系统环境变量”。
- 在系统属性窗口中，点击“环境变量…”按钮。
- 在环境变量窗口中，点击“用户变量”部分下的“新建”。
- 设置变量名为 `CLD_CONFIG_PATH`，变量值为您配置文件的路径。

### 步骤 4：创建配置文件

在您的项目目录（或 `CLD_CONFIG_PATH` 环境变量指定的位置）创建一个 `config.yaml` 文件，其结构如下：

```yaml
directory: ./
file_types:
  - .go
  - .yaml
  - .yml
languages:
  - Chinese
```

### 步骤 5：运行 CLD

安装并配置好 CLD 后，您现在可以运行它来检测代码评论中的指定语言。打开终端或命令提示符，导航到您的项目目录，并执行：

```bash
cld
```

如果您设置了 `CLD_CONFIG_PATH` 环境变量，CLD 将使用指定的配置文件。否则，请确保您的项目目录中有一个 `config.yaml`，或者在运行 CLD 时直接指定配置文件路径。

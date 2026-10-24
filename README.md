# Gemini in Chrome 启动器（macOS）

在 macOS 上为 Chrome 创建一个独立启动器，启动时附带已验证可恢复 Gemini 按钮的 Chromium 参数。项目依据实际测试：通过启动器运行后，Chrome 右上角出现 Gemini 按钮，并可正常对话。此项目是面向个人排查和使用的非官方方法，不代表 Google 提供或支持此功能。

> English version：[README.en.md](./README.en.md)

## 快速安装

1. 从 GitHub 下载项目 ZIP 并解压，或克隆仓库。
2. 双击项目根目录中的 `Install.command`。
3. 若 macOS 提示无法打开未签名的文件，按住 Control 键点按文件，选择“打开”，再确认运行。
4. 安装器会检查 macOS、Chrome、AppleScript 编译工具及目标应用冲突，创建启动器并检查 Chrome 版本。若 Chrome 已退出，会自动通过启动器打开；若 Chrome 正在运行，安装器不会强制退出，按提示保存工作、完全退出 Chrome（⌘Q），再打开新建的启动器。

安装也可以在终端中运行 `./Install.command`。手动调用底层脚本时可运行 `bash scripts/install.sh`。

## 使用场景

适用于 macOS 上已安装 Google Chrome 的用户：新装 Chrome 后希望尝试启用 Gemini 入口，或 Chrome 更新后 Gemini 工具栏入口消失；普通 Chrome 启动时入口不可见，而带本项目参数启动后入口恢复。新 Chrome 配置仍须由用户登录账号并完成首次启用。

若 Gemini 按钮本来就能正常使用，不需要安装此启动器。它只解决 Chrome 启动时的本地功能开关和地区过滤问题，不用于修复网络连接、账号封禁、服务端拒绝、企业策略或 Gemini 服务故障。

## 前提条件

- Mac 上已安装 Google Chrome；本项目不支持 Windows、Linux、Chromium、Brave 等浏览器。
- 安装时使用的 macOS 用户账户有权在自己的 `~/Applications` 中创建应用。
- 使用前需完全退出 Chrome（按 `⌘Q`），再通过启动器打开；仅关闭窗口可能会让 Chrome 继续在后台运行，导致参数没有生效。
- Gemini 服务仍须接受该 Google 账号和当前网络环境。Google 官方要求用户达到所在地区规定的最低年龄、位于支持地区、使用受支持语言、登录 Chrome，并使用最新 Chrome；无痕模式不可用。工作或学校账号还可能需要管理员开通。具体条件和支持范围会变化，请查阅 [Google 官方支持范围](https://support.google.com/gemini/answer/17140089)。

截至 2026-10-24，Google 官方公开的桌面支持地区列表不包含中国大陆。本项目关闭的是 Chrome 客户端地区过滤，不能据此推断服务端也会允许访问或承诺在中国大陆可用。此前的测试只证明指定账号和当时的网络环境可正常对话。

## 安装

推荐双击项目根目录的 `Install.command`。也可以在“终端”进入项目目录后运行：

```bash
./Install.command
```

安装器会在 `~/Applications/Gemini in Chrome Launcher.app` 创建启动器，并尝试显示 Chrome 版本。若 Chrome 未运行，会自动通过新启动器启动；若 Chrome 正在运行，安装器不会中断它，用户需先完全退出（按 `⌘Q`）再打开启动器。可将启动器拖到 Dock，以后通过它启动 Chrome。

若目标应用已存在，安装脚本会停止，避免覆盖现有应用。请先自行移动或重命名旧应用，再重新安装。

## 参数说明

启动器执行：

```bash
open -a 'Google Chrome' --args \
  --enable-features=Glic,GlicRollout \
  --disable-features=GlicCountryFiltering
```

这些参数在 Chrome 152.0.7977.83 macOS 环境中经实际启动验证。它们绕过本地 Gemini 地区过滤并启用相关功能开关；Google 仍可能根据账号、地区或服务策略调整可用性。Chrome 更新后参数也可能变化。其他版本尚未验证。

## 诊断

```bash
./scripts/diagnose.sh
```

脚本会检查 Chrome 和启动器是否存在、显示 Chrome 版本和启动参数，并尝试确认当前 Chrome 进程是否带有这些参数。启动 Chrome 后也可访问 `chrome://glic/internals` 查看资格状态。普通 Gemini 对话可用时，网页操作等子功能仍可能受其他资格条件限制。

若按钮仍不出现，先确认 Chrome 已完全退出，再从启动器启动；随后检查 `chrome://glic/internals` 中的资格状态。若资格检查显示地区、账号、同意授权或策略未通过，启动参数无法保证解除服务端或账号级限制。诊断页面会显示账号资格等信息，公开报告前应遮盖个人数据。

## 卸载

```bash
./scripts/uninstall.sh
```

卸载脚本只删除本项目创建的启动器，不会删除 Chrome、浏览器资料或其他应用。

## 安全与范围

- 仅支持 macOS 和 Google Chrome 桌面版。
- 安装脚本在本地生成 AppleScript 应用，不下载或执行远程代码。
- 不修改 Chrome 的 `Local State`，不读取或上传浏览器数据。
- Gemini 对话仍会连接 Google 服务；启用网页上下文时，Gemini 会按产品交互使用相关页面内容。请遵循 Google 服务条款和组织的数据要求。
- 项目不由 Google 官方维护，不保证 Chrome 或 Gemini 服务持续支持这些开关，也不保证账号、地区、网络或企业策略允许使用。
- 这是依赖 Chrome 内部实验开关的临时兼容方案，不是官方配置；更新 Chrome 后可能失效，需重新诊断和验证。

## 文件

- `scripts/install.sh`：创建启动器。
- `scripts/uninstall.sh`：移除启动器。
- `scripts/diagnose.sh`：检查安装状态和参数。
- `Install.command`：双击即可运行的安装入口。
- `LICENSE`：MIT 许可证。

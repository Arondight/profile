# Oh My OpenAgent（OmO）配置指引

| 版本 | 日期       | 示例环境                                                       |
| ---- | ---------- | -------------------------------------------------------------- |
| v2.0 | 2026-09-28 | OmO Native 5.0.1 · OpenCode 插件 5.0.1 · 阿里云百炼 Token Plan |

> **时效性**：本文的 agent / category / 模型清单与能力评级会随 [Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-openagent) 及各提供商更新而变化。使用前请以本机 `omo doctor`、`omo --list-models`、`opencode models` 与最新 [JSON Schema](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json) 为准。

Oh My OpenAgent（OmO）是面向 AI 编码会话的多 agent 编排配置，按宿主提供多种形态。本文涉及以下两种：

- **OmO Native**：独立的 `omo` 命令，senpi 引擎内置 OMO 扩展，不依赖任何宿主；本文以它为主体。
- **OpenCode 插件**（Ultimate）：`oh-my-openagent` 插件，加载进 OpenCode v1；5.x 起官方将其列为降级支持（degraded support）形态，新功能优先进入 OmO Native。

OmO Native 运行在 senpi 引擎上，senpi 是 [pi](https://github.com/badlogic/pi-mono) 的 fork，因此其 CLI、会话与扩展机制与 pi 同源。

本文以 **阿里云百炼 Token Plan** 为示例；两个形态各用自己的 provider：Native 侧为 `qwen-token-plan-cn`，OpenCode 插件侧为 `alibaba-token-plan-cn`。替换为其他提供商时，需同步替换 provider 前缀与模型 ID，并核对思考强度、上下文 / 输出限制与认证方式；以 `omo --list-models` / `opencode models` 为准。

- **适用对象**：OmO Native 5.x 用户与 OpenCode 插件（OpenCode v1）用户
- **官方文档**：[GitHub 仓库](https://github.com/code-yeongyu/oh-my-openagent) · [omo.dev/docs](https://omo.dev/docs)
- **JSON Schema**：[omo.schema.json](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json)
- **权威依据**：[Agent-Model Matching Guide](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/agent-model-matching.md) · `omo doctor` · `opencode models`

**目录**

- [术语表](#术语表)
- [1. 安装](#1-安装)
  - [1.1 前置依赖](#11-前置依赖)
  - [1.2 OmO Native](#12-omo-native)
  - [1.3 OpenCode 插件](#13-opencode-插件)
  - [1.4 两种形态共存](#14-两种形态共存)
- [2. 配置文件](#2-配置文件)
  - [2.1 文件位置与优先级](#21-文件位置与优先级)
  - [2.2 解析顺序与配置块](#22-解析顺序与配置块)
  - [2.3 最小结构](#23-最小结构)
- [3. OmO Native：角色与模型选型](#3-omo-native角色与模型选型)
  - [3.1 主 agent 的模型](#31-主-agent-的模型)
  - [3.2 委派角色](#32-委派角色)
  - [3.3 覆盖规则与模型引用](#33-覆盖规则与模型引用)
  - [3.4 图像输入](#34-图像输入)
- [4. OpenCode 插件：角色与模型选型](#4-opencode-插件角色与模型选型)
  - [4.1 配置方式](#41-配置方式)
  - [4.2 Agents（11 个）](#42-agents11-个)
  - [4.3 Categories（9 个）](#43-categories9-个)
  - [4.4 与 OmO Native 的主要差异](#44-与-omo-native-的主要差异)
- [5. 字段参考](#5-字段参考)
  - [5.1 模型条目](#51-模型条目)
  - [5.2 Agent 字段](#52-agent-字段)
  - [5.3 Category 字段](#53-category-字段)
  - [5.4 模型目录与模型 profile](#54-模型目录与模型-profile)
- [6. 完整示例配置](#6-完整示例配置)
  - [6.1 能力档映射](#61-能力档映射)
  - [6.2 示例配置](#62-示例配置)
- [附录 A：示例提供商模型速查](#附录-a示例提供商模型速查)

---

## 术语表

| 术语                         | 含义                                                                                                                                                       |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Recommended（推荐阶梯）      | 未设置 `model_profile` 时使用的默认主模型链（仅 Desktop / headless 新建会话）                                                                              |
| TUI / Desktop / headless     | 终端交互界面 / OmO Desktop 客户端 / 非交互运行（如 `omo -p`）                                                                                              |
| agent / subagent_type        | 由模型、系统提示与工具策略组成的具名角色（如 `explore`）；用 `task(subagent_type: ...)` 调用                                                               |
| category                     | 任务意图标签，如 `deep-low`；用 `task(category: ...)` 调用                                                                                                 |
| lane                         | 官方内置的四组主模型链：Daily / Geeky × Normal / Heavy；以其 ID（如 `daily-normal`）作为 `model_profile` 的取值                                            |
| pin（固定）                  | 将 `model_profile` 直接写成 `provider/model`，只使用该模型，不走命名链                                                                                     |
| plan-gated                   | 需先进入 `/ulw-plan` 计划流（产出 `.omo/plans/*.md` 的计划命令）才能使用                                                                                   |
| provider（提供商）           | `provider/model` 中的前缀，代表模型的提供方，如 `qwen-token-plan-cn`；用 `omo --list-models`（Native）或 `opencode models`（OpenCode）查看                 |
| reasoning（思考强度）        | 模型思考强度的高低，取值见 [3.3](#33-覆盖规则与模型引用)                                                                                                   |
| scoped model / resume / fork | 会话内指定的模型 / 恢复既有会话 / 从既有会话分叉                                                                                                           |
| ulw-loop                     | 多目标循环工作流；其内部评审 agent 见 [3.2](#32-委派角色)                                                                                                  |
| 主 agent                     | 会话中的编排 agent；OmO Native 只有一个，OpenCode 插件有 4 个 primary agent                                                                                |
| 委派                         | 主 agent 通过 `task` 工具把工作交给新的子会话执行                                                                                                          |
| 档位（rung）                 | 模型链中的一项                                                                                                                                             |
| 模型 profile                 | `model_profiles.<name>` 定义的命名链；`model_profile` 指定当前使用哪一条                                                                                   |
| 模型引用                     | `provider/model` 形式的完整模型 ID，如 `qwen-token-plan-cn/glm-5.3`；可附加 `:level` 后缀指定思考强度                                                      |
| 模型目录                     | 顶层或 `[native]` 中的 `models`，将短名映射到模型引用                                                                                                      |
| 模型链                       | 有序的“模型 + 思考强度”列表，用于新建 Desktop / headless 会话与委派时的模型选择，取第一个可服务的条目；会话中途的故障走引擎自身的重试链，不按模型链回退    |
| 聚合器                       | OpenRouter、OpenGateway 等转售多家模型的网关；Recommended 不使用它们                                                                                       |
| 能力档 S / B / V             | 本文对角色所需模型能力的归纳，见 [3. OmO Native：角色与模型选型](#3-omo-native角色与模型选型)                                                              |
| 配置 profile                 | `profiles.<name>` 定义的配置覆盖层，由 `OMO_PROFILE` 等环境变量激活；与“模型 profile”无关                                                                  |
| 门控（gate）                 | 部分 category 需指定模型存在才可用；显式配置其 `model` / `models` 可解除。`plan-consultant` / `plan-reviewer` 另有 plan-gated 条件；见 [3.2](#32-委派角色) |

---

## 1. 安装

### 1.1 前置依赖

| 依赖     | 要求               | 说明                                                                                                   |
| -------- | ------------------ | ------------------------------------------------------------------------------------------------------ |
| Node.js  | 24 或更高版本      | `omo-ai` 的安装与运行要求；OpenCode 插件由 OpenCode 宿主提供运行时                                     |
| Bun      | 1.4 或更高（推荐） | 已安装时引擎以 Bun 运行；可用 `npm install -g bun` 或 `curl -fsSL https://bun.sh/install \| bash` 安装 |
| OpenCode | v1                 | 仅 OpenCode 插件需要；OpenCode v2 的适配仍在进行中                                                     |

未安装 Bun 时 OmO Native 仍可在 Node.js 上运行；可用 `OMO_RUNTIME=node` 强制使用 Node.js。

### 1.2 OmO Native

```bash
npm install -g omo-ai   # 或 bun add -g omo-ai
omo                     # 启动
omo setup               # 可选：从 OpenCode 等导入 provider、MCP、skills、模型选择
omo doctor              # 检查已连接 provider 与各 category 的可用性
omo update              # 原地升级
omo --list-models       # 查看当前可用的 provider/model 组合
```

- npm 包名为 `omo-ai`，命令名为 `omo`；npm 上的 `omo` 包与本项目无关。
- 引擎状态位于 `~/.omo/agent/`（`settings.jsonc`、`auth.json`、`models.json` 等）。
- 订阅登录在会话内完成：`/login <provider>`。
- 卸载：`npm uninstall -g omo-ai`，或 `bun remove -g omo-ai`（Bun 安装可能残留 `~/.bun/bin/omo` shim，可手动删除）。

### 1.3 OpenCode 插件

官方支持以下两种方式：

**方式一：官方安装器（推荐）**

```bash
bunx oh-my-openagent install
```

安装器通过 TUI 完成 provider 检测、模型选择与认证配置。`oh-my-openagent` 的 `prepare` 脚本依赖 Bun，因此请始终通过 `bunx` 调用。

**方式二：写入 OpenCode 的 `plugin` 数组**

OpenCode 会自行安装并缓存数组中的插件，需在 `plugin` 数组中登记；文件可能还包含其他配置：

```jsonc
{
  "plugin": ["oh-my-openagent@latest"],
}
```

对应 `~/.config/opencode/opencode.jsonc` 与（使用 TUI 时的）`~/.config/opencode/tui.jsonc`，后者只需这一项。该方式仅完成插件加载，provider 认证与模型配置需另行完成（见 [4. OpenCode 插件：角色与模型选型](#4-opencode-插件角色与模型选型)）。

> **官方明确不支持全局安装插件**（`npm install -g oh-my-openagent`、`bun add -g oh-my-openagent` 均不可用）：插件必须从 OpenCode 加载插件的位置解析。若要安装 Bun，可用 `npm install -g bun`，随后以 `bunx oh-my-openagent install` 安装插件。

### 1.4 两种形态共存

- 两种形态互不依赖，可同时安装。
- 二者共享 `~/.omo/omo.jsonc`：多数顶层键对两者均生效，少数（如 `model_profile` / `model_profiles` / `memory` / `telemetry`）仅 OmO Native 读取（见 [2.2](#22-解析顺序与配置块)）；`[native]` 与 `[opencode]` 各归其形态。
- 两个形态的 provider ID 可能不同，示例对照如下：

  | 类别                  | OmO Native provider    | OpenCode provider       |
  | --------------------- | ---------------------- | ----------------------- |
  | 阿里云百炼 Token Plan | `qwen-token-plan-cn`   | `alibaba-token-plan-cn` |
  | GLM                   | `zai`                  | `zai-coding-plan`       |
  | Kimi                  | `kimi-coding`          | `kimi-for-coding`       |
  | OpenAI                | `chatgpt-subscription` | `openai`                |

- `omo setup` 可将 OpenCode 的 API key、自定义 provider、MCP 服务器与全局 skills 导入引擎状态目录 `~/.omo/agent/`，并将默认模型与 categories / agents 写入 `[native]` 块。OAuth 登录无法复制，需在 omo 内执行 `/login <provider>`。

---

## 2. 配置文件

### 2.1 文件位置与优先级

| 层级   | 路径                    | 优先级 | 说明                                                                                         |
| ------ | ----------------------- | ------ | -------------------------------------------------------------------------------------------- |
| 用户级 | `~/.omo/omo.jsonc`      | 低     | 全局配置                                                                                     |
| 项目级 | `<项目>/.omo/omo.jsonc` | 高     | 从工作目录向上到 `$HOME` 逐层合并（工作目录在 `$HOME` 之外时继续到根），越近的层级优先级越高 |

```jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json",
}
```

文档涉及的文件与格式：

| 文件                                        | 说明                                 |
| ------------------------------------------- | ------------------------------------ |
| `~/.omo/omo.jsonc`；`<项目>/.omo/omo.jsonc` | OmO 配置                             |
| `~/.omo/agent/settings.jsonc`               | 引擎设置；TUI 的 `Ctrl+S` 写入该文件 |
| `~/.config/opencode/opencode.jsonc`         | OpenCode 主配置                      |
| `~/.config/opencode/tui.jsonc`              | OpenCode TUI 配置                    |

引擎状态目录中的 `auth.json`、`models.json` 等为固定 `.json` 文件名，没有 `.jsonc` 变体。

### 2.2 解析顺序与配置块

合并完成后，每个 harness 按以下顺序解析自己的视图，后者覆盖前者，默认值最后补齐：

1. 顶层键
2. 当前 harness 的配置块：`[native]` 或 `[opencode]`
3. `profiles.<name>`
4. `profiles.<name>` 内的 harness 块（`[native]` / `[opencode]`）

> 层级合并（项目级覆盖用户级）先完成，再应用上述解析顺序；因此激活的 profile 会覆盖合并后的基础值，与文件层级无关。`OMO_PROFILE` 一次只激活一个 profile。

各配置块的职责：

| 键                | 作用域           | 说明                                                                                                  |
| ----------------- | ---------------- | ----------------------------------------------------------------------------------------------------- |
| 顶层键            | 多数形态         | `agents`、`categories`、`models`、`task`、`teams`、`disabled_skills` 等；少数键仅 Native 读取（见下） |
| `[native]`        | OmO Native       | Native 的专属视图；接受与顶层相同的键集，用于只对 Native 生效的覆盖                                   |
| `[opencode]`      | OpenCode 插件    | OpenCode 插件专属配置，含其 agents / categories / hooks 等                                            |
| `profiles.<name>` | 按激活的 profile | 配置层覆盖，由 `OMO_PROFILE` 等环境变量激活                                                           |

> `model_profile` / `model_profiles` / `memory` / `telemetry` 等键写在顶层同样有效，但只有 OmO Native 读取；也可以放进 `[native]` 以明确作用域。

### 2.3 最小结构

```jsonc
// ~/.omo/omo.jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json",
  "[native]": {
    "agents": {
      "<agent-id>": {
        "model": "<provider>/<model-id>",
      },
    },
    "categories": {
      "<category-id>": {
        "model": "<provider>/<model-id>",
      },
    },
  },
  "[opencode]": {
    "agents": {
      "<agent-id>": {
        "model": "<opencode-provider>/<model-id>",
      },
    },
    "categories": {
      "<category-id>": {
        "model": "<opencode-provider>/<model-id>",
      },
    },
  },
}
```

`agents` / `categories` 的键与内置角色同名时**逐字段覆盖**内置定义（只替换显式给出的字段，其余保留内置值），否则追加为自定义角色。仅使用其中一种形态时，可省略另一个配置块。

---

## 3. OmO Native：角色与模型选型

OmO Native 的模型选择分为两层：**主 agent** 决定会话模型，**委派角色**（agents 与 categories）各自使用独立模型链。

本文用以下能力档归纳各角色对模型能力的要求：

| 能力档            | 适用场景                             |
| ----------------- | ------------------------------------ |
| **S** 旗舰推理    | 规划、评审、架构设计、复杂推理、散文 |
| **B** 快 / 低成本 | 代码检索、文档检索、琐碎改动         |
| **V** 视觉        | 图片输入、截图、图表与多模态工作     |

### 3.1 主 agent 的模型

主 agent 使用会话模型。Desktop / headless 会话由 `model_profile` 选择模型；未设置时应用 **Recommended** 阶梯，按顺序取第一个由已连接 provider 提供服务的档位：

`claude-opus-5-5 (medium)` → `claude-fable-5-1 (xhigh)` → `kimi-k3 (max)` → `gpt-6-astra (xhigh)` → `gpt-6-sol (medium)` → `glm-5.3 (max)`

Recommended 的每一档只在官方排名的 provider 上解析（见 [Agent-Model Matching Guide](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/agent-model-matching.md)）——每档预置一组按优先级排列的 provider（订阅在前、API 在后），OpenGateway、OpenRouter 等网关聚合器不参与；四个内置 lane 的候选同样优先使用各自列出的 provider，但 lane 不限制在这些 provider：列出的 provider 均不可用时，同一模型仍可由其他已连接 provider 提供。

四个内置 lane 中，Daily 两条与 Geeky · Heavy 是 Recommended 阶梯的精选子序列（跳过的档位不参与），Geeky · Normal 使用 GPT-5.6 Sol：

| Lane           | ID             | 适用场景           | 模型链                                                         |
| -------------- | -------------- | ------------------ | -------------------------------------------------------------- |
| Daily · Normal | `daily-normal` | 日常任务的稳妥选择 | `claude-opus-5-5` (medium) → `kimi-k3` (max) → `glm-5.3` (max) |
| Daily · Heavy  | `daily-heavy`  | 多角度权衡后执行   | `claude-fable-5-1` (xhigh)                                     |
| Geeky · Normal | `geeky-normal` | 单任务深入思考     | `gpt-5.6-sol` (medium)                                         |
| Geeky · Heavy  | `geeky-heavy`  | 单任务全面推演     | `gpt-6-astra` (xhigh)                                          |

表中括号内为思考强度（`reasoning`），取值含义见 [3.3](#33-覆盖规则与模型引用)。`gpt-6-*` 与 `gpt-5.6-*` 是两代模型：`geeky-normal` 特意使用 GPT-5 旗舰。

`model_profile` 的取值有三类：

- **内置 lane ID**：如 `"model_profile": "daily-normal"`（见上表）。
- **自定义链**：在 `model_profiles.<name>` 定义有序链，再让 `model_profile` 指向该名称。
- **pin**：直接写 `provider/model`，如 `"model_profile": "qwen-token-plan-cn/glm-5.3"`。

```jsonc
{
  "[native]": {
    "model_profiles": {
      "token-plan-cn": {
        "display_name": "Alibaba Token Plan (China)",
        "models": [
          {
            "model": "qwen-token-plan-cn/glm-5.3",
            "reasoning": "max",
          },
          "chatgpt-subscription/gpt-6-sol:medium",
        ],
      },
    },
    "model_profile": "token-plan-cn",
  },
}
```

使用规则：

- `model_profile` 只作用于**新建的 Desktop / headless 会话**；`--model` 参数、scoped model、resume、fork 均保留各自的模型，profile 不会覆盖。
- 应用结果不会写回配置文件，仅在当前会话生效；会话中途的模型故障按引擎自身的重试链处理，不按 profile 回退。
- **交互式 TUI 不应用 `model_profile`**。TUI 的启动模型来自 `~/.omo/agent/settings.jsonc` 的 `defaultProvider` / `defaultModel`；在 TUI 内用 `/model` 选择模型后按 `Ctrl+S` 可存为默认（写入同一文件的 `defaultProvider` / `defaultModel`）。
- 若 TUI 默认模型不在 Recommended 阶梯，启动时会显示 **Risky model warning**。该告警按 `${provider}/${model} ${name}` 是否包含 `qwen` 或 `minimax` 判定，因此在 provider ID 含 `qwen` 的提供方（如 `qwen-token-plan-cn`）上，即使换成 `glm-5.3` 也会出现；要消除需改用不含这两个词的 provider（如 `alibaba-token-plan`，需对应端点的凭据）。
- 官方只对 Recommended 阶梯上的模型验证过编排提示；阶梯外的模型（如 Qwen、DeepSeek）可作为委派模型，但官方不支持其作为主 agent。
- 自定义链中，带 provider 前缀的条目只在该 provider 上解析；裸模型 ID 可匹配任意 provider（provider 由引擎按可用顺序选择）。

### 3.2 委派角色

主 agent 通过 `task` 工具委派工作，有两种目标：

- `task(subagent_type: "<name>", ...)`：指定**由谁执行**，目标为四个精选只读 agent（其中 `plan-consultant` / `plan-reviewer` 需满足计划流条件，见下）。
- `task(category: "<id>", ...)`：指定**以何种能力档与提示执行**，目标为 category worker。

category worker 是全新会话，不能再委派，以避免递归委派。

agent / category 的内置链是跨 provider 的：链中的模型不带 provider 前缀，引擎按已连接 provider 解析；[附录 A](#附录-a示例提供商模型速查) 只列示例 provider 的模型，其他链上模型需登录对应 provider 后才可用；同名模型在不同 provider 上可能不是同一引用（如内置链的 `deepseek-flash` 与附录 A 的 `deepseek-v4-flash`）。

#### Agents（4 个精选 + 3 个内部评审）

| Agent             | 调用方式                                      | 职责                                                                            |
| ----------------- | --------------------------------------------- | ------------------------------------------------------------------------------- |
| `explore`         | `task(subagent_type: "explore", ...)`         | 代码库检索：定位符号、文件与实现                                                |
| `librarian`       | `task(subagent_type: "librarian", ...)`       | 外部文档与开源代码检索                                                          |
| `plan-consultant` | `task(subagent_type: "plan-consultant", ...)` | 计划前置审查：识别隐藏意图、歧义与缺失的验收标准（需先进入 `/ulw-plan` 计划流） |
| `plan-reviewer`   | `task(subagent_type: "plan-reviewer", ...)`   | 计划评审：清晰度、可验证性与完整性；一次性调用（需先进入 `/ulw-plan` 计划流）   |

- 四者均为只读工具策略，并各自带有内置模型链：`explore` / `librarian` 首选 `kimi-for-coding-highspeed` (off)，`plan-consultant` 首选 `claude-fable-5-1` (max)，`plan-reviewer` 首选 `gpt-6-astra` (xhigh)。
- `plan-consultant` 与 `plan-reviewer` 同样经 `task(subagent_type: ...)` 调起，但仅在请求过 `/ulw-plan` 计划流后可用（plan-gated）；在 `agents` 中为其配置模型只改变模型，不解除该限制。
- 在 `agents` 中写内置名称时，仅覆盖显式给出的字段，其余保留内置值；写入其他名称将追加为自定义 agent。
- 此外，ulw-loop 流程内部使用三个评审 agent：`omo-native-code-reviewer`（按 `unspecified-high` 运行）、`omo-native-gate-reviewer`（按 `deep-high`，回退 `unspecified-high`）、`omo-native-qa-executor`（按 `deep-low`，回退 `unspecified-low`）。它们没有独立模型链，随对应 category 的配置变化；category 不可用时对应评审也不可用。

#### Categories（10 个）

| Category             | 用途                                                                          | 内置链（节选）                                                               | 可用条件                            |
| -------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ----------------------------------- |
| `architect`          | 系统设计咨询：只提议、不实现                                                  | `claude-fable-5-1` (max)                                                     | `claude-fable-5-1`                  |
| `visual-engineering` | 前端、UI/UX、样式、动画、设计系统                                             | `claude-fable-5-1` (max) → `claude-opus-5-5` (max) → `kimi-k3` (max)         | 链上至少一档                        |
| `ultrabrain`         | 最难的逻辑与架构推理；只给目标，不给步骤                                      | `gpt-6-astra` (max) → `gpt-5.6-sol` (max)                                    | `gpt-6-astra` 或 `gpt-5.6-sol`      |
| `deep-low`           | 默认深度通道：3D 图形、computer use（桌面自动化）、浏览器、后端、算法、多模态 | `gpt-5.6-sol-fast` (medium) → `gpt-5.6-sol` (medium)                         | `gpt-5.6-sol-fast` 或 `gpt-5.6-sol` |
| `deep-high`          | 升级深度通道：核心决策无法由证据解决时                                        | `gpt-6-astra` (xhigh)                                                        | `gpt-6-astra`                       |
| `artistry`           | 非常规、创意型问题求解                                                        | `claude-fable-5-1` (max) → `claude-opus-5-5` (max) → `kimi-k3` (max)         | 链上至少一档                        |
| `quick`              | 琐碎任务：单文件改动、typo                                                    | `gpt-6-luna-fast` (low) → `deepseek-flash` (off) → `qwen3.6-flash` (low) → … | 链上至少一档                        |
| `unspecified-low`    | 不属于其他 category 的低强度任务                                              | `mimo-v2.6-pro` (max) → `grok-4.7` (xhigh) → `gpt-5.6-terra` (high) → …      | 链上至少一档                        |
| `unspecified-high`   | 不属于其他 category 的高强度任务                                              | `claude-opus-5-5` (medium) → `glm-5.3` (max) → `kimi-k3` (max)               | 链上至少一档                        |
| `writing`            | 文档、散文、commit message、PR 描述                                           | `claude-opus-5-5` (low) → `claude-opus-4-6` (max)                            | 链上至少一档（仅 Claude）           |

- `deep-low` 与 `deep-high` 每次调用只接受一个目标与一个交付物；多个目标应并行发起多个 `deep-low`，仅当核心决策无法由证据解决时才升级至 `deep-high`。
- 未配置的 category 只有满足其可用条件才会出现在委派列表中：`ultrabrain`、`deep-low`、`deep-high`、`architect` 需要对应的门控模型，其余 category 需要链上至少一档可服务（`writing` 的链仅含 Claude，未连接 Claude 时不可用）；否则该 category 不可用。`omo doctor` 会逐条列出不可用的 category 及其修复方式。
- 示例 provider `qwen-token-plan-cn` 不含 Claude / GPT / Kimi K3，因此 `architect`、`visual-engineering`、`ultrabrain`、`deep-low`、`deep-high`、`artistry`、`writing` 默认不可用；示例配置通过显式覆盖解除（见 [6.1](#61-能力档映射)）。
- 显式配置 `categories.<name>.model` 或 `models` 即解除门控：该 category 始终可选，并按所配置的模型运行。
- 内置链中的思考强度是引擎的请求值；模型仅支持开关时会被归一化（见 [3.3](#33-覆盖规则与模型引用)）。
- 表中“内置链（节选）”只表示优先级顺序，不能据此判断可用性；可用性以 `omo doctor` 输出为准。

### 3.3 覆盖规则与模型引用

覆盖单个角色的模型可写 `model`，覆盖整条链可写 `models`：

```jsonc
{
  "[native]": {
    "categories": {
      "unspecified-high": {
        "model": "qwen-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "quick": {
        "models": [
          {
            "model": "qwen-token-plan-cn/deepseek-v4.1-flash",
            "reasoning": "max",
          },
          "qwen-token-plan-cn/qwen3.8-flash:low",
        ],
      },
    },
  },
}
```

模型引用有两种基础形式，并可附加 `:level` 思考强度后缀（如 `qwen-token-plan-cn/glm-5.3:max`）：

- `provider/model`：完整引用，如 `zai/glm-5.3`。
- 短名：引用 `models` 目录中的条目（见 [5.4](#54-模型目录与模型-profile)）。

同一模型条目同时有 `:level` 后缀与 `reasoning` 字段时，以 `reasoning` 字段为准。

`reasoning` 控制模型的思考强度，规范取值如下：

| 取值                                  | 含义                               |
| ------------------------------------- | ---------------------------------- |
| `off`                                 | 关闭思考                           |
| `minimal` / `low` / `medium` / `high` | 思考强度递增                       |
| `xhigh`                               | 高于 `high` 的高档，仅部分模型提供 |
| `max`                                 | 模型支持的最高档                   |
| `auto`                                | 由引擎决定                         |

写入模型不支持的档位时，引擎会归一化到该模型支持的档位；仅支持开关的模型，`off` 关闭思考，其余取值按开启处理。

解析方式为：若用户为角色配置了 `model` / `models`，则直接按其运行（同时解除门控），配置模型不可用时不会回退到内置链，而是报告该角色不可用；否则先检查门控，再沿内置链取第一个由已连接 provider 提供服务的档位。

### 3.4 图像输入

OmO Native 没有独立的 multimodal agent，图片输入直接交给当前会话模型处理。因此：

- 示例主模型 `glm-5.3` 不支持图片输入；需要分析图片时，用 `/model` 将会话切换到支持图像输入的模型（如选择 `qwen-token-plan-cn/qwen3.8-max`；示例提供商另有 `qwen3.8-flash`、`deepseek-v4.1-flash` 等，见 [附录 A](#附录-a示例提供商模型速查)）。
- 若希望委派的多模态工作由视觉模型执行，可将 `deep-low` 等 category 固定到视觉模型。本文示例即把 `deep-low` 配置为 `qwen3.8-max`。

---

## 4. OpenCode 插件：角色与模型选型

### 4.1 配置方式

OpenCode 插件的配置写入 `~/.omo/omo.jsonc` 的 `[opencode]` 块（也可写入项目级 `.omo/omo.jsonc`）。模型引用使用与 OmO Native 相同的 `provider/model` 语法，但 provider ID 使用 OpenCode 侧的命名；可用 `opencode models` 查询可用组合、`opencode auth list` 查询已登录的 provider。

与 OmO Native 不同，OpenCode 插件通过 `agents` / `categories` 逐角色指定模型，没有 `model_profile`。

### 4.2 Agents（11 个）

| Agent               | 模式     | 职责                                                                                          |
| ------------------- | -------- | --------------------------------------------------------------------------------------------- |
| `sisyphus`          | primary  | 主编排与默认入口：理解目标、选择路由、派发任务、验证结果                                      |
| `hephaestus`        | primary  | 自主深度执行：只给目标，自主探索并完成                                                        |
| `prometheus`        | primary  | 规划者：访谈需求并产出计划；只读，仅可写 `.omo/` 下的 md（由内置 hook 实施，非 `tools` 字段） |
| `atlas`             | primary  | 计划执行指挥：读取计划、派发任务、汇总并验证                                                  |
| `oracle`            | subagent | 只读顾问：架构决策、疑难调试、多系统权衡                                                      |
| `metis`             | subagent | 计划前置审查：识别隐藏意图、歧义与缺失的验收标准                                              |
| `momus`             | subagent | 计划评审：清晰度、可验证性与完整性                                                            |
| `sisyphus-junior`   | subagent | 代码执行者：不参与编排，`task()` 仅可用于研究型子 agent（`explore`、`librarian`、`oracle`）   |
| `explore`           | subagent | 代码库检索                                                                                    |
| `librarian`         | subagent | 外部文档与开源代码检索                                                                        |
| `multimodal-looker` | subagent | 图片、PDF、图表与截图分析                                                                     |

四个 primary agent 的默认排列顺序为 `sisyphus` → `hephaestus` → `prometheus` → `atlas`：前两者是会话入口（编排式 / 自主式），后两者构成先规划后执行的计划流。

### 4.3 Categories（9 个）

| Category             | 用途                                |
| -------------------- | ----------------------------------- |
| `visual-engineering` | 前端、UI/UX、样式、动画、设计系统   |
| `ultrabrain`         | 最难的逻辑与架构推理                |
| `deep-low`           | 默认深度通道                        |
| `deep-high`          | 升级深度通道                        |
| `artistry`           | 非常规、创意型问题求解              |
| `quick`              | 琐碎任务：单文件改动、typo          |
| `unspecified-low`    | 不属于其他 category 的低强度任务    |
| `unspecified-high`   | 不属于其他 category 的高强度任务    |
| `writing`            | 文档、散文、commit message、PR 描述 |

OpenCode 插件的 category 与 Native 使用同一套内置选型与门控逻辑（其中不含 `architect`）；在 `[opencode].categories.<name>` 中配置 `model` / `models` 即可覆盖并解除门控，示例见 [6.1](#61-能力档映射)。

### 4.4 与 OmO Native 的主要差异

| 维度          | OmO Native                                                                                                                                    | OpenCode 插件                                                                                           |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| 形态          | 独立 `omo` 命令                                                                                                                               | OpenCode 插件                                                                                           |
| 主 agent 模型 | `model_profile`（Recommended 阶梯 / lane）                                                                                                    | 由 OpenCode 会话模型决定；primary agent 可用 `agents.<name>.model` 单独覆盖，插件不读取 `model_profile` |
| Agent 名单    | `explore`、`librarian`、`plan-consultant`、`plan-reviewer` + `omo-native-code-reviewer`、`omo-native-gate-reviewer`、`omo-native-qa-executor` | 上表 11 个 agent                                                                                        |
| 图像分析      | 由会话模型处理                                                                                                                                | 由 `multimodal-looker` agent 处理                                                                       |
| 新增能力      | 优先获得                                                                                                                                      | 部分能力不进入插件                                                                                      |

---

## 5. 字段参考

字段的完整定义见 [JSON Schema](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json)。以下仅列本文用到的规范字段。

### 5.1 模型条目

| 字段               | 类型   | 说明                                                                                                          |
| ------------------ | ------ | ------------------------------------------------------------------------------------------------------------- |
| `model`            | string | 模型引用；支持 `provider/model`、目录短名与 `:level` 后缀；同时有后缀与 `reasoning` 字段时以 `reasoning` 为准 |
| `reasoning`        | string | 思考强度，取值见 [3.3](#33-覆盖规则与模型引用)                                                                |
| `temperature`      | number | 采样温度，0–2；越高输出越随机                                                                                 |
| `top_p`            | number | 核采样概率，0–1；越小候选范围越窄                                                                             |
| `max_tokens`       | number | 输出 token 上限                                                                                               |
| `provider_options` | object | 透传给提供商的请求选项                                                                                        |

### 5.2 Agent 字段

| 字段                | 类型                      | 说明                                                                                                                                                                                                       |
| ------------------- | ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `model`             | string                    | 单模型，等价于仅含一项的 `models`                                                                                                                                                                          |
| `models`            | array                     | 有序模型链，条目为字符串或模型条目对象                                                                                                                                                                     |
| `temperature`       | number                    | 采样温度，0–2                                                                                                                                                                                              |
| `description`       | string                    | 角色描述                                                                                                                                                                                                   |
| `prompt`            | string                    | 覆盖系统提示                                                                                                                                                                                               |
| `tools`             | `record<string, boolean>` | 工具开关映射：`true` 启用、`false` 禁用（如 `{ "read": true, "write": false }`）；未列出的工具保持该角色的内置工具策略；`disallowed_tools` 是 agent 上的另一种禁用方式（字符串列表），两种写法不要同时使用 |
| `execution_mode`    | `in-process` / `process`  | 执行方式；`in-process` 与父会话同进程，`process` 为独立进程；精选内置 agent（`explore`、`librarian`、`plan-consultant`、`plan-reviewer`）固定为 in-process                                                 |
| `background`        | boolean                   | 默认后台运行                                                                                                                                                                                               |
| `max_depth`         | number                    | 允许的最大委派深度（仅 agent；category worker 不能再委派）                                                                                                                                                 |
| `allowed_subagents` | string[]                  | 允许调用的子 agent                                                                                                                                                                                         |
| `disallowed_tools`  | string[]                  | 禁用的工具                                                                                                                                                                                                 |
| `max_turns`         | number                    | 最大回合数                                                                                                                                                                                                 |
| `disable`           | boolean                   | 禁用该 agent                                                                                                                                                                                               |

精选内置 agent（`explore`、`librarian`、`plan-consultant`、`plan-reviewer`）默认使用内置只读工具策略；如需调整，可用 `tools` 覆盖。

### 5.3 Category 字段

| 字段                | 类型                      | 说明                                                                                                                       |
| ------------------- | ------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `model`             | string                    | 单模型                                                                                                                     |
| `models`            | array                     | 有序模型链                                                                                                                 |
| `description`       | string                    | 用途描述，展示于 task 提示中                                                                                               |
| `prompt_append`     | string                    | 追加到系统提示                                                                                                             |
| `temperature`       | number                    | 采样温度，0–2                                                                                                              |
| `top_p`             | number                    | 核采样概率，0–1                                                                                                            |
| `max_tokens`        | number                    | 输出 token 上限                                                                                                            |
| `provider_options`  | object                    | 透传给提供商的请求选项                                                                                                     |
| `tools`             | `record<string, boolean>` | 工具开关映射：`true` 启用、`false` 禁用；未列出的工具保持该 category 的内置工具策略（category 无 `disallowed_tools` 字段） |
| `max_prompt_tokens` | number                    | 委派任务的提示 token 上限                                                                                                  |
| `is_unstable_agent` | boolean                   | 标记不稳定，强制后台监控                                                                                                   |
| `warn_unavailable`  | boolean                   | 是否输出“链不可用”提示                                                                                                     |
| `disable`           | boolean                   | 禁用该 category                                                                                                            |

### 5.4 模型目录与模型 profile

顶层 `models` 是共享目录，两个形态均可引用；`[native]` 内的 `models` 只对 Native 生效。目录将短名映射到 `{ model, reasoning? }`，供 `model` / `models` 引用；使用处仍可覆盖目录中的思考强度。目录条目以 `provider/model` 固定；两个形态 provider ID 不同时，需分别配置或在各自 harness 块内覆盖。

```jsonc
{
  "[native]": {
    "models": {
      "flagship": {
        "model": "qwen-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "fast": {
        "model": "qwen-token-plan-cn/deepseek-v4.1-flash",
        "reasoning": "max",
      },
    },
    "categories": {
      "unspecified-high": {
        "model": "flagship",
      },
      "quick": {
        "model": "fast",
        "reasoning": "high",
      },
    },
  },
}
```

模型 profile 的两个键（仅 OmO Native 读取）：

| 键               | 类型   | 说明                                                                 |
| ---------------- | ------ | -------------------------------------------------------------------- |
| `model_profiles` | object | 命名模型链。名称与内置 lane 同名时整体替换该内置链；其他名称新增一条 |
| `model_profile`  | string | 当前使用的 profile ID，或 `provider/model` 形式的 pin                |

`model_profiles.<name>` 条目支持 `display_name`（string，可选展示名，缺省用 ID）、`family` / `tier`（可选元数据）与 `models`（有序链，条目与 category 的 `models` 相同）四个字段。

---

## 6. 完整示例配置

示例配置与 `~/.omo/omo.jsonc` 保持一致：`[native]` 块为主，`[opencode]` 块为 OpenCode 插件提供同能力档映射。以下模型与 provider 为示例环境快照，实际以 `omo --list-models` / `opencode models` 为准；表中“思考强度”的取值含义见 [3.3](#33-覆盖规则与模型引用)。

### 6.1 能力档映射

`[native]` 块（provider `qwen-token-plan-cn`）：

| 模型                  | 能力档           | 思考强度 | 覆盖角色                                                                                                                                                                                                                                                     |
| --------------------- | ---------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `glm-5.3`             | 主 agent / **S** | `max`    | Desktop / headless 新建会话的 profile 首选（TUI 不适用，见 [3.1](#31-主-agent-的模型)）、`plan-consultant`、`plan-reviewer` 及 7 个 S 档 category（`architect`、`visual-engineering`、`ultrabrain`、`deep-high`、`artistry`、`unspecified-high`、`writing`） |
| `qwen3.8-max`         | **V** 视觉       | `xhigh`  | `deep-low`（兼多模态）                                                                                                                                                                                                                                       |
| `deepseek-v4.1-flash` | **B** 快         | `max`    | `explore`、`librarian`、`quick`、`unspecified-low`                                                                                                                                                                                                           |

`[opencode]` 块（provider `alibaba-token-plan-cn`）：

| 模型                  | 思考强度 | 覆盖角色                                                                                                                                                                                |
| --------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `glm-5.3`             | `max`    | `sisyphus`、`hephaestus`、`oracle`、`prometheus`、`metis`、`momus` 及 6 个 S 档 category（`visual-engineering`、`ultrabrain`、`deep-low`、`deep-high`、`artistry`、`unspecified-high`） |
| `glm-5.3`             | `high`   | `atlas`、`sisyphus-junior`                                                                                                                                                              |
| `deepseek-v4.1-flash` | `max`    | `explore`、`librarian`、`quick`、`unspecified-low`、`writing`                                                                                                                           |
| `qwen3.8-max`         | `xhigh`  | `multimodal-looker`                                                                                                                                                                     |

两边的 `writing` 与 `deep-low` 选择不同：OpenCode 侧 `writing` 用 `deepseek-v4.1-flash`、`deep-low` 用 `glm-5.3`（它另有 `multimodal-looker` 处理图像）；Native 侧 `writing` 用 `glm-5.3`、`deep-low` 用视觉模型 `qwen3.8-max`。

B 档模型统一使用 `reasoning: max`，属于质量优先的取舍（内置链对 `explore` / `librarian` 用 `off`、`quick` 用 `low`）；若更看重延迟与成本，可下调为 `low`（该模型不支持 `off`）。

### 6.2 示例配置

示例配置参见 [omo.jsonc](omo.jsonc)。

---

## 附录 A：示例提供商模型速查

> 以下清单来自本机 `omo --list-models qwen-token-plan-cn`，思考强度来自 models.dev 元数据；两者都会随提供商更新，请以命令输出为准。`qwen-token-plan-cn` 是阿里云百炼的聚合 provider，除 Qwen 系列外还托管 GLM、DeepSeek、Kimi、MiniMax 等模型。
>
> 表中 `K` / `M` 为 token 单位（K = 千，M = 百万）；“上下文”是单次请求可接受的总 token 上限，“输出”是单次回复的 token 上限，“思考模式”表示模型是否支持 `reasoning`，“图片输入”为 `—` 表示不支持。“思考强度”列出该模型支持的 `reasoning` 取值；“开关”表示仅有开/关、无强度分档；`—` 表示元数据未标注。

`qwen-token-plan-cn` 共 20 个模型，其中 9 个支持图片输入：

| 模型 ID                  | 上下文 | 输出 | 思考模式 | 图片输入 | 思考强度             |
| ------------------------ | ------ | ---- | -------- | -------- | -------------------- |
| `glm-5.3`                | 1M     | 131K | ✓        | —        | `low, high, max`     |
| `glm-5.2`                | 1M     | 131K | ✓        | —        | `high, max`          |
| `glm-5.1`                | 203K   | 128K | ✓        | —        | 开关                 |
| `glm-5`                  | 203K   | 16K  | ✓        | —        | 开关                 |
| `qwen3.8-max`            | 1M     | 131K | ✓        | ✓        | `low, medium, xhigh` |
| `qwen3.8-flash`          | 1M     | 131K | ✓        | ✓        | `low, medium, xhigh` |
| `qwen3.7-max`            | 1M     | 131K | ✓        | —        | 开关                 |
| `qwen3.7-plus`           | 1M     | 66K  | ✓        | ✓        | 开关                 |
| `qwen3.6-plus`           | 1M     | 66K  | ✓        | ✓        | 开关                 |
| `qwen3.6-flash`          | 1M     | 66K  | ✓        | ✓        | 开关                 |
| `deepseek-v4.1-flash`    | 1M     | 384K | ✓        | ✓        | `low, high, max`     |
| `deepseek-v4-pro`        | 1M     | 384K | ✓        | —        | `high, max`          |
| `deepseek-v4-pro-0813`   | 1M     | 384K | ✓        | —        | `high, max`          |
| `deepseek-v4-flash`      | 1M     | 384K | ✓        | —        | `high, max`          |
| `deepseek-v4-flash-0731` | 1M     | 384K | ✓        | —        | `high, max`          |
| `deepseek-v3.2`          | 131K   | 66K  | ✓        | —        | 开关                 |
| `kimi-k2.7-code`         | 262K   | 262K | ✓        | ✓        | 开关                 |
| `kimi-k2.6`              | 262K   | 262K | ✓        | ✓        | 开关                 |
| `kimi-k2.5`              | 262K   | 98K  | ✓        | ✓        | 开关                 |
| `MiniMax-M2.5`           | 197K   | 33K  | ✓        | —        | —                    |

OpenCode 插件侧以 `alibaba-token-plan-cn` 为 provider（与 Native 的 `qwen-token-plan-cn` 相互独立），模型清单以 `opencode models` 为准；`glm-5.3`、`deepseek-v4.1-flash`、`qwen3.8-max` 在其清单中可用，另含图片与视频生成类模型（`qwen-image-2.0`、`wan2.7-image`、`happyhorse-1.1-*` 等）。

---

_本文档基于 Oh My OpenAgent [GitHub 仓库](https://github.com/code-yeongyu/oh-my-openagent) 公开文档与本机 OmO Native 5.0.1 实机信息编写。安装见 [Installation](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/installation.md)，配置全量参考见 [omo.jsonc 参考](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/reference/omo-json.md)。_

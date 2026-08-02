# Oh My OpenAgent 配置指引

| 版本 | 日期       | 示例 Provider                         |
| ---- | ---------- | ------------------------------------- |
| v1.1 | 2026-08-02 | OpenCode · Alibaba Token Plan (China) |

> ⚠️ **时效声明**：本文所述的 agent 清单、模型清单、能力评级均会随 [Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-openagent) 及各 provider 的更新而过时。使用前请以本地 `~/.cache/opencode/models.json` 与最新 [JSON Schema](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json) 为准。文中凡引用具体模型清单之处，均标注核查日期，以便判断时效。

**配置文件路径**（两处均可，优先级从高到低）：

| 层级   | 路径                                       | 优先级 |
| ------ | ------------------------------------------ | ------ |
| 项目级 | `.opencode/oh-my-openagent.jsonc`          | 高     |
| 用户级 | `~/.config/opencode/oh-my-openagent.jsonc` | 低     |

兼容层同时识别 `oh-my-openagent.json[c]` 与旧名 `oh-my-opencode.json[c]`。JSONC 格式（支持注释与尾逗号）。

- **JSON Schema**：[oh-my-opencode.schema.json](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json)
- **适用对象**：已安装 `oh-my-openagent` 插件的 [OpenCode](https://opencode.ai/docs/zh-cn/config/) 用户
- **官方文档**：[OpenCode.asia 生态文档](https://www.opencode.asia/ecosystem/oh-my-openagent/) · [配置参考](https://www.opencode.asia/ecosystem/oh-my-openagent/configuration/)

**术语对照**：本文涉及的厂商与模型家族均使用官方名称，下表供参照。

| 术语            | 全称 / 说明                                         | 厂商                               |
| --------------- | --------------------------------------------------- | ---------------------------------- |
| OpenCode        | 开源 AI 编程 Agent（CLI 命令为 `opencode`）         | OpenCode 项目                      |
| Oh My OpenAgent | OpenCode 的多 Agent 编排插件（旧名 oh-my-opencode） | code-yeongyu                       |
| Claude          | 模型家族，含 Opus / Sonnet / Haiku / Fable 系列     | Anthropic                          |
| GPT             | 模型家族，含 5.4 / 5.5 / 5.6 Sol / Luna 等型号      | OpenAI                             |
| Gemini          | 模型家族，含 Pro / Flash 等型号                     | Google                             |
| GLM             | 模型家族，含 5 / 5.1 / 5.2 等型号                   | Zhipu AI（智谱 AI，国际品牌 Z.ai） |
| DeepSeek        | 模型家族，含 V4-Pro / V4-Flash 等型号               | DeepSeek                           |
| Qwen            | 模型家族，又称通义千问；Qwen-VL 为视觉语言子系列    | Alibaba Cloud                      |
| Kimi            | 模型家族，含 K3 / K2.7 / K2.6 等型号                | Moonshot AI                        |
| MiniMax         | 模型家族，含 M2.5 / M2.7 等型号                     | MiniMax                            |
| MiMo            | 模型家族，含 V2.5 / V2.5-Pro 等型号                 | Xiaomi（小米）                     |

**文档定位**：本文以阐述配置方法与选型思想为主，以 OpenCode 的 **Alibaba Token Plan (China)** provider（`alibaba-token-plan-cn`，baseURL `https://token-plan.cn-beijing.maas.aliyuncs.com/compatible-mode/v1`）作为示例进行演示。该 provider 同时托管 GLM、DeepSeek、Qwen-VL、Kimi 等多家模型，便于一篇文档覆盖多档位选型。若使用其他 provider，将示例中的模型 ID 替换为所用 provider 下同等能力的型号即可，配置方法与字段完全一致。

Oh My OpenAgent 是一个多 agent 编排系统，包含 **11 个内置 agent** 与 **8 个语义 category**，不同角色对模型能力的要求差异极大。本配置文件用于为每个 agent / category 指定所用模型。**将全部角色配置为同一模型属于反模式**——以旗舰模型承担简单搜索会浪费配额，以快档模型承担复杂推理会降低质量。

**目录**

- [1. 配置文件顶层结构](#1-配置文件顶层结构)
- [2. 模型选型规划：先定能力档，再选具体模型](#2-模型选型规划先定能力档再选具体模型)
  - [2.1 能力档位定义](#21-能力档位定义)
  - [2.2 能力 → 角色映射](#22-能力--角色映射)
  - [2.3 Sisyphus 的认证约束](#23-sisyphus-的认证约束)
  - [2.4 本文示例的总规](#24-本文示例的总规)
- [3. Agents 配置参考（11 个）](#3-agents-配置参考11-个)
- [4. Categories 配置参考（8 个）](#4-categories-配置参考8-个)
- [5. 字段说明](#5-字段说明)
- [附录 A：完整示例配置](#附录-a完整示例配置)
- [附录 B：Alibaba Token Plan (China) 视觉模型速查](#附录-b-alibaba-token-plan-china-视觉模型速查)

---

## 1. 配置文件顶层结构

```jsonc
// ~/.config/opencode/oh-my-openagent.jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json",
  "agents": {
    "<agent-id>": { "model": "<provider>/<model-id>" },
  },
  "categories": {
    "<category-id>": { "model": "<provider>/<model-id>" },
  },
}
```

模型 ID 格式恒为 `<provider>/<model-id>`，例如 `alibaba-token-plan-cn/glm-5.2`。其中 `<provider>` 必须为 OpenCode 已注册的 provider（由用户自定义或经插件 / auth 注册）。可运行 `opencode models` 查看当前可用的全部 provider/model 组合，运行 `opencode auth list` 查看已登录的 provider。

---

## 2. 模型选型规划：先定能力档，再选具体模型

选型的关键并非"某个 agent 使用某个具体模型"，而是"某个 agent **需要多强能力的模型**"。本文将模型能力划分为四档，任意 provider 下只要找到对应档位的型号即可替换——下文以 Alibaba Token Plan (China) 为示例给出具体映射，读者无需照搬示例中的模型设置。

### 2.1 能力档位定义

| 档位                | 能力要求                                                        | 跨 provider 参考型号                                            | 本文示例（截至 2026-08-02）                           |
| ------------------- | --------------------------------------------------------------- | --------------------------------------------------------------- | ----------------------------------------------------- |
| **S** 旗舰推理      | 最强推理 / 架构 / 长链逻辑；规划、审查、架构顾问、最难算法      | Claude Opus 4.8 / Fable 5、GPT-5.6 Sol、Kimi K3、Gemini 3.1 Pro | `glm-5.2`                                             |
| **A** 强推理 / 中强 | 可靠执行 + 中等推理；编排指挥、写代码（harness 严格时中强即可） | Claude Sonnet 4.6、GPT-5.6 Sol (medium)                         | `glm-5.2`（该 provider 无独立中强档，由 S 档兼任）    |
| **B** 快 / 低成本   | grep、查文档、琐碎改动、散文；不依赖深推理，侧重速度与成本      | Claude Haiku 4.5、GPT-5.6 Luna Fast、MiniMax M2.7 highspeed     | `deepseek-v4-flash`                                   |
| **V** 视觉          | 必须支持图片 / 视频输入并具备理解能力；图像、PDF、截图、图表    | Qwen-VL Max、Gemini、GPT-4o 级多模态                            | `qwen3.8-max-preview`（最强）/ `qwen3.7-plus`（稳定） |

> ⚠️ **纯文本模型不支持图像输入**：多数旗舰文本模型（含本文 S 档 `glm-5.2`、B 档 `deepseek-v4-flash`）的输入仅接受 text。视觉任务必须使用 V 档，否则无法完成图像理解。为 `multimodal-looker` 配置模型前，请在本地 `~/.cache/opencode/models.json` 中核对该模型的 `modalities.input` 是否包含 `image`。

### 2.2 能力 → 角色映射

下表给出各角色所需的能力档位。读者取得所用 provider 的模型清单后，按下表对应档位填入型号即可，无需拘泥于具体型号。

| 角色                 | 档位  | 选用理由                                                                     |
| -------------------- | ----- | ---------------------------------------------------------------------------- |
| `sisyphus`           | **S** | 主编排，决定整体质量上限（须认证型号，见 [2.3 节](#23-sisyphus-的认证约束)） |
| `hephaestus`         | **S** | 自主深度推理与架构                                                           |
| `oracle`             | **S** | 高智商只读顾问，承担最难推理                                                 |
| `prometheus`         | **S** | 规划与访谈，需强推理                                                         |
| `metis`              | **S** | 计划前置审查，查漏补缺                                                       |
| `momus`              | **S** | 计划评审，需强推理                                                           |
| `atlas`              | **A** | 指挥执行，中强即可                                                           |
| `sisyphus-junior`    | **A** | 代码执行者，harness 严格时中强即可                                           |
| `explore`            | **B** | 代码库 grep 类检索                                                           |
| `librarian`          | **B** | 文档与 OSS 检索                                                              |
| `multimodal-looker`  | **V** | 图像 / PDF 理解                                                              |
| `quick`              | **B** | 琐碎单文件改动                                                               |
| `unspecified-low`    | **B** | 低强度杂项任务                                                               |
| `writing`            | **B** | 文档与散文                                                                   |
| `unspecified-high`   | **S** | 高强度杂项任务                                                               |
| `visual-engineering` | **S** | 前端与设计质量                                                               |
| `ultrabrain`         | **S** | 最难逻辑                                                                     |
| `deep`               | **S** | 自主深度研究                                                                 |
| `artistry`           | **S** | 复杂创意                                                                     |

### 2.3 Sisyphus 的认证约束

Sisyphus 是主编排 agent，其提示词约 1,100 行，对模型的指令遵循、对话维持、委派编排能力有极高要求。**并非所有强推理模型都能胜任 Sisyphus**。

当前（截至 2026-08-02），Sisyphus **仅在以下模型上经过维护者验证**（完整清单以 [Agent-Model Matching Guide](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/agent-model-matching.md) 为准）：

| 模型家族 | 厂商        | 认证型号                                | 备注                                 |
| -------- | ----------- | --------------------------------------- | ------------------------------------ |
| Claude   | Anthropic   | Fable 5、Opus 4.8、Opus 4.7、Sonnet 4.6 | 首选                                 |
| Kimi     | Moonshot AI | K3、K2.7                                | 首选                                 |
| GLM      | Zhipu AI    | 5、5.1                                  | 可接受（长嵌套工作流略松）           |
| GPT      | OpenAI      | 5.4、5.5、5.6 Sol                       | 有 GPT-native 提示路径，但非推荐默认 |

> 🚨 **以下模型明确不支持 Sisyphus**
>
> **MiniMax**（MiniMax）、**Qwen**（Alibaba Cloud）、**MiMo**（Xiaomi）、**DeepSeek**（DeepSeek，含 `deepseek-v4-pro`、`deepseek-v4-flash` 等全部变体）。官方原文："We have NOT found any way to make MiniMax, Qwen, MiMo, or DeepSeek work acceptably as Sisyphus."
>
> 这些模型无法支撑 Sisyphus 的 nested todo + delegation + orchestration 提示，属模型固有特性，非"调优即可"的问题。

> ⚠️ **GLM 5.2 的实验性状态**
>
> GLM 5.2 **不属于认证集**，当前标记为 **experimental（实验性）**。维护者为其提供了校准提示，Sisyphus 回退链中的 `glm-5` 字面量经模糊匹配可能解析为 GLM 5.1 或 GLM 5.2，但仅有社区报告、尚无维护者端到端验证。任何 GLM 5.2 的使用均为实验性配置，不保证后续版本兼容。
>
> 在 `alibaba-token-plan-cn` provider 下，因该 provider 不提供 Claude / Kimi 认证型号，S 档只能落于 `glm-5.2`（可用的最低门槛选项）。更换 provider 时，若可获取 Claude（Fable 5 / Opus 4.8）或 Kimi（K3）认证型号，应优先于 GLM 5.2。

> ℹ️ **DeepSeek 的可用位置**
>
> DeepSeek 整体不在任何 agent 的回退链中，仅作为 `unspecified-low` category 的回退项被批准（官方标注 "Limited Alternative"），且不可替代仅限 Sol 的 `deep` category。故在本文示例中，`deepseek-v4-pro` **不用作 Sisyphus 的强推理替代**。而 `deepseek-v4-flash` 因能力限制，仅用于 B 档（`explore` / `librarian` / `quick` 等），不用于任何 S / A 档 agent。

> 📋 **认证清单与回退链核查地址**（权威，随版本更新）
>
> - [Agent-Model Matching Guide](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/agent-model-matching.md) — 各 agent 推荐模型与认证状态
> - [model-requirements.ts](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/packages/omo-opencode/src/shared/model-requirements.ts) — 回退链源码（agent / category 各自硬编码链）
> - 运行 `bunx oh-my-openagent doctor` — 检查当前配置的有效模型解析

### 2.4 本文示例的总规

综上，[附录 A](#附录-a完整示例配置) 的示例配置以 `glm-5.2` 兼任 S 档与 A 档（该 provider 无独立中强档）、以 `deepseek-v4-flash` 任 B 档、以 `qwen3.8-max-preview` 任 V 档（模型清单截至 2026-08-02）。若读者选用其他强推理模型（如 Claude Opus 4.8、Kimi K3），将 S 档的 `glm-5.2` 整体替换为所选型号即可；A / B / V 档同理，替换为所用 provider 下对应档位的型号。

---

## 3. Agents 配置参考（11 个）

`mode: primary` 指顶层会话 agent，可在 UI / CLI 中直接选取；`mode: subagent` 指通过 `task(subagent_type=...)` 调起的工人或顾问。

| Agent               | 模式     | 职责                                                                                                   | 能力档位¹                                                 |
| ------------------- | -------- | ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- |
| `sisyphus`          | primary  | **主编排 agent，对话默认入口**。理解目标 → 选路由 → 派发任务 → 验证 → 直至完成                         | **S**（须认证型号，见 [2.3 节](#23-sisyphus-的认证约束)） |
| `hephaestus`        | primary  | 自主深度 agent。仅给目标、不给步骤，自主探索与执行。适用于架构设计、复杂调试、跨域综合                 | **S**                                                     |
| `prometheus`        | primary  | 规划者。以工程师方式访谈、识别歧义、将计划写入 `.omo/plans/*.md`。**只读**，仅可写 `.omo/` 下的 md     | **S**                                                     |
| `atlas`             | primary  | 计划执行指挥。读取 Prometheus 计划 → 派发任务给工人 → 累积 wisdom → 独立验证。`/start-work` 时自动登场 | **A**                                                     |
| `oracle`            | subagent | 只读高智商顾问。负责架构决策、疑难调试、多系统权衡                                                     | **S**                                                     |
| `metis`             | subagent | 计划前置顾问。在 Prometheus 写计划前，识别隐藏意图、歧义、AI-slop 与缺失验收标准                       | **S**                                                     |
| `momus`             | subagent | 计划评审。就清晰度、可验证性、完整性把关，仅拦截确认的阻塞项                                           | **S**                                                     |
| `sisyphus-junior`   | subagent | 代码执行者。被禁止 delegate、强制 todo 跟踪、完成前必须通过 `lsp_diagnostics`                          | **A**                                                     |
| `explore`           | subagent | 代码库 grep。定位符号与文件                                                                            | **B**                                                     |
| `librarian`         | subagent | 外部文档与 OSS 代码检索。查阅库 API、最佳实践、实现示例                                                | **B**                                                     |
| `multimodal-looker` | subagent | 分析图片、PDF、图表、截图，需视觉理解                                                                  | **V**                                                     |

¹ 档位定义见 [2.1 节](#21-能力档位定义)；档位 → 具体型号映射见 [2.2 节](#22-能力--角色映射)、[2.4 节](#24-本文示例的总规)。

### Canonical primary 组装顺序

11 个内置 agent 中，仅有 4 个为 `primary` 模式（Sisyphus、Hephaestus、Prometheus、Atlas），即可在 UI / CLI 中直接选取作为顶层会话入口。其余 7 个均为 `subagent`，只能被 primary 调起。

建议在配置文件的 `agents` 对象中按以下顺序排列这 4 个 primary agent，该顺序反映了它们在典型工作流中的逻辑关系：

```
Sisyphus → Hephaestus → Prometheus → Atlas
```

| 顺序 | Primary Agent | 角色     | 工作流关系                                                                   |
| ---- | ------------- | -------- | ---------------------------------------------------------------------------- |
| 1    | `sisyphus`    | 主编排   | **对话默认入口**。理解目标后自行选路由、派发任务，适用于大多数场景           |
| 2    | `hephaestus`  | 自主深度 | **替代入口**。当不需要编排、只需给目标让其自主探索执行时，手动切换到此 agent |
| 3    | `prometheus`  | 规划者   | 手动调起或经 Sisyphus 委派。访谈需求后将计划写入 `.omo/plans/*.md`           |
| 4    | `atlas`       | 计划执行 | 读取 Prometheus 产出的计划并指挥工人执行。`/start-work` 命令时自动登场       |

简言之：前两位是**会话入口**（编排式 vs 自主式），后两位是**计划流**（先规划后执行）。按此顺序排列配置，阅读时能快速把握系统的核心工作流。

---

## 4. Categories 配置参考（8 个）

**Category 的含义**：Category 是一类语义意图标签，用于在委派任务时按任务性质选择模型与优化提示，而非直接指定模型名。调用方式为 `task(category="<id>", ...)`；所有 category 最终均由 `sisyphus-junior` 这一执行型 agent 承接，但系统会依据 category 的语义为其加载对应档位的模型与优化后的提示。

**Category 与 Agent 的区别**：agent 是具体的角色实体（如 `oracle`、`explore`），通过 `task(subagent_type="<id>")` 直接调用；category 描述的是任务意图（如"琐碎快活 `quick`"、"最难逻辑 `ultrabrain`"），不绑定具体 agent，仅决定以哪一档模型与何种优化提示来驱动 `sisyphus-junior`。简言之：调用 agent 是指定"由谁执行"，调用 category 是指定"以何种风格与能力档执行"。

**设计意图**：直接以模型名委派会给模型引入自我能力认知的分布偏置；以语义 category 委派则仅传递任务意图，由系统按档位匹配模型，从而规避偏置。

| Category             | 用途                                | 能力档位¹ |
| -------------------- | ----------------------------------- | --------- |
| `quick`              | 琐碎单文件改动、typo、简单修改      | **B**     |
| `unspecified-low`    | 不属于其他类、低强度杂项任务        | **B**     |
| `writing`            | 文档、散文、commit msg、PR 描述     | **B**     |
| `unspecified-high`   | 不属于其他类、高强度杂项任务        | **S**     |
| `visual-engineering` | 前端 / UI / UX / 设计 / 样式 / 动画 | **S**     |
| `ultrabrain`         | 最难的逻辑 / 算法 / 架构推理        | **S**     |
| `deep`               | 自主深度研究 + 端到端实现           | **S**     |
| `artistry`           | 复杂创意 / 非常规解题               | **S**     |

¹ 档位定义见 [2.1 节](#21-能力档位定义)；档位 → 具体型号映射见 [2.2 节](#22-能力--角色映射)、[2.4 节](#24-本文示例的总规)。除上述 8 个内置 category 外，用户可自定义 category（如 `business-logic`）。

---

## 5. 字段说明

每个 agent / category 块支持以下字段（仅列常用项，完整定义见 [JSON Schema](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json)）：

| 字段                       | 类型            | 说明                                                                                                                                                         |
| -------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `model`                    | string          | **必填**，格式 `<provider>/<model-id>`                                                                                                                       |
| `fallback_models`          | string \| array | 主模型不可用时的回退链。可填字符串数组，或对象数组（每项可带 `reasoningEffort` / `temperature` / `maxTokens` / `thinking` 等）。字符串与对象可混排于同一数组 |
| `variant`                  | string          | 模型变体标识（如 `max`、`high`）                                                                                                                             |
| `reasoningEffort`          | string          | 推理强度：`none` / `minimal` / `low` / `medium` / `high` / `xhigh` / `max`                                                                                   |
| `temperature`              | number          | 采样温度，0–2                                                                                                                                                |
| `top_p`                    | number          | 核采样概率，0–1                                                                                                                                              |
| `maxTokens`                | number          | 输出 token 上限                                                                                                                                              |
| `thinking`                 | object          | `{ "type": "enabled" \| "disabled", "budgetTokens": number }`                                                                                                |
| `prompt` / `prompt_append` | string          | 覆盖 / 追加该 agent 的系统提示                                                                                                                               |
| `disable`                  | boolean         | 禁用该 agent                                                                                                                                                 |
| `ultrawork`                | object          | ultrawork 模式专用：`{ "model": string, "variant": string }`                                                                                                 |
| `compaction`               | object          | 上下文压缩专用：`{ "model": string, "variant": string }`                                                                                                     |
| `permission`               | object          | 权限控制：`edit` / `bash` / `webfetch` / `task` 等，值为 `ask` / `allow` / `deny`                                                                            |
| `tools`                    | object          | 工具白名单 / 黑名单，键为工具名，值为 `true`（启用）/ `false`（禁用）                                                                                        |

最小可用配置仅需 `model`，其余按需。

---

## 附录 A：完整示例配置

以下为 `~/.config/opencode/oh-my-openagent.jsonc` 的当前内容，可作为起步模板。分档逻辑（模型清单截至 2026-08-02）：

| 模型                  | 档位                      | 用量 | 覆盖角色                                                                                                                                                                                  |
| --------------------- | ------------------------- | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `deepseek-v4-flash`   | **B** 快                  | ×5   | `explore`、`librarian`、categories `quick` / `unspecified-low` / `writing`                                                                                                                |
| `glm-5.2`             | **S** 强推理（兼任 A 档） | ×13  | `sisyphus`、`hephaestus`、`oracle`、`prometheus`、`metis`、`momus`、`atlas`、`sisyphus-junior`、categories `visual-engineering` / `ultrabrain` / `deep` / `artistry` / `unspecified-high` |
| `qwen3.8-max-preview` | **V** 视觉最强            | ×1   | `multimodal-looker`                                                                                                                                                                       |

```jsonc
{
  "$schema": "https:/busercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json",
  "agents": {
    "sisyphus": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "hephaestus": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "oracle": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "librarian": {
      "model": "alibaba-token-plan-cn/deepseek-v4-flash",
    },
    "explore": {
      "model": "alibaba-token-plan-cn/deepseek-v4-flash",
    },
    "multimodal-looker": {
      "model": "alibaba-token-plan-cn/qwen3.8-max-preview",
    },
    "prometheus": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "metis": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "momus": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "atlas": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "sisyphus-junior": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
  },
  "categories": {
    "visual-engineering": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "ultrabrain": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "deep": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "artistry": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "quick": {
      "model": "alibaba-token-plan-cn/deepseek-v4-flash",
    },
    "unspecified-low": {
      "model": "alibaba-token-plan-cn/deepseek-v4-flash",
    },
    "unspecified-high": {
      "model": "alibaba-token-plan-cn/glm-5.2",
    },
    "writing": {
      "model": "alibaba-token-plan-cn/deepseek-v4-flash",
    },
  },
}
```

---

## 附录 B：Alibaba Token Plan (China) 视觉模型速查

> ⚠️ **本节模型清单具有强时效性**
>
> 会随 provider 更新而变动。使用前请以本地 `~/.cache/opencode/models.json` 中该 provider 的实际清单为准，或查阅 [阿里云百炼 Token Plan 概述](https://help.aliyun.com/zh/model-studio/token-plan-overview)。以下信息核查日期为 2026-08-02。

该 provider 共 22 个模型，其中 **9 个支持图片输入**。下表为文本输出型视觉模型（适合 `multimodal-looker` 分析图像 / PDF；视频与图片生成类已排除）：

| 模型 ID               | 名称                | 上下文 | 输出   | 思考模式 | 备注                          |
| --------------------- | ------------------- | ------ | ------ | -------- | ----------------------------- |
| `qwen3.8-max-preview` | Qwen3.8 Max Preview | 1M     | 131072 | ✓        | **最强**，flagship 多模态推理 |
| `qwen3.7-plus`        | Qwen3.7 Plus        | 1M     | 65536  | ✓        | 多模态主力，稳定              |
| `qwen3.6-plus`        | Qwen3.6 Plus        | 1M     | 65536  | ✓        | 早期多模态主力                |
| `qwen3.6-flash`       | Qwen3.6 Flash       | 1M     | 65536  | ✓        | 视觉快档，低成本备选          |
| `kimi-k2.7-code`      | Kimi K2.7 Code      | 262144 | 262144 | ✓        | 偏代码，带视觉                |
| `kimi-k2.6`           | Kimi K2.6           | 262144 | 262144 | ✓        | Kimi 多模态主力               |
| `kimi-k2.5`           | Kimi K2.5           | 262144 | 98304  | ✓        | 早期 Kimi 前沿                |

> ⚠️ **不适用于图像分析的模型**
>
> - `happyhorse-1.1-*`（i2v / r2v / t2v）为**视频生成**模型，输出为 video，配置给 `multimodal-looker` 无意义
> - `qwen-image-2.0` / `qwen-image-2.0-pro` / `wan2.7-image*` 为**图片生成**模型（文生图），同样不适用于图像理解

**选型建议**：需最强视觉理解能力 → `qwen3.8-max-preview`；需稳定 → `qwen3.7-plus`；需控制成本 → `qwen3.6-flash`。

---

_本文档基于 Oh My OpenAgent [GitHub 仓库](https://github.com/code-yeongyu/oh-my-openagent) 的公开文档编写。如需安装指引，请参阅 [Installation Guide](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/refs/heads/master/docs/guide/installation.md)。_

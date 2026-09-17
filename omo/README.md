# Oh My OpenAgent 配置指引

| 版本 | 日期       | 示例 Provider                         |
| ---- | ---------- | ------------------------------------- |
| v1.5 | 2026-09-17 | OpenCode · Alibaba Token Plan (China) |

> **时效性**：本文的 agent / 模型清单与能力评级会随 [Oh My OpenAgent](https://github.com/code-yeongyu/oh-my-openagent) 及各提供商更新而变化。使用前请以本地 `~/.cache/opencode/models.json` 与最新 [JSON Schema](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json) 为准。

Oh My OpenAgent 是 OpenCode 的多 agent 编排插件，内置 **11 个 agent** 与 **8 个语义 category**。不同角色对模型能力的要求不同，需分别指定模型：检索类任务使用旗舰模型会增加消耗，复杂推理使用快档模型会影响质量；同一模型承担多档角色时，可用思考强度（`reasoning`）区分。

本文以 OpenCode 的 **Alibaba Token Plan (China)**（`alibaba-token-plan-cn`，baseURL `https://token-plan.cn-beijing.maas.aliyuncs.com/compatible-mode/v1`）为示例。该提供商同时托管 GLM、DeepSeek、Qwen、Kimi 等模型，可覆盖各能力档位。改用其他提供商时，将示例中的模型 ID 替换为同档位型号即可，配置方法与字段不变。

- **适用对象**：已安装 `oh-my-openagent` 插件的 [OpenCode](https://opencode.ai/docs/zh-cn/config/) 用户
- **JSON Schema**：[统一配置](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json)（推荐） · [旧版扁平配置](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json)
- **官方文档**：[OpenCode.asia 生态文档](https://www.opencode.asia/ecosystem/oh-my-openagent/) · [配置参考](https://www.opencode.asia/ecosystem/oh-my-openagent/configuration/)
- **权威来源**：[Agent-Model Matching Guide](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/agent-model-matching.md) · [agent-model-requirements.ts](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/packages/model-core/src/agent-model-requirements.ts) · [category-model-requirements.ts](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/packages/model-core/src/category-model-requirements.ts) · `bunx oh-my-openagent doctor`

**目录**

- [1. 配置文件结构](#1-配置文件结构)
- [2. 模型选型](#2-模型选型)
  - [2.1 能力档位](#21-能力档位)
  - [2.2 角色 → 档位](#22-角色--档位)
  - [2.3 Sisyphus 的模型约束](#23-sisyphus-的模型约束)
  - [2.4 示例配置总规](#24-示例配置总规)
- [3. Agents（11 个）](#3-agents11-个)
- [4. Categories（8 个）](#4-categories8-个)
- [5. 字段说明](#5-字段说明)
- [附录 A：完整示例配置](#附录-a完整示例配置)
- [附录 B：视觉模型速查](#附录-b视觉模型速查)

---

## 1. 配置文件结构

统一配置 `~/.omo/omo.jsonc`（harness-neutral，推荐）将 OpenCode 设置放在 `[opencode]` 命名空间下。

| 类型           | 路径                                                 | Schema                       | 优先级 | 状态     |
| -------------- | ---------------------------------------------------- | ---------------------------- | ------ | -------- |
| 项目级         | `.opencode/oh-my-openagent.json[c]`                  | `oh-my-opencode.schema.json` | 高     |          |
| 用户级（统一） | `~/.omo/omo.json[c]`                                 | `omo.schema.json`            | 中     | **推荐** |
| 用户级（兼容） | `~/.config/opencode/oh-my-open[agent\|code].json[c]` | `oh-my-opencode.schema.json` | 低     | 建议迁移 |

JSONC 支持注释与尾逗号。模型 ID 格式为 `<provider>/<model-id>`，其中 `<provider>` 必须是 OpenCode 已注册的提供商。可用 `opencode models` 查看全部 provider/model 组合，用 `opencode auth list` 查看已登录的提供商。

```jsonc
// ~/.omo/omo.jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json",
  "[opencode]": {
    "agents": {
      "<agent-id>": { "model": "<provider>/<model-id>" },
    },
    "categories": {
      "<category-id>": { "model": "<provider>/<model-id>" },
    },
  },
}
```

> **迁移旧配置**：若 `~/.config/opencode/oh-my-openagent.json` 仍存在，执行 `bunx oh-my-openagent config migrate` 会将其并入统一配置：旧文件备份至 `~/.omo/migration-backup-<时间戳>-opencode-config/`，原 `agents` / `categories` 包裹进 `[opencode]`，并写入 `_migrations` 记录。
>
> 兼容层同时识别 `oh-my-openagent.json[c]` 与旧名 `oh-my-opencode.json[c]`。旧版扁平结构（顶层直接为 `agents` / `categories`，schema 指向 `oh-my-opencode.schema.json`）仍可用，新装建议直接使用统一配置。

---

## 2. 模型选型

选型分两步：先确定角色所需的能力档位，再选择该档位下的具体型号。

### 2.1 能力档位

| 档位                | 能力要求                                                 | 跨提供商参考型号                                                                 | 本文示例                                 |
| ------------------- | -------------------------------------------------------- | -------------------------------------------------------------------------------- | ---------------------------------------- |
| **S** 旗舰推理      | 最强推理、架构与长链逻辑；规划、审查、架构顾问、最难算法 | Claude Opus 5 / Fable 5.1、GPT-6 Astra、Kimi K3、Gemini 3.1 Pro                  | `glm-5.3` · `reasoning: max`             |
| **A** 强推理 / 中强 | 可靠执行 + 中等推理；编排指挥、编码                      | Claude Sonnet 5、GPT-5.6 Sol (medium)                                            | `glm-5.3` · `reasoning: high`            |
| **B** 快 / 低成本   | grep、查文档、琐碎改动、散文；侧重速度与成本             | Claude Haiku 4.5、GPT-5.6 Luna Fast、DeepSeek V4.1 Flash、MiniMax M2.7 highspeed | `deepseek-v4.1-flash` · `reasoning: max` |
| **V** 视觉          | 支持图片 / 视频输入并具备理解能力；图像、PDF、截图、图表 | Qwen3.8 Max / Qwen-VL Max、Gemini、GPT-4o 级多模态                               | `qwen3.8-max` · `reasoning: xhigh`       |

S 与 A 共用 `glm-5.3`，通过 `reasoning` 区分：S 取 `max`，A 取 `high`；B 与 V 各取本档模型的最高强度。各模型支持的取值不同：`glm-5.3`、`deepseek-v4.1-flash` 为 `low | high | max`，`qwen3.8-max` 为 `low | medium | xhigh`；应填写所用模型支持的最高档。

> **图像输入限制**：多数文本模型仅接受 text 输入。为 `multimodal-looker` 选择模型前，请在 `~/.cache/opencode/models.json` 中确认该模型的 `modalities.input` 包含 `image`。

### 2.2 角色 → 档位

取得提供商的模型清单后，按下表为各角色填入对应档位的型号即可。

| 角色                 | 档位  | 说明                                                                      |
| -------------------- | ----- | ------------------------------------------------------------------------- |
| `sisyphus`           | **S** | 主编排，决定整体质量上限（须认证型号，见 [2.3](#23-sisyphus-的模型约束)） |
| `hephaestus`         | **S** | 自主深度推理与架构                                                        |
| `oracle`             | **S** | 只读顾问，承担最难推理                                                    |
| `prometheus`         | **S** | 规划与访谈                                                                |
| `metis`              | **S** | 计划前置审查                                                              |
| `momus`              | **S** | 计划评审                                                                  |
| `atlas`              | **A** | 指挥执行                                                                  |
| `sisyphus-junior`    | **A** | 代码执行者                                                                |
| `explore`            | **B** | 代码库检索                                                                |
| `librarian`          | **B** | 文档与 OSS 检索                                                           |
| `multimodal-looker`  | **V** | 图像 / PDF 理解                                                           |
| `quick`              | **B** | 琐碎单文件改动                                                            |
| `unspecified-low`    | **B** | 低强度杂项任务                                                            |
| `writing`            | **B** | 文档与散文                                                                |
| `unspecified-high`   | **S** | 高强度杂项任务                                                            |
| `visual-engineering` | **S** | 前端与设计                                                                |
| `ultrabrain`         | **S** | 最难逻辑                                                                  |
| `deep`               | **S** | 自主深度研究                                                              |
| `artistry`           | **S** | 复杂创意                                                                  |

### 2.3 Sisyphus 的模型约束

Sisyphus 对指令遵循、对话维持与委派编排要求较高，并非所有强推理模型都适用。当前经维护者验证的型号（完整清单以 [Agent-Model Matching Guide](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/agent-model-matching.md) 为准）：

| 模型家族 | 厂商        | 认证型号                    | 备注                                                        |
| -------- | ----------- | --------------------------- | ----------------------------------------------------------- |
| Claude   | Anthropic   | Fable 5.1、Opus 5、Sonnet 5 | 首选                                                        |
| Kimi     | Moonshot AI | K3、K2.7                    | 指令遵循接近 Claude；维护者视为较低置信（需预算思考 token） |
| GLM      | Zhipu AI    | 5.3、5.2                    | 置信度低于 Claude / Kimi                                    |
| GPT      | OpenAI      | 5.4、5.5、5.6 Sol           | 有 GPT-native 提示路径，非推荐默认                          |

以下模型不支持 Sisyphus：**MiniMax、Qwen、MiMo、DeepSeek**（含 `deepseek-v4-pro`、`deepseek-v4.1-flash` 等全部变体）。官方说明："We have NOT found any way to make MiniMax, Qwen, MiMo, or DeepSeek work acceptably as Sisyphus." 这些模型无法支撑 Sisyphus 的 nested todo、delegation 与 orchestration 提示，属模型固有特性。

> **GLM 说明**：GLM 5.3 与 5.2 均在认证集内，harness 提供 `glm-5-3` / `glm-5-2` 提示预设。`model_profile` 的 `capable` 链与 `unspecified-high` category 回退链含 `glm-5.3`；Sisyphus 自身的回退链仍含 `glm-5.2`。GLM 属较低置信配置，尚无维护者端到端验证。在 `alibaba-token-plan-cn` 下，因该提供商不提供 Claude / Kimi 认证型号，S 档使用 `glm-5.3`；若可获取 Claude 或 Kimi 认证型号，应优先于 GLM。

### 2.4 示例配置总规

[附录 A](#附录-a完整示例配置) 以 `glm-5.3` 兼任 S / A 档（该提供商无独立中强档），分别取 `reasoning: max` 与 `high`；`deepseek-v4.1-flash` 任 B 档（`max`），`qwen3.8-max` 任 V 档（`xhigh`）。档位与强度定义见 [2.1](#21-能力档位)。替换为其他强推理模型时，将 S / A 档的型号与强度一并替换。

---

## 3. Agents（11 个）

`primary` 可在 UI / CLI 中直接选取作为顶层会话入口；`subagent` 通过 `task(subagent_type=...)` 调起。

| Agent               | 模式     | 职责                                                                                   | 档位¹               |
| ------------------- | -------- | -------------------------------------------------------------------------------------- | ------------------- |
| `sisyphus`          | primary  | 主编排与默认入口。理解目标 → 选路由 → 派发任务 → 验证                                  | **S**（须认证型号） |
| `hephaestus`        | primary  | 自主深度 agent。只给目标、不给步骤，自主探索与执行                                     | **S**               |
| `prometheus`        | primary  | 规划者。访谈需求、识别歧义，将计划写入 `.omo/plans/*.md`；只读，仅可写 `.omo/` 下的 md | **S**               |
| `atlas`             | primary  | 计划执行指挥。读取计划 → 派发任务 → 汇总经验 → 独立验证                                | **A**               |
| `oracle`            | subagent | 只读顾问。架构决策、疑难调试、多系统权衡                                               | **S**               |
| `metis`             | subagent | 计划前置顾问。写计划前识别隐藏意图、歧义、低质量内容与缺失验收标准                     | **S**               |
| `momus`             | subagent | 计划评审。就清晰度、可验证性、完整性把关                                               | **S**               |
| `sisyphus-junior`   | subagent | 代码执行者。禁止 delegate、强制 todo 跟踪、完成前须通过 `lsp_diagnostics`              | **A**               |
| `explore`           | subagent | 代码库 grep，定位符号与文件                                                            | **B**               |
| `librarian`         | subagent | 外部文档与 OSS 代码检索                                                                | **B**               |
| `multimodal-looker` | subagent | 分析图片、PDF、图表、截图                                                              | **V**               |

¹ 档位定义见 [2.1](#21-能力档位)；档位 → 型号映射见 [2.4](#24-示例配置总规) 与[附录 A](#附录-a完整示例配置)。

4 个 primary agent 建议按工作流顺序排列：`Sisyphus → Hephaestus → Prometheus → Atlas`。

| 顺序 | Primary      | 角色     | 说明                                 |
| ---- | ------------ | -------- | ------------------------------------ |
| 1    | `sisyphus`   | 主编排   | 编排式会话入口，适用于多数场景       |
| 2    | `hephaestus` | 自主深度 | 自主式替代入口                       |
| 3    | `prometheus` | 规划者   | 规划流入口，产出 `.omo/plans/*.md`   |
| 4    | `atlas`      | 计划执行 | 执行规划流，`/start-work` 时自动登场 |

前两位是会话入口（编排式 / 自主式），后两位是计划流（先规划后执行）。

---

## 4. Categories（8 个）

Category 是任务意图标签，调用方式为 `task(category="<id>", ...)`。它不绑定具体 agent：所有 category 均由 `sisyphus-junior` 承接，系统按 category 语义加载对应档位的模型与提示。

**与 Agent 的区别**：`task(subagent_type=...)` 指定"由谁执行"；`task(category=...)` 指定"以何种能力档与提示执行"。以语义 category 委派，可避免向模型直接暴露能力档位信息。

| Category             | 用途                                | 档位¹ |
| -------------------- | ----------------------------------- | ----- |
| `quick`              | 琐碎单文件改动、typo、简单修改      | **B** |
| `unspecified-low`    | 低强度杂项任务                      | **B** |
| `writing`            | 文档、散文、commit msg、PR 描述     | **B** |
| `unspecified-high`   | 高强度杂项任务                      | **S** |
| `visual-engineering` | 前端 / UI / UX / 设计 / 样式 / 动画 | **S** |
| `ultrabrain`         | 最难的逻辑 / 算法 / 架构推理        | **S** |
| `deep`               | 自主深度研究 + 端到端实现           | **S** |
| `artistry`           | 复杂创意 / 非常规解题               | **S** |

¹ 档位定义见 [2.1](#21-能力档位)；档位 → 型号映射见 [2.4](#24-示例配置总规) 与[附录 A](#附录-a完整示例配置)。除上述 8 个内置 category 外，可自定义 category（如 `business-logic`）。

---

## 5. 字段说明

每个 agent / category 块支持以下字段（完整定义见 [JSON Schema](https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json)）：

| 字段                       | 类型            | 说明                                                                                                                                             |
| -------------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `model`                    | string          | **必填**，格式 `<provider>/<model-id>`                                                                                                           |
| `fallback_models`          | string \| array | 主模型不可用时的回退链。可填字符串数组，或对象数组（每项可带 `reasoning` / `temperature` / `maxTokens` / `thinking` 等）；两者可混排             |
| `reasoning`                | string          | 思考强度：`off` / `minimal` / `low` / `medium` / `high` / `xhigh` / `max` / `auto`。旧字段 `variant`、`reasoningEffort` 会被归一化为 `reasoning` |
| `temperature`              | number          | 采样温度，0–2                                                                                                                                    |
| `top_p`                    | number          | 核采样概率，0–1                                                                                                                                  |
| `maxTokens`                | number          | 输出 token 上限                                                                                                                                  |
| `thinking`                 | object          | `{ "type": "enabled" \| "disabled", "budgetTokens": number }`                                                                                    |
| `prompt` / `prompt_append` | string          | 覆盖 / 追加该 agent 的系统提示                                                                                                                   |
| `disable`                  | boolean         | 禁用该 agent                                                                                                                                     |
| `ultrawork`                | object          | ultrawork 模式专用：`{ "model": string, "reasoning": string }`                                                                                   |
| `compaction`               | object          | 上下文压缩专用：`{ "model": string, "reasoning": string }`                                                                                       |
| `permission`               | object          | 权限控制：`edit` / `bash` / `webfetch` / `task` 等，值为 `ask` / `allow` / `deny`                                                                |
| `tools`                    | object          | 工具白名单 / 黑名单，键为工具名，值为 `true`（启用）/ `false`（禁用）                                                                            |

最小可用配置仅需 `model`，其余按需。

---

## 附录 A：完整示例配置

`~/.omo/omo.jsonc` 的当前内容，可作为起步模板：

| 模型                  | 档位           | 思考强度 | 用量 | 覆盖角色                                                                                                                                                      |
| --------------------- | -------------- | -------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `deepseek-v4.1-flash` | **B** 快       | `max`    | ×5   | `explore`、`librarian`、categories `quick` / `unspecified-low` / `writing`                                                                                    |
| `glm-5.3`             | **S** 旗舰推理 | `max`    | ×11  | `sisyphus`、`hephaestus`、`oracle`、`prometheus`、`metis`、`momus`、categories `visual-engineering` / `ultrabrain` / `deep` / `artistry` / `unspecified-high` |
| `glm-5.3`             | **A** 强推理   | `high`   | ×2   | `atlas`、`sisyphus-junior`                                                                                                                                    |
| `qwen3.8-max`         | **V** 视觉     | `xhigh`  | ×1   | `multimodal-looker`                                                                                                                                           |

```jsonc
// OMO configuration: ~/.omo/omo.jsonc
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json",
  "[opencode]": {
    "agents": {
      "sisyphus": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "hephaestus": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "oracle": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "librarian": {
        "model": "alibaba-token-plan-cn/deepseek-v4.1-flash",
        "reasoning": "max",
      },
      "explore": {
        "model": "alibaba-token-plan-cn/deepseek-v4.1-flash",
        "reasoning": "max",
      },
      "multimodal-looker": {
        "model": "alibaba-token-plan-cn/qwen3.8-max",
        "reasoning": "xhigh",
      },
      "prometheus": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "metis": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "momus": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "atlas": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "high",
      },
      "sisyphus-junior": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "high",
      },
    },
    "categories": {
      "visual-engineering": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "ultrabrain": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "deep": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "artistry": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "quick": {
        "model": "alibaba-token-plan-cn/deepseek-v4.1-flash",
        "reasoning": "max",
      },
      "unspecified-low": {
        "model": "alibaba-token-plan-cn/deepseek-v4.1-flash",
        "reasoning": "max",
      },
      "unspecified-high": {
        "model": "alibaba-token-plan-cn/glm-5.3",
        "reasoning": "max",
      },
      "writing": {
        "model": "alibaba-token-plan-cn/deepseek-v4.1-flash",
        "reasoning": "max",
      },
    },
  },
}
```

---

## 附录 B：视觉模型速查

> **时效性**：以下清单会随提供商更新。使用前请以 `~/.cache/opencode/models.json` 或阿里云百炼 [Token Plan 团队版概述](https://help.aliyun.com/zh/model-studio/token-plan-team-overview#tpt01-h-models) 为准。本次核查时 `models.dev` 尚未为 `alibaba-token-plan-cn` 收录 `glm-5.3`（以及 `qwen-image-3.0-pro`、`qwen-audio-3.0-*`），本地 `opencode models` 可能暂不显示。

`alibaba-token-plan-cn` 共 31 个模型，其中 9 个支持图片输入。下表为文本输出的视觉模型（适合 `multimodal-looker`；视频、图片生成与语音类已排除）：

| 模型 ID               | 名称                | 上下文 | 输出   | 思考模式 | 备注                      |
| --------------------- | ------------------- | ------ | ------ | -------- | ------------------------- |
| `qwen3.8-max`         | Qwen3.8 Max         | 1M     | 131072 | ✓        | 多模态旗舰，支持 PDF 输入 |
| `qwen3.8-flash`       | Qwen3.8 Flash       | 1M     | 131072 | ✓        | 新一代视觉快档，支持视频  |
| `qwen3.7-plus`        | Qwen3.7 Plus        | 1M     | 65536  | ✓        | 多模态主力，稳定          |
| `qwen3.6-plus`        | Qwen3.6 Plus        | 1M     | 65536  | ✓        | 早期多模态主力            |
| `qwen3.6-flash`       | Qwen3.6 Flash       | 1M     | 65536  | ✓        | 视觉快档，低成本备选      |
| `deepseek-v4.1-flash` | DeepSeek V4.1 Flash | 1M     | 384000 | ✓        | B 档兼 V 档备选           |
| `kimi-k2.7-code`      | Kimi K2.7 Code      | 262144 | 262144 | ✓        | 偏代码，带视觉            |
| `kimi-k2.6`           | Kimi K2.6           | 262144 | 262144 | ✓        | Kimi 多模态主力           |
| `kimi-k2.5`           | Kimi K2.5           | 262144 | 98304  | ✓        | 早期 Kimi 前沿            |

> `reasoning` 最高档因模型而异：`deepseek-v4.1-flash` 为 `max`，`qwen3.8-max` / `qwen3.8-flash` 为 `xhigh`。

---

_本文档基于 Oh My OpenAgent [GitHub 仓库](https://github.com/code-yeongyu/oh-my-openagent) 公开文档编写。安装指引见 [Installation](https://github.com/code-yeongyu/oh-my-openagent/blob/dev/docs/guide/installation.md)。_

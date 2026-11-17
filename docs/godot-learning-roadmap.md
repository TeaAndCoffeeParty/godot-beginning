# Godot 4 功能驱动学习路线（大纲 v0.2）

> 生成日期：2026-11-17
> 适用对象：有 Android / Java / Kotlin 背景、已经能跑通 Godot 基础项目、想系统补齐引擎能力的开发者

---

## 零、这份大纲的起点：先看清你现在在哪

这不是一份「零基础入门」大纲。写下之前我读了你的仓库 `D:\homespace\godot-beginning`，实际情况是：

| 工程 | Godot 版本 | 内容 | 说明 |
|---|---|---|---|
| `firstgame` | 4.4 | Sprite2D + 脚本 | 第一个工程 |
| `first2dgame` | 4.4 | main / mob / player / hud | 官方 Dodge the Creeps 教程 |
| `tutorial-move` | 4.5 | Cat / Cow / 关卡 / 箱子 / 床 | 角色移动与交互教程 |
| `jrpg-move` | 4.5 | game_world + player | JRPG 地图行走 |
| `jrpg-battle` | 4.5 | battle_scene + character | JRPG 回合制战斗 |
| `dual-map-testing` | 4.5 | TileMapDual 插件 + map | 瓦片双网格（自动过渡） |
| `theming-tutoal` | 4.5 | slot / party_slot / gameplay_ui / Item | UI 主题与物品栏 |

另外 `docs/HowToMakeJRPG/` 下有《How to Make an RPG》的英文原文、中文对照和 PDF，`pixel101/` 下有大量 Aseprite 像素素材，git 提交里能看到 `JRPG-119`、`JRPG-72` 这类工单号。

**三个结论：**

1. **你已经越过了「入门」阶段。** 场景、节点、脚本、基础移动你都摸过了，再从头学一遍 `_ready` 和 `print` 是浪费时间。
2. **你的缺口在「心智模型」和「系统性」。** 能跟着教程做出东西，不等于知道为什么这样做；换个需求就卡住，正是因为缺乏阶段 1 那层理解。
3. **版本在漂移。** 4.4 和 4.5 混着用，`Forward Plus` 与 `canvas_items` 拉伸策略各工程不一致。这不致命，但会持续制造「明明一样写法却不生效」的困惑。

所以这份大纲的重心不是「教你用工具」，而是**把已经会用的东西重新拆开，逐个确认你真的懂**。

---

## 一、方法论：功能驱动，但要加三个约束

你要的「一个功能一个功能慢慢学」，本质是**按引擎的功能单元（Feature Unit）而非教程章节来组织**。这是对的：教程是线性的，引擎能力是网状的，跟着教程走完往往只记住一条主线。

但只做到「一个功能一个功能」还不够，加三个约束才能真正长本事：

### 约束一：每个单元必须有可运行的产出

一个单元 = 20 到 60 分钟，结束时你手里要能跑出一个小场景。只「看懂了」不算过。

### 约束二：粒度以「一个 API 簇」为单位，不以「菜单项」为单位

一个单元覆盖一组强相关的 API，能独立解释一个现象。比如 `CharacterBody2D` 是单元，`move_and_slide` 的返回值详解不是单独单元，而是它的变式挑战。

### 约束三：每 4 到 6 个单元必须有一个项目锚点

否则 60 个功能点学完，你还是做不出一个游戏。功能是砖，项目才是墙。

### 统一的功能卡模板

每个单元学完，在语雀「Godot 功能卡」表格里记一行（这张表是本文档的姊妹文档，见阶段 0.4）：

| 字段 | 填什么 |
|---|---|
| 单元编号与名称 | 2.4 CharacterBody2D 移动 |
| 一句话本质 | 用速度向量驱动一个会碰撞的 2D 身体 |
| 核心 API | `velocity`、`move_and_slide()`、`is_on_floor()` |
| 最小实验 | 方块能左右走、跳、落地，不会穿墙 |
| 变式挑战 | 加土狼时间（coyote time）与跳跃缓冲 |
| 常见坑 | 移动写在 `_process` 而不是 `_physics_process` |
| 自检问题 | 不看文档说出 `move_and_slide` 三个返回值的含义 |
| 状态 | 已掌握 / 会用但不懂 / 待复习 |
| AI 提问记录 | 保存当次对话结论，形成个人知识库 |

「状态」这一列是关键：它让这份大纲从「学完一遍」变成「可复习的资产」。

---

## 二、分阶段大纲

按「**用 → 懂 → 优化**」三层递进，7 个阶段、62 个功能单元 + 4 个实战项目。按你每周 6 到 8 小时计，约 16 周。

### 阶段 0：基线校准（第 1 周，4 个单元）

先把地基对齐，否则后面每个单元都会遇到「上个工程是 4.4、这个是 4.5」的杂音。

| # | 单元 | 核心概念 | 最小实验 | 常见坑 |
|---|---|---|---|---|
| 0.1 | 版本与渲染器统一 | `config/features`、Forward+ / Mobile / Compatibility | 把 7 个工程统一到 4.5；列出各工程渲染器差异 | 4.4 升 4.5 直接开工程不报错，但 `.tscn` 里 UID 引用可能失效 |
| 0.2 | 实验台约定 | 「一阶段一工程、一单元一场景」 | 建 `lab-01-core` 工程，按 `01_node_tree.tscn` 命名场景 | 所有实验堆一个工程，场景树越来越乱，最后不敢删 |
| 0.3 | 调试基建 | 断点、Remote 场景树、Errors 面板、`print` 规范 | 在 `jrpg-move` 里打断点观察 `_physics_process` 每帧调用 | 只看 Output 不看 Remote，运行时节点状态全靠猜 |
| 0.4 | 功能卡系统落地 | 语雀表格 + 自检问题 | 建「Godot 功能卡」表格，录入前 5 张卡 | 只记笔记不设「状态」列，三个月后不知道哪些真会 |

**阶段 0 验收**：7 个工程版本一致，`lab-01-core` 能跑，功能卡表建好。

---

### 阶段 1：引擎核心心智模型（第 2 到 3 周，12 个单元）

**这是整条路线里最值钱的部分。** 你已经能做出东西，但大概率在这 12 个点上有模糊地带。做完这一阶段，你看任何 Godot 教程都能「看出它在讲哪个机制」。

| # | 单元 | 核心 API 与概念 | 最小实验 | 常见坑 |
|---|---|---|---|---|
| 1.1 | Node 与场景树 | `Node`、`add_child`、`get_parent`、`get_children` | 运行时用代码动态生成 5 个 Label 排成一行 | 以为场景树是「层级 UI」，其实是运行时对象图 |
| 1.2 | 节点生命周期 | `_enter_tree` / `_ready` / `_process` / `_physics_process` / `_exit_tree` | 每个回调加带时间戳的 print，观察子节点先于父节点 ready | 在 `_ready` 里访问还没进树的兄弟节点 |
| 1.3 | 节点路径 | `$Path`、`get_node()`、`%UniqueName` | 同一个节点用三种方式取到，比较哪个在重构后不炸 | 硬编码长路径，挪一层节点全崩 |
| 1.4 | 场景实例化 | `PackedScene`、`preload`、`instantiate()`、`add_child` | 把「敌人」做成独立场景，运行中生成 10 个 | 实例化后忘记 `add_child`，节点存在但不显示 |
| 1.5 | 信号 Signal | `signal`、`connect`、`emit`、`Callable`、`bind` | 按钮点击 → 自定义信号 → 三个不同节点各自响应 | 用 `connect` 字符串旧写法；重复连接导致一次点击触发两次 |
| 1.6 | 导出与属性 | `@export`、`@export_range`、`@onready`、`@export_group` | 做一个「可调参数」的敌人生成器，全部参数从 Inspector 配 | `@onready` 变量在 `_ready` 之前被别处访问，读到 null |
| 1.7 | 自定义 Resource | `extends Resource`、`class_name`、`.tres`、`ResourceLoader` | 做 `ItemData` 资源，用 3 个 `.tres` 表示 3 件武器 | 把 Resource 当数据库用，运行时改它导致所有引用一起变 |
| 1.8 | Autoload 单例 | Project Settings → Autoload、`get_node("/root/X")` | 做 `GameState` 存金币，跨场景保留 | Autoload 里 `_ready` 访问场景节点，时序上一定拿不到 |
| 1.9 | 输入系统 | `InputMap`、`Input.is_action_pressed`、`is_action_just_pressed` | 把硬编码的 `KEY_A` 全部改成 action | `is_action_pressed` 写在 `_process` 里做「按一次触发一次」 |
| 1.10 | 场景切换 | `change_scene_to_file`、`change_scene_to_packed`、`get_tree().current_scene` | 主菜单 → 关卡 → 结算，三场景循环 | 切场景后老场景的 Autoload 引用还是旧对象 |
| 1.11 | 组 Group | `add_to_group`、`get_tree().get_nodes_in_group`、`call_group` | 所有敌人入组，一次调用全部冻结 | 用组代替信号做高频通信，性能崩 |
| 1.12 | 时间与暂停 | `get_tree().paused`、`process_mode`、`Engine.time_scale` | 按 ESC 暂停，暂停时 UI 仍可点 | 暂停后 UI 也停了，因为 `process_mode` 没设 `WHEN_PAUSED` |

**阶段 1 锚点项目**：`lab-02-core`——两个场景互相切换、带暂停菜单、用 Autoload 存分数并显示在 HUD。要求：不看教程，从空工程开始，40 分钟内完成。

---

### 阶段 2：2D 表现与交互（第 4 到 6 周，17 个单元）

你已经有 `first2dgame` 和 `tutorial-move` 的底子，这一阶段是把「会拼」升级成「会选」。

| # | 单元 | 核心 API 与概念 | 最小实验 | 常见坑 |
|---|---|---|---|---|
| 2.1 | Sprite2D 与贴图 | `texture`、`region_enabled`、`flip_h`、`centered`、`offset` | 用一张 sprite sheet 切出 4 帧 idle | 像素画开了默认线性过滤，糊成一团 |
| 2.2 | AnimatedSprite2D | `SpriteFrames`、`play`、`animation_finished`、`frame_changed` | idle / run / jump 三动画，按状态切换 | 动画播完不停，循环状态机卡在最后一帧 |
| 2.3 | AnimationPlayer | 关键帧、`AnimationTree` 入门、`animation_finished` | 做一个门打开 + 摄像机推进的组合动画 | 用 AnimationPlayer 做角色移动，物理对不上 |
| 2.4 | CharacterBody2D 移动 | `velocity`、`move_and_slide()`、`is_on_floor()`、`floor_snap_length` | 左右走、跳、落地，斜坡不滑 | 把移动写在 `_process`，帧率一变速度就变 |
| 2.5 | 碰撞体与物理层 | `CollisionShape2D`、`collision_layer`、`collision_mask`、`Area2D` 与 body 区别 | 玩家只撞墙不撞道具，敌人只撞玩家 | 层和掩码搞反，物体互相穿过还查不出原因 |
| 2.6 | Area2D 检测 | `body_entered`、`area_entered`、`get_overlapping_bodies` | 金币拾取区 + 伤害判定区 | 用 `_process` 轮询重叠，性能差且漏帧 |
| 2.7 | RayCast2D | `is_colliding`、`get_collider`、`force_raycast_update` | 敌人视线检测，看到玩家才追击 | 每帧新建 RayCast2D |
| 2.8 | TileMapLayer | `TileMapLayer`、`TileSet`、`terrain`、`physics layer` | 用 terrain 自动铺草地、水、路 | 4.3 后仍用 `TileMap`，新特性都用不上 |
| 2.9 | Camera2D | `position_smoothing_enabled`、`limit_*`、`drag_*`、`make_current` | 跟随玩家 + 关卡边界限制 + 受击震屏 | 相机拖尾参数全开，手感反而糊 |
| 2.10 | Parallax2D | 4.3+ 的 `Parallax2D`、`scroll_scale`、`repeat_size` | 三层视差背景，横向滚动不露边 | 用老 `ParallaxBackground` 教程，节点在 4.5 里已弃用 |
| 2.11 | 音频 | `AudioStreamPlayer` / `2D`、`AudioBusLayout`、`AudioServer` | BGM + 3 个音效分属不同总线，音量独立可调 | 音效每次新建播放器，节点泄漏 |
| 2.12 | 粒子 | `GPUParticles2D`、`ParticleProcessMaterial`、`emitting` | 跑步尘土 + 受击火花 | 粒子材质没设 `emission_shape`，粒子全从一个点喷 |
| 2.13 | 2D 光照 | `PointLight2D`、`LightOccluder2D`、`CanvasModulate` | 夜晚场景，角色提灯照亮 | 忘了 `CanvasModulate` 压暗全场景，光看起来「不发光」 |
| 2.14 | CanvasLayer 与 Control | `CanvasLayer`、`Control`、锚点 `anchor_*`、`Container` 区别 | UI 固定屏幕，不随相机移动 | 把 UI 塞进世界节点下，相机一动 UI 就跑 |
| 2.15 | 容器布局 | `VBoxContainer`、`HBoxContainer`、`MarginContainer`、`size_flags_*` | 做一个自动适配 16:9 与 4:3 的结算界面 | 用绝对坐标摆 UI，换个分辨率全错位 |
| 2.16 | Theme 与字体 | `Theme`、`theme_type_variation`、`FontVariation` | 给全项目统一按钮样式与字体 | 每个按钮单独改样式，改一次要改 20 处 |
| 2.17 | Tween | `create_tween()`、`tween_property`、`set_trans`、`chain`、`parallel` | 血条平滑下降 + 数值弹跳 + 菜单滑入 | 在 Tween 里改物理属性，和 `_physics_process` 打架 |

**阶段 2 锚点项目**：`lab-03-2d`——一个 2D 平台小关：移动跳跃、敌人巡逻、金币拾取、相机跟随、UI 血条、音效。**这个项目要能导出的成品。**

---

### 阶段 3：游戏系统（第 7 到 8 周，12 个单元）

这一阶段是从「做 demo」到「做游戏」的分水岭。你正在做 JRPG，其中 3.7 对话、3.8 背包是直接可用的。

| # | 单元 | 核心概念 | 最小实验 | 常见坑 |
|---|---|---|---|---|
| 3.1 | 有限状态机 | 状态枚举 + 状态节点 / 状态脚本 | 把玩家移动改成 `Idle/Run/Jump/Fall` 四状态 | 状态切换散落各处 if，新增状态要改 5 个文件 |
| 3.2 | 事件总线 | Autoload + 自定义信号 | `GameEvents.player_died` 全局广播，UI 与音效各自订阅 | 用事件总线传所有参数，最后没人知道谁发的 |
| 3.3 | 数据驱动设计 | Resource 配表、数组资源、`@export` 嵌套 | 用 `WeaponData` 资源配 5 把武器，表格化 | 把数值写死在脚本里，调平衡要改代码 |
| 3.4 | 对象池 | 预生成 + 取用归还 | 子弹池 50 发循环使用，无 instantiate | 池化对象状态没重置，复用后残留上次数据 |
| 3.5 | 存档 | `ConfigFile`、`JSON`、`ResourceSaver`、`user://` | 存 关卡进度 + 金币 + 设置，重启能读回 | 存 Resource 引用路径而非数据，版本升级后失效 |
| 3.6 | 异步加载 | `ResourceLoader.load_threaded_request`、进度回调 | 加载大场景时显示进度条 | 主线程 `load` 卡死，进度条一动不动 |
| 3.7 | 对话系统 | 数据结构 + `RichTextLabel` 打字机 + 分支 | 三段对话带选项分支，选项影响后续 | 对话逻辑写进 UI 脚本，加分支就失控 |
| 3.8 | 背包与物品 | `ItemData` 资源 + `Inventory` 容器 + 拖拽 UI | 拾取入包、装备、使用、消耗 | 用节点树当数据结构，排序和查找都很难 |
| 3.9 | 本地化 | `tr()`、`TranslationServer`、CSV 翻译表 | 中英切换，UI 与对话全部生效 | 字符串散落在脚本里，提取时漏一半 |
| 3.10 | 设置菜单 | 音量总线、`InputMap` 运行时重绑定 | 音量滑条 + 按键重绑定 + 存盘 | 重绑定没处理冲突，两个动作绑同一个键 |
| 3.11 | 性能剖析 | Profiler、`Performance` 单例、`print_orphan_nodes` | 找到项目里最耗时的 3 个函数 | 只看 FPS 不看 Profiler，优化全靠猜 |
| 3.12 | 单元测试 | GUT 框架、断言、`before_each` | 给背包写 5 个测试用例 | 测试依赖场景树，跑起来就崩 |

**阶段 3 锚点项目**：给 `lab-03-2d` 加上状态机、存档、设置菜单、事件总线。

---

### 阶段 4：3D（第 9 到 10 周，9 个单元）

你的工程全是 2D，这一阶段是**扩展新领域**，不是补课。3D 的心智模型和 2D 共享 80%，重点是变换、光照、导航。

| # | 单元 | 核心概念 | 最小实验 | 常见坑 |
|---|---|---|---|---|
| 4.1 | Node3D 与变换 | `position`、`rotation`、`basis`、`global_transform`、父子变换 | 父节点旋转 45°，观察子节点世界坐标 | 用局部坐标做世界方向计算，斜着走就偏 |
| 4.2 | MeshInstance3D 与材质 | `Mesh`、`StandardMaterial3D`、`albedo`、`metallic` / `roughness` | 一个房间：地板、墙、金属球、玻璃 | 材质全用默认，场景像塑料玩具 |
| 4.3 | Camera3D | 投影 `projection`、FOV、`look_at`、第一人称 / 第三人称 | 鼠标控制视角，WASD 移动 | 旋转顺序（yaw 与 pitch 分离）搞错，视角会翻转 |
| 4.4 | 光照与环境 | `DirectionalLight3D`、`OmniLight3D`、`WorldEnvironment`、`sky`、`SSAO`、`glow` | 白天 → 黄昏 → 夜晚三套环境切换 | 只调灯光不调环境，画面永远灰 |
| 4.5 | CharacterBody3D | `velocity`、`move_and_slide`、`is_on_floor`、`up_direction` | 3D 走跳，斜坡不滑，楼梯能上 | 直接用 2D 参数调 3D 重力，跳起来像月球 |
| 4.6 | 碰撞与刚体 | `CollisionShape3D`、`RigidBody3D`、`PhysicsMaterial` | 推箱子、扔球、堆叠 | 刚体用 `position` 直接改，物理直接爆 |
| 4.7 | NavigationAgent3D | `NavigationRegion3D`、`NavigationAgent3D`、`bake` | 敌人绕过障碍追玩家 | 改了地形没重新 bake，寻路走直线穿墙 |
| 4.8 | 3D 动画 | `AnimationTree`、`StateMachine`、`blend`、骨骼动画 | 走 / 跑 / 跳三态混合 + 转身 | 动画根运动没处理，角色穿模 |
| 4.9 | Shader 入门 | `shader_type spatial`、`uniform`、`ALBEDO`、`vertex` | 一个随时间流动的水面 + 描边效果 | 把 Shader 当魔法，不看文档乱复制 |

**阶段 4 锚点项目**：`lab-04-3d`——第一人称小 demo：移动、拾取、一个简单房间关卡、有光照层次。

---

### 阶段 5：工程化与进阶（第 11 到 12 周，8 个单元）

| # | 单元 | 核心概念 | 最小实验 | 常见坑 |
|---|---|---|---|---|
| 5.1 | 编辑器插件 | `EditorPlugin`、`@tool`、`EditorInterface` | 做一个批量重命名节点的插件 | `@tool` 脚本里访问运行时数据，编辑器直接崩 |
| 5.2 | GDExtension | C++ / Rust 扩展、`gdextension` 配置 | 用 C++ 写一个简单节点类注册到引擎 | 版本 ABI 不匹配，加载即崩 |
| 5.3 | C# 接入 | .NET 版、C# 与 GDScript 互调、性能取舍 | 用 C# 重写计算密集的部分 | GDScript 与 C# 互相引用，循环依赖编译失败 |
| 5.4 | 多线程 | `WorkerThreadPool`、`Thread`、`Mutex` | 后台生成地图数据，主线程显示进度 | 在子线程碰场景树，必然崩 |
| 5.5 | 渲染与优化 | 三种渲染器、`OcclusionCulling`、`MultiMesh`、`LOD` | 1000 个物体用 MultiMesh，对比纯节点 | 3D 项目用 Compatibility 渲染器，效果全丢 |
| 5.6 | 导出发布 | 导出预设、Android / Web、`export_presets.cfg` | Windows + Android 两平台跑通 | 导出后资源路径大小写问题，Windows 能跑 Linux 挂 |
| 5.7 | 网络多人 | `MultiplayerAPI`、`ENetMultiplayerPeer`、RPC | 两个客户端同步一个方块位置 | 每帧 RPC 同步位置，带宽爆炸 |
| 5.8 | 版本控制 | `.gitignore`、`.tscn` 合并冲突、Git LFS | 两人同时改一个场景，手动解决冲突 | 把 `.godot/` 提交上去，每个 clone 都报错 |

---

### 阶段 6：项目实战（第 13 到 16 周）

| 项目 | 周期 | 验收标准 | 对应你这四个月练过的能力 |
|---|---|---|---|
| P1 2D 平台跳跃小游戏 | 2 周 | 3 关、存档、主菜单、可导出安装包 | 阶段 2 + 阶段 3 |
| P2 2D 俯视角 RPG 原型 | 2 周 | 对话、背包、敌人 AI、地图切换、战斗 | 阶段 2 + 阶段 3（直接延续你的 JRPG 教程） |
| P3 3D 小 demo | 2 周 | 移动、拾取、关卡、光照 | 阶段 4 |
| P4 复盘与发布 | 收尾 | 一篇「我踩过的 10 个坑」，3 个项目上架或开源 | 全部 |

**注意 P2 和你的 JRPG 教程的关系**：教程做的是 `jrpg-move`、`jrpg-battle`，是分立的演示。P2 要做的是把它们**缝成一个完整可玩的原型**——这正是从「跟教程」到「做项目」的关键一跳。

---

## 三、AI 辅助学习法

「资料少」的正确解法不是找更多教程，而是**把 AI 当随时可问的助教**。但要设死三条红线，否则会被带偏。

### 三条红线

**红线一：Godot 3 与 4 的 API 差异极大，AI 会混用。**

每次提问先声明「Godot 4.x，只给 4.x 的 API，不确定就说不确定」。看到下面这些词立刻警觉，那是 Godot 3：

| Godot 3 的写法 | Godot 4 的替代 |
|---|---|
| `yield()` | `await` |
| `KinematicBody2D` | `CharacterBody2D` |
| `Spatial` | `Node3D` |
| `TileMap` | `TileMapLayer` |
| `ParallaxBackground` | `Parallax2D` |
| `connect("sig", self, "func")` | `sig.connect(func)` |
| `export var x` | `@export var x` |

**红线二：不要让 AI 直接给成品代码。**

直接要代码，你得到的是「能跑但不懂」的黑盒。要「最小可运行片段 + 解释 + 一个改坏它的练习」。

**红线三：AI 给的 API 一定去官方类参考页核对一次。**

Godot 文档每个类页都有完整属性 / 方法 / 信号列表。AI 记错的参数名，一查就现形。这一步别省。

### 七个可固化的提示词模式

1. **概念降维**：`用 3 句话解释 Godot 4 的 X 的本质，再举一个日常类比，并指出这个类比在哪里失效。`
2. **预测-验证**：`给我一段 15 行以内的 Godot 4 代码，先别解释，让我预测输出；等我回答后再逐行解释。`（这是效率最高的模式，强迫你从「读」切换到「推演」）
3. **反例训练**：`列出 3 种错误使用 X 的写法，说明每种会导致什么现象、怎么排查。`
4. **源码导航**：`Godot 4 里 X 功能在引擎源码哪个类实现？关键函数名是什么？`（配合 GitHub 上的 godotengine/godot）
5. **出题检验**：`针对 X 出 10 道题，6 道概念、2 道改错、2 道动手，先只给题目。`
6. **最小项目生成**：`用 X 设计一个 30 分钟能完成的小任务，给出验收标准和常见失败现象。`
7. **代码审查**：`这是我的代码，按 Godot 4 最佳实践审查，指出 3 个最值得改的地方，并说明为什么。`

每完成一个单元，把「自检问题的答案 + AI 对话里的关键结论」写进功能卡。**半年后这张表就是你自己写的、比任何教程都贴合你的 Godot 手册。**

---

## 四、资料地图

资料确实少，但下面这几处够用，且权威。

| 来源 | 用途 | 说明 |
|---|---|---|
| `docs.godotengine.org` 中文版 `/zh-cn/4.x/` | 查 API 的**唯一权威** | 每个类页有属性、方法、信号、示例；遇到不确定的参数先查这里 |
| GitHub `godotengine/godot-demo-projects` | 每个功能的**可运行参考** | 比教程可靠，直接跑起来读源码 |
| GDQuest | 系统课 | 免费 2D/3D 课程，教学法最好 |
| Brackeys Godot 4 入门 | 建立第一印象 | 你已经过了这个阶段，可当复习 |
| 官方 Discord / 论坛 | 卡住时问 | 响应很快，提问前先搜 |
| `github.com/godotengine/godot` | 为什么这样设计 | 配合「源码导航」提示词 |
| 你手边的《How to Make an RPG》 | JRPG 主线 | 已在中英对照，继续吃透 |

**你仓库里已经有的优势**：`docs/HowToMakeJRPG/` 有中英双语文档和 PDF，`pixel101/` 有成套像素素材。这意味着你做 P2 时不用到处找美术资源——这在独立开发里是很大的时间节省。

---

## 五、16 周时间表（每周 6 到 8 小时）

| 周 | 内容 | 周末产出 |
|---|---|---|
| 1 | 阶段 0 全部 | 版本统一 + `lab-01-core` + 功能卡表 |
| 2–3 | 阶段 1 | `lab-02-core` 场景切换 demo |
| 4–6 | 阶段 2 | `lab-03-2d` 平台小关（可导出） |
| 7–8 | 阶段 3 | 给平台关加上存档、设置、状态机 |
| 9–10 | 阶段 4 | `lab-04-3d` 第一人称 demo |
| 11–12 | 阶段 5 | 三平台导出 + 一个编辑器插件 |
| 13–16 | 阶段 6 | P1 → P2 → P3 → 复盘 |

**弹性规则**：每周只能投入 3 到 4 小时，就把 16 周拉长到 24 周，**单元顺序不变**。顺序是有依赖关系的，砍单元可以，跳顺序不行。

---

## 六、下一步

这份文档是骨架。真正开始学之前，有三件事要先定：

1. **确认主攻方向**：继续深挖 2D JRPG（你的教程和素材都在那），还是也想铺 3D？——决定阶段 4 的权重，以及 P3 做不做。
2. **确认每周可投入时间**：6 到 8 小时排 16 周，3 到 4 小时排 24 周。
3. **确认颗粒度偏好**：每个单元要不要展开成「可直接照做的实验清单」（含具体节点树、脚本、参数）？要的话我按阶段 0 → 2 的顺序一篇篇写。

确认后我会：
- 把这份大纲建成语雀文档，并按阶段拆成 7 篇子文档；
- 建「Godot 功能卡」表格，预填阶段 0 和阶段 1 的 16 张卡；
- 从阶段 0.1 开始，一个单元一个单元陪你走，每个单元给你实验清单 + 自检题 + 代码审查。

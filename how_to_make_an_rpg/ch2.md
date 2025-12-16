这是一份专为 **Godot 4.5+** 编写的《How to Make an RPG》第二章学习指南。

书中主要使用 Lua 编写底层引擎，而在 Godot 中，我们不需要从画点开始，而是利用引擎现有的节点来实现相同的逻辑。

---

# Godot 4.5 RPG 开发指南：探索篇 (Exploration)

## 1. Tilemaps (瓦片地图)
**核心目标**：将细碎的像素素材（Tileset）组合成完整的游戏地图，并处理渲染和相机。

### Godot 4.5 实现方案
书中需要手动写 UV 计算和渲染循环，Godot 中直接使用节点。

*   **节点选择**：
    *   **必须使用 `TileMapLayer`**：Godot 4.5 中，不再建议使用旧的 `TileMap` 节点。你需要为每一层（地面、墙壁、装饰）创建一个独立的 `TileMapLayer` 节点。
*   **资源设置**：
    *   在文件系统中双击你的素材（如 `atlas.png`），在导入设置中将 Filter 设为 **Nearest**（像素风必须设置，否则会模糊）。
    *   创建 `TileSet` 资源，将图片拖入底部面板，选择 "Yes" 自动切片。
*   **相机控制**：
    *   添加 `Camera2D` 节点。
    *   将其作为主角节点的**子节点**。
    *   启用 `Position Smoothing`（位置平滑）以获得更现代的手感，或者关闭它以获得复古手感。

---

## 2. From Maps to Worlds (从地图到世界)
**核心目标**：让地图拥有逻辑，不仅仅是图片。主要包括碰撞检测（不能穿墙）和层级遮挡（Y-Sort）。

### Godot 4.5 实现方案
书中使用代码数组判断 `IsBlocked`，Godot 推荐使用 **Custom Data**。

*   **碰撞检测 (Grid-based)**：
    1.  打开 `TileSet` 编辑器 -> 右侧 Inspector -> **Custom Data Layers**。
    2.  添加一个 Layer，命名为 `is_wall`，类型为 `bool`。
    3.  在 TileSet 画板中，选中墙壁、水等瓦片，将其 `is_wall` 属性勾选为 `true`。
    4.  **代码实现**：
        ```gdscript
        func can_move_to(target_pos: Vector2) -> bool:
            var map_layer = get_node("../TileMapLayer_Ground")
            var grid_pos = map_layer.local_to_map(target_pos)
            var tile_data = map_layer.get_cell_tile_data(grid_pos)
            
            # 如果没有瓦片，或者是墙壁，则返回 false
            if tile_data == null or tile_data.get_custom_data("is_wall") == true:
                return false
            return true
        ```
*   **层级遮挡 (Y-Sort)**：
    *   在 World 根节点、TileMapLayer 节点和 Player 节点上，全部开启 **Y Sort Enabled**。
    *   Godot 会自动根据 Y 轴高度决定谁遮挡谁（实现“绕到树后面”的效果）。

---

## 3. A Living World (鲜活的世界)
**核心目标**：创建 NPC，让他们动起来，并且把数据（属性）和表现（Sprite）分离开。

### Godot 4.5 实现方案
书中使用 Lua Table 存储 Entity 数据，Godot 使用 **Custom Resource (自定义资源)**。

*   **创建数据模版**：
    新建一个脚本 `CharacterData.gd`：
    ```gdscript
    extends Resource
    class_name CharacterData
    
    @export var name: String
    @export var texture: Texture2D
    @export var walk_speed: float = 0.3
    @export var dialogs: Array[String]
    ```
*   **创建 NPC 场景**：
    1.  新建场景 `NPC.tscn` (Node2D)。
    2.  添加 `Sprite2D` 和 `AnimationPlayer`。
    3.  添加脚本，导出变量 `@export var data: CharacterData`。
    4.  在 `_ready()` 中，根据 `data` 里的纹理自动更换 Sprite 的图片。
*   **实例化**：
    在编辑器文件系统中右键新建 Resource -> CharacterData，填入“卫兵”、“村民”的数据。然后把 NPC 场景拖入地图，把对应的 Resource 拖给 NPC。

---

## 4. User Interface (用户界面)
**核心目标**：绘制对话框、九宫格（9-slice）背景和文字渲染。

### Godot 4.5 实现方案
Godot 的 UI 系统（Control 节点）非常强大。

*   **九宫格背景**：
    *   使用 **`NinePatchRect`** 节点（或者 `PanelContainer` + `StyleBoxTexture`）。
    *   将书中的 `textbox_frame.png` 放入 Texture。
    *   在 Patch Margin 中设置上、下、左、右的边距（通常是边框的像素宽度），这样中间会拉伸，边角保持不变。
*   **文字显示**：
    *   使用 **`RichTextLabel`**。它支持 `[color=red]文本[/color]` 这样的标签，非常适合 RPG。
    *   **打字机效果**：代码中控制 `visible_ratio` 属性从 0 增加到 1。

---

## 5. Menus (菜单系统)
**核心目标**：实现“状态栈”（State Stack）。打开菜单时暂停游戏，打开子菜单时盖住父菜单，关闭时一层层返回。

### Godot 4.5 实现方案
我们需要一个全局的 UI 管理器来实现 Stack。

*   **场景结构**：使用 `CanvasLayer` 节点确保 UI 永远画在游戏画面之上。
*   **UI 栈脚本 (MenuManager.gd)**：
    ```gdscript
    extends CanvasLayer
    
    var menu_stack: Array[Control] = []
    
    func push_menu(menu_scene_path: String):
        var menu = load(menu_scene_path).instantiate()
        add_child(menu)
        menu_stack.append(menu)
        
        # 暂停游戏世界，但允许 UI 处理输入
        get_tree().paused = true 
        
        # 聚焦新菜单，确保键盘/手柄能控制它
        menu.grab_focus_first_item()

    func pop_menu():
        if menu_stack.is_empty(): return
        
        var menu = menu_stack.pop_back()
        menu.queue_free()
        
        if menu_stack.is_empty():
            get_tree().paused = false # 恢复游戏
        else:
            menu_stack.back().grab_focus_first_item() # 聚焦上一级菜单
    ```

---

## 6. An Exploration Game (一个完整的探索游戏)
**核心目标**：将以上系统整合，并编写“剧本”（Storyboard）。实现过场动画：屏幕变黑 -> 移动角色 -> 对话 -> 战斗。

### Godot 4.5 实现方案
书中实现了一个复杂的队列系统来处理线性剧情。在 Godot 中，我们可以使用 **`await` (协程)** 极其优雅地实现。

*   **创建一个 Cutscene 脚本**：
    ```gdscript
    func play_opening_cutscene():
        # 1. 锁定玩家输入
        Global.player.set_physics_process(false)
        
        # 2. 屏幕淡出 (调用 UI 里的动画函数，并等待它播放完)
        await UIManager.fade_out(1.0)
        
        # 3. 瞬间移动 NPC 到位置
        var king = get_node("KingNPC")
        king.position = Vector2(300, 300)
        
        # 4. 屏幕淡入
        await UIManager.fade_in(1.0)
        
        # 5. 国王走向玩家 (假设 move_to 是一个补间动画函数)
        await king.move_to(Global.player.position + Vector2(32, 0))
        
        # 6. 显示对话框 (等待对话框关闭信号)
        DialogBox.show("国王", "勇士，去打败恶龙吧！")
        await DialogBox.dialog_finished
        
        # 7. 解锁控制
        Global.player.set_physics_process(true)
    ```

---

### 总结：你的学习路径

1.  **第一周**：熟悉 `TileMapLayer` 和 `TileSet` 的 `Custom Data`，画出地图。
2.  **第二周**：编写 `Character.gd`，实现基于网格的 `Tween` 移动和碰撞检测。
3.  **第三周**：搞定 UI，制作一个通用的 `NinePatchRect` 对话框，并写出 `MenuManager`。
4.  **第四周**：用 `await` 语法写出你的第一个过场动画，把所有东西串起来。

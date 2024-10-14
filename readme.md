![Logo](resources/ui/logo.png)

二创自 [Mindustry](https://github.com/Anuken/Mindustry) 的肉鸽类射击游戏，使用 Godot 4 制作.

## 开发

首先，确保你已安装了 [Godot 4.3 的任意版本](https://godotengine.org/download/windows)，**其他版本的Godot可能有些许问题**。

将仓库中的project.godot导入Godot项目管理器即可开始开发。

### 导出到Android

1. 在Godot编辑器中安装导出模板。
2. 项目->安装Android构建模板。
3. 构建项目并将其导出为APK。

### 可能的问题

#### 权限问题

若你的操作系统为Linux或MacOS，且运行游戏时终端报错 `Permission denied` 或 `Command not found` ，那么请在导出项目之后执行 `chmod +x BINARY_FILE` 。  
*只需要执行一次就行了！*

#### 游戏性问题
若你认为游戏难度过低/过高，可在检查器中调整 `player` 节点的属性词条或者修改 `units` 、 `projectiles` 等节点下的属性词条。

**单位词条注解**

|变量名|类型|默认值|注明|
|-|-|-|-|
|displayName|String|未知单位|单位名称，不要写空字符串，可能会出现一些意料之外的bug
|healthMax|float|100|生命值上限|
|shootOffset|float|10|射击偏差，单位为角度|
|moveSpeed|float|1|移动加速度基值，百分比记录，100%时为每帧600单位|
|critRate|float|0.05|暴击率，百分比|
|critDamageBoost|float|1|暴击伤害，百分比，暴击时伤害提高此比|
|level|int|1|单位等级，等级越高，生命值上限和伤害就越高|
|evasion|float|0|闪避率，实体每次受到伤害时都有概率触发闪避|
|attackSpeed|float|1|攻击速度，百分比|
|attackDamage|float|1|伤害，百分比|
|moveSpeedBoost|float|0|移动加速度加成|
|penetrateBoost|float|0|子弹穿透率加成，百分比，每种子弹自身有穿透率基值，若子弹穿透率已为100%，那么此词条无效|
|attackLimit|float|300|武器序列攻击完后的重载时长，单位为毫秒|
|weaponLaunchLimit|float|100|武器序列中切换武器的间隔，单位为毫秒|
|⚠useGodMode|bool|false|是否启用上帝模式，启用后生命值上限、攻速、伤害均会翻至999倍，不管加到我方单位还是敌方单位上均会影响游戏体验，慎用|

**子弹词条注解**

|变量名|类型|默认值|注明|
|-|-|-|-|
|damage|float|1|伤害|
|speed|float|1|速度，单位为像素每帧|
|lifetime|float|700|生命周期，单位为像素，子弹当前位置距离发射位置大于此值后将会被销毁|
|penetrate|float|0|穿透率基值，百分比|
|tracingTime|float|0|子弹追踪的持续时长，单位毫秒，若0则为不可追踪|
|tracingSpeed|float|1|子弹追踪的速度，单位像素，若0则为不可追踪|
|myDamageType|damageType.Enums|~.COLLITE|子弹的伤害类型，详见下文|

**伤害类型表**

|类型|注明|
|-|-|
|HIGH_T|高温伤害|
|LOW_T|低温伤害|
|COLLITE|动能伤害|
|OVERLOADED|过载伤害|
|SOFTWARE|软件伤害|
|BIOEROSION|生物侵蚀伤害|
|THUNDER|电击伤害|
|MAGIC|魔法伤害|

---

Godot需要一点时间来下载导出模板，耐心点。若你处于中国境内，请使用加速器或VPN。  
若导出途中没有出现问题，应该在 `build/PLATFORM/` 中可以找到对应的可执行文件。
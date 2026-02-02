extends Node

@export var initial_state: State ## 初始状态

var current_state: State # 当前状态
var states: Dictionary # 所有状态字典

func _ready() -> void:
	for child in get_children():
		if child is State: # 当子节点是状态时 加入到字典
			states[child.name] = child #「节点名 - 节点实例」的对应关系，存入 states 字典
			child.transitioned.connect(on_child_transition)

	if initial_state:
		current_state = initial_state


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta) # 调用当前状态的函数


# state是触发状态切换信号的状态 new_state_name是将要切换到的状态名称
func on_child_transition(state, new_state_name):
	# 防止非当前状态乱切换
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name) # 通过名称找到状态实例
	
	# 如果找不到则返回
	if not new_state:
		return
	
	# 如果当前有状态 退出状态
	if current_state:
		current_state.exit()
	
	# 进入新状态
	new_state.enter()
	current_state = new_state # 更新当前状态

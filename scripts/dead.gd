extends State

@export var init_state: State

func enter() -> void:
	parent.collision_shape.set_deferred("disabled", true)
	parent.stop_exhaust_effects()

func exit() -> void:
	pass


func process_input() -> State:
	return null


func process_frame(delta: float) -> State:
	return null


func process_physics(delta: float) -> State:
	return null


func set_shield(value: int) -> State:
	return null

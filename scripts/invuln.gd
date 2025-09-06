extends State

signal enter_invuln

@export var alive_state: State
@export var invuln_time = 1.0
var timer = 0.0


func enter() -> void:
	timer = invuln_time
	parent.sprite.modulate.a = 0.5
	parent.collision_shape.set_deferred("disabled", true)
	parent.stop_exhaust_effects()


func exit() -> void:
	parent.sprite.modulate.a = 1.0
	parent.set_shield(100)


func process_input() -> State:
	return null


func process_frame(delta: float) -> State:
	timer -= delta
	if timer <= 0:
		parent.set_shield(100)
		return alive_state
	return null


func process_physics(delta: float) -> State:
	return null


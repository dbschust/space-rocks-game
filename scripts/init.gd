extends State

@export var alive_state: State
@export var start_delay := 0.5
var timer := 0.0


func enter() -> void:
	timer = start_delay
	screensize = get_viewport().get_visible_rect().size
	screensize.y += 400
	parent.set_deferred("global_position", screensize / 2)
	parent.set_deferred("rotation", 0)
	parent.sprite.modulate.a = 0.5
	parent.collision_shape.set_deferred("disabled", true)
	parent.shield = 100
	parent.stop_exhaust_effects()


func exit() -> void:
	pass


func process_input() -> State:
	return null


func process_frame(delta: float) -> State:
	timer -= delta
	if timer <= 0:
		return alive_state
	return null


func process_physics(delta: float) -> State:
	return null



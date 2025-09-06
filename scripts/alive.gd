extends State

@export var init_state: State
@export var invuln_state: State
@export var dead_state: State
var can_shoot = true
var fire_rate = 0.25
var shield_regen = 5.0

func enter() -> void:
	parent.sprite.modulate.a = 1.0
	parent.collision_shape.set_deferred("disabled", false)


func exit() -> void:
	pass


func process_input() -> State:
	thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust"):
		thrust = engine_power * -parent.transform.y
		parent.play_exhaust_effects()
	if Input.is_action_just_released("thrust"):
		parent.stop_exhaust_effects()
	rotation_dir = Input.get_axis("left", "right")
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		$GunDelay.start(fire_rate)
		parent.shoot()
	return null


func process_frame(delta: float) -> State:
	process_input()
	#check for losing life or death
	if parent.shield <= 0:
		return invuln_state
	if parent.lives <= 0:
		return dead_state
	#regen shield
	if parent.shield < 100:
		parent.shield += shield_regen * delta
		parent.shield_changed.emit(parent.shield)
	
	return null


func process_physics(delta: float) -> State:
	parent.apply_force(thrust)
	parent.apply_torque(rotation_power * rotation_dir)
	return null


func _on_gun_delay_timeout():
	can_shoot = true


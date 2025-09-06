class_name Player
extends RigidBody2D


signal shield_changed
signal dead
signal lives_changed


@onready var state_machine := $StateMachine
@onready var sprite := $Sprite2D
@onready var collision_shape := $CollisionShape2D
@export var bullet_scene: PackedScene
const WRAP_MARGIN = 20
var shield = 0: set = set_shield
var lives = 3: set = set_lives


func init():
	$Sprite2D.show()
	state_machine.init(self)


func _ready():
	init()


func _process(delta):
	state_machine.process_frame(delta)


func _physics_process(delta):
	state_machine.process_physics(delta)


func _unhandled_input(_event):
	state_machine.process_input()


func _integrate_forces(state):
	# handle screen wrapping
	var screensize: Vector2 = get_viewport().get_visible_rect().size
	var pos = state.transform.origin
	
	if pos.x < 0 - WRAP_MARGIN:
		pos.x = screensize.x + WRAP_MARGIN
	elif pos.x > screensize.x + WRAP_MARGIN:
		pos.x = 0 - WRAP_MARGIN
	if pos.y < 0 - WRAP_MARGIN:
		pos.y = screensize.y + WRAP_MARGIN
	elif pos.y > screensize.y + WRAP_MARGIN:
		pos.y = 0 - WRAP_MARGIN
	
	state.transform.origin = pos


func change_state(new_state: State):
	state_machine.change_state(new_state)


func shoot():
	$LaserSound.play()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b.fire($Muzzle.global_transform)


func _on_body_entered(body):
	if body.is_in_group("rocks"):
		body.explode()
		var damage = 25 * body.size
		set_shield(shield - damage)


func set_shield(value):
	shield = clamp(value, 0, 100)
	shield_changed.emit(shield)
	if shield <= 0:
		set_lives(lives - 1)


func set_lives(value):
	lives = value
	lives_changed.emit(lives)
	if lives <= 0:
		dead.emit()
		#explode()
		lives = 3


func explode():
	$Explosion.show()
	$Sprite2D.hide()
	$Explosion/AnimationPlayer.play("explosion")
	await $Explosion/AnimationPlayer.animation_finished
	$Explosion.hide()


func play_exhaust_effects():
	$ExhaustParticles.show()
	if $ExhaustSound.is_playing():
		return
	$ExhaustSound.play()


func stop_exhaust_effects():
	$ExhaustParticles.hide()
	$ExhaustSound.stop()

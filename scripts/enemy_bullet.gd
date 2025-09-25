extends Area2D


@export var damage = 20
@export var speed = 1000
var dir = Vector2.ZERO


func start(_pos, _dir):
	position = _pos
	dir = _dir.normalized()
	rotation = dir.angle() + deg_to_rad(90)


func _process(delta):
	position += delta * speed * dir


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("rocks"):
		queue_free()
	if is_instance_of(body, Player):
		body.set_shield(body.shield - 25)
		queue_free()
		body.flash_red()



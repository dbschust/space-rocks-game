extends Area2D


@export var damage = 20
@export var speed = 1000


func start(_pos, _dir):
	position = _pos
	rotation = _dir.angle()


func _process(delta):
	position += delta * speed * transform.x


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("rocks"):
		queue_free()
	if is_instance_of(body, Player):
		body.set_shield(body.shield - 25)
		queue_free()



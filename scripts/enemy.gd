extends Area2D


@export var bullet_scene: PackedScene
@export var movespeed = 150
@export var rotation_speed = 120
@export var health = 3
@export var bullet_spread = 0.2
@export var burst_delay = 0.25


var path_follow = PathFollow2D.new()
var target: Player = null


func _ready():
	$Sprite2D.frame = randi() % 3
	var path = $Paths.get_children()[randi() % $Paths.get_child_count()]
	path.add_child(path_follow)
	path_follow.loop = false


func _physics_process(delta):
	rotation += deg_to_rad(rotation_speed) * delta
	path_follow.progress += movespeed * delta
	position = path_follow.global_position
	if path_follow.progress_ratio >= 1:
		queue_free()


func shoot():
	$EnemyLaserSound.play()
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	var dir = global_position.direction_to(target.global_position)
	var spread = deg_to_rad(randf_range(-bullet_spread, bullet_spread))
	dir = dir.rotated(spread)
	b.start(global_position, dir)


func shoot_burst(num_shots):
	$BurstTimer.start()
	for i in num_shots:
		shoot()
		await $BurstTimer.timeout
	$BurstTimer.stop()


func take_damage(amount):
	health -= amount
	if health <= 0:
		explode()
	else:
		flash_on_hit()


func explode():
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	$ExplosionSound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$GunCooldown.stop()
	movespeed = 0
	await $Explosion/AnimationPlayer.animation_finished
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("rocks"):
		return
	if body.name == "Player":
		body.set_shield(body.shield - 50)
		explode()


func _on_gun_cooldown_timeout():
	shoot_burst(3)


func flash_on_hit():
	$AnimationPlayer.play("hitflash")

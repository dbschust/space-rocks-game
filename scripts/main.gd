extends Node


@export var rock_scene: PackedScene
@export var enemy_scene: PackedScene
@export var starting_rocks:int = 2


var screensize = Vector2.ZERO
var level = 1
var playing = false
var score = 0

## to-do items:  add modulate effect on hit for both the enemy and player


func _process(delta):
	if get_tree().get_nodes_in_group("rocks").size() == 0 and playing:
		new_level()


func start_game():
	playing = true
	score = 0
	$Player.init()
	$HUD.update_score(score)
	$EnemyTimer.start()
	new_level()


func new_level():
	$LevelSound.play()
	$HUD.new_level(level)
	for i in level + starting_rocks - 1:
		spawn_new_rock(3)
	level += 1


func game_over():
	playing = false
	$EnemyTimer.stop()
	$ExplosionSound.play()
	get_tree().call_group("rocks", "queue_free")
	get_tree().call_group("enemies", "queue_free")
	$Player.explode()
	$HUD.game_over()


func spawn_new_rock(size: int, pos=null, vel=null):
	if not pos:
		$Path2D/SpawnPath.progress_ratio = randf() 
		pos = $Path2D/SpawnPath.position
	if not vel:
		vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(50, 125)
	var r = rock_scene.instantiate()
	r.exploded.connect(self._on_rock_exploded)
	call_deferred("add_child", r)
	r.start(size, pos, vel)


func _on_rock_exploded(size, radius, pos, vel):
	score += size * 10
	$HUD.update_score(score)
	$ExplosionSound.play()
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = $Player.position.direction_to(pos).orthogonal() * offset
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1
		spawn_new_rock(size - 1, newpos, newvel)


func _on_enemy_timer_timeout():
	var e = enemy_scene.instantiate()
	add_child(e)
	e.target = $Player
	$EnemyTimer.start(20)

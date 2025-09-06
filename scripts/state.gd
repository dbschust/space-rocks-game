class_name State
extends Node

@export var engine_power: int = 500
@export var rotation_power: int = 5000
@export var bullet_scene: PackedScene

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var parent: Player
var thrust = Vector2.ZERO
var rotation_dir: float = 0.0
var screensize = Vector2.ZERO


func enter() -> void:
	pass


func exit() -> void:
	pass


func process_input() -> State:
	return null


func process_frame(delta: float) -> State:
	return null


func process_physics(delta: float) -> State:
	return null

extends Node

var SPAWN_RADIUS = 900

@export var white_bubble:PackedScene
@export var memes:PackedScene
@export var voice_message:PackedScene
@export var calls:PackedScene

var elite_enemys = [memes,voice_message,calls]

@onready var player_node = get_tree().get_first_node_in_group("Player") as Node2D

var enemy = null

var enemy_count = 0

var spawn_time = 1.2
func get_spawn_time():
	return spawn_time
func set_spawn_time(new_spawn_time):
	
	if new_spawn_time < 0.05:
		new_spawn_time = 0.05
	
	spawn_time = new_spawn_time
	
	print(spawn_time)

@onready var audio_stream_player = $AudioStreamPlayer
@onready var spawn_timer = $SpawnTimer

var elite_weight = 0.08
var special_weight = 0.15

var damage = 1

func _ready():
	player_node.skill_manager.super_high_damage_active.connect(_on_super_high_damage_active)

func _on_spawn_timer_timeout():
	
	spawn_timer.wait_time = randf_range(0.8 * spawn_time,1.5 * spawn_time)
	spawn_timer.start()
	
	if player_node == null:
		return
	
	var i = randf_range(0,1)
	if i < elite_weight:
		var j = randi_range(0,3)
		
		_spawn_enemy(memes,1)
	else:
		var j = randf_range(0,1)
		var correction = 1 #hitpoint/speed
		if j<0.15:
			correction = 1.5
		elif j>0.85:
			correction = 0.6
		
		_spawn_enemy(white_bubble,correction)

func _on_super_high_damage_active():
	damage = 9999
	for i in get_child_count():
		var child = get_child(i)
		if child.damage != null:
			child.damage = 9999

func _spawn_enemy(wanted_enemy,correction):
	var packed_enemy = wanted_enemy
	
	enemy = packed_enemy.instantiate()
	add_child(enemy)
	
	enemy.damage = damage
	if correction>1:
		enemy.hitpoint += 1
	elif correction<1:
		enemy.hitpoint -= 1
	enemy.speed /= correction
	
	enemy.transform = enemy.transform.scaled(Vector2(1,1)*correction)
	
	var random_direction = Vector2.LEFT.rotated(randf_range(-PI,PI))
	var spawn_position = player_node.global_position + (random_direction * SPAWN_RADIUS)
	
	enemy.global_position = spawn_position
	
	audio_stream_player.play()
	

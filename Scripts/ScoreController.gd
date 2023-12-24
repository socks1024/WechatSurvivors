extends Node

var exp = 0
#经验值足够高时升级
func get_exp():
	return exp
func set_exp(new_exp):
	exp = new_exp
	
	exp_changed.emit()
	
	if exp >= exp_for_level_up:
		
		set_level(get_level() + 1)

var level = 1
func get_level():
	return level
func set_level(new_level):
	
	if new_level > level:
		level_up()
	
	level = new_level
	
	if level == 15:
		pass
		#胜出结算
	


var exp_for_level_up = 6

@onready var enemy_manager = get_tree().get_first_node_in_group("EnemyManager")
@onready var player = get_tree().get_first_node_in_group("Player") as Node2D

var level_up_correction = 1.5
var spawn_time_correction = 0.85

func _ready():
	exp_changed.emit()

#升级功能
func level_up():
	exp_for_level_up *= level_up_correction
	exp_for_level_up  = exp_for_level_up as int
	set_exp(0)
	
	enemy_manager.set_spawn_time(enemy_manager.get_spawn_time() * spawn_time_correction)
	
	level_up_signal.emit()

signal level_up_signal
signal exp_changed

func _on_reduce_exp_for_level_up_active():
	exp_for_level_up *=0.8
	exp_for_level_up = exp_for_level_up as int
	level_up_correction *= 0.8

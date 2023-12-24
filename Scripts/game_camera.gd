extends Camera2D

var target_position = Vector2.ZERO

var shake_time = 60
var current_shake_time = 0

#enum SHAKE_STAT { SHAKING,NOT_SHAKING }
#var shake_stat = SHAKE_STAT.NOT_SHAKING


func _ready():
	make_current()


func _process(delta):
	target_position = _get_aquire_target()
	if target_position != null:
		global_position = global_position.lerp(target_position,( 1.0 - exp( - delta * 10 )))
	



#获取玩家坐标
func _get_aquire_target():
	var player_nodes = get_tree().get_nodes_in_group("Player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		return player.global_position


#相机抖动
func _shake():
	pass

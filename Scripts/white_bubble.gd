extends Area2D

var speed = 60

var hitpoint = 2
func get_hp():
	return hitpoint
#减少生命值
func set_hp(i):
	self.hitpoint = i
	
	if hitpoint <= 0:
		#还没有加动画
		self.queue_free()
		
		scoreController.set_exp( scoreController.get_exp() + enemyExp )

var damage = 1

var enemyExp = 1

var knockback = 20
var knockbackSpeed = Vector2(0,0)

var velocity = Vector2.ZERO

var direction_to_player = Vector2.ZERO

@onready var sprite2D = $BubbleSprite
@onready var player_node = get_tree().get_first_node_in_group("Player") as Node2D
@onready var scoreController = get_tree().get_first_node_in_group("ScoreController")

func _physics_process(delta):
	
	direction_to_player = _get_direction_to_player()
	
	sprite2D.flip_h = (direction_to_player.x < 0)
	
	velocity = direction_to_player * delta * speed + knockbackSpeed
	
	knockbackSpeed *= 0.9
	if knockbackSpeed.length() < 0.1:
		knockbackSpeed = Vector2(0,0)
	
	self.position += velocity

#返回朝向玩家的方向
func _get_direction_to_player():
	
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO

#处理与玩家的碰撞
func _on_body_entered(body):
	if body.hitpoint != null:
		
		body.set_hp( body.get_hp() - damage)
		
		self.knockbackSpeed = -(direction_to_player * knockback)

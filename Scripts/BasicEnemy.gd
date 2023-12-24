extends Area2D

var speed = 0

var hitpoint = 0
#减少生命值
func _set_hp(i):
	self.hitpoint -= i
	
	if hitpoint <= 0:
		#还没有加动画
		self.queue_free()
		
		scoreController.set_exp(enemyExp)

var damage = 0

var enemyExp =0

var knockback = 0

var velocity = Vector2.ZERO

var direction_to_player = Vector2.ZERO

@onready var sprite2D = $Bu
@onready var collisionShape2D = $CollisionShape2D
@onready var player_node = get_tree().get_first_node_in_group("Player") as Node2D
@onready var scoreController = get_tree().get_first_node_in_group("ScoreController")

func _physics_process(delta):
	
	direction_to_player = get_direction_to_player()
	
	sprite2D.set_flip_h(direction_to_player.x < 0)
	
	velocity += direction_to_player * delta
	if velocity.length() >= speed:
		velocity = velocity.normalized() * speed
	
	self.position += velocity
	

#返回朝向玩家的方向
func get_direction_to_player():
	
	if player_node != null:
		return (player_node.global_position - self.global_position).normalized()
	
	return Vector2.ZERO

#处理与玩家的碰撞
func _on_body_entered(body):
	if body.hitpoint != null:
		
		body._set_hp(damage)
		
		self.velocity += (-(direction_to_player * knockback))

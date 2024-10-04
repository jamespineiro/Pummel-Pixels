extends Sprite2D

var starting_y : int
var player_array = []
var weight = 0

@onready var collision_shape_2d = $CharacterBody2D/Area2D/CollisionShape2D
@onready var collision_shape_2d_2 = $CharacterBody2D/Area2D/CollisionShape2D2

func _ready():
	starting_y = int(global_position.y)

func change_speed():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_array.size() < 1 and global_position.y > starting_y:
		global_position.y -= 1
	elif player_array.size() >= 1:
		global_position.y += weight

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("shoot_arrow"):
			if body not in player_array:
				weight += .07
				player_array.append(body)

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		if body.has_method("shoot_arrow"):
			if body in player_array:
				weight -= .07
				player_array.erase(body)

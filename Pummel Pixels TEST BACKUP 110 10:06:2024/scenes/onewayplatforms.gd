extends TileMap

@export var moving = false

var player1 : CharacterBody2D
var player2 : CharacterBody2D
var player3 : CharacterBody2D
var player4 : CharacterBody2D

@export var MAX = -15
@export var MIN = 50
var direction = -.05
var players = []

var player1_can_pass = true
var player2_can_pass = true
var player3_can_pass = true
var player4_can_pass = true


# Called when the node enters the scene tree for the first time.
func _ready():
	if GameSettings.player1_selected:
		player1 = get_node("../player")
		players.append(player1)
	if GameSettings.player2_selected:
		player2 = get_node("../player2")
		players.append(player2)
	if GameSettings.player3_selected:
		player3 = get_node("../player3")
		players.append(player3)
	if GameSettings.player4_selected:
		player4 = get_node("../player4")
		players.append(player4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if GameSettings.player1_selected:
		if player1_can_pass and (player1.sprite.animation == "down_dodge" or player1.sprite.animation == "down_dodge_cooldown" or (player1.crouching_on_one_way and player1.jump_button_pressed)) and abs((player1.global_position.y-150)-global_position.y) < 4:
			player1.set_collision_mask_value(3, false)
			player1_can_pass = false
		elif abs((player1.global_position.y-150)-global_position.y) >= 4:
			player1.set_collision_mask_value(3, true)
			player1_can_pass = true
			
		if (player1.sprite.animation == "crouching" or player1.down_pressed) and abs((player1.global_position.y-150)-global_position.y) < 4:
			player1.crouching_on_one_way = true
		elif player1.crouching_on_one_way and (abs((player1.global_position.y-150)-global_position.y) >= 4 or (player1.sprite.animation != "crouching" or not player1.down_pressed)):
			player1.crouching_on_one_way = false
			
		
	if moving:
		global_position.y += direction
			
		if global_position.y < MAX or global_position.y > MIN:
			direction *= -1

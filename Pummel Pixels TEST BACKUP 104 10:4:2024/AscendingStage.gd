extends TileMap

var player1 : CharacterBody2D
var player2 : CharacterBody2D
var player3 : CharacterBody2D
var player4 : CharacterBody2D

var MAX = -25
var MIN = 60
var direction = -.05
var players = []
var spawning_on_platform = true

# Called when the node enters the scene tree for the first time.
func _ready():
	players = []
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
	
func set_spawning_on_platform(boolean):
	spawning_on_platform = boolean

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position.y += direction
	
	if spawning_on_platform:
		for player in players:
			player.starting_position_y = global_position.y + 170
		
	if global_position.y < MAX or global_position.y > MIN:
		direction *= -1
	

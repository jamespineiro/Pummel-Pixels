extends TileMap

var player1 : CharacterBody2D
var player2 : CharacterBody2D
var player3 : CharacterBody2D
var player4 : CharacterBody2D

var MAX = -15
var MIN = 50
var direction = -.05
var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = get_node("../player")
	players.append(player1)
	if get_node("../player2") != null:
		player2 = get_node("../player2")
		players.append(player2)
	if get_node("../player3") != null:
		player3 = get_node("../player3")
		players.append(player3)
	if get_node("../player4") != null:
		player4 = get_node("../player4")
		players.append(player4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position.y += direction
		
	if global_position.y < MAX or global_position.y > MIN:
		direction *= -1
	

extends Camera2D

var dis = 0
var player_x_positions = 0
var player_y_positions = 0
var player_1 = CharacterBody2D
var player_2 = CharacterBody2D
var player_3 = CharacterBody2D
var player_4 = CharacterBody2D
var new_zoom = 0
var starting_x = 0
var starting_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameSettings.player1_selected:
		player_1 = get_node("../player")
	if GameSettings.player2_selected:
		player_2 = get_node("../player2")
	if GameSettings.player3_selected:
		player_3 = get_node("../player3")
	if GameSettings.player4_selected:
		player_4 = get_node("../player4")
	update_player_positions()
	starting_x = global_position.x
	starting_y = global_position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_dead = false
	for player in get_tree().get_nodes_in_group("players"):
		if player.dead:
			player_dead = true
	if not player_dead:
		update_player_positions()
		if player_x_positions < 200:
			global_position.x = 200
		elif player_x_positions > 350:
			global_position.x = 350
		else:
			global_position.x = player_x_positions
		
		if player_y_positions - 20 > 210:
			global_position.y = 210
		elif player_y_positions - 20 < 105:
			global_position.y = 105
		else:
			global_position.y = player_y_positions - 20
		dis=find_largest_distance()
		
		zoom = Vector2((0.005*dis)+abs(9-(dis/65)), (0.005*dis)+abs(9-(dis/65)))
		
		if dis > 250:
			global_position.x = 294
			global_position.y = 161
		if zoom.x < 6:
			zoom = Vector2(6,6)
		elif zoom.x > 8:
			zoom = Vector2(8,8)
	else:
		zoom = Vector2(6,6)
		global_position = Vector2(starting_x, starting_y)

func update_player_positions():
	player_x_positions = 0
	player_y_positions = 0
	for player in get_tree().get_nodes_in_group("players"):
		player_x_positions += player.global_position.x
		player_y_positions += player.global_position.y
	player_x_positions /= get_tree().get_nodes_in_group("players").size()
	player_y_positions /= get_tree().get_nodes_in_group("players").size()
	
func find_largest_distance():
	if GameSettings.player_count == 1:
		return 1
	else:
		var p1p2distance = 0
		var p1p3distance = 0
		var p1p4distance = 0
		var p2p3distance = 0
		var p2p4distance = 0
		var p3p4distance = 0
		if GameSettings.player1_selected and GameSettings.player2_selected:
			p1p2distance = abs(player_1.global_position.distance_to(player_2.global_position))
		if GameSettings.player1_selected and GameSettings.player3_selected:
			p1p3distance = abs(player_1.global_position.distance_to(player_3.global_position))
		if GameSettings.player1_selected and GameSettings.player4_selected:
			p1p4distance = abs(player_1.global_position.distance_to(player_4.global_position))
		if GameSettings.player2_selected and GameSettings.player3_selected:
			p2p3distance = abs(player_2.global_position.distance_to(player_3.global_position))
		if GameSettings.player2_selected and GameSettings.player4_selected:
			p2p4distance = abs(player_2.global_position.distance_to(player_4.global_position))
		if GameSettings.player3_selected and GameSettings.player4_selected:
			p3p4distance = abs(player_3.global_position.distance_to(player_4.global_position))
		return max(p1p2distance, p1p3distance, p1p4distance, p2p3distance, p2p4distance, p3p4distance)

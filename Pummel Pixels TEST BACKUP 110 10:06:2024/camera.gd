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
var size = 0
var last_dis = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameSettings.player1_selected:
		player_1 = get_node("../player")
		size += 1
	if GameSettings.player2_selected:
		player_2 = get_node("../player2")
		size += 1
	if GameSettings.player3_selected:
		player_3 = get_node("../player3")
		size += 1
	if GameSettings.player4_selected:
		player_4 = get_node("../player4")
		size += 1
	starting_x = global_position.x
	starting_y = global_position.y
	position_smoothing_speed = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_player_positions()
	
	if player_x_positions < 160:
		global_position.x = 160
	elif player_x_positions > 420:
		global_position.x = 420
	else:
		global_position.x = player_x_positions
	
	if player_y_positions - 10 > 270:
		global_position.y = 270
	elif player_y_positions - 10 < 75:
		global_position.y = 75
	else:
		global_position.y = player_y_positions - 10
	
	dis=find_largest_distance()
	last_dis = dis
	zoom = Vector2((0.005*dis)+abs(14-(dis/30)), (0.005*dis)+abs(14-(dis/30)))

	if dis > 250:
		global_position.x = 294
		global_position.y = 161
	if zoom.x < 6:
		zoom = Vector2(6,6)
	elif zoom.x > 10:
		zoom = Vector2(10,10)
			
	if size == 0:
		global_position.x = 294
		global_position.y = 161

func update_player_positions():
	size = 0
	player_x_positions = 0
	player_y_positions = 0
	if GameSettings.player1_selected:
		player_1 = get_node("../player")
		if not player_1.dead and not player_1.global_position.x < 0:
			size+=1
	if GameSettings.player2_selected:
		player_2 = get_node("../player2")
		if not player_2.dead and not player_2.global_position.x < 0:
			size+=1
	if GameSettings.player3_selected:
		player_3 = get_node("../player3")
		if not player_3.dead and not player_3.global_position.x < 0:
			size+=1
	if GameSettings.player4_selected:
		player_4 = get_node("../player4")
		if not player_4.dead and not player_4.global_position.x < 0:
			size+=1
	for player in get_tree().get_nodes_in_group("players"):
		if not player.dead and player.global_position.x > 0:
			player_x_positions += player.global_position.x
			player_y_positions += player.global_position.y
			
	player_x_positions /= 1 if (size == 0) else size
	player_y_positions /= 1 if (size == 0) else size
	
func find_largest_distance():
	if GameSettings.player_count == 1:
		return 1
	elif GameSettings.player_count == size:
		var p1p2distance = 0
		var p1p3distance = 0
		var p1p4distance = 0
		var p2p3distance = 0
		var p2p4distance = 0
		var p3p4distance = 0
		if GameSettings.player1_selected and player_1.global_position.x > 0 and GameSettings.player2_selected and player_2.global_position.x > 0:
			p1p2distance = abs(player_1.global_position.distance_to(player_2.global_position))
		if GameSettings.player1_selected and player_1.global_position.x > 0 and GameSettings.player3_selected and player_3.global_position.x > 0:
			p1p3distance = abs(player_1.global_position.distance_to(player_3.global_position))
		if GameSettings.player1_selected and player_1.global_position.x > 0 and GameSettings.player4_selected and player_4.global_position.x > 0:
			p1p4distance = abs(player_1.global_position.distance_to(player_4.global_position))
		if GameSettings.player2_selected and player_2.global_position.x > 0 and GameSettings.player3_selected and player_3.global_position.x > 0:
			p2p3distance = abs(player_2.global_position.distance_to(player_3.global_position))
		if GameSettings.player2_selected and player_2.global_position.x > 0 and GameSettings.player4_selected and player_4.global_position.x > 0:
			p2p4distance = abs(player_2.global_position.distance_to(player_4.global_position))
		if GameSettings.player3_selected and player_3.global_position.x > 0 and GameSettings.player4_selected and player_4.global_position.x > 0:
			p3p4distance = abs(player_3.global_position.distance_to(player_4.global_position))
		return max(p1p2distance, p1p3distance, p1p4distance, p2p3distance, p2p4distance, p3p4distance)
	else:
		return last_dis

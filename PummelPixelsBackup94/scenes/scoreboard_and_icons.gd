extends Control
@onready var player_1_icon = $Player1Icon
@onready var player_2_icon = $Player2Icon
@onready var player_3_icon = $Player3Icon
@onready var player_4_icon = $Player4Icon

@onready var label = $Label
@onready var match_timer = $MatchTimer
@onready var player_1_health = $Player1Health
@onready var player_2_health = $Player2Health
@onready var player_3_health = $Player3Health
@onready var player_4_health = $Player4Health
@onready var end_of_match_timer = $EndOfMatchTimer

@onready var countdown_timer = $CountdownTimer
@onready var countdown = $Countdown

@onready var player_1_photo = $Player1Photo
@onready var player_2_photo = $Player2Photo
@onready var player_3_photo = $Player3Photo
@onready var player_4_photo = $Player4Photo

@onready var countdown_sound = $CountdownSound
@onready var bell_sound = $BellSound
@onready var player_1_score = $Player1Score
@onready var player_2_score = $Player2Score
@onready var player_3_score = $Player3Score
@onready var player_4_score = $Player4Score
@onready var blue_team_score_label = $BlueTeamScore
@onready var red_team_score_label = $RedTeamScore
@onready var blue_team_score = 0
@onready var red_team_score = 0

@onready var goal_score = GameSettings.game_lives

var match_timer_int : int
@onready var main = get_tree().get_root()
var player1 : CharacterBody2D
var player2 : CharacterBody2D
var player3 : CharacterBody2D
var player4 : CharacterBody2D
@onready var player_count : int 
var player_1_health_number : int
var player_2_health_number : int
var player_3_health_number : int
var player_4_health_number : int
var health_color_count = 0

var player_1_icons = [preload("res://assets/Player1Icon1.png"), 
preload("res://assets/Player1Icon2.png"), preload("res://assets/Player1Icon3.png"),
preload("res://assets/Player1Icon4.png")]

var player_2_icons = [preload("res://assets/Player2Icon1.png"),
preload("res://assets/Player2Icon2.png"), preload("res://assets/Player2Icon3.png"), 
preload("res://assets/Player2Icon4.png")]

var player_3_icons = [preload("res://assets/Player3/Player3Icon1.png"),
preload("res://assets/Player3/Player3Icon2.png"), preload("res://assets/Player3/Player3Icon3.png"), 
preload("res://assets/Player3/Player3Icon4.png")]

var player_4_icons = [preload("res://assets/Player4/Player4Icon1.png"),
preload("res://assets/Player4/Player4Icon2.png"), preload("res://assets/Player4/Player4Icon3.png"), 
preload("res://assets/Player4/Player4Icon4.png")]

const red_icons = [preload("res://assets/RedIcon1.png"), 
preload("res://assets/RedIcon2.png"), preload("res://assets/RedIcon3.png"),
preload("res://assets/RedIcon4.png")]

const blue_icons = [preload("res://assets/BlueIcon1.png"), 
preload("res://assets/BlueIcon2.png"), preload("res://assets/BlueIcon3.png"),
preload("res://assets/BlueIcon4.png")]

var player_1_count = 0
var player_1_index = 0
var player_2_count = 0
var player_2_index = 0
var player_3_count = 0
var player_3_index = 0
var player_4_count = 0
var player_4_index = 0
var border_speed = int(7)
var nine_moved = false
var nineteen_moved = false
var starting_time = 0
var game_just_finished = false

var p1_score_red = false
var p2_score_red = false
var p3_score_red = false
var p4_score_red = false
var red_score_red = false
var blue_score_red = false
var overtime = false

var p1_score_vibrate_count = 0
var p2_score_vibrate_count = 0
var p3_score_vibrate_count = 0
var p4_score_vibrate_count = 0
var blue_score_vibrate_count = 0
var red_score_vibrate_count = 0

var p1_score_direction = .5
var p2_score_direction = .5
var p3_score_direction = .5
var p4_score_direction = .5
var blue_score_direction = .5
var red_score_direction = .5

var p1_twovstwo_icon_switched = false
var p2_twovstwo_icon_switched = false
var p3_twovstwo_icon_switched = false
var p4_twovstwo_icon_switched = false

@onready var icon_positions = [player_3_icon.global_position, player_1_icon.global_position,
							player_2_icon.global_position, player_4_icon.global_position]

@onready var icons_filled = [false, false, false, false]

@onready var photo_positions = [player_3_photo.global_position, player_1_photo.global_position,
							player_2_photo.global_position, player_4_photo.global_position]

@onready var photos_filled = [false, false, false, false]

var blue_team = []
var red_team = []

func move_icon_and_photo(icon, photo, team, health):
	if GameSettings.current_gamemode != GameSettings.GAMEMODE.JUGGERNAUT:
		if team == "blue":
			for index in range(icons_filled.size()):
				if icons_filled[index] == false:
					icon.global_position = icon_positions[index]
					photo.global_position = photo_positions[index]
					icons_filled[index] = true
					photos_filled[index] = true
					health.global_position.x = photo.global_position.x - 12
					break
		elif team == "red":
			for index in range(len(icons_filled)-1, -1, -1):
				if icons_filled[index] == false:
					icon.global_position = icon_positions[index]
					photo.global_position = photo_positions[index]
					icons_filled[index] = true
					photos_filled[index] = true
					health.global_position.x = photo.global_position.x - 12
					break

func _ready():
	GameSettings.reset_player_stats()
	countdown_timer.start()
	health_color_count = 0
	player_count = Input.get_connected_joypads().size()
	if GameSettings.player1_selected:
		player1 = get_node("../player")
		player_1_health_number = player1.health
		player1.starting_round = true
		if player1.team_name == "red-team":
			player_1_icons = red_icons
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				red_team.append(player1)
		elif player1.team_name == "blue-team":
			player_1_icons = blue_icons
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				blue_team.append(player1)
	if GameSettings.player2_selected:
		player2 = get_node("../player2")
		player_2_health_number = player2.health
		player2.starting_round = true
		if player2.team_name == "red-team":
			player_2_icons = red_icons
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				red_team.append(player2)
		elif player2.team_name == "blue-team":
			blue_team.append(player2)
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				player_2_icons = blue_icons
			
	if GameSettings.player3_selected:
		player3 = get_node("../player3")
		player_3_health_number = player3.health
		player3.starting_round = true
		if player3.team_name == "red-team":
			player_3_icons = red_icons
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				red_team.append(player3)
		elif player3.team_name == "blue-team":
			player_3_icons = blue_icons
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				blue_team.append(player3)
			
	if GameSettings.player4_selected:
		player4 = get_node("../player4")
		player_4_health_number = player4.health
		player4.starting_round = true
		
		if player4.team_name == "red-team":
			player_4_icons = red_icons
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				red_team.append(player4)
		elif player1.team_name == "blue-team":
			player_4_icons = blue_icons
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				blue_team.append(player4)
			
			
	if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
		goal_score = 5
	elif GameSettings.current_gamemode == GameSettings.GAMEMODE.JUGGERNAUT:
		goal_score = 5
	
	match_timer.start()
	match_timer.set_wait_time(GameSettings.game_time)
	
	starting_time = match_timer.time_left
	if match_timer.time_left < 1:
		match_timer.stop()
	if int(match_timer_int/61) > 0 and int(match_timer_int%60) > 10:
		label.text = str(str(int(match_timer_int/60)) + ":" + str(int(match_timer_int%60)))
	elif int(match_timer_int/61) > 0 and match_timer_int%60 < 10:
		label.text = str(str(int(match_timer_int/60)) + ":0" + str(int(match_timer_int%60)))
	elif match_timer_int < 61:
		label.text = str(match_timer_int)

func _process(_delta):
	if GameSettings.player1_selected and not p1_twovstwo_icon_switched:
		if player1.team_name == "red-team":
			player_1_icons = red_icons
		elif player1.team_name == "blue-team":
			player_1_icons = blue_icons
		p1_twovstwo_icon_switched = true
	if GameSettings.player2_selected and not p2_twovstwo_icon_switched:
		if player2.team_name == "red-team":
			player_2_icons = red_icons
		elif player2.team_name == "blue-team":
			player_2_icons = blue_icons
		p2_twovstwo_icon_switched = true
	if GameSettings.player3_selected and not p3_twovstwo_icon_switched:
		if player3.team_name == "red-team":
			player_3_icons = red_icons
		elif player3.team_name == "blue-team":
			player_3_icons = blue_icons
		p3_twovstwo_icon_switched = true
	if GameSettings.player4_selected and not p4_twovstwo_icon_switched:
		if player4.team_name == "red-team":
			player_4_icons = red_icons
		elif player4.team_name == "blue-team":
			player_4_icons = blue_icons
		p4_twovstwo_icon_switched = true
		
	if match_timer.time_left < 1 and not overtime:
		overtime = true
	
	if overtime and not game_just_finished:
		if GameSettings.player1_selected:
			player1.health+=.01
			GameSettings.player1_dmg_taken += .01
		if GameSettings.player2_selected:
			player2.health+=.01
			GameSettings.player2_dmg_taken += .01
		if GameSettings.player3_selected:
			player3.health+=.01
			GameSettings.player3_dmg_taken += .01
		if GameSettings.player4_selected:
			player4.health+=.01
			GameSettings.player4_dmg_taken += .01
	
	if not game_just_finished:
		if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
			if GameSettings.player1_selected:
				player_1_score.text = str(player1.score)
			if GameSettings.player2_selected:
				player_2_score.text = str(player2.score)
			if GameSettings.player3_selected and GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
				player_3_score.text = str(player3.score)
			if GameSettings.player4_selected and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				player_4_score.text = str(player4.score)
		elif GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
			var score = 0
			for player in blue_team:
				score += player.score
			blue_team_score = score
			blue_team_score_label.text = str(score)
			score = 0
			for player in red_team:
				score += player.score
			red_team_score = score
			red_team_score_label.text = str(score)
		
	
	if countdown.visible and not game_just_finished:
		if countdown.text == "1":
			bell_sound.play()
		if countdown_timer.time_left > 4:
			countdown.text = "3"
		elif countdown_timer.time_left >= 2:
			countdown.text = str(int(countdown_timer.time_left-1))
		elif countdown_timer.time_left < 2 and countdown_timer.time_left > 1:
			countdown.global_position.x = 185
			countdown.text = "FIGHT!"
			label.visible = true
			
			if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				red_team_score_label.visible = true
				blue_team_score_label.visible = true
			
			if GameSettings.player1_selected:
				player1.starting_round = false
				player_1_health.visible = true
				player_1_icon.visible = true
				player_1_photo.visible = true
				if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
					player_1_score.visible = true
				if player1.team_name == "red-team":
					move_icon_and_photo(player_1_icon, player_1_photo, "red", player_1_health)
					player_1_icons = red_icons
				elif player1.team_name == "blue-team":
					move_icon_and_photo(player_1_icon, player_1_photo, "blue", player_1_health)
					player_1_icons = blue_icons
			if GameSettings.player2_selected:
				player2.starting_round = false
				player_2_health.visible = true
				player_2_icon.visible = true
				player_2_photo.visible = true
				if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
					player_2_score.visible = true
				if player2.team_name == "red-team":
					move_icon_and_photo(player_2_icon, player_2_photo, "red", player_2_health)
					player_2_icons = red_icons
				elif player2.team_name == "blue-team":
					move_icon_and_photo(player_2_icon, player_2_photo, "blue", player_2_health)
					player_2_icons = blue_icons
			if GameSettings.player3_selected:
				player3.starting_round = false
				player_3_health.visible = true
				player_3_icon.visible = true
				player_3_photo.visible = true
				if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
					player_3_score.visible = true
				if player3.team_name == "red-team":
					move_icon_and_photo(player_3_icon, player_3_photo, "red", player_3_health)
					player_3_icons = red_icons
				elif player3.team_name == "blue-team":
					move_icon_and_photo(player_3_icon, player_3_photo, "blue", player_3_health)
					player_3_icons = blue_icons
			if GameSettings.player4_selected:
				player4.starting_round = false
				player_4_health.visible = true
				player_4_icon.visible = true
				player_4_photo.visible = true
				if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
					player_4_score.visible = true
				if player4.team_name == "red-team":
					move_icon_and_photo(player_4_icon, player_4_photo, "red", player_4_health)
					player_4_icons = red_icons
				elif player1.team_name == "blue-team":
					move_icon_and_photo(player_4_icon, player_4_photo, "blue", player_4_health)
					player_4_icons = blue_icons
			
	if not p1_score_red and GameSettings.player1_selected and player1.score == goal_score - 1:
		if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
			player_1_score.modulate = Color(.7,.1,.1,1)
			p1_score_red = true
	if not p2_score_red and GameSettings.player2_selected and player2.score == goal_score - 1:
		if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
			player_2_score.modulate = Color(.7,.1,.1,1)
			p2_score_red = true
	if not p3_score_red and GameSettings.player3_selected and player3.score == goal_score - 1:
		if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
			player_3_score.modulate = Color(.7,.1,.1,1)
			p3_score_red = true
	if not p4_score_red and GameSettings.player4_selected and player4.score == goal_score - 1:
		if GameSettings.current_team_type != GameSettings.TEAM_TYPE.TWOVSTWO:
			player_4_score.modulate = Color(.7,.1,.1,1)
			p4_score_red = true
	if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO and not blue_score_red and blue_team_score == goal_score - 1:
		blue_team_score_label.modulate = Color("#094ef9")
		blue_score_red = true
	if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO and not red_score_red and red_team_score == goal_score - 1:
		red_team_score_label.modulate = Color(.7,.1,.1,1)
		red_score_red = true
		
	if p1_score_red:
		if p1_score_vibrate_count > 3:
			p1_score_vibrate_count = 0
			p1_score_direction *= -1
		player_1_score.global_position.x += p1_score_direction
		p1_score_vibrate_count += 1
		
	if p2_score_red:
		if p2_score_vibrate_count > 3:
			p2_score_vibrate_count = 0
			p2_score_direction *= -1
		player_2_score.global_position.x += p2_score_direction
		p2_score_vibrate_count += 1
		
	if p3_score_red:
		if p3_score_vibrate_count > 3:
			p3_score_vibrate_count = 0
			p3_score_direction *= -1
		player_3_score.global_position.x += p3_score_direction
		p3_score_vibrate_count += 1
		
	if p4_score_red:
		if p4_score_vibrate_count > 3:
			p4_score_vibrate_count = 0
			p4_score_direction *= -1
		player_4_score.global_position.x += p4_score_direction
		p4_score_vibrate_count += 1
		
	if blue_score_red:
		if blue_score_vibrate_count > 3:
			blue_score_vibrate_count = 0
			blue_score_direction *= -1
		blue_team_score_label.global_position.x += blue_score_direction
		blue_score_vibrate_count += 1
		
	if red_score_red:
		if red_score_vibrate_count > 3:
			red_score_vibrate_count = 0
			red_score_direction *= -1
		red_team_score_label.global_position.x += red_score_direction
		red_score_vibrate_count += 1
		
	if not game_just_finished and (red_team_score >= goal_score or blue_team_score >= goal_score or (GameSettings.player1_selected and player1.score >= goal_score) or (GameSettings.player2_selected and player2.score >= goal_score) or (GameSettings.player3_selected and player3.score >= goal_score) or (GameSettings.player4_selected and player4.score >= goal_score)):
		GameSettings.refresh()
		countdown.global_position.x = 125
		countdown.visible = true
		countdown.text = "FINISHED!"
		bell_sound.play()
		game_just_finished = true
		
		if GameSettings.player1_selected:
			player1.lives = 0
		if GameSettings.player2_selected:
			player2.lives = 0
		if GameSettings.player3_selected:
			player3.lives = 0
		if GameSettings.player4_selected:
			player4.lives = 0
		
		if red_team_score >= goal_score:
			red_team_score = goal_score
			countdown.modulate = Color("#fc8387")
		elif blue_team_score >= goal_score:
			blue_team_score = goal_score
			countdown.modulate = Color("#8cceff")
		elif player1.score >= goal_score:
			player1.score = goal_score
			if player1.team_name == "red-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#fc8387")
			elif player1.team_name == "blue-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#8cceff")
			else:
				countdown.modulate = Color(1,.8,.64)
		elif player2.score >= goal_score:
			player2.score = goal_score
			if player2.team_name == "red-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#fc8387")
			elif player2.team_name == "blue-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#8cceff")
			else:
				countdown.modulate = Color(.69,.57,.99,1)
		elif player3.score >= goal_score:
			player3.score = goal_score
			if player3.team_name == "red-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#fc8387")
			elif player4.team_name == "blue-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#8cceff")
			else:
				countdown.modulate = Color(.8,1,.71)
		elif player4.score >= goal_score:
			player4.score = goal_score
			if player4.team_name == "red-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#fc8387")
			elif player4.team_name == "blue-team" and GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
				countdown.modulate = Color("#8cceff")
			else:
				countdown.modulate = Color(1,.69,.82,1)
				
		end_of_match_timer.start()
	
	update_timer_text()
	update_player_borders()
	update_player_health()
	
func update_timer_text():
	match_timer_int = int(match_timer.time_left)
	if match_timer.time_left < 1:
		match_timer.stop()
	if int(match_timer_int/61) > 0 and int(match_timer_int%60) > 10:
		label.text = str(str(int(match_timer_int/60)) + ":" + str(int(match_timer_int%60)))
	elif int(match_timer_int/61) > 0 and int(match_timer_int%60) < 10:
		label.text = str(str(int(match_timer_int/60)) + ":0" + str(int(match_timer_int%60)))
	elif match_timer_int < 61:
		label.text = str(match_timer_int)
	
	if match_timer_int <= 5:
		if label.get_theme_color("font_color") != Color(.7,.1,.1,1):
			label.add_theme_color_override("font_color", Color(.7,.1,.1,1))
			label.add_theme_font_size_override("font_size", 400)
			label.global_position.y -= 10
			label.global_position.x -= 7
	elif match_timer_int <= 9 and not nine_moved:
		if not nine_moved:
			label.global_position.x += 7
			nine_moved = true
	elif match_timer_int <= 10:
		if label.get_theme_color("font_color") != Color(.7,.2,.2,1):
			label.add_theme_color_override("font_color", Color(.7,.2,.2,1))
	elif match_timer_int <= 19 and not nineteen_moved:
		if not nineteen_moved:
			label.global_position.x += 3
			nineteen_moved = true
	elif match_timer_int <= 20:
		if label.get_theme_color("font_color") != Color(.8,.3,.3,1):
			label.add_theme_color_override("font_color", Color(.8,.3,.3,1))
	elif match_timer_int <= 30:
		if label.get_theme_color("font_color") != Color(.8,.4,.4,1):
			label.add_theme_color_override("font_color", Color(.8,.4,.4,1))
	elif match_timer_int <= 40:
		if label.get_theme_color("font_color") != Color(.8,.5,.5,1):
			label.add_theme_color_override("font_color", Color(.8,.5,.5,1))
	elif match_timer_int <= 50:
		if label.get_theme_color("font_color") != Color(.9,.6,.6,1):
			label.add_theme_color_override("font_color", Color(.9,.6,.6,1))
	elif match_timer_int < 61 and label.get_theme_color("font_color") != Color(1,.7,.7,1) and label.get_theme_font_size("font_size") != 230:
		border_speed = 5
		label.add_theme_font_size_override("font_size", 230)
		label.global_position.y -= 7
		label.add_theme_color_override("font_color", Color(1,.7,.7,1))
	elif match_timer_int > 61 and label.get_theme_font_size("font_size") != 130:
		border_speed = 7
		label.global_position.y += 7
		label.add_theme_font_size_override("font_size", 130)
		if nine_moved:
			nine_moved = false
		if nineteen_moved:
			nineteen_moved = false
			
func update_player_borders():
	player_1_count += 1
	player_2_count += 1
	player_3_count += 1
	player_4_count += 1
	if player_1_count % border_speed == 0:
		player_1_index += 1
		if player_1_index > 3:
			player_1_index = 0
		player_1_icon.texture = player_1_icons[player_1_index]
	if player_2_count % border_speed == 0:
		player_2_index += 1
		if player_2_index > 3:
			player_2_index = 0
		player_2_icon.texture = player_2_icons[player_2_index]
	if player_3_count % border_speed == 0:
		player_3_index += 1
		if player_3_index > 3:
			player_3_index = 0
		player_3_icon.texture = player_3_icons[player_3_index]
	if player_4_count % border_speed == 0:
		player_4_index += 1
		if player_4_index > 3:
			player_4_index = 0
		player_4_icon.texture = player_4_icons[player_4_index]
		
func update_player_health():
	if GameSettings.player1_selected:
		player_1_health_number = int(player1.health)
		player_1_health.text = str(int(player1.health))
		update_player_health_color(player_1_health, player1.health)
	if GameSettings.player2_selected:
		player_2_health_number = int(player2.health)
		player_2_health.text = str(int(player2.health))
		update_player_health_color(player_2_health, player2.health)
	if GameSettings.player3_selected:
		player_3_health_number = int(player3.health)
		player_3_health.text = str(int(player3.health))
		update_player_health_color(player_3_health, player3.health)
	if GameSettings.player4_selected:
		player_4_health_number = int(player4.health)
		player_4_health.text = str(int(player4.health))
		update_player_health_color(player_4_health, player4.health)
		
func update_player_health_color(health_label, health):
	if health >= 300:
		health_color_count = 8
	elif health >= 250:
		health_color_count = 7
	elif health >= 180:
		health_color_count = 6
	elif health >= 120:
		health_color_count = 5
	elif health >= 100:
		health_color_count = 4
	elif health >= 70:
		health_color_count = 3
	elif health >= 60:
		health_color_count = 2
	elif health >= 40:
		health_color_count = 1
	elif health < 40:
		health_color_count = 0
		
	if health >= 300 and health_color_count == 8:
		health_label.modulate = Color(.6,.1,.1,1)
	elif health >= 250 and health_color_count == 7:
		health_label.modulate = Color(.7,.1,.1,1)
	elif health >= 180 and health_color_count == 6:
		health_label.modulate =  Color(.7,.2,.2,1)
	elif health >= 120 and health_color_count == 5:
		health_label.modulate = Color(.8,.3,.3,1)
	elif health >= 100 and health_color_count == 4:
		health_label.modulate = Color(.9,.4,.4,1)
	elif health >= 70 and health_color_count == 3:
		health_label.modulate = Color(.9,.5,.5,1)
	elif health >= 60 and health_color_count == 2:
		health_label.modulate = Color(.9,.6,.6,1)
	elif health >= 40 and health_color_count == 1:
		health_label.modulate = Color(.9,.7,.7,1)
	elif health < 40 and health_label.get_modulate() != Color(1,1,1,1):
		health_label.modulate = Color(1,1,1,1)
		health_color_count = 0
		
func get_player_health_color(player_index):
	if player_index == 0:
		return player_1_health.get_modulate()
	elif player_index == 1:
		return player_2_health.get_modulate()
	elif player_index == 2:
		return player_3_health.get_modulate()
	elif player_index == 3:
		return player_4_health.get_modulate()

func _on_countdown_timer_timeout():
	countdown_timer.stop()
	countdown.visible = false

func _on_match_timer_timeout():
	overtime = true
	match_timer.stop()

func update_icons():
	if GameSettings.player1_selected:
		if player1.team_name == "red-team":
			player_1_icons = red_icons
		elif player1.team_name == "blue-team":
			player_1_icons = blue_icons
	if GameSettings.player2_selected:
		if player2.team_name == "red-team":
			player_2_icons = red_icons
		elif player2.team_name == "blue-team":
			player_2_icons = blue_icons
	if GameSettings.player3_selected:
		if player3.team_name == "red-team":
			player_3_icons = red_icons
		elif player3.team_name == "blue-team":
			player_3_icons = blue_icons
	if GameSettings.player4_selected:
		if player4.team_name == "red-team":
			player_4_icons = red_icons
		elif player4.team_name == "blue-team":
			player_4_icons = blue_icons

func _on_end_of_match_timer_timeout():
	for node in get_tree().get_nodes_in_group("Projectiles"):
		node.queue_free()
	get_tree().change_scene_to_file("res://scenes/results_screen.tscn")

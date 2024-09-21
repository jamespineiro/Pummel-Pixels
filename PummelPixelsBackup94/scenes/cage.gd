extends Sprite2D

var scoreboard : Control
var direction : int
var match_timer : Timer
var cage_speed : float

func _ready():
	scoreboard = get_node("../ScoreboardAndIcons")
	match_timer = scoreboard.match_timer
	direction = 1
	cage_speed = 1

func _process(_delta):
	
	if direction > 0 and global_position.y < 100:
		change_speed()
		global_position.y += direction * cage_speed
	elif direction < 0 and global_position.y > 20:
		change_speed()
		global_position.y += direction * cage_speed
	else:
		direction *= -1

func change_speed():
	if match_timer.time_left >= 300:
		cage_speed = .2
	elif match_timer.time_left >= 250:
		cage_speed = .4
	elif match_timer.time_left >= 200:
		cage_speed = .6
	elif match_timer.time_left >= 150:
		cage_speed = .8
	elif match_timer.time_left >= 100:
		cage_speed = 1
	elif match_timer.time_left >= 50:
		cage_speed = 1.1
	elif match_timer.time_left < 50:
		cage_speed = 1.2
	

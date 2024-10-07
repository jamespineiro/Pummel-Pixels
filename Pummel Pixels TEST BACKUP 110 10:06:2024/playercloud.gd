extends AnimatedSprite2D
var cloud_animations = ["orangecloud", "purplecloud", "greencloud", "whitecloud"]
var arrow : CharacterBody2D

func assign_player(player):
	global_position = player.global_position
	if player.team_name == "team-one":
		play.call_deferred("orangecloud")
	elif player.team_name == "team-two":
		play.call_deferred("purplecloud")
	elif player.team_name == "team-three":
		play.call_deferred("greencloud")
	elif player.team_name == "team-four":
		play.call_deferred("pinkcloud")
	elif player.team_name == "blue-team":
		play.call_deferred("bluecloud")
	elif player.team_name == "red-team":
		play.call_deferred("redcloud")
	else:
		play.call_deferred("whitecloud")
	
func assign_arrow(arr):
	global_position = arr.global_position
	if arr.team_name == "team-one":
		play.call_deferred("orangecloud")
	elif arr.team_name == "team-two":
		play.call_deferred("purplecloud")
	elif arr.team_name == "team-three":
		play.call_deferred("greencloud")
	elif arr.team_name == "team-four":
		play.call_deferred("pinkcloud")
	elif arr.team_name == "blue-team":
		play.call_deferred("bluecloud")
	elif arr.team_name == "red-team":
		play.call_deferred("redcloud")
	else:
		play.call_deferred("whitecloud")
	arrow = arr
	arr.queue_free()

func _process(_delta):
	rotation_degrees += 1

func _on_animation_finished():
	if arrow != null:
		arrow.queue_free()
	queue_free()

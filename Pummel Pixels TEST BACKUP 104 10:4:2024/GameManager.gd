extends Node2D

var scene : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	scene = $main

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if scene == null:
		scene = $main
	else:
		if Input.is_action_just_pressed("FFA"):
			get_tree().reload_current_scene()
			scene.current_gamemode = scene.TEAM_TYPE.FFA
			scene.changes_made = true
			
		if Input.is_action_just_pressed("2v2"):
			get_tree().reload_current_scene()
			scene.current_gamemode = scene.TEAM_TYPE.TWOVSTWO
			scene.changes_made = true

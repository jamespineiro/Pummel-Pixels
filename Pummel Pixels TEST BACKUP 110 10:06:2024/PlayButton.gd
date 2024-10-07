extends Label

var frame_count = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	frame_count += 1
	
	if frame_count % 50 == 0:
		if modulate == Color(1,1,1,1):
			modulate = Color(.6,.9,1,1)
		else:
			modulate = Color(1,1,1,1)

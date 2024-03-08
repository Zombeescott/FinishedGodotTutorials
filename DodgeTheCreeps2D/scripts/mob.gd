extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Grabs the three animations as an array of strings
	var mob_types : PackedStringArray = $AnimatedSprite2D.sprite_frames.get_animation_names()
	# Gets a random animation to play
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Gee I wonder what this does
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

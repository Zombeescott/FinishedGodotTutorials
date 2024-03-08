extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# When the player gets hit
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()


# When the start button is pushed
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start() 
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	# Lesson: Since we added mobs to a group, every mob that spawns in is now part of the mobs group.
	# Because of this, we can use call_group() to remove all mobs that have spawned in.
	# With this idea, we can assign objects to different groups and call any function that applies.
	# Useful and different to signal as a function has to be listening for a signal.
	# With the use of groups, a function of theirs can be called along with its parameters.
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()


func _on_score_timer_timeout():
	score += 1
	
	$HUD.update_score(score)


func _on_start_timer_timeout():
	# Lesson: StartTimer has One Shot on, so it will not run multiple times once it starts.
	# Score and Mob Timer have it off, so when their timer ends, they will start again immediately.
	# So at the end of StartTimer's 2 second Wait Time, it will start the other timers.
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout():
	# Gets a mob object
	var mob = mob_scene.instantiate()
	
	# Gets a point from the MobPath and finds a random spot on it to spawn the mob
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Makes the direction of the mob perpindicular to the path by default
	# Note: PI is equal to about 180 degrees in radians
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Sets the position
	mob.position = mob_spawn_location.position
	
	# Randomizes the direction that the mob goes in slightly
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Randomizes the velocity of the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

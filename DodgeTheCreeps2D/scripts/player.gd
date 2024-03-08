extends Area2D
signal hit

# Lesson: the @export allows its value to be set in the inspector
@export var speed : int = 400 # pixels/sec
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # Gets the screen size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # Player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# Checks if the player is moving
	if velocity.length() > 0:
		# Prevents the player from moving faster diagonally
		velocity = velocity.normalized() * speed
		# Lesson: '$' is shorthand for get_node()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide()
	hit.emit() # Sends 'hit' signal out
	$CollisionShape2D.set_deferred("disabled", true) # Deactivates collision


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

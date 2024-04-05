extends Area2D

signal hit

@export var speed = 400
@onready var sprite = $AnimatedSprite2D
@onready var screen_size = get_viewport_rect().size
@onready var colision = $CollisionShape2D

func _ready():
	hide()

func handle_animate(velocity):
	if velocity.x != 0:
		sprite.animation = "WALK"
		sprite.flip_v = false

		sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		sprite.animation = "UP"
		sprite.flip_v = velocity.y > 0

func _physics_process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play()
	else:
		sprite.stop()
	
	handle_animate(velocity)
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func start(pos):
	position = pos
	show()
	colision.set_deferred("disabled", false)

func _on_body_entered(body):
	hide()
	hit.emit()
	colision.set_deferred("disabled", true)

extends Node2D

@export var mob_scene: PackedScene
var score
var difficult = 1
var min_speed = 150.0
var max_speed = 250.0

func _ready():
	var initial_volum
	$Music.play()
	$HUD.set_volume(0.8)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$DeadSound.play()
 
func new_game():
	score = 0
	difficult = 1
	$MobTimer.wait_time = 0.5
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	
	get_tree().call_group("mobs", "queue_free")

func _on_score_timer_timeout():
	score += 1
	if score % 10 == 0:
		difficult += 0.1
		if $MobTimer.wait_time > 0.1:
			$MobTimer.wait_time -= 0.05
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(min_speed * difficult, max_speed * difficult), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_update_volume(volume):
	get_tree().set_group("sounds", "volume_db", volume)

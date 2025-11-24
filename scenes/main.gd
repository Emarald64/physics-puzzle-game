extends Node2D

var currentLevelNumber:=1
var level:Node
#const levels:Array[PackedScene]=[preload("res://scenes/levels/level_1.tscn"),preload("res://scenes/levels/level_2.tscn"),preload("res://scenes/levels/level_3.tscn")]
var failedAttempts:=0
var blocks:Array[Node]
#var secondsUntilWin:=6

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug 1"):win()
	if Input.is_action_just_pressed("reset"):fail()
	if not $WinCountdownTimer.is_stopped():
		$"Count Down".text=str(int(ceilf($WinCountdownTimer.time_left)))
		$"Count Down".add_theme_font_size_override("font_size",64+(384*minf(0.5,1-fmod($WinCountdownTimer.time_left-0.01,1.0))))

func _ready() -> void:
	loadLevel(1)

func fail() -> void:
	if not $WinCountdownTimer.is_stopped():
		failedAttempts+=1
	$Fail.set_deferred('monitoring',false)
	
	for block in level.get_node('Blocks').get_children():
		block.reset(not $WinCountdownTimer.is_stopped())
	$WinCountdownTimer.stop()
	#
	#secondsUntilWin=6
	$"Count Down".hide()

func loadLevel(number:int)->void:
	if level!=null:
		# remove existing level
		level.queue_free()
	# add the new level
	level=load("res://scenes/levels/level_"+str(number)+".tscn").instantiate()
	blocks=level.get_node('Blocks').get_children()
	level.z_index=-1
	$Fail.position.y=level.get_meta("fail_line_offset",630.0)
	add_child(level)
	#secondsUntilWin=6
	$"Count Down".hide()
	$Fail.monitoring=false

func startLevel()->void:
	# check that no blocks overlap
	print('starting level')
	for block in blocks:
		if block.get_node('Overlapping Blocks Check').has_overlapping_areas() or block.get_node('Overlapping Blocks Check').has_overlapping_bodies():
			block.modulate=Color.RED
			get_tree().create_timer(1).timeout.connect(block.set_modulate.bind(Color.WHITE))
			return
	print('checks passed')
	for block in blocks:
		assert(block is RigidBody2D)
		block.activate()
	$Fail.monitoring=true
	$WinCountdownTimer.start()
	$"Count Down".show()

#func decWinCounter()->void:
	#secondsUntilWin-=1
	#if secondsUntilWin<=0:
		#$WinCountdownTimer.stop()
		#win()
	#else:
		#$"Count Down".show()
		#$"Count Down".text=str(secondsUntilWin)
		#$"Count Down".scale=Vector2.ONE/4.0
		#var tween := get_tree().create_tween()
		#tween.tween_property($"Count Down",'scale',Vector2.ONE,0.5)

func win() -> void:
	currentLevelNumber+=1
	loadLevel(currentLevelNumber)

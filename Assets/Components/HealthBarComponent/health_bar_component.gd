extends Node3D
class_name HealthBarComponent

@export var entity : Node
@export var modulateAlpha : bool = false
#@export var show_text : bool = false
@export var change_fill_color : bool = true

var hp_tween : Tween
var hp_delay_tween : Tween
var modulate_tween : Tween

@onready var hp_bar = $SubViewport/HPBar
@onready var hp_bar_delay = $SubViewport/HPBarDelay
@onready var delay_timer = $DelayTimer
@onready var alpha_timer = $AlphaTimer

@onready var green_progress_fill = preload("res://Assets/Components/HealthBarComponent/barfill.png")
@onready var red_progress_fill = preload("res://Assets/Components/HealthBarComponent/barfillRED.png")
@onready var yellow_progress_fill = preload("res://Assets/Components/HealthBarComponent/barfillYELLOW.png")


@export var circled_frame : CompressedTexture2D
@export var squared_frame : CompressedTexture2D

enum FrameType {Circled, Squared}

@export var curent_frame : FrameType = FrameType.Circled

var new_hp
var tm

func _ready() -> void:
	
	setFrame()
	
	if change_fill_color:
		if entity.current_health <= (0.2 * entity.max_health):
			hp_bar.set_progress_texture(red_progress_fill)
		elif entity.current_health > (0.25 * entity.max_health) and entity.current_health < (0.6 * entity.max_health):
			hp_bar.set_progress_texture(yellow_progress_fill)
		else:
			hp_bar.set_progress_texture(green_progress_fill)
	
	
	#if show_text:
		#$hpText.show()
		#$hpText.text = str(int(entity.current_health)) + "/" + str(int(entity.max_health))
	#else:
		#$hpText.hide()
	
	
	if modulateAlpha:
		alphaDown()
	
	hp_bar.max_value = entity.max_health
	hp_bar_delay.max_value = hp_bar.max_value
	
	hp_bar.value = entity.current_health
	hp_bar_delay.value = hp_bar.value
	


func hpDrop(_old_health, new_health, time):
	
	if modulateAlpha:
		modulate_tween.stop()
		alphaUp()
		alpha_timer.start()
	
	delay_timer.start()
	new_hp = new_health
	tm = time
	hp_tween = get_tree().create_tween()
	hp_tween.set_ease(Tween.EASE_OUT)
	
	
	hp_tween.tween_property(hp_bar, "value", new_health, 0.05)
	
	
	if change_fill_color:
		if entity.current_health <= (0.25 * entity.max_health):
			$SubViewport/HPBar.set_progress_texture(red_progress_fill)
		elif entity.current_health > (0.25 * entity.max_health) and entity.current_health < (0.6 * entity.max_health):
			$SubViewport/HPBar.set_progress_texture(yellow_progress_fill)
		else:
			$SubViewport/HPBar.set_progress_texture(green_progress_fill)
	
	#$hpText.text = str(int(entity.current_health)) + "/" + str(int(entity.max_health))
	
	if entity.current_health <= 0:
		hide()

func _on_delay_timer_timeout() -> void:
	hp_delay_tween = get_tree().create_tween()
	hp_delay_tween.set_ease(Tween.EASE_OUT)
	hp_delay_tween.tween_property(hp_bar_delay, "value", new_hp, tm)




func alphaDown():
	modulate_tween = get_tree().create_tween()
	modulate_tween.set_ease(Tween.EASE_IN)
	
	modulate_tween.tween_property($ViewportTex, "modulate:a", 0.2 , 0.5)

func alphaUp():
	modulate_tween = get_tree().create_tween()
	modulate_tween.set_ease(Tween.EASE_OUT)
	
	modulate_tween.tween_property($ViewportTex, "modulate:a", 1 , 0.05)


func _on_alpha_timer_timeout() -> void:
	alphaDown()

func setFrame():
	match curent_frame:
		FrameType.Circled:
			$SubViewport/HPBar.texture_under = circled_frame
		FrameType.Squared:
			$SubViewport/HPBar.texture_under = squared_frame

extends Control

class_name UI

signal game_paused
signal play_again

enum State { GAME_RUNNING, MAIN_MENU, SETTINGS, INFO_WINDOW, CONGRATULATIONS_DIALOG }

var state = State.GAME_RUNNING

var greyscreen_tween: Tween = null

func _ready() -> void:
	set_greyscreen(false)

func set_greyscreen(_value: bool) -> void:
	if _value:
		$Greyscreen.modulate.a = 0.5
	else:
		$Greyscreen.modulate.a = 0
	game_paused.emit(_value)

func set_state(_state: State) -> void:
	var _previous_state = state
	state = _state
	
	for child in $Windows.get_children():
		child.set_visible(false)
		
	match state:
		State.GAME_RUNNING:
			set_greyscreen(false)
		
		State.MAIN_MENU:
			$Windows/MainMenu.visible = true
			set_greyscreen(true)
			
		State.SETTINGS:
			$Windows/SettingsWindow.visible = true
			set_greyscreen(true)
			
		State.INFO_WINDOW:
			$Windows/InfoWindow.visible = true
			set_greyscreen(true)
			
		State.CONGRATULATIONS_DIALOG:
			$Windows/CongratulationsDialog.visible = true
			greyscreen_tween = create_tween()
			greyscreen_tween.tween_property($Greyscreen, "modulate:a", 1, 0.5)

func congratulate():
	set_state(State.CONGRATULATIONS_DIALOG)

#########################
# TRANSITIONS - IN GAME #
#########################
func _on_hud_settings_button_clicked() -> void:
	set_state(State.MAIN_MENU)

###########################
# TRANSITIONS - MAIN MENU #
###########################
func _on_main_menu_return_to_game_pressed() -> void:
	set_state(State.GAME_RUNNING)

func _on_main_menu_about_button_pressed() -> void:
	set_state(State.INFO_WINDOW)

func _on_main_menu_new_game_button_pressed() -> void:
	print("Main Menu: Redealing")
	if greyscreen_tween != null:
		greyscreen_tween.stop()
		
	play_again.emit()
	set_state(State.GAME_RUNNING)

func _on_main_menu_quit_button_pressed() -> void:
	print("Main Menu: Quitting")
	get_tree().quit()

func _on_main_menu_settings_button_pressed() -> void:
	set_state(State.SETTINGS)	


#################################
# TRANSITIONS - SETTINGS WINDOW #
#################################
func _on_settings_window_exit_button_clicked() -> void:
	set_state(State.MAIN_MENU)

func _on_settings_window_music_toggled(_value: bool) -> void:
	SettingsManager.music_muted = _value

func _on_settings_window_sfx_toggled(_value: bool) -> void:
	SettingsManager.sfx_muted = _value
	

#############################
# TRANSITIONS - INFO WINDOW #
#############################
func _on_info_window_close_button_clicked() -> void:
	set_state(State.MAIN_MENU)
	
################################
# TRANSITIONS - VICTORY SCREEN #
################################
func _on_congratulations_dialog_play_again() -> void:
	_on_main_menu_new_game_button_pressed()


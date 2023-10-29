extends Control

class_name UI

signal game_paused

enum State { GAME_RUNNING, MAIN_MENU, SETTINGS, INFO_WINDOW }

var state = State.GAME_RUNNING

func set_greyscreen(_value: bool) -> void:
	$Greyscreen.visible = _value
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
	


func _on_hud_settings_button_clicked() -> void:
	set_state(State.MAIN_MENU)

#############
# MAIN MENU #
#############
func _on_main_menu_return_to_game_pressed() -> void:
	set_state(State.GAME_RUNNING)

func _on_main_menu_about_button_pressed() -> void:
	set_state(State.INFO_WINDOW)

func _on_main_menu_new_game_button_pressed() -> void:
	assert(false) # TODO

func _on_main_menu_quit_button_pressed() -> void:
	print("Main Menu: Quitting")
	get_tree().quit()

func _on_main_menu_settings_button_pressed() -> void:
	set_state(State.SETTINGS)	


###################
# SETTINGS WINDOW #
###################
func _on_settings_window_exit_button_clicked() -> void:
	set_state(State.MAIN_MENU)

func _on_settings_window_music_toggled(_value: bool) -> void:
	assert(false) # TODO

func _on_settings_window_sfx_toggled(_value: bool) -> void:
	assert(false) # TODO
	

###############
# INFO WINDOW #
###############
func _on_info_window_close_button_clicked() -> void:
	set_state(State.MAIN_MENU)

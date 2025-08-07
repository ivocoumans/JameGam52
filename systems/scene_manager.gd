extends Node

enum Scene {
	TITLE,
	HELP,
	GAME_START,
	GAME,
	PAUSE,
	ROUND_END,
	GAME_OVER
}

const SCENES = {
	Scene.TITLE: "res://scenes/title.tscn",
	Scene.HELP: "res://scenes/help.tscn",
	Scene.GAME_START: "res://scenes/game_start.tscn",
	Scene.GAME: "res://scenes/game.tscn",
	Scene.PAUSE: "res://scenes/pause.tscn",
	Scene.ROUND_END: "res://scenes/round_end.tscn",
	Scene.GAME_OVER: "res://scenes/game_over.tscn"
}

var current_scene: Scene = Scene.TITLE
var game_scene_instance: Node = null
var overlay_scene: Node = null
var game_data = {}


func _change_scene(scene: Scene):
	match scene:
		Scene.TITLE:
			_load_single_scene(scene)
		Scene.HELP:
			_show_overlay(scene)
		Scene.GAME_START:
			_load_single_scene(scene)
		Scene.GAME:
			_load_game_scene()
		Scene.PAUSE:
			_show_overlay(scene)
		Scene.ROUND_END:
			_show_overlay(scene)
		Scene.GAME_OVER:
			_show_overlay(scene)
	current_scene = scene


func _load_single_scene(scene: Scene):
	_clear_overlay()
	_clear_game_scene()
	
	var scene_resource = load(SCENES[scene])
	var scene_instance = scene_resource.instantiate()
	get_tree().root.add_child(scene_instance)
	get_tree().current_scene = scene_instance


func _load_game_scene():
	if game_scene_instance != null:
		_clear_overlay()
		#if game_scene_instance:
			#game_scene_instance.visible = true
		return
	
	_clear_overlay()
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	var game_resource = load(SCENES[Scene.GAME])
	game_scene_instance = game_resource.instantiate()
	get_tree().root.add_child(game_scene_instance)
	get_tree().current_scene = game_scene_instance


func _show_overlay(scene: Scene):
	#if game_scene_instance:
		#game_scene_instance.visible = false
	
	_clear_overlay()
	var overlay_resource = load(SCENES[scene])
	overlay_scene = overlay_resource.instantiate()
	get_tree().root.add_child(overlay_scene)


func _clear_overlay():
	if !overlay_scene:
		return
	overlay_scene.queue_free()
	overlay_scene = null


func _clear_game_scene():
	if !game_scene_instance:
		return
	game_scene_instance.queue_free()
	game_scene_instance = null


func go_to_title():
	_change_scene(Scene.TITLE)


func show_help():
	_change_scene(Scene.HELP)


func show_game_start():
	_change_scene(Scene.GAME_START)


func start_game():
	_change_scene(Scene.GAME)


func pause_game():
	if current_scene == Scene.GAME:
		set_game_data("paused", true)
		_change_scene(Scene.PAUSE)


func unpause_game():
	if current_scene == Scene.PAUSE:
		set_game_data("paused", false)
		_change_scene(Scene.GAME)
		SignalBus.unpaused.emit()


func show_round_end():
	if current_scene == Scene.GAME:
		_change_scene(Scene.ROUND_END)


func continue_from_round_end():
	if current_scene == Scene.ROUND_END:
		_change_scene(Scene.GAME)


func show_game_over():
	_change_scene(Scene.GAME_OVER)


func restart_game():
	_clear_game_scene()
	game_data.clear()
	_change_scene(Scene.GAME)


func quit_to_title():
	_clear_game_scene()
	game_data.clear()
	_change_scene(Scene.TITLE)


func set_game_data(key: String, value):
	game_data[key] = value


func get_game_data(key: String, default_value = null):
	return game_data.get(key, default_value)


func is_paused() -> bool:
	return game_data.get("paused", false)

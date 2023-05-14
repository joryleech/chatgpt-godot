@tool
extends EditorPlugin

const AUTOLOAD_NAME: String = "ChatGptApi"
const AUTOLOAD_PATH: String = "res://addons/chat_gpt_api/chat_gpt_api.gd"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)
	

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)


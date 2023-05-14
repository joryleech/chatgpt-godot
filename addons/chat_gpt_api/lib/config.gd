@tool
extends Node

const SETTINGS_PATH: String = "addons/chat_gpt/"
const API_KEY_SETTINGS_PATH: String = "api_key"
const JSON_DELIMITER = '\t'
var api_key : String


func _init():
	ProjectSettings.set_initial_value(get_api_key_settings_path(), " ")
	if(!ProjectSettings.has_setting(get_api_key_settings_path())):
		ProjectSettings.set_setting(get_api_key_settings_path(), " ")
		
	var property_info = {
		"name": get_api_key_settings_path,
		"type": TYPE_STRING,
	}
	ProjectSettings.add_property_info(property_info)
	
	
func get_api_key_settings_path() -> String:
	return SETTINGS_PATH+API_KEY_SETTINGS_PATH

func get_api_key(safe : bool = true):
	var key : String = ProjectSettings.get_setting(get_api_key_settings_path())
	if(safe):
		assert(ProjectSettings.has_setting(get_api_key_settings_path()) && key != null && !key.is_empty(), "ChatGPT API Key is not set. Please set it in the Project Settings. This can be found under Project > Project Settings > Plugins > Chatgpt.");
	return key

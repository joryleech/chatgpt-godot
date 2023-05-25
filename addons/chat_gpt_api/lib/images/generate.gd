extends ChatGptApi.Request

@export var prompt : String
@export var size : String = "1024x1024"
@export var image_count : int = 1
@export var response_format : String = "url"
#@export var generate_textures : bool = false TODO Implement


func _init():
	self.api_endpoint = 'images/generations'

func generate_body() -> String:
	var body_dictionary : Dictionary = {
		"prompt": prompt,
		"n": image_count,
		"size": size
	}
	var json_body : String = JSON.stringify(body_dictionary, ChatGptApi.Config.JSON_DELIMITER)
	return json_body

func _on_success(response):
	emit_signal('on_success', response) 
	


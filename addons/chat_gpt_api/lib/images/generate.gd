extends ChatGptApi.Request

@export var prompt : String
@export var size : String = "1024x1024"
@export var image_count : int = 1
@export var response_format : String = "url"
@export var generate_textures : bool = false
signal on_generate_texture(textures : Array)

func _init():
	self.api_endpoint = 'images/generations'

func generate_body() -> String:
	var body_dictionary : Dictionary = {
		"prompt": prompt,
		"n": image_count,
		"size": size,
		"response_format": 'b64_json' if generate_textures else response_format
	}
	var json_body : String = JSON.stringify(body_dictionary, ChatGptApi.Config.JSON_DELIMITER)
	return json_body
	
func base_64_to_texture(image_b64 : String):
	var i = Image.new()
	i.load_png_from_buffer(Marshalls.base64_to_raw(image_b64))
	return ImageTexture.create_from_image(i)
	
	
func _on_success(response):
	if(generate_textures):
		var images_to_return : Array = []
		for image_response in response['data']:
			images_to_return.append(base_64_to_texture(image_response['b64_json']))
		emit_signal("on_generate_texture", images_to_return)
	emit_signal('on_success', response) 


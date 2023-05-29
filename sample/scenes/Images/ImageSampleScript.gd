extends Node

var text_log : PackedStringArray = []
@onready var text_input : TextEdit = $HBoxContainer/Input
@onready var size_input : OptionButton = $OptionsContainer/ImageSize/OptionButton
@onready var image_count_input : SpinBox = $OptionsContainer/ImageCount/SpinBox
@onready var text_output : RichTextLabel = $OutputContainer/UrlOutput
@onready var image_output_container : HBoxContainer = $OutputContainer/ImageOutput
@onready var generate_textures_bool : CheckBox = $OptionsContainer/GenerateTextureBool/OptionButton
func _on_submit_log():
	var requested_text = text_input.text
	text_input.text = ""
	text_log = []
	_send_message(requested_text)
	
func _send_message(message : String):
	for n in image_output_container.get_children():
		image_output_container.remove_child(n)
		n.queue_free()
	

	var image_generator = ChatGptApi.Images.Generate.new()
	add_child(image_generator)
	
	if(generate_textures_bool.is_pressed()):
		image_output_container.visible = true
		text_output.visible = false
		image_generator.generate_textures = true
	else:
		image_output_container.visible = false
		text_output.visible = true
		
	
	image_generator.prompt = message
	image_generator.size = size_input.get_item_text(size_input.get_selected_id())
	image_generator.image_count = image_count_input.value 
	image_generator.on_request_completed.connect(self.on_request_completed)
	image_generator.on_success.connect(self.on_request_success)
	image_generator.on_failure.connect(self.on_request_error)
	image_generator.on_generate_texture.connect(self.on_generate_texture)
	image_generator.request()

func on_generate_texture(textures : Array):
	for texture in textures:
		var rect : TextureRect = TextureRect.new()
		rect.texture = texture
		image_output_container.add_child(rect)
	
func on_request_completed( result,response_code,headers,body, response):
	print(result)
	print(body)
	print(headers)
	print(response_code)
	print(response)

func on_request_success(response : Dictionary):
	for image_response in response['data']:
		if(image_response.has('url')):
			_add_log("[url]"+image_response['url']+"[/url]", "blue")
	
func on_request_error(code, response):
	print("Code"+str(code))
	print("response")
	print(response)
	_add_log("Error "+str(code), "red")
	if(response && response['error'] && response['error']['message']):
		_add_log("Error Message: "+response['error']['message'], "red")
	if(response && response['error'] && response['error']['type']):
		_add_log("Error Type: "+response['error']['type'], "red")
	
func _add_log(log : String, color : String = "white"):
	var converted_log : String = "[color="+color+"]"+log+""
	if(log.length() > 0):
		text_log.append(converted_log)
	text_output.text = "\n".join(text_log)


func _on_output_link_clicked(meta):
	OS.shell_open(meta)
	pass # Replace with function body.

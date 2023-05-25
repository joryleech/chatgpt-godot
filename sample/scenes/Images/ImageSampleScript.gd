extends Node

var text_log : PackedStringArray = []
@onready var text_input : TextEdit = $HBoxContainer/Input
@onready var size_input : OptionButton = $OptionsContainer/ImageSize/OptionButton
@onready var image_count_input : SpinBox = $OptionsContainer/ImageCount/SpinBox


func _on_submit_log():
	var requested_text = text_input.text
	text_input.text = ""
	text_log = []
	_send_message(requested_text)
	
func _send_message(message : String):
	var image_generator = ChatGptApi.Images.Generate.new()
	add_child(image_generator)
	
	image_generator.prompt = message
	image_generator.size = size_input.get_item_text(size_input.get_selected_id())
	image_generator.image_count = image_count_input.value 
	image_generator.on_request_completed.connect(self.on_request_completed)
	image_generator.on_success.connect(self.on_request_success)
	image_generator.on_failure.connect(self.on_request_error)
	image_generator.request()
	
func on_request_completed( result,response_code,headers,body, response):
	print(result)
	print(body)
	print(headers)
	print(response_code)
	print(response)

func on_request_success(response):
	for image_response in response['data']:
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
	$Output.text = "\n".join(text_log)


func _on_output_link_clicked(meta):
	print(meta)
	OS.shell_open(meta)
	pass # Replace with function body.

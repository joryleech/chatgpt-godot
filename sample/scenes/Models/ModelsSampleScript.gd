extends Node

var text_log : PackedStringArray = []
@onready var text_input : TextEdit = $HBoxContainer/Input
@onready var text_output : RichTextLabel = $Output
var models : ChatGptApi.Models.List

func _send_message():
	models = ChatGptApi.Models.List.new()
	add_child(models)
	#System message, indicates the state which the AI should perform
	models.on_success.connect(self.on_request_success)
	models.on_failure.connect(self.on_request_error)
	models.request()

func on_request_success(response):
	print(response)
	_add_log(JSON.stringify(response, ChatGptApi.Config.JSON_DELIMITER), "gray")
	
func on_request_error(code, response):
	print("Code"+str(code))
	print("response")
	print(response)
	var error_log = ""
	error_log += "Error "+str(code)+"\n"
	if(response && response['error'] && response['error']['message']):
		error_log += "Error Message: "+response['error']['message']+"\n"
	if(response && response['error'] && response['error']['type']):
		error_log += "Error Type: "+response['error']['type']+"\n"
	_add_log(error_log, "red")
	
func _add_log(log : String, color : String = "white"):
	var converted_log : String = "[color="+color+"]"+log+""
	$Output.text = converted_log

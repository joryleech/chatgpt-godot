extends Node

var text_log : PackedStringArray = []
@onready var text_input : TextEdit = $HBoxContainer/Input
@onready var text_output : RichTextLabel = $Output

var completion : ChatGptApi.Completion = null
var keep_messages = false

func _on_submit_log():
	var requested_text = text_input.text
	_add_log(requested_text)
	text_input.text = ""
	_send_message(requested_text)
	
func _send_message(message : String):
	if(!keep_messages || completion == null):
		completion = ChatGptApi.Completion.new()
	completion.one_shot = !keep_messages
	add_child(completion)
	#System message, indicates the state which the AI should perform
	completion.add_message(
		"You are a helpful assistant AI",
		ChatGptApi.Completion.CompletionMessage.CompletionMessageRole.System
	)
	completion.add_message(
		message,
		ChatGptApi.Completion.CompletionMessage.CompletionMessageRole.User
	)
	completion.on_request_completed.connect(self.on_request_completed)
	completion.on_success.connect(self.on_request_success)
	completion.on_failure.connect(self.on_request_error)
	completion.request()
	
	
func on_request_completed( result,response_code,headers,body, response):
	print(result)
	print(body)
	print(headers)
	print(response_code)
	print(response)

func on_request_success(response):
	_add_log(response['choices'][0]['message']['content'], "gray")
	
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
	
func _on_check_box_toggled(button_pressed):
	print(button_pressed)
	keep_messages = button_pressed

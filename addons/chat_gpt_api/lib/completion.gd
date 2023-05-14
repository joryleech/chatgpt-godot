extends ChatGptApi.Request
const CompletionMessage = preload('res://addons/chat_gpt_api/lib/completion/completion_message.gd')
var model : String = 'gpt-3.5-turbo'
var messages : Array[CompletionMessage]
var automatically_add_messages = true
func _init():
	self.api_endpoint = 'chat/completions'

func generate_body() -> String:
	var body_dictionary : Dictionary = {
		"model": model,
		"messages": messages.map(func(message : CompletionMessage): return message.to_dictionary())
	}
	var json_body : String = JSON.stringify(body_dictionary, ChatGptApi.Config.JSON_DELIMITER)
	return json_body

func 	raw_add_message(message : CompletionMessage):
	messages.append(message)
	
func add_message(content : String, role : CompletionMessage.CompletionMessageRole):
	raw_add_message(
		CompletionMessage.new(content, role)
	)

func _on_success(response):
	if(automatically_add_messages):
		var returned_message : Dictionary = response['choices'][0]['message']
		var convertedMessage = CompletionMessage.new(
			returned_message['content'],
			CompletionMessage.CompletionMessageRole.Assistant
		)
	emit_signal('on_success', response) 

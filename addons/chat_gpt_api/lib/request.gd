extends Node

var one_shot : bool = true
var method : int = HTTPClient.METHOD_POST

var api_endpoint : String =""
var api_root : String = "https://api.openai.com/v1/"

signal on_success(response : Dictionary)
signal on_request_completed(result, response_code, headers, body, response) #Passthrough
signal on_failure(code : int, response : Dictionary)

var debug = false
var headers : PackedStringArray = []

@onready var http_request : HTTPRequest = HTTPRequest.new()
func _ready():
	add_child(http_request)
	http_request.request_completed.connect(self._request_completed)


func generate_headers() -> PackedStringArray:
	var pregenerated_headers : PackedStringArray = [
		"Content-Type: application/json",
		"Authorization: Bearer "+ChatGptApi.Config.get_api_key()
	]
	pregenerated_headers.append_array(headers)
	return pregenerated_headers

func generate_url():
	return api_root+api_endpoint
	
func generate_body() -> String:
	return ""
	
func request():
	http_request.request_completed.connect(self._request_completed)
	
	var error = http_request.request(
		generate_url(),
		generate_headers(),
		method, 
		generate_body()
	)
		
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		

func _request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	if(debug):
		print(body.get_string_from_utf8())
	var response = json.get_data()
	emit_signal("on_request_completed", result,response_code,headers,body, response)
	if(response_code == 200):
		_on_success(response)
	else:
		emit_signal('on_failure', response_code, response)
	if(one_shot):
		self.queue_free()

func _on_success(response):
	emit_signal('on_success', response)

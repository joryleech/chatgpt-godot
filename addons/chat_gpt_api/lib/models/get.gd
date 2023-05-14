extends ChatGptApi.Request

@export var model_id : String

func _init(model_id : String):
	self.model_id = model_id
	self.api_endpoint = 'models'
	self.method = HTTPClient.METHOD_GET

func generate_url():
	return api_root+api_endpoint+"/"+model_id

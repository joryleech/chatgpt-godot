extends ChatGptApi.Request

func _init():
	self.api_endpoint = 'models'
	self.method = HTTPClient.METHOD_GET

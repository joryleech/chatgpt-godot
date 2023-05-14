extends ChatGptApi.Request

func _init():
	self.api_endpoint = 'chat/models'
	self.method = HTTPClient.METHOD_GET

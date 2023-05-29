
  
# ChatGPT Godot
OpenAI ChatGPT unofficial GDscript wrapper 

Use text completion with the [OpenAI API](https://openai.com/blog/openai-api) via GDscript and Nodes.


## Installation
* Copy the contents of the ``/addons`` folder to your projects ``res://addons`` folder.
* Enable ``ChatGptApiPlugin`` in ``Project > Project Settings > Plugins``
* Set up and generate your OpenAI API Key here from [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys)
* Activate Advanced Settings in Project Settings
* Enter your API key in the new setting found ``Project > Project Settings > General > Addons > Chat Gpt > API Key``


## Usage

### Completions

Used to generate text completions, or AI assistance.

**Examples**

For one off requests:
```GDScript
func request_message(message : String):
	var completion = ChatGptApi.Completion.new()
	add_child(completion)
	
	#The system message determines the AIs intended role, and behavior
	completion.add_message(
		"You are a helpful assistant AI",
		ChatGptApi.Completion.CompletionMessage.CompletionMessageRole.System
	)
	
	completion.add_message(
		message,
		ChatGptApi.Completion.CompletionMessage.CompletionMessageRole.User
	)
	
	completion.on_success.connect(self.on_fetch_completion_success)
	completion.on_failure.connect(self.on_fetch_completion_error)
	completion.request()
	
func on_fetch_completion_success(response : Dictionary):
	print(response['choices'][0]['message']['content'])
```


**Properties**
| Properties                 | Type              | Default       | Summary                                                                                          |
|----------------------------|-------------------|---------------|--------------------------------------------------------------------------------------------------|
| one_shot                   | bool              | true          | Destroys request node after completion when true                                                 |
| model                      | String            | gpt-3.5-turbo | The completion model to be used.                                                                 |
| automatically_add_messages | bool              | true          | If true all messages made by the request node will be stored and resent to maintain chat history |
| headers                    | PackedStringArray | []            | Additional headers to be sent with the request                                                   |

**Callbacks**
| Callbacks            | Description                                                                                             |   |
|----------------------|---------------------------------------------------------------------------------------------------------|---|
| on_success           | Emitted on successful network call and 200 response code, provides parsed JSON of response              |   |
| on_request_completed | Emitted on completion of any network call, returns all unparsed request data for manual interpretation. |   |
| on_failure           | Emitted on failure of network call or API error, provides parsed JSON of response, and code.            |   |

### Models

Used to list the several models that can be used for text completion.

**List Example**
```GDScript
func fetch_models():
	var models : ChatGptApi.Models.List = ChatGptApi.Models.List.new()
	add_child(models)
	models.on_success.connect(self.on_fetch_models_success)
	models.on_failure.connect(self.on_fetch_models_error)
	models.request()
	
func on_fetch_models_success(response : Dictionary):
	print(response['data'])
```

Models get allows you to fetch information about a specific model

**Get Example**
```GDScript
var models : ChatGptApi.Models.Get = ChatGptApi.Models.Get.new("text-ada-001")
```

### Images 

Generates one or more images based on a prompt.

#### Generate Example
```GDScript
func generate_images():
	var image_generator = ChatGptApi.Images.Generate.new()
	add_child(image_generator)
	image_generator.prompt = "A basket full of kittens"
	image_generator.size = "256x256"
	image_generator.image_count = 2
	image_generator.on_success.connect(self.on_request_success)
	image_generator.request()
	
func on_request_success(response):
	for image_response in response['data']:
		print(image_response['url'])
```

**Properties**

| Properties  | Type   | Default | Summary                                                                        |
|-------------|--------|---------|--------------------------------------------------------------------------------|
| prompt      | String | null    | A description of the image intended to be generated.                           |
| size        | String | 256x256 | The pixel size of the generated images. (Options: 256x256, 512x512, 1024x1024) |
| image_count | int    | 1       | The number of images to be generated                                           |
| generate_textures  | bool    | false       | Automatically converts images into textures via on_generate_texture signal                                           |
| response_format  | string    | url       | The returned format of the images in the dictionary (defaults to base64 if generate_textures  is enabled)                                           |
## TODO List
* Additional error handling for failed network requests

## License

The gem is available as open source under the terms of the  [MIT License](https://opensource.org/licenses/MIT).

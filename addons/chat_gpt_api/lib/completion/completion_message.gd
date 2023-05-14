extends Object

enum CompletionMessageRole {
	System,
	User,
	Assistant
}

#Terrible Hack Please Fix
const CompletionMessageRoleNames = {
	0: 'system',
	1: 'user',
	2: 'assistant'
}

var role : CompletionMessageRole = CompletionMessageRole.System
var content : String = ""

func _init(content : String, role : CompletionMessageRole):
	self.content = content
	self.role = role
	

func to_dictionary() -> Dictionary:
	return {
		"role": CompletionMessageRoleNames[role],
		"content": content
	}

@tool
extends Node

const Request = preload("res://addons/chat_gpt_api/lib/request.gd")
const Completion = preload("res://addons/chat_gpt_api/lib/completion.gd")
const Models = preload("res://addons/chat_gpt_api/lib/models.gd")
const Images = preload("res://addons/chat_gpt_api/lib/images.gd")
var Config = preload("res://addons/chat_gpt_api/lib/config.gd").new()


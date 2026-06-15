variable "function_name" {
    type = string
}

variable "role_arn" {
    type = string
}

variable "handler" {
    type = string
}

variable "filename" {
    type = string
}

variable "dead_letter_target_arn" {
    type = string
    default = null
}
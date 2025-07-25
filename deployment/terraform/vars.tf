variable "yc_token" {
  type        = string
  description = "Yandex.Cloud token"
}
variable "yc_cloud_id" {
  type        = string
  description = "Yandex.Cloud cloud_id"
}
variable "yc_folder_id" {
  type        = string
  description = "Yandex.Cloud folder_id"
}

variable "image_id" {
  default = "fd8slqa3vkedptmcmgh7"
}

variable "platform_id" {
  default = "standard-v2"
}

variable "user_data" {
    default = "./metadata/main.yml"
}

variable "configuration_flavor" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
  }))

  default = {
    FLV_2_4_20_20 = { cores = 2, memory = 4, core_fraction = 20, disk_size = 10 } # default for all
    FLV_4_4_20_20 = { cores = 4, memory = 4, core_fraction = 20, disk_size = 10 } # zabbix server
  }
}

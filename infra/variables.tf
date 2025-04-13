# ===============
# Variables
# ===============

variable "ssh_key" {
  description = "SSH Public Key"
  type        = string
}

variable "username" {
  description = "Имя создаваемого пользователя VM"
  type        = string
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
}

variable "folder_id" {
  description = "ID каталога"
  type        = string
}

variable "vpc_name" {
  description = "Имя VPC"
  type        = string
  default     = "infra-network-kittygram"
}

variable "net_cidr" {
  description = "Настройка подсети"
  type = list(object({
    name   = string,
    zone   = string,
    prefix = string
  }))

  default = [
    { name = "infra-subnet-a", zone = "ru-central1-a", prefix = "10.129.1.0/24" },
    { name = "infra-subnet-b", zone = "ru-central1-b", prefix = "10.130.1.0/24" },
    { name = "infra-subnet-d", zone = "ru-central1-d", prefix = "10.131.1.0/24" },
  ]
}

variable "vm_1_name" {
  type    = string
  default = "vm-kittygram"
}

variable "zone" {
  description = "Зона доступности"
  default     = "ru-central1-a"
  type        = string
}

variable "platform_id" {
  description = "Стандартные платформы"     #https://yandex.cloud/ru/docs/compute/concepts/vm-platforms
  default = "standard-v1"
  type    = string
}

variable "cores" {
  description = "Количество ядер"
  default     = 2
  type        = number
}

variable "memory" {
  description = "Количество памяти"
  default     = 4
  type        = number
}

variable "image_family" {
  description = "Устанавливаемая ОС"
  default     = "ubuntu-2004-lts"
  type        = string
}

variable "disk_type" {
  description = "Тип диска для загрузочного устройства (например: 'network-hdd', 'network-ssd')"
  default     = "network-ssd"
  type        = string
}

variable "disk_size" {
  description = "Размер диска загрузочного устройства в гигабайтах (ГБ)"
  default     = 40
  type        = number
}

variable "nat" {
  description = "Включения NAT"
  default     = true
  type        = bool
}

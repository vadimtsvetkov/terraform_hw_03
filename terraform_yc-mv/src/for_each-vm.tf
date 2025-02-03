# Переменная для описания конфигураций ВМ
variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 8
      disk_volume = 50
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 4
      disk_volume = 20
    }
  ]
}

# Создание ВМ с использованием for_each
resource "yandex_compute_instance" "db" {
  for_each      = { for vm in var.each_vm : vm.vm_name => vm }
  name          = each.value.vm_name
  platform_id   = "standard-v1"
  zone          = "ru-central1-a"

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id  = "fd8aphn6s5hrmjaa3qas" # Ubuntu 20.04 LTS
      size      = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}" # Используем SSH-ключ
  }
}
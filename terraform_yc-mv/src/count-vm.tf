locals {
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

# Создание двух одинаковых ВМ (web-1 и web-2)
resource "yandex_compute_instance" "web" {
  count        = 2
  name         = "web-${count.index + 1}" # Генерация имён: web-1, web-2
  platform_id  = "standard-v1"
  zone         = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id  = "fd8aphn6s5hrmjaa3qas" # Ubuntu 20.04 LTS
      size      = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}" # Добавляем SSH-ключ для пользователя ubuntu
  }

  

  depends_on = [yandex_compute_instance.db] # Ожидаем создания ВМ из for_each-vm.tf
}
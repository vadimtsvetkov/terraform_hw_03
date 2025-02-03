resource "yandex_compute_disk" "disks" {
  count       = 3
  name        = "disk-${count.index + 1}" # Названия: disk-1, disk-2, disk-3
  zone        = "ru-central1-a"
  size        = 1                         # Размер диска в ГБ
  type        = "network-hdd"             # Тип диска
}

resource "yandex_compute_instance" "storage" {
  name         = "storage"
  platform_id  = "standard-v1"
  zone         = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8aphn6s5hrmjaa3qas" # Ubuntu 20.04 LTS
      size     = 10                     # Размер системного диска в ГБ
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id    
    nat       = true
  }

 
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks # Перебираем созданные диски
    content {
      disk_id = secondary_disk.value.id  # ID диска
    }
  }
}
# «Основы Terraform. Yandex Cloud»

## Задание 1 :monkey:



**1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.** \
**2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).** \
**3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную **vms_ssh_public_root_key**.** \

Дерево моей рабочей директории.
```Bash
terraform_hw_02/
├── authorized_key.json
├── LICENSE
├── README.md
└── terraform-yc_mv
    ├── console.tf
    ├── locals.tf
    ├── main.tf
    ├── outputs.tf
    ├── private.auto.tfvars
    ├── providers.tf
    └── variables.tf

```
Создал файл с переменными.
```private.auto.tfvars

# Yandex Cloud Oauth token
yc_token = "***"

# Yandex Cloud ID
yc_cloud_id = "***"

# Yandex Cloud folder ID
yc_folder_id = "***"

# Default Yandex Cloud Region
yc_region = "ru-central1-a"

#SSH-key для подключения к VM
vms_ssh_public_root_key = "***"
```

**4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.**

```Bash
╷
│ Error: code = FailedPrecondition desc = Platform "standart-v4" not found
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
╵
```

В файле main.tf указана platform_id = "standart-v4", такой платформы нет. Указал платформу v1.
После чего появилась другая ошибка.
```Bash
╷
│ Error: Error while requesting API to create instance: server-request-id = b4ee9d86-64eb-49b5-bec4-36beb69fac4e server-trace-id = b81918851d26816c:358b748f285084aa:b81918851d26816c:1 client-request-id = d3ec4390-f162-4098-96dd-43b355ed07e0 client-trace-id = 9ea7355b-4e3d-46d7-ab54-fcbf477374ff rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
│ 
╵
```
Изменил кол-во ядер на 2.

**5. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.**
![img.png](https://github.com/vadimtsvetkov/terraform_hw_02/blob/main/screen/ter-yc_1.png)
![img.png](https://github.com/vadimtsvetkov/terraform_hw_02/blob/main/screen/ter-yc_2.png)

**6. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ.**

Параметры ```preemptible = true``` и ```core_fraction=5``` могут быть полезны в процессе обучения по следующим причинам:

**Экономия затрат:** \
preemptible = true: Виртуальные машины с этим параметром могут быть автоматически остановлены (прерваны) при необходимости, что позволяет снизить затраты на ресурсы. 
Это особенно полезно для задач, которые не требуют постоянного доступа к ресурсам, таких как обучение моделей, где можно временно остановить работу ВМ без потери данных.

**Гибкость ресурсов:** \
core_fraction=5: Этот параметр позволяет использовать только часть ядра процессора, что снижает потребление ресурсов и затраты. Это может быть полезно для задач, которые не требуют полной мощности процессора, таких как обучение небольших моделей или выполнение простых вычислений.
### Задание 2 :monkey:

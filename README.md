# Kittygram 🐾  
Kittygram — это Instagram для кошек, который позволяет пользователям создавать профили своих любимцев, публиковать фотографии и взаимодействовать друг с другом. Проект построен на микросервисной архитектуре, использует Docker для контейнеризации, Terraform для управления инфраструктурой и GitHub Actions для CI/CD.

---

## 📋 Основная функциональность

Kittygram предоставляет пользователям:
- Возможность создать профиль их питомца.
- Публиковать фотографии и описания.
- Просматривать и взаимодействовать с профилями других пользователей.

---

## 🚀 Технологический стек

- **Backend:** API для обработки данных.
- **Frontend:** Веб-интерфейс.
- **Gateway:** Прокси на основе Nginx.
- **PostgreSQL:** Для хранения данных.
- **Terraform:** Для управления облачной инфраструктурой (Yandex Cloud).
- **GitHub Actions:** Автоматизация процессов сборки, тестирования, деплоя.
- **Docker:** Для контейнеризации всех компонентов.

---

## 🛠️ CI/CD: Сборка, тестирование и деплой

Проект использует два основных workflow в GitHub Actions:

### 1. Сборка (`build.yml`):
Запускается при каждом пуше в ветку `main`.  
Что происходит:
- **Тестирование:**
  - Backend: проверка стиля кода с помощью `flake8`, отказоустойчивости кода.
  - Frontend: запуск unit-тестов через `npm run test`.
- **Сборка и публикация образов на Docker Hub:**
  - Docker-образы backend, frontend и gateway создаются и загружаются в Docker Hub.

### 2. Деплой (`deploy.yml`):
- Запускается вручную (или при событии `repository_dispatch`).
- Процесс деплоя:
  1. Проверяется завершение работы `cloud-init` на виртуальной машине.
  2. Создаётся `.env` файл для конфигурации.
  3. Загружаются образы из Docker Hub и запускаются с помощью `docker-compose`.
  4. Выполняются миграции базы данных, сбор статических файлов и развёртывание приложения.

---

## ⚙️ Terraform: Создание облачной инфраструктуры

Проект использует Terraform для управления всеми ресурсами в Yandex Cloud.

### Список инфраструктуры:

1. **Сетевые ресурсы (VPC):**
    - **VPC (Virtual Private Cloud):** Создаётся виртуальная облачная сеть, обеспечивая изоляцию инфраструктуры.
    - **Подсети (Subnets):** Три подсети в зонах:
        - `ru-central1-a`: 10.129.1.0/24.
        - `ru-central1-b`: 10.130.1.0/24.
        - `ru-central1-d`: 10.131.1.0/24.
    - **Security Group:**
        - Входящие подключения разрешены:
            - По протоколу `TCP`, порт `22` для SSH-доступа.
            - По протоколу `TCP`, порт `80` для HTTP-запросов.
        - Исходящие подключения разрешены полностью.

2. **Виртуальная машина (VM):**
    - Создаётся виртуальная машина с характеристиками:
        - ОС: Ubuntu 20.04 LTS.
        - 2 CPU, 4 GB RAM, SSD-диск 40 GB.
    - Подключение к VPC, включение NAT.
    - Используется `cloud-init` для выполнения начальной конфигурации, создания пользователя и добавления ключей SSH.

### Обработка состояния:
- Состояние Terraform хранится в Yandex Object Storage (S3).

### Взаимодействие Terraform и CI/CD:
- Вручную запустите workflow Terraform через интерфейс GitHub Actions.
- После успешного выполнения `apply`:
    - Полученный IP адрес ВМ передаётся в деплой-процесс для автоматической настройки приложения.
    - Workflow `deploy.yml` разворачивает приложение на сервере.

---

## 🏗️ Docker Compose: Развёртывание приложений

Файл `docker-compose.production.yml` используется для управления микросервисами приложения:
- **Postgres:** Служит базой данных (версия 13-alpine).
- **Backend:** Обрабатывает запросы API (образ публикуется на Docker Hub).
- **Frontend:** Реализует пользовательский интерфейс (образ публикуется на Docker Hub).
- **Gateway (Nginx):** Прокси-сервер для обмена между frontend и backend.

---

## 📦 Инструкция по запуску

### Шаги для автоматического деплоя:

1. **Создание инфраструктуры:**
    - Запустите Terraform workflow:
        - Создаёт VPC, подсети и виртуальную машину.
        - После успешного выполнения передаёт внешний IP-адрес в следующий этап.

2. **Деплой приложения:**
    - С помощью workflow `deploy.yml`:
        - Приложение устанавливается на созданный сервер.
        - Выполняются миграции базы данных и сбор статических файлов.
        - Приложение доступно по внешнему IP-адресу сервера.


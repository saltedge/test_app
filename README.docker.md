# Docker README

## Prerequisites

#### - Install Docker Desktop


## App Setup

<details>
  <summary>1. Copy configs</summary>

  ```bash
    cp config/application.example.yml config/application.yml
    cp config/database.example.yml config/database.yml
    cp config/unicorn.example.rb config/unicorn.rb
  ```
</details>

<details>
  <summary>2. Build containers</summary>

  ```bash
    docker compose build
  ```
</details>

<details>
  <summary>3. Create/Migrate databases & seed data in the Development DB</summary>

  ```bash
    docker compose run test_app bundle exec rake db:create db:migrate db:seed
  ```

  ```bash
    docker compose run test_app bundle exec bin/rails db:migrate RAILS_ENV=test
  ```
</details>

<br>

## Running

  ```bash
    docker compose up
  ```

  - that command runs following services:
    - TestApp application (ruby v. 2.5.8 & unicorn server) -> **port:** 9009, default credentials -> **email:** `admin@example.com` & **password:** `password`
    - postgres (v. 15) - **username:** dev-user & **password:** 123456
    - redis

<br>
<br>

## How to access the Application:

<details>
  <summary>From browser</summary>

  - localhost:9009
  - 127.0.0.1:9009
</details>

<br>

## How to run:

<details>
  <summary>Rails console?</summary>

  ```bash
    docker compose run test_app bundle exec rails c
  ```
</details>

<details>
  <summary>Rails DB console?</summary>

  ```bash
    docker compose run test_app bundle exec rails dbconsole
  ```
</details>

<details>
  <summary>Rspec?</summary>

  ```bash
    docker compose run test_app bundle exec rspec
  ```
</details>

  
<details>
  <summary>Migration?</summary>

  - **development env.**
    ```bash
      docker compose run test_app bundle exec rake db:migrate
    ```
  - **test env.**
    ```bash
      docker compose run test_app bundle exec bin/rails db:migrate RAILS_ENV=test
    ```
</details>

<details>
  <summary>Migration rollback?</summary>

  - **development env.**
    ```bash
      docker compose run test_app bundle exec rake db:rollback
    ```
  - **test env.**
    ```bash
      docker compose run test_app bundle exec bin/rails db:rollback RAILS_ENV=test
    ```
</details>
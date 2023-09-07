# README

* **Ruby version:** 2.5.8

* **Rails version:** 6.1.4.1

* **PostgreSQL version:** 15

* **Configuration:** see the README.docker.md file

## Details about Application
### What is the purpose of the Application?

The main purpose of the Application is to check if a person is found in either the EU sanctions lists or the UN sanctions list. The verification process is done synchronously, using the following details about the person: Full Name, Birth Date, Citizenship & Gender. All of these details should exist in order to perform the check.
### What is the structure of DB?

The DB contains 2 tables:

- sanctionable_entities
- users

See the schema.rb file for more details.

<hr>

### Routes

### sanctions/check_persons route

**Route:** `api/v1/sanctions/check_persons`

**POST** => `localhost:9009/api/v1/sanctions/check_persons`

**Required header**: `APP_SECRET:` external_app_to_test_app_secret

All data should be wrapped in the data field.

#### Mandatory fields are:
- **list_of_persons** - array which contains objects with persons details (**Limit:** max 3 persons)

  - Mandatory fields in **person** object:
    - **fields** - object with person fields

      Possible values are: `full_name`, `date_of_birth`, `gender`, `citizenship`

      **Note:** All fields are mandatory

    - **fields_to_check** - array of strings, contains field names

      **Example:** ["full_name", "date_of_birth", "citizenship", "gender"]

- **meta** - object.
  - Mandatory fields in **meta** object:
     - **client_id** - string
     - **client_email** - string


#### Example:

<details>
  <summary>Request ></summary>

  ```json
  {
  "data": {
    "list_of_persons": [
      {
        "fields_to_check": [
          "full_name",
          "date_of_birth",
          "citizenship",
          "gender"
        ],
        "fields": {
          "full_name": "said jhan",
          "account_type": "personal",
          "date_of_birth": "1972-01-01",
          "place_of_birth": "some place of birth",
          "gender": "M",
          "residence_address": "address",
          "citizenship": "AF"
        }
      },
      {
        "fields_to_check": [
          "full_name",
          "date_of_birth",
          "citizenship",
          "gender"
        ],
        "fields": {
          "full_name": "tariq aziz",
          "account_type": "personal",
          "date_of_birth": "1936-07-01",
          "place_of_birth": "some place of birth",
          "gender": "M",
          "residence_address": "address",
          "citizenship": "IQ"
        }
      }
    ],
    "meta": {
      "client_id": "123123",
      "client_email": "client@mail.com"
    }
  }
}
  ```
</details>

<details>
  <summary>Response ></summary>

  ```json
  {
  "results_of_verification": [
    {
      "person_details": {
        "full_name": "said jhan",
        "citizenship": "AF",
        "date_of_birth": "1972-01-01",
        "gender": "M"
      },
      "detected": true,
      "sanctionable_entities": [
        {
          "id": 403
        },
        {
          "id": 4054
        }
      ]
    },
    {
      "person_details": {
        "full_name": "tariq aziz",
        "citizenship": "IQ",
        "date_of_birth": "1936-07-01",
        "gender": "M"
      },
      "detected": true,
      "sanctionable_entities": [
        {
          "id": 21
        },
        {
          "id": 3571
        }
      ]
    }
  ],
  "client_id": "123123"
}
  ```
</details>




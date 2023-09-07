Please read the Readme.md file and look how the Application works now.

Imagine the situation when the Application requirements have been changed and the following must be covered:

1. api route must accept max 100 persons
2. api request processing must remain synchronous and the processing time must not be more than 5 sec
3. add possibility to check person using the following combination of fields:
  - only by full_name
  - by full_name + birth_date
  - by full_name + birth_date + citizenship
  - by full_name + birth_date + citizenship + gender (as it is now)
4. when searching by full_name, any combination of name, surname and second name must be detected and search must be case insensitive:
  - Ex: said jhan, jhan said, Walid hAmid tawfiq, Tawfiq Walid Hamid, hamid walid Hamid

5. the process of creating/updating of a Sanctionable Entity must be simplified by using Admin pages.

6. sanctionable entities must be updated once a day, using the official sources:
  - UN Sanctions List: https://scsanctions.un.org/resources/xml/en/consolidated.xml
  - EU Sanctions List: https://webgate.ec.europa.eu/europeaid/fsd/fsf/public/files/xmlFullSanctionsList_1_1/content

Any changes in the structure of the DB and in the Application are accepted in order to achieve everything that was mentioned above.
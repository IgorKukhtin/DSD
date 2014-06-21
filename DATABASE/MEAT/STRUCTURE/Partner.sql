/*
  Создание 
    - таблицы Sale1C (промежуточная таблица продажа)
    - связей
    - индексов
*/

-- Table: Movement

-- DROP TABLE Partner;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Partner
(
KODBRANCH	TVarChar ,
NAMEBRANCH	TVarChar ,
JURIDICALNAME	TVarChar ,
OKPO	        TVarChar ,
CODETT1C	TVarChar ,
TTIN1C	TVarChar ,
INDEX	TVarChar ,
CITYTYPE	TVarChar ,
CITYNAME	TVarChar ,
REGIONTYPE	TVarChar ,
REGION	TVarChar ,
STREETTYPE	TVarChar ,
STREETNAME	TVarChar ,
HOUSE	TVarChar ,
HOUSE1	TVarChar ,
HOUSE2	TVarChar ,
HOUSE3	TVarChar ,
Kontakt1Name	  TVarChar ,
Kontakt1Tel	TVarChar ,
Kontakt1EMail	TVarChar ,
Kontakt2Name	TVarChar ,
Kontakt2Tel	TVarChar ,
Kontakt2EMail	TVarChar ,
Kontakt3Name	TVarChar ,
Kontakt3Tel	TVarChar ,
Kontakt3EMail  TVarChar,
PartnerId Integer,
PartnerOldId Integer, 
ContractOldId Integer 
)
WITH (
  OIDS=FALSE
);

ALTER TABLE Partner
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/



/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
*/

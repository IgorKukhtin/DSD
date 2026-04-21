/*
  Создание 
    - таблица Object_TT_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_TT_effie(
   Id                   BIGSERIAL NOT NULL PRIMARY KEY, 
   PartnerId            Integer   NOT NULL,
   StreetId             Integer   NOT NULL,
   PartnerTagId         Integer   NOT NULL,
   AreaId               Integer   NOT NULL,
   EDIId                Integer   NOT NULL, -- Признак 1=EDI 2=VHASNO 0-нет
   HouseNumber          TVarChar  NOT NULL,
   CaseNumber           TVarChar  NOT NULL,
   RoomNumber           TVarChar  NOT NULL,
   InsertDate           TDateTime NOT NULL,
   isErased             Boolean   NOT NULL 
);
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
-- CREATE UNIQUE INDEX idx_Object_TT_effie_StreetId_HouseNumber_CaseNumber_RoomNumber ON Object_TT_effie (StreetId, HouseNumber, CaseNumber, RoomNumber);
CREATE UNIQUE INDEX idx_Object_TT_effie_StreetId_HouseNumber_CaseNumber_RoomNumber ON Object_TT_effie (PartnerId);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.26                                        *
*/

/*
            ALTER TABLE Object_TT_effie ADD COLUMN EDIId Integer;
            UPDATE Object_TT_effie SET EDIId = 0;
            ALTER TABLE Object_TT_effie ALTER COLUMN EDIId SET NOT NULL;

            ALTER TABLE Object_TT_effie ADD COLUMN PartnerId Integer;
            UPDATE Object_TT_effie SET PartnerId = 0;
            ALTER TABLE Object_TT_effie ALTER COLUMN PartnerId SET NOT NULL;

*/
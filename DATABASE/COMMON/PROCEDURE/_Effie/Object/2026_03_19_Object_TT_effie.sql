/*
  Создание 
    - таблица Object_TT_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_TT_effie(
   Id                   BIGSERIAL NOT NULL PRIMARY KEY, 
   StreetId             Integer   NOT NULL,
   PartnerTagId         Integer   NOT NULL,
   AreaId               Integer   NOT NULL,
   HouseNumber          TVarChar  NOT NULL,
   CaseNumber           TVarChar  NOT NULL,
   RoomNumber           TVarChar  NOT NULL,
   InsertDate           TDateTime NOT NULL,
   isErased             Boolean   NOT NULL 
);
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_TT_effie_StreetId_HouseNumber_CaseNumber_RoomNumber ON Object_TT_effie (StreetId, HouseNumber, CaseNumber, RoomNumber);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.26                                        *
*/

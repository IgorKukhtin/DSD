/*
  Создание 
    - таблица Object_PriceForTwin_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PriceForTwin_effie(
   Id                   BIGSERIAL NOT NULL PRIMARY KEY, 
   clientExtID          Integer   NOT NULL,
   priceHeaderExtId     Integer   NOT NULL
);
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_PriceForTwin_effie_clientExtID_priceHeaderExtId ON Object_PriceForTwin_effie (clientExtID, priceHeaderExtId);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.26                                        *
*/

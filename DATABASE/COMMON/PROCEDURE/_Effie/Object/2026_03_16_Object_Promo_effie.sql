/*
  Создание 
    - таблица Object_Promo_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_Promo_effie(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   MovementId             Integer   NOT NULL,
   MovementItemId         Integer   NOT NULL,
   GoodsId                Integer   NOT NULL,
   GoodsKindId            Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_Promo_effie_MovementItemId_GoodsKindId ON Object_Promo_effie (MovementItemId, GoodsKindId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26                                        *
*/

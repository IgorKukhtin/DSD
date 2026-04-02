/*
  Создание 
    - таблица Object_PriceListItem_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PriceListItem_effie(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   PriceListId            Integer   NOT NULL,
   GoodsId                Integer   NOT NULL,
   GoodsKindId            Integer   NOT NULL,
   GoodsByGoodsKindId     Integer   NOT NULL,
   Price                  TFloat    NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_PriceListItem_effie_PriceListId_GoodsId_GoodsKindId ON Object_PriceListItem_effie (PriceListId, GoodsId, GoodsKindId); 
CREATE UNIQUE INDEX idx_PriceListItem_effie_PriceListId_GoodsByGoodsKindId  ON Object_PriceListItem_effie (PriceListId, GoodsByGoodsKindId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.03.26                                        *
*/
/*
            ALTER TABLE Object_PriceListItem_effie ADD COLUMN GoodsByGoodsKindId Integer;
            UPDATE Object_PriceListItem_effie SET GoodsByGoodsKindId = 0;
            ALTER TABLE Object_PriceListItem_effie ALTER COLUMN GoodsByGoodsKindId SET NOT NULL;

*/

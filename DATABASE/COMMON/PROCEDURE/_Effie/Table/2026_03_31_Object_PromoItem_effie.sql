/*
  Создание 
    - таблица Object_PromoItem_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_PromoItem_effie(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   MovementId             Integer   NOT NULL,
   MovementItemId         Integer   NOT NULL,
   StartSale              TDateTime NOT NULL,
   EndSale                TDateTime NOT NULL,
   ContractId             Integer   NOT NULL,
   PriceListId            Integer   NOT NULL,
   PartnerId              Integer   NOT NULL,
   GoodsId                Integer   NOT NULL,
   GoodsKindId            Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_PromoItem_effie_ContractId_PriceListId ON Object_PromoItem_effie (ContractId, PriceListId); 
CREATE INDEX idx_Object_PromoItem_effie_StartSale_EndSale ON Object_PromoItem_effie (StartSale, EndSale); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.03.26                                        *
*/

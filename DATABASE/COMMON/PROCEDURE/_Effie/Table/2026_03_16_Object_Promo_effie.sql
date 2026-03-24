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
   ContractId             Integer   NOT NULL,
   PartnerId              Integer   NOT NULL,
   GoodsId                Integer   NOT NULL,
   GoodsKindId            Integer   NOT NULL,
   PricePromoId           Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_Promo_effie_MovementItemId_GoodsKindId_ContractId_PartnerId ON Object_Promo_effie (MovementItemId, GoodsKindId, ContractId, PartnerId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26                                        *
*/

/*
            ALTER TABLE Object_Promo_effie ADD COLUMN PartnerId Integer;
            UPDATE Object_Promo_effie SET PartnerId = 0;
            ALTER TABLE Object_Promo_effie ALTER COLUMN PartnerId SET NOT NULL;

            ALTER TABLE Object_Promo_effie ADD COLUMN ContractId Integer;
            UPDATE Object_Promo_effie SET ContractId = 0;
            ALTER TABLE Object_Promo_effie ALTER COLUMN ContractId SET NOT NULL;
   

*/
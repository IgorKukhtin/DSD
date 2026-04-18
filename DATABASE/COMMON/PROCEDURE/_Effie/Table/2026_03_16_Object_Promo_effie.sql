/*
  Создание 
    - таблица Object_Promo_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/
-- drop table Object_Promo_effie;
-- truncate table Object_Promo_effie;
-- 
CREATE TABLE Object_Promo_effie(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   MovementId             Integer   NOT NULL,
   PartnerId              Integer   NOT NULL,
   ContractId             Integer   NOT NULL,
   PriceListId            Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_Promo_effie_MovementId_ContractId_PriceListId ON Object_Promo_effie (MovementId, PartnerId, ContractId, PriceListId); 
CREATE UNIQUE INDEX idx_Object_Promo_effie_ContractId_PriceListId_MovementId ON Object_Promo_effie (ContractId, PartnerId, PriceListId, MovementId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26                                        *
*/

/*
            ALTER TABLE Object_Promo_effie ADD COLUMN MovementId Integer;
            UPDATE Object_Promo_effie SET MovementId = 0;
            ALTER TABLE Object_Promo_effie ALTER COLUMN MovementId SET NOT NULL;

            ALTER TABLE Object_Promo_effie ADD COLUMN ContractId Integer;
            UPDATE Object_Promo_effie SET ContractId = 0;
            ALTER TABLE Object_Promo_effie ALTER COLUMN ContractId SET NOT NULL;
   
            ALTER TABLE Object_Promo_effie ADD COLUMN PriceListId Integer;
            UPDATE Object_Promo_effie SET PriceListId = 0;
            ALTER TABLE Object_Promo_effie ALTER COLUMN PriceListId SET NOT NULL;


*/

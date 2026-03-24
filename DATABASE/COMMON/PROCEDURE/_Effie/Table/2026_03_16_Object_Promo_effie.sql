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
   ContractId             Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_Promo_effie_MovementId_ContractId ON Object_Promo_effie (MovementId, ContractId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26                                        *
*/

/*
            ALTER TABLE Object_Promo_effie ADD COLUMN MovementId Integer;
            UPDATE Object_Promo_effie SET MovementId = 0;
            ALTER TABLE Object_Promo_effie ALTER COLUMN MovementIdSET NOT NULL;

            ALTER TABLE Object_Promo_effie ADD COLUMN ContractId Integer;
            UPDATE Object_Promo_effie SET ContractId = 0;
            ALTER TABLE Object_Promo_effie ALTER COLUMN ContractId SET NOT NULL;
   

*/
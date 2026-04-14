/*
  Создание 
    - таблица Object_ClientBalance_effie(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_ClientBalance_effie(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   PartnerId              Integer   NOT NULL,
   ContractId             Integer   NOT NULL,
   PaidKindId             Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
  );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_Object_ClientBalance_effie_PartnerId_ContractId_PaidKindId ON Object_ClientBalance_effie (PartnerId, ContractId, PaidKindId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.26                                        *
*/

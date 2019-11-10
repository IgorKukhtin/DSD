/*
  Создание 
    - таблицы HistoryCost_err - сохранили айди, потом проводим руками
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE HistoryCost_err(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   InsertDate            TDateTime NOT NULL,
   MovementId            Integer   NOT NULL
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_HistoryCost_err_InsertDate ON HistoryCost_err(InsertDate);
CREATE INDEX idx_HistoryCost_err_MovementId ON HistoryCost_err(MovementId);

/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 05.11.19             *
*/

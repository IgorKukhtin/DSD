/*
  Создание 
    - таблицы ObjectPrint(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectPrint(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY,
   ObjectId               Integer   NOT NULL,
   UserId                 Integer   NOT NULL,
   Amount                 Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_ObjectPrint_InsertDate_UserId ON ObjectPrint (InsertDate, UserId);
CREATE UNIQUE INDEX idx_ObjectPrint_GoodsId_UnitId_InsertDate ON ObjectPrint (ObjectId, InsertDate); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.20         *
*/

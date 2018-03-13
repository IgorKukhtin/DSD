/*
  Создание 
    - таблицы Object_GoodsPrint(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_GoodsPrint(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   PartionId              Integer   NOT NULL,
   UnitId                 Integer   NOT NULL,
   UserId                 Integer   NOT NULL,
   Amount                 TFloat    NOT NULL,
   isReprice              Boolean   NOT NULL, 
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_GoodsPrint_InsertDate_UserId ON Object_GoodsPrint (InsertDate, UserId);
CREATE UNIQUE INDEX idx_Object_GoodsPrint_PartionId_UnitId_InsertDate ON Object_GoodsPrint (PartionId, UnitId, InsertDate); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.17                                        *
*/

/*
  Создание 
    - таблицы Object_GoodsPrint(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_GoodsPrint(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY,
   UnitId                 Integer   NOT NULL,
   GoodsId                Integer   NOT NULL,
   UserId                 Integer   NOT NULL,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_GoodsPrint_InsertDate_UserId ON Object_GoodsPrint (InsertDate, UserId);
CREATE UNIQUE INDEX idx_Object_GoodsPrint_GoodsId_UnitId_InsertDate ON Object_GoodsPrint (GoodsId, UnitId, InsertDate); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.19         *
*/

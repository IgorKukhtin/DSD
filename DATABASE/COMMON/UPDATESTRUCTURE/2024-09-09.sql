/*
  Создание 
    - таблицы Object_Print(oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_Print(
   Id                     BIGSERIAL NOT NULL PRIMARY KEY, 
   ObjectId               Integer   NOT NULL,
   ReportKindId           Integer   NOT NULL,
   UserId                 Integer   NOT NULL,
   Value                  TFloat,
   ValueDate              TDateTime,
   InsertDate             TDateTime NOT NULL 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_Print_UserId ON Object_Print (UserId);
CREATE UNIQUE INDEX idx_Object_Print_ObjectId_ReportKindId_UserId ON Object_Print (ObjectId, ReportKindId, UserId); 

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.24                                        *
*/

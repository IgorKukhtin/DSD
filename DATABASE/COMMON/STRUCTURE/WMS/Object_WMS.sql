/*
  Создание 
    - таблицы Object_WMS
    - связей
    - индексов
*/

-- DROP TABLE Object_WMS

/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_WMS(
   Id                    BIGSERIAL NOT NULL PRIMARY KEY, 
   GUID                  TVarChar  NOT NULL,
   ProcName              TVarChar  NOT NULL,
   TagName               TVarChar  NOT NULL,
   ActionName            TVarChar  NOT NULL,
   RowNum                Integer   NOT NULL,
   RowData               Text      NOT NULL,
   ObjectId              Integer   NOT NULL,
   GroupId               Integer   NOT NULL
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_WMS_ProcName      ON Object_WMS (ProcName);
CREATE INDEX idx_Object_WMS_TagName       ON Object_WMS (TagName);
CREATE INDEX idx_Object_WMS_GUID          ON Object_WMS (GUID);
CREATE INDEX idx_Object_WMS_GUID_ProcName ON Object_WMS (GUID, ProcName);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                       *
*/

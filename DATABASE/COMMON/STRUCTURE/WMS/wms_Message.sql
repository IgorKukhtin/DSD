/*
  Создание 
    - таблицы wms_Message
    - связей
    - индексов
*/

-- DROP TABLE wms_Message

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_Message(
   Id                    BIGSERIAL NOT NULL PRIMARY KEY, 
   GUID                  TVarChar  NOT NULL,
   ProcName              TVarChar  NOT NULL,
   TagName               TVarChar  NOT NULL,
   ActionName            TVarChar  NOT NULL,
   RowNum                Integer   NOT NULL,
   RowData               Text      NOT NULL,
   ObjectId              Integer   NOT NULL,
   GroupId               Integer   NOT NULL,
   InsertDate            TDateTime NOT NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE INDEX idx_wms_Message_InsertDate    ON wms_Message (InsertDate);
CREATE INDEX idx_wms_Message_ProcName      ON wms_Message (ProcName);
CREATE INDEX idx_wms_Message_TagName       ON wms_Message (TagName);
CREATE INDEX idx_wms_Message_GUID          ON wms_Message (GUID);
CREATE INDEX idx_wms_Message_GUID_ProcName ON wms_Message (GUID, ProcName);
CREATE INDEX idx_wms_Message_GUID_ObjectId ON wms_Message (GUID, ObjectId);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                       *
*/

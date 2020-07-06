/*
  Создание 
    - таблицы wms_toHostDetail
    - связей
    - индексов
*/

-- DROP TABLE wms_toHostDetail

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_toHostDetail(
   Id                 BIGSERIAL NOT NULL PRIMARY KEY, 
   wID                BIGSERIAL NOT NULL, 
   wHEADER_ID         BIGSERIAL NOT NULL, 
   wTYPE              TVarChar  NOT NULL,
   wACTION            TVarChar  NOT NULL,
   wCREATED           TDateTime NOT NULL,
   wSTATUS            TVarChar  NOT NULL,
-- wSTART_DATE        TDateTime NOT NULL,
-- wFINISH_DATE       TDateTime     NULL,
   wMESSAGE           Text      NOT NULL,
-- wERR_CODE          Integer   NOT NULL,
-- wERR_DESCR         TVarChar  NOT NULL,
   InsertDate         TDateTime NOT NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_wms_toHostDetail_wID          ON wms_toHostDetail (wID);
CREATE        INDEX idx_wms_toHostDetail_wHEADER_ID   ON wms_toHostDetail (wHEADER_ID);
CREATE        INDEX idx_wms_toHostDetail_InsertDate   ON wms_toHostDetail (InsertDate);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.19                                       *
*/

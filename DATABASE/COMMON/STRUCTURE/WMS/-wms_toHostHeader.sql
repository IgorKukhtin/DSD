/*
  Создание 
    - таблицы wms_toHostHeader
    - связей
    - индексов
*/

-- DROP TABLE wms_toHostHeader

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_toHostHeader(
   Id                 BIGSERIAL NOT NULL PRIMARY KEY, 
   wID                BIGSERIAL NOT NULL, 
   wTYPE              TVarChar  NOT NULL,
   wACTION            TVarChar  NOT NULL,
   wCREATED           TDateTime NOT NULL,
   wSTATUS            TVarChar  NOT NULL,
   wSTART_DATE        TDateTime NOT NULL,
   wFINISH_DATE       TDateTime     NULL,
   wMESSAGE           Text      NOT NULL,
   wERR_CODE          Integer   NOT NULL,
   wERR_DESCR         TVarChar  NOT NULL,
   InsertDate         TDateTime NOT NULL
   );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_wms_toHostHeader_wID          ON wms_toHostHeader (wID);
CREATE        INDEX idx_wms_toHostHeader_wSTART_DATE  ON wms_toHostHeader (wSTART_DATE);
CREATE        INDEX idx_wms_toHostHeader_wFINISH_DATE ON wms_toHostHeader (wFINISH_DATE);
CREATE        INDEX idx_wms_toHostHeader_InsertDate   ON wms_toHostHeader (InsertDate);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.19                                       *
*/

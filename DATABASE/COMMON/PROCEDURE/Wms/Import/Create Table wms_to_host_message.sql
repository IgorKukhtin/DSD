/*
  Создание 
    - таблицы wms_to_host_message
    - связей
    - индексов
*/

-- DROP TABLE wms_to_host_message;


/*-------------------------------------------------------------------------------*/
CREATE TABLE wms_to_host_message
    (
    Id               SERIAL   NOT NULL PRIMARY KEY,
    Type             TVarChar NOT NULL,   -- значение to_host_header_message.Type
    Header_Id        Integer  NOT NULL,
    Detail_Id        Integer  NOT NULL,
    MovementId       Integer,            -- order_id -> Movement.id или <receiving_result.inc_id> -> wms_MI_Incoming.id 
    Sku_Id           Integer,            -- уникальный код товара
    Name             TVarChar,           -- имя груза 
    Qty              TFloat,
    Weight           TFloat,
    Weight_biz       TFloat,
    Production_Date  TDateTime,
    OperDate         TDateTime,          -- Дата, время когда документ проведен в WMS, т.е. в oracle это from_host_header_message.CREATED
    InsertDate       TDateTime DEFAULT CLOCK_TIMESTAMP(),
    Done             Boolean   DEFAULT FALSE
);

/*-------------------------------------------------------------------------------*/

--                                  Индексы
CREATE INDEX idx_wms_to_host_message_MovementId ON wms_to_host_message (MovementId);
CREATE INDEX idx_wms_to_host_message_Type       ON wms_to_host_message (Type);
CREATE INDEX idx_wms_to_host_message_Done       ON wms_to_host_message (Done);

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Скородумов С.
 04.06.20                                        *
 03.06.20                                                          *
*/

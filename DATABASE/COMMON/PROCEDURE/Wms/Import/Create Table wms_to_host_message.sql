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
    Header_Id        Integer  NOT NULL,   -- шапка в Oracle
    Detail_Id        Integer  NOT NULL,   -- строчная часть в Oracle
    MovementId       Integer,             -- какой-то наш Id: order_id -> Movement.Id или <receiving_result.inc_id> -> wms_MI_Incoming.Id
    Sku_Id           Integer,             -- уникальный код товара
    Name             TVarChar,            -- имя груза
    Qty              TFloat,              -- Кол-во, используется только когда Шт
    Weight           TFloat,              -- Вес, используется только когда НЕ Шт
    Weight_biz       TFloat,              -- Вес с бизербы - подставим в кол-во у Покупателя
    Production_Date  TDateTime,           -- дата партии
    OperDate         TDateTime,           -- Дата, время когда документ проведен в WMS, т.е. в Oracle это from_host_header_message.CREATED
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

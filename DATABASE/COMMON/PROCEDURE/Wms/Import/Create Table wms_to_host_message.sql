CREATE TABLE wms_to_host_message
    (
    id               SERIAL NOT NULL PRIMARY KEY,
    type             TVarChar NOT NULL,   -- значение to_host_header_message.Type, например 'receiving_result'
    header_id        integer  NOT NULL,
    detail_id        integer  NOT NULL,
    movement_id      integer,  -- order_id -> Movement.id или <receiving_result.inc_id> -> wms_MI_Incoming.id 
    sku_id           integer, -- уникальный код товара
    name             TVarChar, -- имя груза 
    qty              numeric,
    weight           numeric,
    weight_biz       numeric,
    production_date  TDateTime,
	operdate         TDateTime,
    insertDate       TDateTime DEFAULT clock_timestamp(),
	done             boolean DEFAULT false
);
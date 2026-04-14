-- Function: gpInsert_Movement_Orders_effie

DROP FUNCTION IF EXISTS gpInsert_Movement_Orders_effie (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Orders_effie(
    IN inExtId    TVarChar,   --
    IN inSession  TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- Результат
     CREATE TEMP TABLE _tmpItem ON COMMIT DROP AS
     WITH _tmpresult AS (SELECT gpSelect.extId                -- Идентификатор заказа
                              , gpSelect.clientExtId          -- Идентификатор контрагента, по которому сделан заказ
                              , gpSelect.clientName           -- Название контрагента
                              , gpSelect.employeeExtId        -- Идентификатор сотрудника, сделавшего заказ
                              , gpSelect.employeeName         -- ФИО сотрудника
                              , gpSelect.createDate_ch        -- Дата и время создания документа на мобильном устройстве
                              , gpSelect.dbCreateDate_ch      -- Дата и время (в UTC) записи документа в БД Effie
                              , gpSelect.priceHeaderExtId     -- Идентификатор прайса
                              , gpSelect.priceHeaderName      -- Название прайса
                              , gpSelect.contractHeaderExtId  -- Идентификатор контракта
                              , gpSelect.comments             -- Комментарии
                              , gpSelect.orderForm            -- W - 1 Форма, B - 2 форма
                              , gpSelect.warehouseExtId       -- Идентификатор склада
                              , gpSelect.warehouseName        -- Название склада

                              , gpSelect.productExtId         -- Идентификатор товара
                              , gpSelect.productName          -- Название товара
                              , gpSelect.quantity             -- Количество товара
                              , gpSelect.price                -- Цена за единицу товара с учетом всех скидок

                         FROM dblink ('host=192.168.251.33 dbname=effie_api port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                    , ('SELECT Orders.extId                ::TVarChar
                                             , Orders.clientExtId          ::Integer
                                             , Orders.clientName           ::TVarChar
                                             , Orders.employeeExtId        ::Integer
                                             , Orders.employeeName         ::TVarChar
                                             , Orders.createDate_ch        ::TDateTime
                                             , Orders.dbCreateDate_ch      ::TDateTime
                                             , Orders.priceHeaderExtId     ::Integer
                                             , Orders.priceHeaderName      ::TVarChar
                                             , Orders.contractHeaderExtId  ::Integer
                                             , Orders.comments	           ::TVarChar
                                             , Orders.orderForm            ::TVarChar
                                             , Orders.warehouseExtId       ::Integer
                                             , Orders.warehouseName        ::TVarChar

                                             , orders_items.productExtId   ::Integer    -- Идентификатор товара
                                             , orders_items.productName    ::TVarChar   -- Название товара
                                             , orders_items.quantity       ::TFloat     -- Количество товара
                                             , orders_items.price          ::TFloat     -- Цена за единицу товара с учетом всех скидок

                                       FROM Orders
                                            JOIN orders_items ON orders_items.orderextId = Orders.extId
                                       WHERE Orders.extId = ' || CHR (39) || inExtId || CHR (39)
                                       ) :: Text
                                     ) AS gpSelect (extId                TVarChar   -- Идентификатор заказа
                                                  , clientExtId          Integer    -- Идентификатор контрагента, по которому сделан заказ
                                                  , clientName           TVarChar   -- Название контрагента
                                                  , employeeExtId        Integer    -- Идентификатор сотрудника, сделавшего заказ
                                                  , employeeName         TVarChar   -- ФИО сотрудника
                                                  , createDate_ch        TDateTime  -- Дата и время создания документа на мобильном устройстве
                                                  , dbCreateDate_ch      TDateTime  -- Дата и время (в UTC) записи документа в БД Effie
                                                  , priceHeaderExtId     Integer    -- Идентификатор прайса
                                                  , priceHeaderName      TVarChar   -- Название прайса
                                                  , contractHeaderExtId  Integer    -- Идентификатор контракта
                                                  , comments             TVarChar   -- Комментарии
                                                  , orderForm            TVarChar   -- W - 1 Форма, B - 2 форма
                                                  , warehouseExtId       Integer    -- Идентификатор склада
                                                  , warehouseName        TVarChar   -- Название склада

                                                  , productExtId          Integer    -- Идентификатор товара
                                                  , productName           TVarChar   -- Название товара
                                                  , quantity              TFloat     -- Количество товара
                                                  , price                 TFloat     -- Цена за единицу товара с учетом всех скидок
                                                   )
                        )
     --
     SELECT Orders.extId                ::TVarChar   -- Идентификатор заказа
          , Orders.clientExtId          ::Integer    -- Идентификатор контрагента, по которому сделан заказ
          , Orders.clientName           ::TVarChar   -- Название контрагента
          , Orders.employeeExtId        ::Integer    -- Идентификатор сотрудника, сделавшего заказ
          , Orders.employeeName         ::TVarChar   -- ФИО сотрудника
          , Orders.createDate_ch        ::TDateTime  -- Дата и время создания документа на мобильном устройстве
          , Orders.dbCreateDate_ch      ::TDateTime  -- Дата и время (в UTC) записи документа в БД Effie
          , Orders.priceHeaderExtId     ::Integer    -- Идентификатор прайса
          , Orders.priceHeaderName      ::TVarChar   -- Название прайса
          , Orders.contractHeaderExtId  ::Integer    -- Идентификатор контракта
          , Orders.comments	        ::TVarChar   -- Комментарии
          , Orders.orderForm            ::TVarChar   -- W - 1 Форма, B - 2 форма
          , Orders.warehouseExtId       ::Integer    -- Идентификатор склада
          , Orders.warehouseName        ::TVarChar   -- Название склада

          , Orders.productExtId         ::Integer    -- Идентификатор товара
          , Orders.productName          ::TVarChar   -- Название товара
          , Orders.quantity             ::TFloat     -- Количество товара
          , Orders.price                ::TFloat     -- Цена за единицу товара с учетом всех скидок

     FROM _tmpresult AS Orders
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.26                                        *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Orders_effie ('123', zfCalc_UserAdmin()::TVarChar);

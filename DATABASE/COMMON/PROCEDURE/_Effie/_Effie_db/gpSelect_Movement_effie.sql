-- Function: gpSelect_Movement_Orders_effie

DROP FUNCTION IF EXISTS gpSelect_Movement_Orders (TDateTime, TDateTime);
DROP FUNCTION IF EXISTS gpSelect_Movement_Orders_effie (TDateTime, TDateTime);
DROP FUNCTION IF EXISTS gpSelect_Movement_Orders_effie (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_effie (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_effie(
    IN inStartDate     TDateTime,   --
    IN inEndDate       TDateTime,   --
    IN inSession       TVarChar     -- сессия пользователя
)
RETURNS TABLE (extId                      TVarChar   -- Идентификатор заказа
             , clientExtId                Integer    -- Идентификатор контрагента, по которому сделан заказ
             , clientName                 TVarChar   -- Название контрагента
             , employeeExtId              Integer    -- Идентификатор сотрудника, сделавшего заказ
             , employeeName               TVarChar   -- ФИО сотрудника
             , createDate_ch	          TDateTime  -- Дата и время создания документа на мобильном устройстве
             , dbCreateDate_ch	          TDateTime  -- Дата и время (в UTC) записи документа в БД Effie
             , priceHeaderExtId	          Integer    -- Идентификатор прайса
             , priceHeaderName	          TVarChar   -- Название прайса
             , contractHeaderExtId        Integer    -- Идентификатор контракта
             , comments	                  TVarChar   -- Комментарии
             , orderForm                  TVarChar   -- W - 1 Форма, B - 2 форма
             , warehouseExtId             Integer    -- Идентификатор склада
             , warehouseName              TVarChar   -- Название склада
             , MovementDescId             Integer    -- 

           --, productExtId               Integer    -- Идентификатор товара
           --, productName                TVarChar   -- Название товара
           --, quantity	                  TFloat     -- Количество товара
           --, price	                  TFloat     -- Цена за единицу товара с учетом всех скидок
) AS

$BODY$
   DECLARE vb1 Boolean;
BEGIN
     -- Дата и время создания документа на мобильном устройстве
     vb1:= (SELECT gpSelect.Res
            FROM dblink ('host=192.168.251.33 dbname=effie_api port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                 , ('SELECT Res 
                                    FROM gpUpdatet_Movement_Orders()'
                                    ) :: Text
                                  ) AS gpSelect (Res Boolean)
           );


     -- Результат
     RETURN QUERY
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
                                       FROM Orders
                                       WHERE Orders.OperDate_get IS NULL'
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
          
          , zc_Movement_OrderExternal() :: Integer AS MovementDescId

        /*, orders_items.productExtId   ::Integer    -- Идентификатор товара
          , orders_items.productName    ::TVarChar   -- Название товара
          , orders_items.quantity	::TFloat     -- Количество товара
          , orders_items.price	        ::TFloat     -- Цена за единицу товара с учетом всех скидок
          */

     FROM _tmpresult AS Orders
          -- JOIN orders_items ON orders_items.orderextId = Orders.extId
     -- WHERE Orders.createDate_ch >= inStartDate - INTERVAL '1 DAY' AND Orders.createDate_ch < inEndDate + INTERVAL '1 DAY'
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
-- SELECT * FROM gpSelect_Movement_effie ('01.03.2026', '01.04.2026', zfCalc_UserAdmin()::TVarChar);

-- Function: gpInsert_Movement_Orders_effie

DROP FUNCTION IF EXISTS gpInsert_Movement_effie (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_effie(
    IN inExtId           TVarChar,   --
    IN inMovementDescId  Integer,    --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Не загружаем второй раз!!!!
     IF EXISTS (SELECT MovementString_GUID.MovementId
                FROM MovementString AS MovementString_GUID
                     JOIN Movement ON Movement.Id       = MovementString_GUID.MovementId
                                  AND Movement.DescId   = inMovementDescId
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                WHERE MovementString_GUID.DescId    = zc_MovementString_GUID()
                  AND MovementString_GUID.ValueData = inExtId
               )
      --AND inExtId <> '4525cbaa-c5c1-41b9-850c-7302822edde1' --  34072184
     THEN
         -- !!!ВЫХОД!!!!
         RETURN;
     END IF;


     IF inMovementDescId = zc_Movement_OrderExternal()
     THEN
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
         -- Результат
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

              , 0                           :: Integer AS MovementItemId -- -- сформируем позже

         FROM _tmpresult AS Orders
        ;


         -- Документ
         vbMovementId:= (WITH tmpParams AS (SELECT DISTINCT
                                                   _tmpItem.extId                   AS GUID          -- Идентификатор заказа
                                                 , _tmpItem.clientExtId             AS PartnerId     -- Идентификатор контрагента, по которому сделан заказ
                                                 , _tmpItem.employeeExtId           AS MemberId      -- Идентификатор сотрудника, сделавшего заказ
                                                 , _tmpItem.createDate_ch           AS InsertMobile  -- Дата и время создания документа на мобильном устройстве
                                                 , _tmpItem.dbCreateDate_ch         AS UpdateMobile  -- Дата и время (в UTC) записи документа в БД Effie
                                                 , _tmpItem.priceHeaderExtId        AS PriceListId
                                                 , _tmpItem.contractHeaderExtId     AS ContractId
                                                 , _tmpItem.comments	               AS Comments
                                                 , CASE WHEN _tmpItem.orderForm ILIKE 'W' THEN zc_Enum_PaidKind_FirstForm() ELSE zc_Enum_PaidKind_SecondForm() END AS PaidKindId
                                                 , _tmpItem.warehouseExtId          AS UnitId
                                            FROM _tmpItem
                                           )
                         SELECT gpInsertUpdateMobile_Movement_OrderExternal(inGUID                := tmpParams.GUID
                                                                          , inInvNumber           := CAST (NEXTVAL ('movement_orderexternal_seq') AS TVarChar)
                                                                          , inOperDate            := DATE_TRUNC ('DAY', tmpParams.InsertMobile)
                                                                          , inComment             := tmpParams.Comments
                                                                          , inPartnerId           := tmpParams.PartnerId
                                                                          , inUnitId              := tmpParams.UnitId
                                                                        --, inPaidKindId          := tmpParams.PaidKindId
                                                                          , inPaidKindId          := (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = tmpParams.ContractId AND OL.DescId = zc_ObjectLink_Contract_PaidKind())
                                                                          , inContractId          := tmpParams.ContractId
                                                                          , inPriceListId         := tmpParams.PriceListId
                                                                          , inPriceWithVAT        := COALESCE ((SELECT OB.ValueData FROM ObjectBoolean AS OB WHERE OB.ObjectId = tmpParams.PriceListId AND OB.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()), FALSE) :: Boolean
                                                                          , inVATPercent          := COALESCE ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = tmpParams.PriceListId AND OFl.DescId = zc_ObjectFloat_PriceList_VATPercent()), 20) :: TFloat
                                                                          , inChangePercent       := COALESCE ((SELECT Object_Contract_View.ChangePercent FROM Object_Contract_View WHERE Object_Contract_View.ContractId = tmpParams.ContractId), 0) :: TFloat
                                                                          , inInsertDate          := tmpParams.InsertMobile
                                                                          , inSession             := (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.ChildObjectId = tmpParams.MemberId AND OL.DescId = zc_ObjectLink_User_Member()) :: TVarChar
                                                                           )
                        FROM tmpParams
                       );



         -- Строки Документа
         UPDATE _tmpItem SET MovementItemId = gpInsertUpdateMobileEffie_MI_OrderExternal
                                                                (inGUID                := _tmpItem.productExtId :: TVarChar
                                                               , inMovementGUID        := _tmpItem.extId
                                                               , inGoodsId             := ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                               , inGoodsKindId         := ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
                                                               , inChangePercent       := 0
                                                               , inAmount              := _tmpItem.quantity
                                                               , inPrice               := 0 -- _tmpItem.price
                                                               , inSession             := (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.ChildObjectId = _tmpItem.employeeExtId AND OL.DescId = zc_ObjectLink_User_Member()) :: TVarChar
                                                                )
         FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
              LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
         WHERE ObjectLink_GoodsByGoodsKind_Goods.ObjectId = _tmpItem.productExtId
           AND ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
        ;

        -- сохранили свойство <Цена из Effie>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceEffie(), _tmpItem.MovementItemId, _tmpItem.price / 1.2)
        FROM _tmpItem
       ;

        PERFORM gpSetMobileErased_Movement_OrderExternal (inMovementGUID:= (SELECT DISTINCT _tmpItem.extId FROM _tmpItem)
                                                        , inSession     := (SELECT DISTINCT OL.ObjectId FROM ObjectLink AS OL JOIN _tmpItem ON _tmpItem.employeeExtId = OL.ChildObjectId WHERE OL.DescId = zc_ObjectLink_User_Member()) :: TVarChar
                                                         );

     END IF;


     IF inMovementDescId IN (zc_Movement_OrderExternal())
     THEN
        -- сохранили свойство <Effie (да)>
        PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Effie(), vbMovementId, TRUE);
    
        -- сохранили свойство <Дата/время создания заказа на мобильном устройстве>
        PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbMovementId, (SELECT DISTINCT _tmpItem.createDate_ch FROM _tmpItem));
        -- сохранили свойство <Дата/время создания заказа на мобильном устройстве>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, (SELECT DISTINCT _tmpItem.dbCreateDate_ch FROM _tmpItem));
     END IF;

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
-- SELECT * FROM gpInsert_Movement_effie ('827150cf-c288-40bf-bd19-5d16b4780683', zc_Movement_OrderExternal(), zfCalc_UserAdmin()::TVarChar);

-- Function: gpInsert_Movement_ReturnIn_effie

DROP FUNCTION IF EXISTS gpInsert_Movement_ReturnIn_effie (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_ReturnIn_effie(
    IN inExtId    TVarChar,   --
    IN inSession  TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbMovementId   Integer;
   DECLARE vbContractId   Integer;
   DECLARE vbUnitId       Integer;
   DECLARE vbPartnerId    Integer;
   DECLARE vbPaidKindId   Integer;
   DECLARE vbSubjectDocId Integer;
BEGIN

     -- Результат
     CREATE TEMP TABLE _tmpItem ON COMMIT DROP AS
     WITH _tmpresult AS (SELECT gpSelect.extId                -- Идентификатор документа возврат
                              , gpSelect.clientExtId          -- Идентификатор контрагента
                              , gpSelect.clientName           -- Название контрагента
                              , gpSelect.employeeExtId        -- Идентификатор сотрудника
                              , gpSelect.employeeName         -- ФИО сотрудника
                              , gpSelect.createDate_ch        -- Дата и время создания документа на мобильном устройстве
                              , gpSelect.dbCreateDate_ch      -- Дата и время (в UTC) записи документа в БД Effie
                              , gpSelect.comments             -- Комментарии
                              , gpSelect.documentform         -- W - 1 Форма, B - 2 форма

                              , gpSelect.productExtId         -- Идентификатор товара
                              , gpSelect.productName          -- Название товара
                              , gpSelect.quantity             -- Количество товара
                              , gpSelect.reasonId             -- Идентификатор причины возврата
                              , gpSelect.reasonName           -- Причина возврата

                         FROM dblink ('host=192.168.251.33 dbname=effie_api port=5432 user=project password=sqoII5szOnrcZxJVF1BL'::text
                                    , ('SELECT order_returns.extId                ::TVarChar
                                             , order_returns.clientExtId          ::Integer
                                             , order_returns.clientName           ::TVarChar
                                             , order_returns.employeeExtId        ::Integer
                                             , order_returns.employeeName         ::TVarChar
                                             , order_returns.createDate_ch        ::TDateTime
                                             , order_returns.dbCreateDate_ch      ::TDateTime
                                             , order_returns.comments	          ::TVarChar
                                             , order_returns.documentform         ::TVarChar

                                             , order_returns_items.productExtId   ::Integer    -- Идентификатор товара
                                             , order_returns_items.productName    ::TVarChar   -- Название товара
                                             , order_returns_items.quantity       ::TFloat     -- Количество товара
                                             , order_returns_items.reasonid       ::Integer
                                             , order_returns_items.reasonname     ::TVarChar

                                       FROM order_returns
                                            JOIN order_returns_items ON order_returns_items.orderextId = order_returns.extId
                                       WHERE order_returns.extId = ' || CHR (39) || inExtId || CHR (39)
                                       ) :: Text
                                     ) AS gpSelect (extId                TVarChar   -- Идентификатор заказа
                                                  , clientExtId          Integer    -- Идентификатор контрагента, по которому сделан заказ
                                                  , clientName           TVarChar   -- Название контрагента
                                                  , employeeExtId        Integer    -- Идентификатор сотрудника, сделавшего заказ
                                                  , employeeName         TVarChar   -- ФИО сотрудника
                                                  , createDate_ch        TDateTime  -- Дата и время создания документа на мобильном устройстве
                                                  , dbCreateDate_ch      TDateTime  -- Дата и время (в UTC) записи документа в БД Effie
                                                  , comments             TVarChar   -- Комментарии
                                                  , documentform         TVarChar   -- W - 1 Форма, B - 2 форма

                                                  , productExtId          Integer    -- Идентификатор товара
                                                  , productName           TVarChar   -- Название товара
                                                  , quantity              TFloat     -- Количество товара
                                                  , reasonId              Integer
                                                  , reasonName            TVarChar
                                                   )
                        )
     -- Результат
     SELECT order_returns.extId                ::TVarChar   -- Идентификатор заказа
          , order_returns.clientExtId          ::Integer    -- Идентификатор контрагента, по которому сделан заказ
          , order_returns.clientName           ::TVarChar   -- Название контрагента
          , order_returns.employeeExtId        ::Integer    -- Идентификатор сотрудника, сделавшего заказ
          , order_returns.employeeName         ::TVarChar   -- ФИО сотрудника
          , order_returns.createDate_ch        ::TDateTime  -- Дата и время создания документа на мобильном устройстве
          , order_returns.dbCreateDate_ch      ::TDateTime  -- Дата и время (в UTC) записи документа в БД Effie
          , order_returns.comments	       ::TVarChar   -- Комментарии
          , order_returns.documentform         ::TVarChar   -- W - 1 Форма, B - 2 форма

          , order_returns.productExtId         ::Integer    -- Идентификатор товара
          , order_returns.productName          ::TVarChar   -- Название товара
          , order_returns.quantity             ::TFloat     -- Количество товара
          , order_returns.reasonId             ::Integer    -- Идентификатор причины возврата
          , order_returns.reasonName           ::TVarChar   -- Причина возврата

          , 0                                  ::Integer AS MovementItemId -- -- сформируем позже

          , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     AS GoodsId
          , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId AS GoodsKindId

          , (SELECT MAX (OL.ObjectId) FROM ObjectLink AS OL WHERE OL.ChildObjectId = order_returns.employeeExtId AND OL.DescId = zc_ObjectLink_User_Member()) :: Integer AS UserId

--          , COALESCE((SELECT MAX (Object.Id) FROM Object WHERE Object.ValueData ILIKE order_returns.reasonName AND Object.DescId = zc_Object_SubjectDoc() AND Object.isErased = FALSE)
--                   , (SELECT MAX (Object.Id) FROM Object WHERE Object.ValueData ILIKE order_returns.reasonName AND Object.DescId = zc_Object_SubjectDoc() AND Object.isErased = TRUE)
--                    ) :: Integer AS SubjectDocId
          , COALESCE((SELECT MAX (Object.Id) FROM Object WHERE Object.ObjectCode = order_returns.reasonId AND Object.DescId = zc_Object_SubjectDoc() AND Object.isErased = FALSE)
                   , (SELECT MAX (Object.Id) FROM Object WHERE Object.ObjectCode = order_returns.reasonId AND Object.DescId = zc_Object_SubjectDoc() AND Object.isErased = TRUE)
                    ) :: Integer AS SubjectDocId


     FROM _tmpresult AS order_returns
          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                               ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = order_returns.productExtId
                              AND ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
          LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                               ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                              AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
    ;

    -- Поиск
    vbUserId:= (SELECT DISTINCT _tmpItem.UserId FROM _tmpItem);
    -- Поиск
    vbPartnerId:= (SELECT DISTINCT _tmpItem.clientExtId FROM _tmpItem);
    -- Поиск
    vbPaidKindId:= (SELECT DISTINCT CASE WHEN _tmpItem.documentform ILIKE 'W' THEN zc_Enum_PaidKind_FirstForm() ELSE zc_Enum_PaidKind_SecondForm() END FROM _tmpItem);
    -- Поиск
    vbUnitId:= (SELECT gpGet.UnitId_ret FROM gpGetMobile_Object_Const (inSession:= vbUserId :: TVarChar) AS gpGet);


    -- Поиск - 1.1. - Все параметры
    vbContractId:= (SELECT soldtable.contractid
                    FROM soldtable
                         JOIN _tmpItem ON _tmpItem.GoodsId= soldtable.GoodsId
                                    --AND COALESCE (_tmpItem.GoodsKindId, 0) = COALESCE (soldtable.GoodsKindId, 0)
                    WHERE soldtable.OperDate <= CURRENT_DATE - INTERVAL '14 DAY'
                      AND soldtable.PartnerId = vbPartnerId
                      AND soldtable.PaidKindId = vbPaidKindId
                    ORDER BY soldtable.OperDate DESC
                    LIMIT 1
                   );
    -- Поиск - 1.2. - Все параметры
    IF COALESCE (vbContractId, 0) = 0
    THEN
        vbContractId:= (SELECT soldtable.contractid
                        FROM soldtable
                             JOIN _tmpItem ON _tmpItem.GoodsId= soldtable.GoodsId
                                        --AND COALESCE (_tmpItem.GoodsKindId, 0) = COALESCE (soldtable.GoodsKindId, 0)
                        WHERE soldtable.OperDate > CURRENT_DATE - INTERVAL '14 DAY'
                          AND soldtable.PartnerId = vbPartnerId
                          AND soldtable.PaidKindId = vbPaidKindId
                        ORDER BY soldtable.OperDate
                        LIMIT 1
                       );
    END IF;

    -- Поиск - 2.1. - без PaidKindId
    IF COALESCE (vbContractId, 0) = 0
    THEN
        vbContractId:= (SELECT soldtable.contractid
                        FROM soldtable
                             JOIN _tmpItem ON _tmpItem.GoodsId= soldtable.GoodsId
                                        --AND COALESCE (_tmpItem.GoodsKindId, 0) = COALESCE (soldtable.GoodsKindId, 0)
                        WHERE soldtable.OperDate <= CURRENT_DATE - INTERVAL '14 DAY'
                          AND soldtable.PartnerId = vbPartnerId
                        --AND soldtable.PaidKindId = vbPaidKindId
                        ORDER BY soldtable.OperDate
                        LIMIT 1
                       );
    END IF;
    -- Поиск - 2.2. - без PaidKindId
    IF COALESCE (vbContractId, 0) = 0
    THEN
        vbContractId:= (SELECT soldtable.contractid
                        FROM soldtable
                             JOIN _tmpItem ON _tmpItem.GoodsId= soldtable.GoodsId
                                        --AND COALESCE (_tmpItem.GoodsKindId, 0) = COALESCE (soldtable.GoodsKindId, 0)
                        WHERE soldtable.OperDate > CURRENT_DATE - INTERVAL '14 DAY'
                          AND soldtable.PartnerId = vbPartnerId
                        --AND soldtable.PaidKindId = vbPaidKindId
                        ORDER BY soldtable.OperDate
                        LIMIT 1
                       );
    END IF;


    -- Поиск - 3. - для PaidKindId = zc_Enum_PaidKind_SecondForm
    IF COALESCE (vbContractId, 0) = 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
    THEN
        vbContractId:= (SELECT Object_Contract_View.ContractId
                        FROM ObjectLink AS ObjectLink_Partner_Juridical
                             INNER JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                            AND Object_Contract_View.PaidKindId = zc_Enum_PaidKind_SecondForm()
                                                            AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                                            AND View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101()) -- Готовая продукция
                        WHERE ObjectLink_Partner_Juridical.ObjectId = vbPartnerId
                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                        ORDER BY Object_Contract_View.EndDate DESC
                        LIMIT 1
                       );
    END IF;


    -- Проверка
    IF COALESCE (vbContractId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Договор не найден.%<%> %<%> %<%> %<%> %<%>  '
                       , CHR (13)
                       , (select STRING_AGG (GoodsId :: TVarChar, ',') from (select * from _tmpItem order by GoodsId, GoodsKindId) as _tmpItem)
                       , CHR (13)
                       , (select STRING_AGG (GoodsKindId :: TVarChar, ',') from (select * from _tmpItem order by GoodsId, GoodsKindId) as _tmpItem)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbPaidKindId)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbPartnerId)
                       , CHR (13)
                       , COALESCE (vbPaidKindId, 0) :: TVarChar || ' ' || COALESCE (vbPartnerId, 0) :: TVarChar
                        ;
        -- select * from Object where Id in (2116, 11317467)
    END IF;


    -- Документ
    vbMovementId:= (WITH tmpParams AS (SELECT _tmpItem.extId                   AS GUID          -- Идентификатор заказа
                                            , _tmpItem.createDate_ch           AS InsertMobile  -- Дата и время создания документа на мобильном устройстве
                                            , _tmpItem.dbCreateDate_ch         AS UpdateMobile  -- Дата и время (в UTC) записи документа в БД Effie
                                            , _tmpItem.comments	            AS Comments
                                            , MAX (_tmpItem.SubjectDocId)      AS SubjectDocId
                                       FROM _tmpItem
                                       GROUP BY _tmpItem.extId
                                              , _tmpItem.createDate_ch
                                              , _tmpItem.dbCreateDate_ch
                                              , _tmpItem.comments
                                      )
                    SELECT gpInsertUpdateMobile_Movement_ReturnIn(inGUID                := tmpParams.GUID
                                                                , inInvNumber           := CAST (NEXTVAL ('movement_returnin_seq') AS TVarChar)
                                                                , inOperDate            := DATE_TRUNC ('DAY', tmpParams.InsertMobile)
                                                                , inStatusId            := zc_Enum_Status_UnComplete()
                                                                , inPriceWithVAT        := FALSE
                                                                , inInsertDate          := tmpParams.InsertMobile
                                                                , inVATPercent          := 20
                                                                , inChangePercent       := COALESCE ((SELECT Object_Contract_View.ChangePercent FROM Object_Contract_View WHERE Object_Contract_View.ContractId = vbContractId), 0) :: TFloat
                                                                , inPaidKindId          := vbPaidKindId
                                                                , inPartnerId           := vbPartnerId
                                                                , inUnitId              := vbUnitId
                                                                , inContractId          := vbContractId
                                                                , inComment             := tmpParams.Comments
                                                                , inSubjectDocId        := tmpParams.SubjectDocId
                                                                , inSession             := vbUserId :: TVarChar
                                                                 )
                   FROM tmpParams
                  );

    -- Строки Документа
    UPDATE _tmpItem SET MovementItemId = gpInsertUpdateMobileEffie_MI_ReturnIn
                                                           (inGUID                := _tmpItem.productExtId :: TVarChar
                                                          , inMovementGUID        := _tmpItem.extId
                                                          , inGoodsId             := _tmpItem.GoodsId
                                                          , inGoodsKindId         := _tmpItem.GoodsKindId
                                                          , inAmount              := _tmpItem.quantity
                                                          , inPrice               := 0
                                                          , inChangePercent       := 0
                                                          , inSubjectDocId        := _tmpItem.SubjectDocId
                                                          , inSession             := vbUserId :: TVarChar
                                                           )
   ;

    -- сохранили свойство <Цена из Effie>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceEffie(), _tmpItem.MovementItemId, COALESCE (MIF_Price.ValueData, 0))
    FROM _tmpItem
         LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = _tmpItem.MovementItemId AND MIF_Price.DescId = zc_MIFloat_Price()
   ;


    -- Удаление
    PERFORM gpSetMobileErased_Movement_ReturnIn (inMovementGUID:= (SELECT DISTINCT _tmpItem.extId FROM _tmpItem)
                                               , inSession     := vbUserId :: TVarChar
                                                );

    -- сохранили свойство <Effie (да)>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Effie(), vbMovementId, TRUE);

    -- сохранили свойство <Дата/время создания заказа на мобильном устройстве>
    PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbMovementId, (SELECT DISTINCT _tmpItem.createDate_ch FROM _tmpItem));
    -- сохранили свойство <Дата/время создания заказа на мобильном устройстве>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, (SELECT DISTINCT _tmpItem.dbCreateDate_ch FROM _tmpItem));


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
-- SELECT * FROM gpInsert_Movement_ReturnIn_effie ('1cfb0471-9d83-4d81-b5af-23a787596890', zfCalc_UserAdmin()::TVarChar);

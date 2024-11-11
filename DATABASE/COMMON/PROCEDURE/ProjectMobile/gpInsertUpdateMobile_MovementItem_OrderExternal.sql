-- Function: gpInsertUpdateMobile_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_OrderExternal (TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_OrderExternal(
    IN inGUID                TVarChar  , -- Глобальный уникальный идентификатор
    IN inMovementGUID        TVarChar  , -- Глобальный уникальный идентификатор шапки документа
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbCountForPrice TFloat;
   DECLARE vbStatusId Integer;

   DECLARE vbPartnerId Integer;
   DECLARE vbPriceListId Integer;
   DECLARE vbOperDate_pl TDateTime;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());
      vbUserId:= lpGetUserBySession (inSession);


      -- поиск Id документа по GUID
      SELECT MovementString_GUID.MovementId
           , Movement_OrderExternal.StatusId
            INTO vbMovementId
               , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_OrderExternal
                         ON Movement_OrderExternal.Id = MovementString_GUID.MovementId
                        AND Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID()
        AND MovementString_GUID.ValueData = inMovementGUID;
      -- Проверка
      IF COALESCE (vbMovementId, 0) = 0 THEN
         RAISE EXCEPTION 'Ошибка. Не сохранена шапка документа.';
      END IF;

      -- получаем Id строки документа по GUID
      vbId:= (SELECT MovementItem.Id
              FROM MovementItem
                   JOIN MovementItemString
                     ON MovementItemString.MovementItemId = MovementItem.Id
                    AND MovementItemString.DescId         = zc_MIString_GUID()
                    AND MovementItemString.ValueData      = inGUID
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.DescId     = zc_MI_Master()
             );



      -- !!! ВРЕМЕННО - 04.07.17 !!!
      IF vbStatusId = zc_Enum_Status_Complete() AND vbId <> 0
      THEN
           -- !!! ВРЕМЕННО !!!
           RETURN (vbId);
      END IF;
      -- !!! ВРЕМЕННО - 04.07.17 !!!



      IF vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
      THEN
           -- Распроводим Документ
           PERFORM lpUnComplete_Movement_OrderExternal (inMovementId:= vbMovementId, inUserId:= vbUserId);
      END IF;
      
      --
      vbPartnerId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId AND MLO.DescId = zc_MovementLinkObject_From());


      -- если есть кол-во
      IF inAmount <> 0
      THEN
          -- !!!замена!!!
          SELECT tmp.PriceListId, tmp.OperDate
                 INTO vbPriceListId, vbOperDate_pl
          FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                    , inPartnerId      := vbPartnerId
                                                    , inMovementDescId := zc_Movement_Sale()
                                                    , inOperDate_order := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId)
                                                    , inOperDatePartner:=  NULL
                                                    , inDayPrior_PriceReturn:= NULL
                                                    , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                    , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                     ) AS tmp;
          -- !!!замена!!!
          IF 1 < (SELECT COUNT(*)
                  FROM (SELECT DISTINCT
                               ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                             , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

                        FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                             INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                   ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                  AND ObjectLink_PriceListItem_PriceList.ChildObjectId = vbPriceListId
                                                  AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                             LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                     ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                    AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                    AND vbOperDate_pl >= ObjectHistory_PriceListItem.StartDate AND vbOperDate_pl < ObjectHistory_PriceListItem.EndDate
                             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                          ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                         AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                         AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
                        WHERE ObjectLink_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                          AND ObjectLink_PriceListItem_Goods.ChildObjectId = inGoodsId
                       ) AS tmp
                 )
          THEN
              -- !!!замена!!!
              inPrice:= 0;
          END IF;


          -- если товара и вид товара нет в zc_ObjectBoolean_GoodsByGoodsKind_Order - тогда ошиибка
          IF NOT EXISTS (SELECT 1
                         FROM ObjectBoolean AS ObjectBoolean_Order
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_NotMobile
                                                      ON ObjectBoolean_NotMobile.ObjectId = ObjectBoolean_Order.ObjectId
                                                     AND ObjectBoolean_NotMobile.DescId   = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()
                              INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                         WHERE ObjectBoolean_Order.ValueData = TRUE
                           AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                           AND Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
                           AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0)
                           AND COALESCE (ObjectBoolean_NotMobile.ValueData, FALSE) = FALSE
                         )  
               AND EXISTS (SELECT 1 FROM ObjectLink AS OL
                                    WHERE OL.ObjectId = inGoodsId
                                      AND OL.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                      AND OL.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                           --, zc_Enum_InfoMoney_30102() -- Тушенка
                                                             , zc_Enum_InfoMoney_20901() -- Ирна
                                                              )
                          )
               AND NOT EXISTS (SELECT 1
                               FROM ObjectLink AS OL
                                    INNER JOIN ObjectLink AS OL_Juridical_Retail
                                                          ON OL_Juridical_Retail.ObjectId = OL.ChildObjectId 
                                                         AND OL_Juridical_Retail.DescId   =  zc_ObjectLink_Juridical_Retail()
                                                         AND OL_Juridical_Retail.ChildObjectId = 310854 -- Фоззі
                               WHERE OL.ObjectId   = vbPartnerId
                                 AND OL.DescId     = zc_ObjectLink_Partner_Juridical()
                                 AND inGoodsId     = 9505524 -- 457 - Сосиски ФІЛЕЙКИ вар 1 ґ ТМ Наші Ковбаси
                                 AND inGoodsKindId = 8344    -- Б/В 0,5кг
                              )
           AND vbUserId <> 1058558 -- Чернікова Ольга Петрівна
          THEN
              RAISE EXCEPTION '%У товара <%>%<%>%не установлено свойство <Используется в заявках>=Да.%№ % от % % % % % % % %'
                             , CHR (13)
                             , lfGet_Object_ValueData (inGoodsId)
                             , CHR (13)
                             , lfGet_Object_ValueData_sh (inGoodsKindId)
                             , CHR (13)
                             , CHR (13)
                           --, (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()) 
                             , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId)
                             , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId))
                             , CHR (13)
                             , (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                             , CHR (13)
                             , CHR (13)
                             , CHR (13)
                             , CHR (13)
                             , CHR (13)
                              ;
          END IF;

          -- сохранили элемент
          SELECT ioId INTO vbId FROM lpInsertUpdate_MovementItem_OrderExternal (ioId            := vbId
                                                                              , inMovementId    := vbMovementId
                                                                              , inGoodsId       := inGoodsId
                                                                              , inAmount        := inAmount
                                                                              , inAmountSecond  := 0
                                                                              , inGoodsKindId   := inGoodsKindId
                                                                              , ioPrice         := inPrice
                                                                              , ioCountForPrice := 1
                                                                              , inUserId        := vbUserId
                                                                               );

          -- сохранили свойство <Глобальный уникальный идентификатор>
          PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, inGUID);

      END IF;

      IF vbUserId = 5 AND 1=1
      THEN
          RAISE EXCEPTION 'Ошибка.Admin.';
      END IF;

      -- сохранили свойство <Дата/время сохранения с мобильного устройства>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, CURRENT_TIMESTAMP);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 28.02.17                                                        *
*/

-- тест
/* SELECT * FROM gpInsertUpdateMobile_MovementItem_OrderExternal (inGUID:= '{FFA0D4A2-3278-4B3B-A477-692067AFB021}'
                                                                , inMovementGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}'
                                                                , inGoodsId:= 460651
                                                                , inGoodsKindId:= 8335
                                                                , inChangePercent:= 6.0
                                                                , inAmount:= 12.0
                                                                , inPrice:= 47.07
                                                                , inSession:= zfCalc_UserAdmin()
                                                                 )
*/

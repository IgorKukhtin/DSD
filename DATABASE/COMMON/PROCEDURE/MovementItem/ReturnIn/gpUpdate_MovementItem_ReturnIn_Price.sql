-- Function: gpUpdate_MovementItem_ReturnIn_Price()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_ReturnIn_Price (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_ReturnIn_Price(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inPriceListId             Integer   , -- ключ Прайс листа
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
     
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_ReturnIn_Price());


     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
            INTO vbStatusId, vbInvNumber, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;


     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- Проверка - Прайс лист должен быть установлен
     IF COALESCE (inPriceListId, 0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Прайс лист> должно быть установлено.';
     END IF;
   
      
      -- таблица -  Цены из прайса
      CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
         INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
             SELECT lfSelect.GoodsId     AS GoodsId
                  , lfSelect.GoodsKindId AS GoodsKindId
                  , lfSelect.ValuePrice  AS ValuePrice
             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= vbOperDate) AS lfSelect;


     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price()
                                             , MovementItem.Id
                                             , COALESCE (tmpPriceList_kind.ValuePrice, tmpPriceList.ValuePrice, 0)
                                             )
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                      ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                     AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
          -- вид товара
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
         -- привязываем 2 раза по виду товара и без
          LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = MovementItem.ObjectId
                                AND tmpPriceList.GoodsKindId IS NULL
          LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                 ON tmpPriceList_kind.GoodsId = MovementItem.ObjectId
                                AND COALESCE (tmpPriceList_kind.GoodsKindId, 0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)          
     WHERE MovementId = inMovementId
       -- !!! без акций !!!
       AND COALESCE (MIFloat_PromoMovement.ValueData, 0) = 0
    ;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- сохранили связь с <PriceList>
     -- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, inPriceListId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.12.19         *
 27.08.15         *
*/

-- Function: gpUpdate_MovementItem_Sale_PriceIn()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_PriceIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_PriceIn(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPriceListInId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_Price());

     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_PriceListIn.ObjectId AS PriceListInId

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListInId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceListIn
                                       ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
     WHERE Movement.Id = inMovementId;


     -- проверка - проведенные/удаленные документы Изменять нельзя
     /*IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     */
     
     /*-- Проверка - Прайс лист должен быть установлен
     IF COALESCE (vbPriceListInId, 0) = 0 
     THEN
         RAISE EXCEPTION 'Ошибка.Значение <Прайс лист> должно быть установлено.';
     END IF;*/
   
     --сохраняем прайс вх.
     IF COALESCE (vbPriceListInId,0) = 0
     THEN
         vbPriceListInId = 3552610;  -- "*прайс -20"
         -- Сохранили Прайс
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceListIn(), inMovementId, vbPriceListInId);
     END IF;


     -- меняется параметр
     -- !!!замена!!!
     SELECT tmp.OperDate
            INTO vbOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := vbOperDate ::TDateTime
                                               , inOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())::TDateTime
                                               , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                               , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                               , inOperDatePartner_order:= NULL ::TDateTime
                                                ) AS tmp;


     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.Id, tmp.PriceIn)
     FROM 
         (WITH
          -- Цены из прайса вх.
          tmpPriceListIn AS (SELECT lfSelect.GoodsId     AS GoodsId
                                  , lfSelect.GoodsKindId AS GoodsKindId
                                  , lfSelect.ValuePrice
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListInId, inOperDate:= vbOperDate) AS lfSelect
                            )

          SELECT MovementItem.Id
               , COALESCE (tmpPriceListIn_kind.ValuePrice, tmpPriceListIn.ValuePrice, 0) AS PriceIn
          FROM MovementItem
               -- вид товара
               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

               -- привязываем 2 раза по виду товара и с пустым видом
               LEFT JOIN tmpPriceListIn AS tmpPriceListIn
                                        ON tmpPriceListIn.GoodsId = MovementItem.ObjectId
                                       AND tmpPriceListIn.GoodsKindId IS NULL
                                                 
               LEFT JOIN tmpPriceListIn AS tmpPriceListIn_kind 
                                        ON tmpPriceListIn_kind.GoodsId = MovementItem.ObjectId
                                       AND COALESCE (tmpPriceListIn_kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
          WHERE MovementId = inMovementId
         ) AS tmp
     ;

if vbUserId = 5 OR vbUserId = 9457
then
    RAISE EXCEPTION 'Ошибка.<%>', vbOperDate;
end if;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- пересчитали Итоговые суммы по накладной
     --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.22         *
*/

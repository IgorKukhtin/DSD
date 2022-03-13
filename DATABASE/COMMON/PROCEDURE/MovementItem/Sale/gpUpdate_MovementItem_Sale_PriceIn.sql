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
   DECLARE vbToId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_Price());


     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_PriceListIn.ObjectId AS PriceListInId
          , MovementLinkObject_To.ObjectId AS ToId

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListInId, vbToId

     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceListIn
                                       ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;


     -- проверка - удаленный документ Изменять нельзя
     IF vbStatusId = zc_Enum_Status_Erased()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


     -- сохраняем прайс вх.
     IF COALESCE (vbPriceListInId, 0) = 0
        AND EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbToId AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Partner_Unit())
     THEN
         -- "*прайс -20"
         vbPriceListInId = 3552610;

         -- Сохранили Прайс
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceListIn(), inMovementId, vbPriceListInId);

         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     ELSEIF vbPriceListInId > 0
        AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbToId AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Partner_Unit())
     THEN
         -- обнулили Прайс
         vbPriceListInId:= 0;
         -- обнулили Прайс
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceListIn(), inMovementId, vbPriceListInId);

         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     END IF;


     -- меняется параметр
     -- !!!замена!!!
     SELECT tmp.OperDate
            INTO vbOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := vbToId
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := vbOperDate ::TDateTime
                                               , inOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())::TDateTime
                                               , inDayPrior_PriceReturn:= 0 -- !!!параметр здесь не важен!!!
                                               , inIsPrior        := FALSE -- !!!параметр здесь не важен!!!
                                               , inOperDatePartner_order:= NULL ::TDateTime
                                                ) AS tmp;


     -- сохранили
     PERFORM lpInsert_MovementItemProtocol (tmp.Id, vbUserId, FALSE)
     FROM (-- сохранили
           SELECT tmp.Id
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn(), tmp.Id, tmp.PriceIn)
           FROM
               (WITH -- Цены из прайса вх.
                     tmpPriceListIn AS (SELECT lfSelect.GoodsId     AS GoodsId
                                             , lfSelect.GoodsKindId AS GoodsKindId
                                             , lfSelect.ValuePrice
                                        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListInId, inOperDate:= vbOperDate) AS lfSelect
                                       )
                --
                SELECT MovementItem.Id
                     , COALESCE (tmpPriceListIn_kind.ValuePrice, tmpPriceListIn.ValuePrice, 0) AS PriceIn
                FROM MovementItem
                     -- вид товара
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     --
                     LEFT JOIN MovementItemFloat AS MIFloat
                                                 ON MIFloat.MovementItemId = MovementItem.Id
                                                AND MIFloat.DescId         = zc_MIFloat_PriceIn()

                     -- привязываем 2 раза по виду товара и с пустым видом
                     LEFT JOIN tmpPriceListIn AS tmpPriceListIn
                                              ON tmpPriceListIn.GoodsId = MovementItem.ObjectId
                                             AND tmpPriceListIn.GoodsKindId IS NULL

                     LEFT JOIN tmpPriceListIn AS tmpPriceListIn_kind
                                              ON tmpPriceListIn_kind.GoodsId = MovementItem.ObjectId
                                             AND COALESCE (tmpPriceListIn_kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND COALESCE (MIFloat.ValueData, 0) <> COALESCE (tmpPriceListIn_kind.ValuePrice, tmpPriceListIn.ValuePrice, 0)
               ) AS tmp
          ) AS tmp
     ;

    --
    if vbUserId IN (5, 9457) AND 1=0
    then
        RAISE EXCEPTION 'Ошибка.<%>', vbOperDate;
    end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.22         *
*/

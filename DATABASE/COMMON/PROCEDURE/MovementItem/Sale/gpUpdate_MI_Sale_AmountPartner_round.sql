-- Function: gpUpdate_MI_Sale_AmountPartner_round()

DROP FUNCTION IF EXISTS gpUpdate_MI_Sale_AmountPartner_round (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Sale_AmountPartner_round(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inAmount                  TFloat    , -- количество знаков после зпт. для округления
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
   DECLARE vbPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_AmountPartner());

     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.Invnumber
            INTO vbStatusId, vbInvNumber 
     FROM Movement
     WHERE Movement.Id = inMovementId;
     
     --проверка что вібрано округлние до 2 или 3 знаков
     IF inAmount <> 2 AND inAmount <> 3
     THEN
         RAISE EXCEPTION 'Ошибка.Выбрано не верное значение для округления.';
     END IF;

     -- проверка - округления только в проведенных документах
     IF vbStatusId <> zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно. Только для проведенных документов.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


     --
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner()
                                            , MovementItem.Id
                                            , CASE WHEN inAmount = 2 THEN ROUND (MIFloat_AmountPartner.ValueData,2) 
                                                   WHEN inAmount = 3 THEN ROUND (MIFloat_AmountPartner.ValueData,3)
                                              END
                                              )
     FROM MovementItem
          INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.isErased = FALSE
       AND MovementItem.DescId = zc_MI_Master()
     ;

     -- проводим Документ
     PERFORM lpComplete_Movement_Sale (inMovementId := inId
                                     , inUserId     := vbUserId);


    --
    if vbUserId IN (5, 9457) AND 1=1
    then
        RAISE EXCEPTION 'Ошибка.<%>', vbInvNumber;
    end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.22         *
*/

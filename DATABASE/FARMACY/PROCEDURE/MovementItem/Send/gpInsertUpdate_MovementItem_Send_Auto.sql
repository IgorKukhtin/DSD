-- Function: gpInsertUpdate_MovementItem_Send_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_Auto(
    IN inFromId              Integer   , -- от кого
    IN inToId                Integer   , -- Кому
    IN inOperDate            TDateTime , -- дата
    IN inGoodsId             Integer   , -- Товары
    IN inRemainsMCS_result   TFloat    , -- Количество
    IN inPrice_from          TFloat    , -- Цена от кого
    IN inPrice_to            TFloat    , -- Цена кому
    IN inMCSPeriod           TFloat    , -- период для расчета НТЗ
    IN inMCSDay              TFloat    , -- на сколько дней НТЗ
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

    IF COALESCE(inRemainsMCS_result, 0) <> 0 THEN
      -- ищем ИД документа (ключ - дата, от кого, кому, создан автоматически)
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        Inner JOIN MovementBoolean AS MovementBoolean_isAuto
                                   ON MovementBoolean_isAuto.MovementId = Movement.Id
                                  AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                  AND COALESCE(MovementBoolean_isAuto.ValueData, False) = True
 
        Inner Join MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.ID
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     AND MovementLinkObject_From.ObjectId = inFromId

        Inner Join MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.ID
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                     AND MovementLinkObject_To.ObjectId = inToId

      WHERE Movement.DescId = zc_Movement_Send() AND Movement.OperDate = inOperDate
          AND Movement.StatusId <> zc_Enum_Status_Erased();
    
      IF COALESCE (vbMovementId,0) = 0 THEN
       -- записываем новый <Документ>
       vbMovementId := lpInsertUpdate_Movement_Send (ioId               := COALESCE(vbMovementId,0) ::Integer
                                                   , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) --inInvNumber
                                                   , inOperDate         := inOperDate
                                                   , inFromId           := inFromId
                                                   , inToId             := inToId
                                                   , inComment          := '' :: TVarChar
                                                   , inChecked          := FALSE
                                                   , inisComplete       := FALSE
                                                   , inNumberSeats      := 0
                                                   , inDriverSunId      := 0
                                                   , inUserId           := vbUserId
                                                   );
    
       -- сохранили свойство <создан автоматически>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
       -- сохранили <период для расчета НТЗ>
       --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MCSPeriod(), vbMovementId, inMCSPeriod);
       -- сохранили <на сколько дней НТЗ>
       --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MCSDay(), vbMovementId, inMCSDay);

      END IF;
      
       -- сохранили свойство <создан автоматически>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
       -- сохранили/обновили <период для расчета НТЗ>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MCSPeriod(), vbMovementId, inMCSPeriod);
       -- сохранили/обновили <на сколько дней НТЗ>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MCSDay(), vbMovementId, inMCSDay);

      -- Ищеи ИД строки (ключ - ид документа, товар)
      SELECT MovementItem.Id
       INTO vbMovementItemId
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementId AND MovementItem.ObjectId = inGoodsId;

       -- сохранили строку документа
       vbMovementItemId := lpInsertUpdate_MovementItem_Send (ioId                 := COALESCE(vbMovementItemId,0) ::Integer
                                                           , inMovementId         := vbMovementId
                                                           , inGoodsId            := inGoodsId
                                                           , inAmount             := inRemainsMCS_result
                                                           , inAmountManual       := 0 ::TFloat
                                                           , inAmountStorage      := 0 ::TFloat
                                                           , inReasonDifferencesId:= 0
                                                           , inCommentSendID      := 0
                                                           , inUserId             := vbUserId
                                                            );
    -- сохранили <цену от кого>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceFrom(), vbMovementItemId, inPrice_from);
    -- сохранили <цену кому>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTo(), vbMovementItemId, inPrice_to);

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.06.16         *
*/

-- тест
--select * from gpInsertUpdate_MovementItem_Send_Auto(inFromId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');

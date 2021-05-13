-- Function: gpInsert_Movement_Send_RemaigpInsert_Movement_Send_express2nsSun_express

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_express2 (TDateTime, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Send_express2 (TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Send_express2 (TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Send_express2 (TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_express2(
     IN inOperDate            TDateTime , -- Дата начала отчета
     IN inUnitId_from         Integer,
     IN inUnitId_to           Integer,
     IN inGoodsId             Integer,
     IN inAmount              TFloat,
     IN inAmountRemains_from  TFloat,
     IN inAmountRemains_to    TFloat,
     IN inMCS_from            TFloat,
     IN inMCS_to              TFloat,
  INOUT ioAmountExcess        TFloat,  -- факт. излишек с учетом перемещения (от кого)
  INOUT ioAmountNeed          TFloat,  -- факт. потребность с учетом перемещения (кому)
  INOUT ioAmountSend_out      TFloat,  -- Перемещ. расх. (ожидается)   - 1-ый грид
  INOUT ioAmountSend_in       TFloat,  -- Перемещ. приход. (ожидается) - 2-ый грид
     IN inSession             TVarChar -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;
     
     inOperDate := inOperDate :: Date;
     
     
     -- переопределяем значение для перемещение, учитывая сколько на точке отправителе есть товара в остатке
     inAmount := (CASE WHEN ioAmountExcess < inAmount THEN ioAmountExcess ELSE inAmount END) ::TFloat;
     
     --  -- создали документы если нужно
     vbMovementId := gpInsertUpdate_Movement_Send (ioId               := COALESCE (tmp.MovementId,0) :: Integer
                                                 , inInvNumber        := COALESCE (tmp.Invnumber, CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)) :: TVarChar
                                                 , inOperDate         := inOperDate
                                                 , inFromId           := inUnitId_from
                                                 , inToId             := inUnitId_to
                                                 , inComment          := 'тест V3'
                                                 , inChecked          := FALSE
                                                 , inisComplete       := FALSE
                                                 , inNumberSeats      := 0
                                                 , inDriverSunId      := 0
                                                 , inSession          := inSession
                                               ) 
                     FROM (SELECT inUnitId_to AS UnitId_to) AS tmpUnit
                          LEFT JOIN (SELECT Movement.Id                    AS MovementId
                                          , Movement.Invnumber
                                          , MovementLinkObject_To.ObjectId AS UnitId_to
                                     FROM Movement
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                                       AND MovementLinkObject_From.ObjectId   = inUnitId_from
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                       AND MovementLinkObject_To.ObjectId = inUnitId_to
                                          --
                                          INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                                    AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                                    AND MovementBoolean_SUN.ValueData  = TRUE
                                          INNER JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                                     ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                                                    AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                                                    AND MovementBoolean_SUN_v3.ValueData  = TRUE
                                     WHERE Movement.OperDate = inOperDate
                                       AND Movement.DescId   = zc_Movement_Send()
                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                      ) AS tmp ON tmp.UnitId_to = tmpUnit.UnitId_to
        ;    

     -- сохранили свойство <Перемещение по СУН-v3> + isAuto
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    vbMovementId, TRUE);
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v3(), vbMovementId, TRUE);
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);

     --- ищем есть ли уже такая строка
     vbId := (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.ObjectId = inGoodsId AND MovementItem.isErased = FALSE);
     
     -- создали строки документа - Перемещение по СУН, если уже есть обновили значения
     vbId := lpInsertUpdate_MovementItem_Send (ioId                   := COALESCE (vbId,0)
                                             , inMovementId           := vbMovementId
                                             , inGoodsId              := inGoodsId
                                             , inAmount               := inAmount
                                             , inAmountManual         := 0
                                             , inAmountStorage        := 0
                                             , inReasonDifferencesId  := 0
                                             , inCommentSendID        := 0
                                             , inUserId               := vbUserId
                                              );
     
     
     -- сохраняем остальные свойства строки
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsFrom(), MovementItem.Id, inAmountRemains_from)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsTo(), MovementItem.Id, inAmountRemains_to)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ValueFrom(), MovementItem.Id, inMCS_from)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ValueTo(), MovementItem.Id, inMCS_to)
     FROM MovementItem
     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.ObjectId = inGoodsId
       AND MovementItem.Id = vbId
       AND MovementItem.isErased = FALSE;


     -- рассчитываем данные для 1-го и 2-го грида
     ioAmountNeed     := (COALESCE (ioAmountNeed,0)     - COALESCE (inAmount,0)) ::TFloat;
     ioAmountExcess   := (COALESCE (ioAmountExcess,0)   - COALESCE (inAmount,0)) ::TFloat;
     ioAmountSend_out := (COALESCE (ioAmountSend_out,0) + COALESCE (inAmount,0)) ::TFloat;
     ioAmountSend_in  := (COALESCE (ioAmountSend_in,0)  + COALESCE (inAmount,0)) ::TFloat;
      
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.20         *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun_express (inOperDate:= CURRENT_DATE - INTERVAL '0 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ

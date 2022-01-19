-- Function: gpInsertUpdate_MovementItem_Send_AutoSUA()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_AutoSUA (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_AutoSUA(
    IN inFromId              Integer   , -- от кого
    IN inToId                Integer   , -- Кому
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
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
    
    IF COALESCE (inFromId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Не определена аптека отдачи.';    
    END IF;

    IF COALESCE(inGoodsId, 0) <> 0
    THEN
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

        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()

      WHERE Movement.DescId = zc_Movement_Send() AND Movement.OperDate = CURRENT_DATE
          AND Movement.StatusId = zc_Enum_Status_UnComplete()
          AND COALESCE (MovementBoolean_SUN.ValueData, FALSE) = FALSE;
    
      IF COALESCE (vbMovementId,0) = 0 THEN
       -- записываем новый <Документ>
       vbMovementId := lpInsertUpdate_Movement_Send (ioId               := COALESCE(vbMovementId,0) ::Integer
                                                   , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) --inInvNumber
                                                   , inOperDate         := CURRENT_DATE::TDateTime
                                                   , inFromId           := inFromId
                                                   , inToId             := inToId
                                                   , inComment          := 'СУА доп. сценарий' :: TVarChar
                                                   , inChecked          := FALSE
                                                   , inisComplete       := FALSE
                                                   , inNumberSeats      := 0
                                                   , inDriverSunId      := 0
                                                   , inUserId           := vbUserId
                                                   );
    
       -- сохранили свойство <создан автоматически>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);

      END IF;
      
      -- Ищеи ИД строки (ключ - ид документа, товар)
      SELECT MovementItem.Id
      INTO vbMovementItemId
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementId 
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = inGoodsId;

      IF COALESCE(vbMovementItemId, 0) <> 0 OR COALESCE(inAmount, 0) <> 0  
      THEN
         -- сохранили строку документа
         vbMovementItemId := lpInsertUpdate_MovementItem_Send (ioId                 := COALESCE(vbMovementItemId,0) ::Integer
                                                             , inMovementId         := vbMovementId
                                                             , inGoodsId            := inGoodsId
                                                             , inAmount             := inAmount
                                                             , inAmountManual       := 0 ::TFloat
                                                             , inAmountStorage      := 0 ::TFloat
                                                             , inReasonDifferencesId:= 0
                                                             , inCommentSendID      := 0
                                                             , inUserId             := vbUserId
                                                              );
      END IF;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.22                                                       *
*/

-- тест
--select * from gpInsertUpdate_MovementItem_Send_AutoSUA(inFromId := 7117700 , inToId := 394426 , inGoodsId := 520 , inAmount := 0 ,  inSession := '3');



-- Function: gpInsertUpdate_MovementItem_Send_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_byUnLiquid (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_byUnLiquid(
    IN inStartSale           TDateTime , -- Дата начала отчета
    IN inEndSale             TDateTime , -- Дата окончания отчета
    IN inFromId              Integer   , -- от кого
    IN inToId                Integer   , -- Кому
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
   DECLARE vbMovementId_ReportUnLiquid Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;


   IF NOT EXISTS (SELECT 1 FROM Object_GoodsPrint WHERE Object_GoodsPrint.UnitId = inFromId AND Object_GoodsPrint.GoodsId = inGoodsId AND Object_GoodsPrint.UserId = vbUserId)
   THEN
       RETURN;
   END IF;
    
    IF COALESCE(inRemainsMCS_result, 0) <> 0
    THEN
        -- ищем ИД документа перещения (ключ - дата, от кого, кому, создан автоматически)
        SELECT Movement.Id  
        INTO vbMovementId
        FROM Movement
          INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                     ON MovementBoolean_isAuto.MovementId = Movement.Id
                                    AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                    AND COALESCE(MovementBoolean_isAuto.ValueData, False) = True
   
          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.ID
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                       AND MovementLinkObject_From.ObjectId = inFromId
  
          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.ID
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                       AND MovementLinkObject_To.ObjectId = inToId
  
        WHERE Movement.DescId = zc_Movement_Send() 
          AND Movement.OperDate = inEndSale
          AND Movement.StatusId <> zc_Enum_Status_Erased();
      
        IF COALESCE (vbMovementId,0) = 0 
        THEN
             -- ищем ИД документа Отчет по неликв. товарам (ключ - подразделение, нач. оконч. отчета)
             SELECT tmp.Id
             INTO vbMovementId_ReportUnLiquid
             FROM (SELECT Movement.Id  
                        , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                   FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.ID
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                  AND MovementLinkObject_Unit.ObjectId = inFromId
                     INNER JOIN MovementDate AS MovementDate_StartSale
                                             ON MovementDate_StartSale.MovementId = Movement.Id
                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                            AND MovementDate_StartSale.ValueData = inStartSale
                     INNER JOIN MovementDate AS MovementDate_EndSale
                                             ON MovementDate_EndSale.MovementId = Movement.Id
                                            AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                            AND MovementDate_EndSale.ValueData = inEndSale
                   WHERE Movement.DescId = zc_Movement_ReportUnLiquid() 
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                  ) AS tmp
             WHERE tmp.Ord = 1;

             IF COALESCE (vbMovementId_ReportUnLiquid, 0) = 0 THEN
                RAISE EXCEPTION 'Перемещения не могут быть созданы. Документ <Отчет по неликвидному товару> не сохранен.';
             END IF;
      
             -- записываем новый <Документ>
             vbMovementId := lpInsertUpdate_Movement_Send (ioId               := COALESCE(vbMovementId,0) ::Integer
                                                         , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) --inInvNumber
                                                         , inOperDate         := inEndSale
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
      
             -- сохранили связь с <Документ Отчет по неликвидному товару>
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ReportUnLiquid(), vbMovementId, vbMovementId_ReportUnLiquid);

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
 20.11.18         *
 19.06.16         *
*/

-- тест
--
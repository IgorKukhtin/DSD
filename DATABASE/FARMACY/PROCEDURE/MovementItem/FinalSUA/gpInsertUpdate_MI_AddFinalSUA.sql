-- Function: gpInsertUpdate_MI_AddFinalSUA()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_AddFinalSUA (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_AddFinalSUA(
    IN inGoodsId             Integer   , -- Товары
    IN inUnitId              Integer   , -- Подразделение
    IN inNeed                TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMIId       Integer;
   DECLARE vbOperDate   TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    IF COALESCE (inNeed, 0) <= 0
    THEN
      RETURN;
    END IF;
        
    vbOperDate := CURRENT_DATE + ((8 - date_part('DOW', CURRENT_DATE)::Integer)::TVarChar||' DAY')::INTERVAL;

    IF EXISTS(SELECT Movement.id
                  FROM Movement 
                  WHERE Movement.OperDate = vbOperDate  
                    AND Movement.DescId = zc_Movement_FinalSUA() 
                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                     )
    THEN 
      SELECT Movement.id
      INTO vbMovementId
      FROM Movement 
      WHERE Movement.OperDate = vbOperDate  
        AND Movement.DescId = zc_Movement_FinalSUA() 
        AND Movement.StatusId <> zc_Enum_Status_Erased();   
    ELSE 
      vbMovementId := gpInsertUpdate_Movement_FinalSUA(0, CAST (NEXTVAL ('Movement_FinalSUA_seq') AS TVarChar), vbOperDate, '', False, inSession);
    END IF;     
    
    IF EXISTS(SELECT 1
              FROM MovementItem

                  INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                    ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId= inGoodsId
                AND MILinkObject_Unit.ObjectId = inUnitId)
    THEN
      SELECT MovementItem.Id
      INTO vbMIId
      FROM MovementItem

           INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId= inGoodsId
        AND MILinkObject_Unit.ObjectId = inUnitId;
    ELSE
      vbMIId := 0;
    END IF;
    
    PERFORM lpInsertUpdate_MI_FinalSUA (ioId                 := vbMIId
                                      , inMovementId         := vbMovementId
                                      , inGoodsId            := inGoodsId
                                      , inUnitId             := inUnitId
                                      , inAmount             := inNeed
                                      , inUserId             := vbUserId
                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_AddFinalSUA (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 11.02.21                                                                      *
*/

-- тест select * from gpInsertUpdate_MI_AddFinalSUA(inGoodsId := 1 , inUnitId := 1, inNeed := 10 ,  inSession := '3');
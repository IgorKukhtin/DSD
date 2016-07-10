-- Function: gpInsertUpdate_Movement_Send_Auto()


DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send_Auto (Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send_Auto(
    IN inFromId              Integer   , -- от кого
    IN inOperDate            TDateTime , -- дата
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- кол-во которое распределяется
    IN inPrice_from          TFloat    , -- Цена от кого
    IN inMCSPeriod           TFloat    , -- период для расчета НТЗ
    IN inMCSDay              TFloat    , -- на сколько дней НТЗ
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;

    IF COALESCE(inAmount, 0) <> 0 THEN
     -- ищем ИД документа Распределений остатков (ключ - дата, Подразделение) 
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inFromId
      WHERE Movement.DescId = zc_Movement_Over()
        AND Movement.OperDate = inOperDate
        AND Movement.StatusId <> zc_Enum_Status_Erased();

      IF COALESCE (vbMovementId,0) = 0 THEN
          RAISE EXCEPTION 'Ошибка. Документ Распределений остатков не найден.';
      END IF;
    
    
      -- по строкам чайлда (ключ - ид документа, товар мастера) записываем строки в док. перемещения
      PERFORM gpInsertUpdate_MovementItem_Send_Auto (inFromId             := inFromId
                                                   , inToId               := MovementItem.ObjectId
                                                   , inOperDate           := inOperDate
                                                   , inGoodsId            := inGoodsId
                                                   , inRemainsMCS_result  := COALESCE (MovementItem.Amount,0)    ::TFloat
                                                   , inPrice_from         := inPrice_from                        ::TFloat  
                                                   , inPrice_to           := COALESCE(MIFloat_Price.ValueData,0) ::TFloat
                                                   , inMCSPeriod          := inMCSPeriod
                                                   , inMCSDay             := inMCSDay
                                                   , inSession            := inSession
                                                     )      
      FROM MovementItem 
           INNER JOIN MovementItem AS MI_Master 
                                   ON MI_Master.Id = MovementItem.ParentId
                                  AND MI_Master.ObjectId = inGoodsId
                                  AND COALESCE(MI_Master.Amount,0)<>0
           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
      WHERE MovementItem.MovementId = vbMovementId 
        AND MovementItem.DescId = zc_MI_Child()
        AND MovementItem.isErased = False
        AND COALESCE (MovementItem.Amount,0)<>0;


    END IF;
      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.07.16         *
*/

-- тест
--select * from gpInsertUpdate_Movement_Send_Auto(inFromId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');

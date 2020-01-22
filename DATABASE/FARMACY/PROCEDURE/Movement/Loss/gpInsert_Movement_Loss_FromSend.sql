-- Function: gpInsert_Movement_Loss_FromSend

DROP FUNCTION IF EXISTS gpInsert_Movement_Loss_FromSend (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Loss_FromSend(
    IN inMovementID       Integer,   -- Перемещение
    IN inUnitId           Integer,   -- Подразделение
   OUT outLossID          Integer,   -- Списание
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbComent TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Документ перемещения не созранен.';
    END IF;
    
    SELECT Format('Перемещение %s от %s кол-во %s Сумма в ценах отправителя %s примечание %s'      
           , Movement_Send.InvNumber
           , TO_CHAR (Movement_Send.OperDate, 'dd.mm.yyyy')
           , MovementFloat_TotalCount.ValueData
           , MovementFloat_TotalSummFrom.ValueData
           , COALESCE (MovementString_Comment.ValueData , ''))
    INTO  vbComent

    FROM Movement AS Movement_Send
              
         LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                 ON MovementFloat_TotalCount.MovementId = Movement_Send.Id
                                AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
   
         LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                 ON MovementFloat_TotalSummFrom.MovementId =  Movement_Send.Id
                                AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()

         LEFT JOIN MovementString AS MovementString_Comment
                                  ON MovementString_Comment.MovementId = Movement_Send.Id
                                 AND MovementString_Comment.DescId = zc_MovementString_Comment()
    WHERE Movement_Send.Id = inMovementID;

    outLossID := gpInsertUpdate_Movement_Loss (ioId := 0
                                             , inInvNumber := CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar)
                                             , inOperDate := CURRENT_DATE
                                             , inUnitId := inUnitId
                                             , inArticleLossId := 0
                                             , inComment := vbComent
                                             , inSession := inSession);

      
    PERFORM lpInsertUpdate_MovementItem_Loss (ioId                 := COALESCE(MovementItemLoos.Id,0)
                                            , inMovementId         := outLossID
                                            , inGoodsId            := MovementItemSend.ObjectId
                                            , inAmount             := MovementItemSend.Amount
                                            , inUserId             := vbUserId)
    FROM (SELECT MovementItemSend.ObjectId
               , SUM(MovementItemSend.Amount) AS Amount
          FROM MovementItem AS MovementItemSend
          WHERE MovementItemSend.MovementId = inMovementID
            AND MovementItemSend.IsErased = False
            AND MovementItemSend.DescId = zc_MI_Master()
            AND MovementItemSend.Amount > 0
          GROUP BY MovementItemSend.ObjectId) AS MovementItemSend

         LEFT OUTER JOIN MovementItem AS MovementItemLoos
                                      ON MovementItemLoos.MovementId = outLossID  
                                     AND MovementItemLoos.ObjectId = MovementItemSend.ObjectId 
                                     AND MovementItemLoos.DescId = zc_MI_Master();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.01.20                                                       *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Loss_FromSend (inMovementId:= 1, inOperDate:= NULL);

-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Check (Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Check(
    IN inMovementId        Integer              , -- ключ Документа
    IN inPaidType          Integer              , --Тип оплаты 0-деньги, 1-карта
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
  vbUserId:= inSession;

  --Перебили дату документа 
  UPDATE Movement SET OperDate = CURRENT_TIMESTAMP WHERE Id = inMovementId;
  
  --прописали тип оплаты
  if inPaidType = 0 then
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Cash());
  ELSEIF inPaidType = 1 THEN
    PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Card());
  ELSE
    RAISE EXCEPTION 'Ошибка.Не определен тип оплаты';
  END IF;

  -- пересчитали Итоговые суммы
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

  -- собственно проводки
  PERFORM lpComplete_Movement_Check(inMovementId, -- ключ Документа
                                    vbUserId);    -- Пользователь                          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 06.07.15                                                                       *  Добавлен тип оплаты
 05.02.15                         * 

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

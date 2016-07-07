-- Function: gpSetErased_Movement_Over_Report (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Over_Report (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Over_Report(
    IN inUnitId              Integer   , -- от кого
    IN inOperDate            TDateTime , -- дата
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Over());
    vbUserId := inSession; 

      -- ищем ИД документа (ключ - дата, Подразделение) 
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        Inner Join MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitId
      WHERE Movement.DescId = zc_Movement_Over() AND Movement.OperDate = inOperDate
          AND Movement.StatusId <> zc_Enum_Status_Erased();

     IF COALESCE (vbMovementId,0) <> 0 THEN
     -- Удаляем Документ если найден
     PERFORM lpSetErased_Movement (inMovementId := vbMovementId
                                 , inUserId     := vbUserId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 06.07.16         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_Over_Report (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())

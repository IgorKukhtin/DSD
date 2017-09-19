-- Function: gpSetMobileErased_Movement_ReturnIn

DROP FUNCTION IF EXISTS gpSetMobileErased_Movement_ReturnIn (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSetMobileErased_Movement_ReturnIn (
    IN inMovementGUID TVarChar , -- глобальный уникальный идентификатор документа
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS VOID
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);
      
      -- определение идентификатора документа по глобальному уникальному идентификатору
      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement ON Movement.Id = MovementString_GUID.MovementId
                        AND Movement.DescId = zc_Movement_ReturnIn()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbId, 0) <> 0
      THEN
           PERFORM lpSetErased_Movement (inMovementId:= vbId, inUserId:= vbUserId);
      END IF;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 19.09.17                                                       *
*/

-- тест
-- SELECT * FROM gpSetMobileErased_Movement_ReturnIn (inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}', inSession:= zfCalc_UserAdmin())

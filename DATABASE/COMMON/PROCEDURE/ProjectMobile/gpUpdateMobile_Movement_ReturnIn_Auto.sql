-- Function: gpUpdateMobile_Movement_ReturnIn_Auto

DROP FUNCTION IF EXISTS gpUpdateMobile_Movement_ReturnIn_Auto (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_Movement_ReturnIn_Auto (
    IN inMovementGUID TVarChar , -- глобальный идентификатор документа
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS TBlob
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbId Integer;
  DECLARE vbMessageText Text:= '';
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
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbId, 0) <> 0
      THEN
           -- автоматом сформировалась строчная часть - zc_MI_Child
           vbMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := NULL
                                                          , inEndDateSale   := NULL
                                                          , inMovementId    := vbId
                                                          , inUserId        := vbUserId
                                                           );
      END IF;

      RETURN vbMessageText::TBlob;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 21.08.17                                                        *
*/

-- тест
-- SELECT gpUpdateMobile_Movement_ReturnIn_Auto (inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}', inSession:= zfCalc_UserAdmin());

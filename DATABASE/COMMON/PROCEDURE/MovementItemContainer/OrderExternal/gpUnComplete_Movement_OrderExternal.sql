-- Function: gpUnComplete_Movement_OrderExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outPrinted          Boolean               ,
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя

)
RETURNS Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDescId_From Integer;
BEGIN
     --из шапки документа получаем вид параметра <от кого>
     vbDescId_From := (SELECT Object.DescId
                       FROM MovementLinkObject AS MLO
                           LEFT JOIN Object ON Object.Id = MLO.ObjectId
                       WHERE MLO.MovementId = inMovementId 
                         AND MLO.DescId = zc_MovementLinkObject_From());

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, CASE WHEN vbDescId_From = zc_Object_Unit() THEN zc_Enum_Process_UnComplete_OrderExternalUnit() ELSE zc_Enum_Process_UnComplete_OrderExternal() END);


     -- меняем статус документа + сохранили протокол
     outPrinted := lpUnComplete_Movement_OrderExternal (inMovementId := inMovementId, inUserId := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.09.21         *
 21.04.17                                        *
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
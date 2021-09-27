-- Function: gpComplete_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderExternal(
    IN inMovementId        Integer              , -- ключ Документа
   OUT outPrinted          Boolean              ,
   OUT outMessageText      Text                 ,
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS RECORD
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
     vbUserId:= lpCheckRight (inSession, CASE WHEN vbDescId_From = zc_Object_Unit() THEN zc_Enum_Process_Complete_OrderExternalUnit() ELSE zc_Enum_Process_Complete_OrderExternal() END);

     -- меняем статус документа + сохранили протокол
     SELECT tmp.outPrinted, tmp.outMessageText
            INTO outPrinted, outMessageText
     FROM lpComplete_Movement_OrderExternal (inMovementId:= inMovementId
                                           , inUserId    := vbUserId
                                            ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.09.21         *
 21.04.17                                        *
 25.08.14                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_OrderExternal (inMovementId:= 579, inSession:= '2')

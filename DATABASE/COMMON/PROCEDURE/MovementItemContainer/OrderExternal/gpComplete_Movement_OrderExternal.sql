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
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                WHERE MLO.MovementId = inMovementId 
                  AND MLO.DescId     = zc_MovementLinkObject_From()
               )
     THEN
         -- так для zc_Object_Unit
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderExternalUnit());
     ELSE
         -- для остальных 
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderExternal());
     END IF;

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

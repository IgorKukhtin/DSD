-- Function: gpReComplete_Movement_byReport()

DROP FUNCTION IF EXISTS gpReComplete_Movement_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_byReport(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_());
     vbUserId:= lpGetUserBySession (inSession);
     
     IF vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Нет Прав.';
     END IF;
     
     
     IF COALESCE (inMovementId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не выбран.';
     END IF;
     

     PERFORM gpComplete_All_Sybase (inMovementId, FALSE, inSession);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 17.12.24
*/

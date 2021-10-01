-- Function: gpGet_ScaleCeh_Movement_checkStorageLine()

DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement_checkStorageLine (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleCeh_Movement_checkStorageLine(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (isStorageLine_empty Boolean
             , MessageStr          TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат - все ок
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId
                           , MovementItem.Amount
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId         = zc_MILinkObject_StorageLine()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.isErased   = FALSE
                        AND MILinkObject_StorageLine.ObjectId IS NULL
                      LIMIT 1
                     )
       SELECT CASE WHEN EXISTS (SELECT 1 FROM tmpMI) THEN FALSE ELSE TRUE END :: Boolean AS isStorageLine_empty
            , ('Для товара ' || lfGet_Object_ValueData ((SELECT tmpMI.ObjectId FROM tmpMI))
            || CHR(13) || 'Кол-во = <' || zfConvert_FloatToString ((SELECT tmpMI.Amount FROM tmpMI)) || '>'
            || CHR(13) || 'не установлено значение <Линия Производства>.'
              ) :: TVarChar AS MessageStr
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 03.06.17                                        *
*/

-- тест
-- SELECT * FROM gpGet_ScaleCeh_Movement_checkStorageLine (inMovementId:= 0, inSession:= '5')

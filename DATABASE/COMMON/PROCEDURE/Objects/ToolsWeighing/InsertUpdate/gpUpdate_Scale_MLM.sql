-- Function: gpUpdate_Scale_MLM()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MLM (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MLM(
    IN inMovementId        Integer   , -- Ключ объекта <документ>
    IN inDescCode          TVarChar  , -- 
    IN inMovementChildId   Integer   , -- 
    IN inSession           TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);


     IF inMovementId <> 0
     THEN
         -- сформировали связь 
         PERFORM lpInsertUpdate_MovementLinkMovement (MovementLinkMovementDesc.Id, inMovementId, inMovementChildId)
         FROM (SELECT inDescCode AS DescCode WHERE TRIM (inDescCode) <> '') AS tmp
              LEFT JOIN MovementLinkMovementDesc ON MovementLinkMovementDesc.Code = tmp.DescCode;

         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.08.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_MLM (inMovementItemId:= 0, inItemName:= 'zc_MILinkObject_BoxNumber', inValueData:= 1, inSession:= '5')

-- Function: gpInsert_Movement_Sale_FileName()

--   gpInsert_Movement_FileName
DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_FileName (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_FileName(
    IN inMovementId         Integer   , -- Id документа
    IN inFileName           TVarChar  ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);

      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_FileName()
                                           , inMovementId
                                           , inFileName ::TVarChar 
                                           );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.08.25         *
*/

-- тест
--
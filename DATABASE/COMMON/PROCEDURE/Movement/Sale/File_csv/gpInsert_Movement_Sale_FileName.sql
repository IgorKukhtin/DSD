-- Function: gpInsert_Movement_Sale_FileName()

DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_FileName (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_FileName(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inMovementId         Integer,    -- Id документа
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
      vbUserId:= lpGetUserBySession (inSession);

      gpGet_Movement_VNscv_FileName
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_FileName()
                                           , inMovementId
                                           , gpGet_Movement_VN_scv_FileName (inStartDate, inEndDate, inMovementId, inSession)
                                            ||' '
                                            ||(SELECT zfConvert_FIO(ValueData, 2, TRUE) FROM Object WHERE Id = vbUserId) ::TVarChar 
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
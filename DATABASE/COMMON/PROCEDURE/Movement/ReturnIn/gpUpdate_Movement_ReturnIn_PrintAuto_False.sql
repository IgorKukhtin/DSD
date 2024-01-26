-- Function: gpUpdate_Movement_ReturnIn_PrintAuto_False()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_PrintAuto_False (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_PrintAuto_False(
    IN inOperDate           TDateTime , --
    IN inUnitId             Integer   , -- склад
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PrintAuto(), tmp.Id, FALSE)
     FROM 
          (SELECT Movement.Id 
           FROM Movement
                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()
                                             AND MovementLinkObject_To.ObjectId = inUnitId
           WHERE Movement.OperDate = inOperDate
             AND Movement.DescId   = zc_Movement_ReturnIn()
             AND Movement.StatusId = zc_Enum_Status_Complete()
          ) AS tmp
     ;

     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.01.24          *
*/

-- тест
--  
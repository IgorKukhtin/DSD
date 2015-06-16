-- Function: lpSetErased_Movement_QualityDoc (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement_QualityDoc (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement_QualityDoc(
    IN inMovementId                 Integer   , -- 
    IN inUserId                     Integer     -- Пользователь
)                              
RETURNS Integer
AS
$BODY$
BEGIN
     -- 
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := inUserId
                                  );
     RETURN inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 22.05.15                                        *
*/

-- тест
-- SELECT * FROM lpSetErased_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')

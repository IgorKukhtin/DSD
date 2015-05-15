-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeSale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (InvNumberBranch TVarChar, BranchDate TDateTime, Checked Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               ''::TVarChar                                     AS InvNumberBranch
             , NULL::TDateTime                                  AS BranchDate
             , false                                            AS Checked;

     ELSE

     RETURN QUERY
       SELECT
             Movement_Income_View.InvNumberBranch
           , Movement_Income_View.BranchDate
           , Movement_Income_View.Checked
       FROM Movement_Income_View       
      WHERE Movement_Income_View.Id = inMovementId;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_IncomeSale (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.05.15                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_IncomeSale (inMovementId:= 0, inSession:= '9818')
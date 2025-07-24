-- Function: gpGet_Movement_Quality_ReportName_export()

DROP FUNCTION IF EXISTS gpGet_Movement_Quality_ReportName_export (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Quality_ReportName_export (
    IN inMovementId         Integer  , -- ключ Документа
   OUT outReportName_fr3    TVarChar ,
   OUT outFileName          TVarChar ,
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     IF inMovementId = 0
     THEN
         RAISE INFO 'Ошибка.inMovementId = <%>', inMovementId;
     END IF:
       
       
     outReportName_fr3:= gpGet_Movement_Quality_ReportName (inMovementId, inSession);
     --
     outFileName:= 'Doc_' || (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.07.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Quality_ReportName_export (inMovementId:= 21043705, inSession:= '5'); -- все

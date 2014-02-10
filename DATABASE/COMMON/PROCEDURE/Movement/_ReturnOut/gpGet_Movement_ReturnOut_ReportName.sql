-- Function: gpGet_Movement_ReturnOut_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnOut_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnOut_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnOut());

       SELECT
            COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_ReturnOut')
       INTO vbPrintFormName
       FROM Movement
       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.ReportType = 'ReturnOut'

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ReturnOut();

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnOut_ReportName (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.02.14                                                        *
*/

-- тест
--SELECT gpGet_Movement_ReturnOut_ReportName FROM gpGet_Movement_ReturnOut_ReportName(inMovementId := 35168,  inSession := '5'); -- все

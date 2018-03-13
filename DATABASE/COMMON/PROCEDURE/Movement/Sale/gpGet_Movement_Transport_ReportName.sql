-- Function: gpGet_Movement_Transport_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Transport_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Transport_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Transport());

       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_Transport')
              INTO vbPrintFormName
       FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     
            LEFT JOIN PrintForms_View
                   ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
                  AND PrintForms_View.JuridicalId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementLinkObject_To.ObjectId ELSE ObjectLink_Partner_Juridical.ChildObjectId END
                  AND PrintForms_View.ReportType = 'Transport'
                  AND PrintForms_View.DescId = zc_Movement_Sale()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Sale();

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Transport_ReportName (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.02.16         *
*/

-- тест
--SELECT gpGet_Movement_Transport_ReportName FROM gpGet_Movement_Transport_ReportName(inMovementId := 35168,  inSession := '5'); -- все

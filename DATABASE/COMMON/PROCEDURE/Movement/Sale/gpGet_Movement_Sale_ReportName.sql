-- Function: gpGet_Movement_Sale_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

       SELECT
            COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName)
       INTO vbPrintFormName
       FROM Movement
       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
              ON MovementLinkObject_To.MovementId = Movement.Id
             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
              ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
              ON MovementLinkObject_PaidKind.MovementId = Movement.Id
             AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
             AND PrintForms_View.ReportType = 'Sale'
             AND PrintForms_View.DescId = zc_Movement_Sale()

       LEFT JOIN PrintForms_View AS PrintForms_View_Default
              ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
             AND PrintForms_View_Default.JuridicalId = 0
             AND PrintForms_View_Default.ReportType = 'Sale'
             AND PrintForms_View_Default.PaidKindId = MovementLinkObject_PaidKind.ObjectId
             AND PrintForms_View_Default.DescId = zc_Movement_Sale()


       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Sale();

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_ReportName (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.02.14                                                        * + PaidKindId
 06.02.14                                                        *
 05.02.14                                                        *
*/

-- тест
-- SELECT gpGet_Movement_Sale_ReportName FROM gpGet_Movement_Sale_ReportName(inMovementId := 40874,  inSession := zfCalc_UserAdmin()); -- все

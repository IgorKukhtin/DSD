-- Function: gpGet_Movement_Sale_ReportNameBill()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_ReportNameBill (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_ReportNameBill (
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
             AND MovementLinkObject_PaidKind.DescId IN ( zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())

       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.JuridicalId = COALESCE( ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
             AND PrintForms_View.ReportType = 'Bill'
--             AND PrintForms_View.DescId = zc_Movement_Sale()

       LEFT JOIN PrintForms_View AS PrintForms_View_Default
              ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
             AND PrintForms_View_Default.JuridicalId = 0
             AND PrintForms_View_Default.ReportType = 'Bill'
             AND PrintForms_View_Default.PaidKindId = MovementLinkObject_PaidKind.ObjectId
--             AND PrintForms_View_Default.DescId = zc_Movement_Sale()


       WHERE Movement.Id =  inMovementId;
--         AND Movement.DescId = zc_Movement_Sale();

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_ReportNameBill (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.04.14                                                        *
*/

-- тест
-- SELECT gpGet_Movement_Sale_ReportNameBill FROM gpGet_Movement_Sale_ReportNameBill(inMovementId := 159646,  inSession := zfCalc_UserAdmin()); -- все
-- SELECT gpGet_Movement_Sale_ReportNameBill FROM gpGet_Movement_Sale_ReportNameBill(inMovementId := 123642,  inSession := zfCalc_UserAdmin()); -- ж/д
-- select * from gpGet_Movement_Sale_ReportNameBill(inMovementId := 185631 ,  inSession := '5');


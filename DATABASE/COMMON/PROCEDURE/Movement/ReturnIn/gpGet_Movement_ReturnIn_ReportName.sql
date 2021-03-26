-- Function: gpGet_Movement_ReturnIn_ReportName()

-- DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn_ReportName (Integer, TVarChar);
--
 DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn_ReportName (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inTypeName           TVarChar , --
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
            CASE WHEN inTypeName = 'zc_Movement_ReturnIn_Corr' AND COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName) = 'PrintMovement_ReturnIn'  -- вызов печати КОРЕГУЮЧА ТОВАРНА НАКЛАДНА
                     THEN 'PrintMovement_ReturnIn_corr'
                 ELSE COALESCE (PrintForms_View.PrintFormName, PrintForms_View_Default.PrintFormName)
            END
       INTO vbPrintFormName
       FROM Movement

       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
              ON MovementLinkObject_From.MovementId = Movement.Id
             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
              ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
              ON MovementLinkObject_PaidKind.MovementId = Movement.Id
             AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
             AND PrintForms_View.ReportType = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 'PriceCorrective' ELSE 'ReturnIn' END
             AND PrintForms_View.DescId = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN zc_Movement_PriceCorrective() ELSE zc_Movement_ReturnIn() END

       LEFT JOIN PrintForms_View AS PrintForms_View_Default
              ON Movement.OperDate BETWEEN PrintForms_View_Default.StartDate AND PrintForms_View_Default.EndDate
             AND PrintForms_View_Default.JuridicalId = 0
             AND PrintForms_View_Default.ReportType = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN 'PriceCorrective' ELSE 'ReturnIn' END
--             AND PrintForms_View_Default.PaidKindId = MovementLinkObject_PaidKind.ObjectId
             AND PrintForms_View_Default.DescId = CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN zc_Movement_PriceCorrective() ELSE zc_Movement_ReturnIn() END

       WHERE Movement.Id =  inMovementId;
--         AND Movement.DescId = zc_Movement_ReturnIn();

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnIn_ReportName (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 25.03.21         * rename inTypeName
 23.10.15         * add inDescName
 12.06.14                                        * add COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
 23.04.14                                                        * + PrintMovement_ReturnIn32049199
 06.02.14                                                        *
*/

-- тест
--SELECT * FROM gpGet_Movement_ReturnIn_ReportName(inMovementId := 139751,  inSession := '5'); -- Metro
--SELECT * FROM gpGet_Movement_ReturnIn_ReportName(inMovementId := 139752,  inSession := '5'); -- все

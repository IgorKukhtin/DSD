-- Function: gpGet_Movement_TaxCorrective_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_TaxCorrective_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbPartnerId Integer;
   DECLARE vbPrintFormName TVarChar;
    DECLARE vbMovementId_TaxCorrective Integer;
    DECLARE vbStatusId_TaxCorrective Integer;

BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TaxCorrective());

     SELECT COALESCE (tmpMovement.MovementId_TaxCorrective, 0) AS MovementId_TaxCorrective
          , Movement_TaxCorrective.StatusId                    AS StatusId_TaxCorrective
            INTO vbMovementId_TaxCorrective, vbStatusId_TaxCorrective
     FROM (SELECT CASE WHEN Movement.DescId = zc_Movement_TaxCorrective()
                            THEN inMovementId
                       ELSE MovementLinkMovement_Master.MovementChildId
                  END AS MovementId_TaxCorrective
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
           WHERE Movement.Id = inMovementId
          ) AS tmpMovement
          INNER JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = tmpMovement.MovementId_TaxCorrective
                                                       AND (Movement_TaxCorrective.StatusId = zc_Enum_Status_Complete() OR tmpMovement.MovementId_TaxCorrective = inMovementId);




--результат

       SELECT
            COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TaxCorrective')
       INTO vbPrintFormName
       FROM Movement

       LEFT JOIN PrintForms_View
              ON Movement.OperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
             AND PrintForms_View.ReportType = 'TaxCorrective'

       WHERE Movement.Id =  vbMovementId_TaxCorrective
         AND Movement.DescId = zc_Movement_TaxCorrective();


     RETURN (vbPrintFormName);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.11.14                                                        *
 10.02.14                                                        *
*/

-- тест
--SELECT gpGet_Movement_TaxCorrective_ReportName FROM gpGet_Movement_TaxCorrective_ReportName(inMovementId := 40874,  inSession := '5'); -- все

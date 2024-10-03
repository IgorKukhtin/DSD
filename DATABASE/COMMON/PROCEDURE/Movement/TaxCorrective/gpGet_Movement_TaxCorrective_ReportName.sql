-- Function: gpGet_Movement_TaxCorrective_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_TaxCorrective_ReportName (
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPartnerId Integer;
   DECLARE vbPrintFormName TVarChar;
   DECLARE vbMovementId_TaxCorrective Integer;
   DECLARE vbStatusId_TaxCorrective Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- поиск даты
     SELECT MAX (CASE WHEN tmpMovement.OperDate1 > tmpMovement.OperDate2 THEN tmpMovement.OperDate1 ELSE tmpMovement.OperDate2 END)
            INTO vbOperDate
     FROM (SELECT CASE /*WHEN (CURRENT_DATE >= '01.03.2021'  OR vbUserId = 5) AND COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                            THEN '01.03.2021'
                       */

                       WHEN COALESCE (MovementString_InvNumberRegistered.ValueData, '') = ''
                            THEN '01.10.2024'

                       WHEN Movement_find.OperDate < '01.03.2017' AND MovementDate_DateRegistered.ValueData >= '01.03.2017'
                            THEN Movement_find.OperDate
                       ELSE COALESCE (MovementDate_DateRegistered.ValueData, Movement_find.OperDate)
                       -- ELSE COALESCE (MovementDate_DateRegistered.ValueData, CURRENT_DATE)
                  END AS OperDate1
                , Movement_find.OperDate AS OperDate2
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- печатаем всегда все корректировки
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()

                LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                          ON MovementBoolean_isAuto.MovementId = Movement.Id
                                         AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                             ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                            AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()

                INNER JOIN Movement AS Movement_find ON Movement_find.Id  = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    --AND Movement_find.StatusId = zc_Enum_Status_UnComplete()   -- док. предоплаты можно печатать и не проведенные
                                                    AND (Movement_find.StatusId = zc_Enum_Status_Complete() OR COALESCE (MovementBoolean_isAuto.ValueData, FALSE) = TRUE OR MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_ChangePercent())
                LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                       ON MovementDate_DateRegistered.MovementId = Movement.Id
                                      AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
                LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                         ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                        AND MovementString_InvNumberRegistered.DescId     = zc_MovementString_InvNumberRegistered()

                --zc_Enum_DocumentTaxKind_Prepay() Предоплата    -- Тип формирования налогового документа
                /*LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                             ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                            AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                         ---MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Prepay()
                */

           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
          UNION
           SELECT CASE WHEN Movement_Master.OperDate < '01.03.2017' AND MovementDate_DateRegistered.ValueData >= '01.03.2017'
                            THEN Movement_Master.OperDate
                       -- ELSE COALESCE (MovementDate_DateRegistered.ValueData, Movement_Master.OperDate)
                       ELSE COALESCE (MovementDate_DateRegistered.ValueData, CURRENT_DATE)
                  END AS OperDate1
                , Movement_Master.OperDate AS OperDate2
           FROM Movement
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                               AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_Master ON Movement_Master.Id  = MovementLinkMovement_Master.MovementId
                                                      AND Movement_Master.StatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                       ON MovementDate_DateRegistered.MovementId = Movement_Master.Id
                                      AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
          ) AS tmpMovement;


       -- поиск формы
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TaxCorrective')
              INTO vbPrintFormName
       FROM PrintForms_View
       WHERE vbOperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
         AND PrintForms_View.ReportType = 'TaxCorrective';


       -- Результат
       RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.03.16                                        *
 25.11.14                                                        *
 10.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_TaxCorrective_ReportName (inMovementId:= 3412647, inSession:= '5'); -- все

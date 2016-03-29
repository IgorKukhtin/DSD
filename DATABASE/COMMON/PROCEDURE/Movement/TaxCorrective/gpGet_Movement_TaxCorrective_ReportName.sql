-- Function: gpGet_Movement_TaxCorrective_ReportName()

DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_TaxCorrective_ReportName (
    IN inMovementId         Integer  , -- ���� ���������
    IN inSession            TVarChar   -- ������ ������������
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
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());


     -- ����� ����
     SELECT MAX (CASE WHEN tmpMovement.OperDate1 > tmpMovement.OperDate2 THEN tmpMovement.OperDate1 ELSE tmpMovement.OperDate2 END)
            INTO vbOperDate
     FROM (SELECT COALESCE (MovementDate_DateRegistered.ValueData, Movement_find.OperDate) AS OperDate1
                , Movement_find.OperDate AS OperDate2
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- �������� ������ ��� �������������
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_find ON Movement_find.Id  = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    AND Movement_find.StatusId = zc_Enum_Status_Complete()
                LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                       ON MovementDate_DateRegistered.MovementId = Movement.Id
                                      AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
          UNION
           SELECT COALESCE (MovementDate_DateRegistered.ValueData, Movement_Master.OperDate) AS OperDate1
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


       -- ����� �����
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintMovement_TaxCorrective')
              INTO vbPrintFormName
       FROM PrintForms_View
       WHERE vbOperDate BETWEEN PrintForms_View.StartDate AND PrintForms_View.EndDate
         AND PrintForms_View.ReportType = 'TaxCorrective';


       -- ���������
       RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TaxCorrective_ReportName (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.03.16                                        *
 25.11.14                                                        *
 10.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_TaxCorrective_ReportName (inMovementId:= 3412647, inSession:= '5'); -- ���

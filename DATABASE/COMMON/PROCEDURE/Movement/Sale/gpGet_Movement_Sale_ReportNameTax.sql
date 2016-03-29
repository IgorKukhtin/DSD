-- Function: gpGet_Movement_Sale_ReportNameTax()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_ReportNameTax (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_ReportNameTax (
    IN inMovementId         Integer  , -- ���� ���������
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbPartnerId Integer;
   DECLARE vbPrintFormName TVarChar;
   DECLARE vbMovementId_Sale Integer;
   DECLARE vbMovementId_Tax Integer;
    DECLARE vbStatusId_Tax Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

     -- ������������ <��������� ��������> � ��� ���������
     SELECT COALESCE (tmpMovement.MovementId_Tax, 0) AS MovementId_Tax
          , Movement_Tax.StatusId                    AS StatusId_Tax
     INTO vbMovementId_Tax, vbStatusId_Tax
     FROM (SELECT CASE WHEN Movement.DescId = zc_Movement_Tax()
                            THEN inMovementId
                       ELSE MovementLinkMovement_Master.MovementChildId
                  END AS MovementId_Tax
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
           WHERE Movement.Id = inMovementId
          ) AS tmpMovement
          LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = tmpMovement.MovementId_Tax

     ;

     -- ����� ������ ��������
     IF COALESCE (vbMovementId_Tax, 0) = 0 OR COALESCE (vbStatusId_Tax, 0) <> zc_Enum_Status_Complete()
     THEN
         IF COALESCE (vbMovementId_Tax, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� <%> �� ������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax());
         END IF;
         IF vbStatusId_Tax = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_Tax);
         END IF;
         IF vbStatusId_Tax = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_Tax AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_Tax);
         END IF;
         -- ��� ��� �������� ������
         RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax());
     END IF;


     -- ������������ <������� ����������> ��� <������� ����� (������)>
     SELECT COALESCE(CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                               THEN inMovementId
                          ELSE MovementLinkMovement_Master.MovementId
                     END, 0)
            INTO vbMovementId_Sale
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
     WHERE Movement.Id = inMovementId;

     -- ���������
     vbPrintFormName:= gpGet_Movement_Tax_ReportName (inMovementId:= vbMovementId_Tax, inSession:= inSession);
--       WHERE Movement.Id =  vbMovementId_Tax;
--         AND Movement.DescId = zc_Movement_Sale();


     RETURN (vbPrintFormName);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_ReportNameTax (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.11.14                                                        *
 05.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Sale_ReportNameTax (inMovementId:= 3402070, inSession:= '5');

-- Function: gpInsert_Movement_Invoice_PaperRecipeSP()

DROP FUNCTION IF EXISTS gpInsert_Movement_Invoice_PaperRecipeSP (TDateTime, TDateTime, Integer, Integer, TDateTime, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Invoice_PaperRecipeSP(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inJuridicalId      Integer  ,  -- ��.����

    IN inJuridicalMedicId Integer  ,  -- ��.���� ����������
    
    IN inDateInvoice      TDateTime  , -- ���� �����
    IN inInvoice          TVarChar   , -- ����
    IN inisInsert         Boolean    , -- �������� ���� (��/���)

    IN inSession          TVarChar     -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMedicSPId Integer;
   DECLARE vbMemberSPId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
    vbUserId := inSession;

    IF COALESCE (inJuridicalId, 0) = 0
    THEN
       RAISE EXCEPTION '������.�� ������� ��.����';
    END IF;

    IF COALESCE (inJuridicalMedicId, 0) = 0
    THEN
       RAISE EXCEPTION '������.�� ������ ��.���� ����������.';
    END IF;

    IF COALESCE (inisInsert, FALSE) = FALSE
    THEN
       RETURN;
    END IF;

    CREATE TEMP TABLE tmpReport (MovementId_Check Integer, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer, SummaComp TFloat, CountSP TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpInvoice (MovementId Integer, InvNumber TVarChar, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer) ON COMMIT DROP;

     -- �������� ������ �� ������
     INSERT INTO tmpReport (MovementId_Check, JuridicalId, PartnerMedicalId, ContractId, SummaComp, CountSP)
       SELECT  tmp.MovementId
             , tmp.JuridicalId
             , inJuridicalMedicId
             , Null
             , SUM (tmp.SummaComp)          AS SummaComp
             , SUM (tmp.CountSP)            AS CountSP
       FROM (SELECT  tmp.Id                           AS MovementId
                   , tmp.JuridicalId
                   , 0                                AS HospitalId
                   , SUM (tmp.SummaSP)                AS SummaComp
                   , COUNT (DISTINCT tmp.InvNumberSP) AS CountSP
             FROM gpReport_PaperRecipeSP(inStartDate:=inStartDate, inEndDate:=inEndDate, inJuridicalId:=inJuridicalId
                                       , inSession:=inSession) AS tmp
             GROUP BY tmp.Id
                    , tmp.JuridicalId
             ) AS tmp
             
       GROUP BY tmp.MovementId
              , tmp.JuridicalId;

     -- ���� , ����� ��� ������ ����
     INSERT INTO tmpInvoice (MovementId, InvNumber, JuridicalId, PartnerMedicalId, ContractId)
     SELECT Movement.Id AS MovementId
          , Movement.InvNumber 
          , COALESCE (MovementLinkObject_Juridical.ObjectId,0)      AS JuridicalId
          , COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) AS PartnerMedicalId 
          , COALESCE (MovementLinkObject_Contract.ObjectId,0)       AS ContractId
     FROM Movement 
        INNER JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                               AND MovementDate_OperDateStart.ValueData = inStartDate
        INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                               AND MovementDate_OperDateEnd.ValueData = inEndDate
        INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                      ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                     AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                     AND (COALESCE (MovementLinkObject_Juridical.ObjectId,0) = inJuridicalId OR inJuridicalId = 0)
        
        INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                      ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                     AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                     AND MovementLinkObject_PartnerMedical.ObjectId = inJuridicalMedicId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.DescId = zc_Movement_Invoice()
      AND Movement.OperDate >= inDateInvoice AND Movement.OperDate <inDateInvoice + interval '1 day'
      AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'')
    LIMIT 1;


    -- ��������� <��������>
    PERFORM lpInsertUpdate_Movement_Invoice (ioId              := COALESCE (tmpInvoice.MovementId, 0)
                                           , inInvNumber       := COALESCE (inInvoice,'')
                                           , inOperDate        := inDateInvoice
                                           , inJuridicalId     := tmpReport.JuridicalId
                                           , inPartnerMedicalId:= tmpReport.PartnerMedicalId
                                           , inContractId      := tmpReport.ContractId
                                           , inStartDate       := inStartDate
                                           , inEndDate         := inEndDate
                                           , inTotalSumm       := SUM (tmpReport.SummaComp):: Tfloat
                                           , inTotalCount      := SUM (tmpReport.CountSP)  :: Tfloat
                                           , inChangePercent   := 0 :: TFloat
                                           , inValueSP         := 1 :: Tfloat
                                           , inUserId          := vbUserId
                                           )
     FROM tmpReport
        LEFT JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND COALESCE (tmpInvoice.ContractId,0) = COALESCE (tmpReport.ContractId,0)
     GROUP BY tmpReport.JuridicalId
            , tmpReport.PartnerMedicalId
            , tmpReport.ContractId
            , COALESCE (tmpInvoice.MovementId, 0);

     --�������� ���. �����, ���� �������� ������ ���������� ����� 
     DELETE FROM tmpInvoice;
     INSERT INTO tmpInvoice (MovementId, InvNumber, JuridicalId, PartnerMedicalId, ContractId)
     SELECT MAX (Movement.Id) AS MovementId
          , MAX (Movement.Id)
          , COALESCE (MovementLinkObject_Juridical.ObjectId,0)      AS JuridicalId
          , COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) AS PartnerMedicalId 
          , COALESCE (MovementLinkObject_Contract.ObjectId,0)       AS ContractId
     FROM Movement 
        INNER JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                               AND MovementDate_OperDateStart.ValueData = inStartDate
        INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                               AND MovementDate_OperDateEnd.ValueData = inEndDate
        INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                      ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                     AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                     AND (COALESCE (MovementLinkObject_Juridical.ObjectId,0) = inJuridicalId OR inJuridicalId = 0)
        
        INNER JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                      ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                     AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                     AND MovementLinkObject_PartnerMedical.ObjectId = inJuridicalMedicId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.DescId = zc_Movement_Invoice()
      AND Movement.OperDate >= inDateInvoice AND Movement.OperDate <inDateInvoice + interval '1 day'
     -- AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'')
    GROUP BY COALESCE (MovementLinkObject_Juridical.ObjectId,0)  
           , COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) 
           , COALESCE (MovementLinkObject_Contract.ObjectId,0)  
    ;

   -- ������ �� �������� ����
   PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), tmpReport.MovementId_Check, tmpInvoice.MovementId)
   FROM tmpReport
        INNER JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND COALESCE (tmpInvoice.ContractId,0) = COALESCE (tmpReport.ContractId,0);

    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%>', inSession;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 11.04.22                                                                    *
*/


-- 

select * from gpInsert_Movement_Invoice_PaperRecipeSP(inStartDate := ('01.03.2022')::TDateTime , inEndDate := ('12.04.2022')::TDateTime , inJuridicalId := 1311462 , inJuridicalMedicId := 10959824 , inDateInvoice := ('01.01.2017')::TDateTime , inInvoice := '0' , inisInsert := 'True' ,  inSession := '3');
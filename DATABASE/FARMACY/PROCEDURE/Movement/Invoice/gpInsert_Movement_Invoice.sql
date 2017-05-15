-- Function: gpInsert_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsert_Movement_Invoice (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, Boolean, TDateTime,  TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Invoice(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inJuridicalId      Integer  ,  -- ��.����
    IN inUnitId           Integer  ,  -- ������
    IN inPartnerMedicalId Integer  ,  -- ��������
    IN inGroupMemberSPId  Integer  ,  -- ��������� ��������
    IN inPercentSP        TFloat   ,  -- % ������
    IN inisGroupMemberSP  Boolean  ,  -- ����� ��������� ��������� ��������

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

    IF COALESCE (inisInsert, FALSE) = FALSE
       THEN
           RETURN;
    END IF;

    CREATE TEMP TABLE tmpReport (MovementId_Sale Integer, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer, SummaComp TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpInvoice (MovementId Integer, InvNumber TVarChar, JuridicalId Integer, PartnerMedicalId Integer,  ContractId Integer) ON COMMIT DROP;

     -- �������� ������ �� ������
     INSERT INTO tmpReport (MovementId_Sale, JuridicalId, PartnerMedicalId, ContractId, SummaComp)
       SELECT  tmp.MovementId
             , tmp.JuridicalId
             , tmp.HospitalId
             , tmp.ContractId
             , SUM(tmp.SummaComp) AS SummaComp
       FROM gpReport_Sale_SP(inStartDate := inStartDate, inEndDate := inEndDate, inJuridicalId :=inJuridicalId, inUnitId := inUnitId, inHospitalId := inPartnerMedicalId
                           , inGroupMemberSPId := inGroupMemberSPId, inPercentSP := inPercentSP, inisGroupMemberSP := inisGroupMemberSP, inSession := inSession) AS tmp
       GROUP BY tmp.MovementId
              , tmp.JuridicalId
              , tmp.HospitalId
              , tmp.ContractId;

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
                                     AND (COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) = inPartnerMedicalId OR inPartnerMedicalId = 0)

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.DescId = zc_Movement_Invoice()
      AND Movement.OperDate >= inDateInvoice AND Movement.OperDate <inDateInvoice + interval '1 day'
      AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'');


    -- ��������� <��������>
    PERFORM lpInsertUpdate_Movement_Invoice (ioId              := COALESCE (tmpInvoice.MovementId, 0)
                                           , inInvNumber       := COALESCE (inInvoice,'')
                                           , inOperDate        := inDateInvoice
                                           , inJuridicalId     := tmpReport.JuridicalId
                                           , inPartnerMedicalId:= tmpReport.PartnerMedicalId
                                           , inContractId      := tmpReport.ContractId
                                           , inStartDate       := inStartDate
                                           , inEndDate         := inEndDate
                                           , inTotalSumm       := SUM(tmpReport.SummaComp):: Tfloat
                                           , inValueSP         := 2 :: Tfloat
                                           , inUserId          := vbUserId
                                           )
     FROM tmpReport
        LEFT JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND tmpInvoice.ContractId = tmpReport.ContractId
     GROUP BY tmpReport.JuridicalId
            , tmpReport.PartnerMedicalId
            , tmpReport.ContractId
            , COALESCE (tmpInvoice.MovementId, 0);

     --�������� ���. �����, ���� �������� ������ ���������� ������ 
     DELETE FROM tmpInvoice;
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
                                     AND (COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) = inPartnerMedicalId OR inPartnerMedicalId = 0)

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
    WHERE Movement.StatusId <> zc_Enum_Status_Erased()
      AND Movement.DescId = zc_Movement_Invoice()
      AND Movement.OperDate >= inDateInvoice AND Movement.OperDate <inDateInvoice + interval '1 day'
  --    AND COALESCE (Movement.InvNumber,'') = COALESCE (inInvoice,'')
    ;

   -- ������ �� �������� ����
   PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), tmpReport.MovementId_Sale, tmpInvoice.MovementId)
   FROM tmpReport
        INNER JOIN tmpInvoice ON tmpInvoice.JuridicalId = tmpReport.JuridicalId 
                             AND tmpInvoice.PartnerMedicalId = tmpReport.PartnerMedicalId 
                             AND tmpInvoice.ContractId = tmpReport.ContractId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 13.05.17         * add inValueSP
 22.03.17         *
*/
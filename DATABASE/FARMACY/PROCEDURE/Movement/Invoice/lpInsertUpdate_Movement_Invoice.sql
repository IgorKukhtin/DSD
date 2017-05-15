-- Function: lpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inJuridicalId           Integer    , -- ���� (����������)
    IN inPartnerMedicalId      Integer    , -- ����������� ����������(���. ������)
    IN inContractId            Integer    , -- �������
    IN inStartDate             TDateTime  , -- ���� ���.
    IN inEndDate               TDateTime  , -- ���� ���.
    IN inTotalSumm             TFloat     , -- �����
    IN inValueSP               Tfloat     , -- ��� ���. �������
    IN inUserId                Integer      -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ��������
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
      
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerMedical(), ioId, inPartnerMedicalId);
 
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inStartDate);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inEndDate);    

    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SP(), ioId, inValueSP);
  
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 13.05.17         * add inValueSP
 22.03.17         *
*/
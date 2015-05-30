-- Function: lpInsertUpdate_Movement_Medoc()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Medoc 
   (Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Medoc(
 INOUT ioId                  Integer    , 
    IN inMedocCode           Integer    ,
    IN inInvNumberPartner    TVarChar   , -- �����
    IN inOperDate            TDateTime  , -- ����
    IN inFromINN             TVarChar   , -- ��� �� ����
    IN inToINN               TVarChar   , -- ��� ����
    IN inInvNumberBranch     TVarChar   , -- ������
    IN inInvNumberRegistered TVarChar   , -- �����
    IN inDateRegistered      TDateTime  , -- ����
    IN inDocKind             TVarChar   , -- ��� ���������
    IN inContract            TVarChar   , -- �������
    IN inTotalSumm           TFloat     , -- ����� ���������
    IN inUserId              Integer      -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbisIncome Boolean;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     SELECT ObjectBoolean_isCorporate.ValueData INTO vbisIncome FROM ObjectHistory_JuridicalDetails_View AS Juridical
                 JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                    ON ObjectBoolean_isCorporate.ObjectId = Juridical.JuridicalId 
                                   AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
         WHERE Juridical.INN = inToINN;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Medoc(), inMedocCode::TVarChar, inOperDate, NULL);

     -- ��������� �������� <����� ���������� ���������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);

     -- ��������� �������� <��� �� ����>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_FromINN(), ioId, inFromINN);

     -- ��������� �������� <��� ����>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_ToINN(), ioId, inToINN);

     -- ��������� �������� <������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), ioId, inInvNumberBranch);
     
     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberRegistered(), ioId, inInvNumberRegistered);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), ioId, inDocKind);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Contract(), ioId, inContract);

     PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_DateRegistered(), ioId, inDateRegistered);

     -- ������
     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_isIncome(), ioId, vbisIncome);

     -- ��������� �������� <�����  ����� (�������) >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);

     -- ��������� ��������
--     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.05.15                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Loss (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')

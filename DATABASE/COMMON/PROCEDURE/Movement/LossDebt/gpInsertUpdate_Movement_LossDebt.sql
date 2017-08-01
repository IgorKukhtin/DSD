-- Function: gpInsertUpdate_Movement_LossDebt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LossDebt (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LossDebt (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LossDebt(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inBusinessId          Integer   , -- ������
    IN inJuridicalBasisId    Integer   , -- ������� ��. ����
    IN inAccountId           Integer   , -- ����
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inisList              Boolean   , 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_LossDebt());

     -- ���������� ���� �������
     -- vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_LossDebt());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_LossDebt(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Business(), ioId, inBusinessId);

     -- ��������� ����� � <���� ���� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
          
     -- ��������� ����� � <������� ��. ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JuridicalBasis(), ioId, inJuridicalBasisId);
     
     -- ��������� ����� � <����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Account(), ioId, inAccountId);

     -- ��������� �������� <������ ��� ������ (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), ioId, inisList);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.04.16         *
 13.09.14                                        * add lpInsert_MovementProtocol
 25.03.14         * add PaidKind                   
 06.03.14         * add Account               
 14.01.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_LossDebt (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')

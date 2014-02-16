-- Function: gpInsertUpdate_Movement_BankStatement()

-- DROP FUNCTION gpInsertUpdate_Movement_BankStatement();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_BankStatement(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFileName            TVarChar  , -- ��� �����
    IN inBankAccountId       Integer   , -- ��������� ����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankStatement());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_BankStatement(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <��� �����>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_FileName(), ioId, inFileName);

     -- ��������� ����� � <��������� ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankAccount(), ioId, inBankAccountId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 08.08.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_BankStatement (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')

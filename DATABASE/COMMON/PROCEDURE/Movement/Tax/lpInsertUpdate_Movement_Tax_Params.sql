-- Function: lpInsertUpdate_Movement_Tax_Params()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Tax_Params (Integer, TVarChar, TDateTime, TDateTime, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Tax_Params(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inDateRegistered      TDateTime , -- ���� �����������
    IN inRegistered          Boolean   , -- ���������������� (��/���)
    IN inContractId          Integer   , -- ��������
    IN inUserId              Integer     -- ������������
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- ���������� ���� �������
--      vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Tax());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Tax(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     --Date
     -- ��������� �������� <���� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), ioId, inDateRegistered);

     --String

     --Boolean
     -- ��������� �������� <���������������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), ioId, inRegistered);

     --Float
     --Link
     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.02.14                                                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Tax_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inUserId:=24)
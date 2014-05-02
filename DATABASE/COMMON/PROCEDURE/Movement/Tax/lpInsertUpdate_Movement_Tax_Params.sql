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
BEGIN
     -- ��������� �������� <���� �����������>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), ioId, inDateRegistered);

     -- ��������� �������� <��������������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), ioId, inRegistered);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 01.05.14                                        * ����� ���� ��������� ������ 2 ���������
 09.02.14                                                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Tax_Params (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inDateRegistered:= '01.01.2013', inRegistered:= FALSE, inContractId:= 1, inUserId:=24)

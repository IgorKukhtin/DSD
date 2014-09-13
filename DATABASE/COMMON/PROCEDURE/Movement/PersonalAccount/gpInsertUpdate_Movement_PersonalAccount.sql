-- Function: gpInsertUpdate_Movement_PersonalAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalAccount (Integer, TVarChar, TDateTime, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalAccount(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPersonalId          Integer   , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalAccount());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalAccount());

     -- ��������
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalAccount(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.09.14                                        * add lpInsert_MovementProtocol
 14.01.14                                        * rem lpInsertUpdate_MovementFloat_TotalSumm
 18.12.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PersonalAccount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')

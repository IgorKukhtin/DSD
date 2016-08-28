-- Function: gpInsertUpdate_Movement_EntryAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EntryAsset (Integer, TVarChar, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EntryAsset(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EntryAsset());
                                              
    -- ���������� ���� �������
    -- vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_EntryAsset());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_EntryAsset(), inInvNumber, inOperDate, NULL);


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
 27.08.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EntryAsset (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')

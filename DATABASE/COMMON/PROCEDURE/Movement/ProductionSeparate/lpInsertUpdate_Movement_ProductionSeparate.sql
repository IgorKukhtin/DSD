-- Function: lpInsertUpdate_Movement_ProductionSeparate (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ProductionSeparate (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ProductionSeparate(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inUserId              Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- ���������� ���� �������
   -- vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_ProductionSeparate());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <��������>
   ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProductionSeparate(), inInvNumber, inOperDate, NULL, vbAccessKeyId, inUserId);

   -- ��������� ����� � <�� ���� (� ���������)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
   -- ��������� ����� � <���� (� ���������)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), ioId, inPartionGoods);

   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.06.15                                        *
 28.05.14                                                        *
 16.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_ProductionSeparate (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')

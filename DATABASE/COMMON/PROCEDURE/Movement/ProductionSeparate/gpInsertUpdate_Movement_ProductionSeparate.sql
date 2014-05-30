-- Function: gpInsertUpdate_Movement_ProductionSeparate()

-- DROP FUNCTION gpInsertUpdate_Movement_ProductionSeparate();
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionSeparate (integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionSeparate(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionSeparate()());
   vbUserId := inSession;

   -- ��������� <��������>
   ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ProductionSeparate(), inInvNumber, inOperDate, NULL);

   -- ��������� ����� � <�� ���� (� ���������)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
   -- ��������� ����� � <���� (� ���������)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), ioId, inPartionGoods);

   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

   -- ��������� ��������
   -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.05.14                                                        *
 16.07.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ProductionSeparate (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')

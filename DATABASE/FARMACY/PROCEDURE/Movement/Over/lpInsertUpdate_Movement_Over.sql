-- Function: lpInsertUpdate_Movement_Over (Integer, TVarChar, TDateTime, Integer, Integer, Boolean, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Over (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Over(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   
   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <��������>
   ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Over(), inInvNumber, inOperDate, NULL);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


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
 05.07.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Over (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')

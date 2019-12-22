-- Function: lpInsertUpdate_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IlliquidUnit(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inFullInvent          Boolean   , -- ������ ��������������
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_IlliquidUnit());

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_IlliquidUnit(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � <������������� � ���������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- ��������� ������� <������ ��������������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FullInvent(), ioId, inFullInvent);

     -- ��������� <����������>
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
 20.12.19                                                       *
 */

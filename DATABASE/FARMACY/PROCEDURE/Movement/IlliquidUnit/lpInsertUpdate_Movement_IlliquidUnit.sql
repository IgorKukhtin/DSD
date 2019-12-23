-- Function: lpInsertUpdate_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IlliquidUnit(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inDayCount            Integer   , -- ���� ��� ������ ��
    IN inProcGoods           TFloat    , -- % ������� ��� ���. 
    IN inProcUnit            TFloat    , -- % ���. �� ������. 
    IN inPenalty             TFloat    , -- ����� �� 1% �����. 
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC ('month', inOperDate)
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

     -- ��������� ������� <���� ��� ������ ��>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), ioId, inDayCount);

     -- ��������� ������� <% ������� ��� ���.>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ProcGoods(), ioId, inProcGoods);

     -- ��������� ������� <% ���. �� ������. >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ProcUnit(), ioId, inProcUnit);

     -- ��������� ������� <����� �� 1% �����. >
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Penalty(), ioId, inPenalty);

     -- ��������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
 */

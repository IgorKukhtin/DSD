-- Function: lpInsertUpdate_MovementItem_EmployeeSchedule()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_EmployeeSchedule (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_EmployeeSchedule(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonId            Integer   , -- ���������
    IN inComingValueDay      TVarChar  , -- ������� �� ������ �� ����
    IN inComingValueDayUser  TVarChar  , -- ������� �� ������ �� ����
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonId, inMovementId, 0, NULL);

    -- ��������� <������� �� ����>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDay(), ioId, inComingValueDay);

    -- ��������� <������� �� ����>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDayUser(), ioId, inComingValueDayUser);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 13.03.19         *
 09.12.18         *
*/
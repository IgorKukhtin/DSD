-- Function: lpInsert_Movement_OrderInternal()
DROP FUNCTION IF EXISTS lpInsert_Movement_OrderInternal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_OrderInternal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inOrderKindId         Integer   , -- 
    IN inMasterId            Integer   , -- �������� ������ ���������� (������-������)
    IN inUserId              Integer    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0; 

    IF (COALESCE(ioId, 0) = 0) AND (COALESCE(inInvNumber, '') = '') THEN
        inInvNumber := (NEXTVAL ('movement_OrderInternal_seq'))::TVarChar;
    END IF;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternal(), inInvNumber, inOperDate, NULL);

    -- ��������� ����� � <�������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

    -- ��������� ����� � ��� ������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_OrderKind(), ioId, inOrderKindId);

    -- ��������� ����� � <���������� �������>
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), ioId, inMasterId);
     
    -- !!!�������� ����� �������� ����������� �������!!!
    IF vbIsInsert = TRUE
    THEN
        -- ��������� �������� <���� ��������>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
        -- ��������� �������� <������������ (��������)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.19         *
*/

-- ����
-- 
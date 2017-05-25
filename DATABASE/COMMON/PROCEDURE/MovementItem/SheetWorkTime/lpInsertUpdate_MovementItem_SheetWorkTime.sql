-- Function: lpInsertUpdate_MovementItem_SheetWorkTime ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, Integer, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SheetWorkTime (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SheetWorkTime(
    IN inMovementItemId      Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inMemberId            Integer   , -- �������
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inStorageLineId       Integer   , -- ����� �����-��
    IN inAmount              TFloat    , -- ���������� ����� ����
    IN inWorkTimeKindId      Integer     -- ���� �������� �������
)                              
RETURNS Integer AS
$BODY$
BEGIN
     
     -- ��������� <������� ���������>
     inMovementItemId := lpInsertUpdate_MovementItem (inMovementItemId, zc_MI_Master(), inMemberId, inMovementId, inAmount, NULL);
     
     -- ��������� ����� � <����������� �����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalGroup(), InMovementItemId, inPersonalGroupId);
     -- ��������� ����� � <����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), InMovementItemId, inPositionId);
     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), InMovementItemId, inPositionLevelId);
     -- ��������� ����� � <���� �������� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), InMovementItemId, inWorkTimeKindId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), InMovementItemId, inStorageLineId);

     RETURN inMovementItemId;
 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.17         * add StorageLine
 07.01.14                         * Replace inPersonalId <> inMemberId
 25.11.13                         * 
 03.10.13         * 

*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_SheetWorkTime (InMovementItemId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:= 0, inSession:= '2')

-- Function: lpInsertUpdate_MI_PromoBonus_Child ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PromoBonus_Child (Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PromoBonus_Child(
 INOUT inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ���������
    IN inParentId            Integer   , -- 
    IN inUnitId              Integer   , -- �������������
    IN inMarginPercent       TFloat    , -- % ������� �� �����
    IN inUserId              Integer   -- ���������� ����� ����
 )                              
RETURNS Integer AS
$BODY$
 DECLARE vbIsInsert Boolean;
BEGIN

     IF COALESCE (inId, 0) = 0 AND
        EXISTS (SELECT *
                FROM MovementItem AS MIChild
                WHERE MIChild.MovementId = inMovementId
                  AND MIChild.ParentId = inParentId
                  AND MIChild.ObjectId = inUnitId 
                  AND MIChild.DescId = zc_MI_Child())
     THEN
       SELECT MIChild.ID
       INTO inId
       FROM MovementItem AS MIChild
       WHERE MIChild.MovementId = inMovementId
         AND MIChild.ParentId = inParentId
         AND MIChild.ObjectId = inUnitId 
         AND MIChild.DescId = zc_MI_Child();     
     END IF;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;
     
     -- ��������� <������� ���������>
     inId := lpInsertUpdate_MovementItem (inId, zc_MI_Child(), inUnitId, inMovementId, inMarginPercent, inParentId, zc_Enum_Process_Auto_PartionClose());
     

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.03.23                                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_PromoBonus_Child (InMovementItemId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:= 0, inSession:= '2')
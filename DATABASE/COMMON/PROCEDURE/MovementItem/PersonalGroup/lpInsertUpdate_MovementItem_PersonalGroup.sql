-- Function: lpInsertUpdate_MovementItem_PersonalGroup()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalGroup(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inWorkTimeKindId        Integer   , --
    IN inAmount                TFloat    , -- 
    IN inUserId                Integer     -- ������������
)                               
RETURNS Integer AS               
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� �������.';
     END IF;

     -- �������� ������������
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                       ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                      AND MILinkObject_Position.ObjectId = inPositionId
                     INNER JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                      ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                                     AND MILinkObject_PositionLevel.ObjectId = inPositionLevelId
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.Id <> ioId
                  AND MovementItem.ObjectId = inPersonalId
                )
     THEN
         RAISE EXCEPTION '������.� ��������� ��� ���������� <%> <%> <%>.������������ ���������.', lfGet_Object_ValueData (inPersonalId), lfGet_Object_ValueData (inPositionId), lfGet_Object_ValueData (inPositionLevelId);
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), ioId, inWorkTimeKindId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- 
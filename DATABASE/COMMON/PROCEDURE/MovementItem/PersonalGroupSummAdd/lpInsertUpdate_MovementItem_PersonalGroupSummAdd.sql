-- Function: lpInsertUpdate_MovementItem_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroupSummAdd (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalGroupSummAdd(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPositionId            Integer   , -- 
    IN inPositionLevelId       Integer   , -- 
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
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
     -- ��������
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <���������> ��� ����� = <%>.', zfConvert_FloatToString (inAmount);
     END IF;
    
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPositionId, inMovementId, inAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     


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
 27.02.24         *
*/

-- ����
-- 
-- Function: gpInsertUpdate_MovementItem_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeClose (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTimeClose(
 INOUT ioId                     Integer   , -- ���� ������� <�������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    --IN inMemberId               Integer   , -- ���.���� ��� �������� ��������
    IN inAmount                 TFloat    , -- ������ ��� ������  0 ��� 1
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTimeClose());
 
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_SheetWorkTimeClose (ioId         := ioId
                                                           , inMovementId := inMovementId
                                                           , inAmount     := inAmount
                                                           , inUserId     := vbUserId
                                                            ) AS tmp;
     --���� ���� ������ ������ ������� ����� ����
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ClosedAuto(), inMovementId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.21         *
*/

-- ����
--
-- Function: gpInsertUpdate_MovementItem_StaffListClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_StaffListClose (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_StaffListClose(
 INOUT ioId                     Integer   , -- ���� ������� <�������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inUnitId                 Integer   , -- �������������(����������)
    --IN inMemberId               Integer   , -- ���.���� ��� �������� ��������
    IN inAmount                 TFloat    , -- ������ ��� ������  0 ��� 1
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StaffListClose());
 
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_StaffListClose (ioId         := ioId
                                                       , inMovementId := inMovementId
                                                       , inUnitId     := inUnitId
                                                       , inAmount     := inAmount
                                                       , inUserId     := vbUserId
                                                        ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.25         *
*/

-- ����
--
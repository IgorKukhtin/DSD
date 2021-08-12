-- Function: gpUpdate_MI_SheetWorkTimeClose_Close()

DROP FUNCTION IF EXISTS gpUpdate_MI_SheetWorkTimeClose_Close (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SheetWorkTimeClose_Close(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAmount              TFloat    , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTimeClose());

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_SheetWorkTimeClose (ioId         := 0
                                                           , inMovementId := inMovementId
                                                           , inAmount     := inAmount
                                                           , inUserId     := vbUserId
                                                            ) AS tmp;

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
-- Function: gpInsertUpdate_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ChoiceCell(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inChoiceCellId        Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChoiceCell());
	    
    -- ���������
    ioId:= lpInsertUpdate_MovementItem_ChoiceCell (ioId                 := COALESCE(ioId,0)
                                                , inMovementId         := inMovementId
                                                , inChoiceCellId          := inChoiceCellId
                                                , inUserId             := vbUserId
                                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.08.24         *
*/

-- ����
-- 
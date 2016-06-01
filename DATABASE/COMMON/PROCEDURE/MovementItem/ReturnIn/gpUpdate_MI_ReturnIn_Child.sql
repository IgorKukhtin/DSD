-- Function: gpUpdate_MI_ReturnIn_Child()

DROP FUNCTION IF EXISTS gpUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReturnIn_Child(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
    IN inParentId            Integer   , -- ����
    IN inGoodsId             Integer   , -- �����
    IN inAmount              TFloat    , -- ����������
    IN inMovementId_sale     Integer   , -- 
    IN inMovementItemId_sale Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     -- !!!����������!!!
     PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := inId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := inParentId
                                                       , inGoodsId             := inGoodsId
                                                       , inAmount              := CASE WHEN inMovementId_sale > 0 AND inMovementItemId_sale > 0 THEN COALESCE (inAmount, 0) ELSE 0 END
                                                       , inMovementId_sale     := COALESCE (inMovementId_sale, 0)
                                                       , inMovementItemId_sale := COALESCE (inMovementItemId_sale, 0)
                                                       , inUserId              := vbUserId
                                                       , inIsRightsAll         := FALSE
                                                        )
    ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.06.16         *
*/

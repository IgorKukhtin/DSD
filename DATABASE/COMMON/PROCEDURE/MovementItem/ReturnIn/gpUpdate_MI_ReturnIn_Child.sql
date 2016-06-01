-- Function: gpUpdate_MI_ReturnIn_Child()

--DROP FUNCTION IF EXISTS gpUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ReturnIn_Child (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReturnIn_Child(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������� ����������>
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
   DECLARE vbParentId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     vbParentId := (SELECT MovementItem.ParentId FROM MovementItem WHERE MovementItem.Id = inId);
     -- !!!����������!!!
     PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := inId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := vbParentId
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

--  select * from gpUpdate_MI_ReturnIn_Child(inId := '51658481' , inMovementId := 3734404 , inGoodsId := 2146 , inAmount := 0.376 , inMovementId_Sale := 3528244 , inMovementItemId_sale := 48941749 ,  inSession := '5');
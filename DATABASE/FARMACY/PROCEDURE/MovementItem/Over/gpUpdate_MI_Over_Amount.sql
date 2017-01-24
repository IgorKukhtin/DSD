-- Function: gpUpdate_MI_Over_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_Over_Amount  (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Over_Amount(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� <������� ���������>
   PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);

   --��������� �������� ������-�����
   PERFORM lpInsertUpdate_MovementItem (ioId           :=  MI.Id
                                      , inDescId       := zc_MI_Child()
                                      , inObjectId     := MI.ObjectId
                                      , inMovementId   := inMovementId
                                      , inAmount       := 0
                                      , inParentId     := inId
                                      , inUserId       := vbUserId
                                        )
   FROM MovementItem AS MI 
   WHERE MI.MovementId = inMovementId 
     AND MI.ParentId = inId 
     AND MI.DescId = zc_MI_Child() 
     AND MI.isErased = False;

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.01.17         *
*/

-- ����
-- select * from gpUpdate_MI_Over_Amount(ioId := 38654751 , inMovementId := 2333564 , inGoodsId := 361056 ,  inSession := '3');


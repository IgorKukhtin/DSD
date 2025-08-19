-- Function: gpUpdate_Scale_MI_StickerTotal()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_StickerTotal (Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_StickerTotal(
    IN inMovementItemId  Integer      ,
    IN inValue           Boolean      , --
    IN inBranchCode      Integer      , --
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS TABLE (GoodsCode_1001     Integer
             , GoodsKindCode_1001 Integer
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbMovementItemId  Integer;
   DECLARE vbGoodsId         Integer;
   DECLARE vbGoodsKindId     Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     -- ��������
     IF COALESCE (inMovementItemId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� �� ������.';
     END IF;
   
     IF inMovementItemId < 0
     THEN
         --
         vbMovementItemId:= (SELECT MAX (MovementItem.Id) FROM MovementItem WHERE MovementItem.MovementId = -1 * inMovementItemId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE);
         --
         SELECT MovementItem.ObjectId
              , MILinkObject_GoodsKind.ObjectId
                INTO vbGoodsId
                   , vbGoodsKindId
         FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
         WHERE MovementItem.Id = vbMovementItemId;

         -- ��������
         IF COALESCE (vbMovementItemId, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ����������� �� �������.';
         END IF;

         -- ��������� ��������
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), vbMovementItemId, inValue);

     ELSE
         -- ��������� ��������
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), inMovementItemId, inValue);
     END IF;

     -- ���������
     RETURN QUERY
        SELECT 
        (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbGoodsId)     :: Integer AS GoodsCode_1001
      , (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbGoodsKindId) :: Integer AS GoodsKindCode_1001
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.07.25                                        *
*/

-- ����
-- SELECT *, AmountTotal - WeightTare_add  FROM gpUpdate_Scale_MI_StickerTotal (331192570, zfCalc_UserAdmin())

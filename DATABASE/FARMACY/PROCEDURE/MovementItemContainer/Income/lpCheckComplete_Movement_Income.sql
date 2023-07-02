 -- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpCheckComplete_Movement_Income (Integer);

CREATE OR REPLACE FUNCTION lpCheckComplete_Movement_Income(
    IN inMovementId        Integer              -- ���� ���������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbGoodsId Integer;
  DECLARE vbNDSKindId Integer;
BEGIN

   -- ��������� ��� �� ������ �����������. 
   IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
      RAISE EXCEPTION '� ��������� ������� �� ��� ������ �����������';
   END IF;


   -- ������� ���. 
   SELECT CASE WHEN ObjectId = 13937605 THEN 9 ELSE ObjectId END INTO vbNDSKindId
   FROM MovementLinkObject AS MovementLinkObject_NDSKind
   WHERE MovementLinkObject_NDSKind.MovementId = inMovementId
     AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind();

   IF COALESCE((SELECT MovementBoolean_UseNDSKind.ValueData
                FROM MovementBoolean AS MovementBoolean_UseNDSKind
                WHERE MovementBoolean_UseNDSKind.MovementId = inMovementId
                  AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()), FALSE) = FALSE
     AND inMovementId not in (22086918, 22076213, 22099026, 22157039)
   THEN
     -- ��������� � ���� �� ������� ��������� ���. 
     vbGoodsId:= (SELECT MovementItem.ObjectId
                  FROM MovementItem
                      JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                      ON ObjectLink_Goods_NDSKind.ObjectId = MovementItem.ObjectId
                                     AND ObjectLink_Goods_NDSKind.ChildObjectId <> vbNDSKindId
                                     AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.IsErased   = FALSE
                  LIMIT 1);
     IF vbGoodsId <> 0
     THEN 
         RAISE EXCEPTION '� "%" �� ��������� ��� ��� � ����������', lfGet_Object_ValueData (vbGoodsId);
     END IF;
   END IF;


  -- ���������, ��������� �� ���� ������� �� ������
  IF EXISTS (SELECT 1 FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_Branch() AND MD.ValueData IS NULL)
  THEN
      RAISE EXCEPTION '� ��������� �� ����������� ���� ������� �� ������';
  END IF;

   -- ��������� ���� ���������� (������� ���� � ������� ���� ����������) 
   vbGoodsId:= (SELECT MovementItem.ObjectId
                FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                               ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                              AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.IsErased   = FALSE
                  AND COALESCE(MIFloat_PriceSale.ValueData,0) = 0
                LIMIT 1);

   IF vbGoodsId <> 0 THEN
      RAISE EXCEPTION '�� �������� �������� ���������. � "%" �� ��������� ���� ����������', lfGet_Object_ValueData (vbGoodsId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.17         *
 26.01.15                         *
 26.12.14                         *
*/

-- ����
-- SELECT * FROM lpCheckComplete_Movement_Income (inMovementId:= 3946325)
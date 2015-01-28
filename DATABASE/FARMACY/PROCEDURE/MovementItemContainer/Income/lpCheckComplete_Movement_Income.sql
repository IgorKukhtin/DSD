-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpCheckComplete_Movement_Income (Integer);

CREATE OR REPLACE FUNCTION lpCheckComplete_Movement_Income(
    IN inMovementId        Integer              -- ���� ���������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer;
  DECLARE vbNDSKindId Integer;
  DECLARE vbGoodsName TVarChar;
BEGIN
  -- ��������� ��� �� ������ �����������. 
  IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
     RAISE EXCEPTION '� ��������� ������� �� ��� ������ �����������';
  END IF;

  -- ��������� � ���� �� ������� ��������� ���. 
  SELECT ObjectId INTO vbNDSKindId 
    FROM MovementLinkObject AS MovementLinkObject_NDSKind
   WHERE MovementLinkObject_NDSKind.MovementId = inMovementId
     AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind();

  SELECT MIN(GoodsId) INTO vbGoodsId
    FROM MovementItem_Income_View 
    JOIN Object_Goods_View ON MovementItem_Income_View.GoodsId = Object_Goods_View.Id
   WHERE MovementId = inMovementId AND Object_Goods_View.NDSKindId <> vbNDSKindId;

  IF COALESCE(vbGoodsId, 0) <> 0 THEN 
     SELECT ValueData INTO vbGoodsName FROM Object WHERE Id = vbGoodsId;
     RAISE EXCEPTION '� "%" �� ��������� ��� ��� � ����������', vbGoodsName;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.01.15                         *
 26.12.14                         *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

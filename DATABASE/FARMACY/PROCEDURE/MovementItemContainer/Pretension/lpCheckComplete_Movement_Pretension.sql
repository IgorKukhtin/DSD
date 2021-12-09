-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpCheckComplete_Movement_Pretension (Integer);

CREATE OR REPLACE FUNCTION lpCheckComplete_Movement_Pretension(
    IN inMovementId        Integer              -- ���� ���������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer;
  DECLARE vbNDSKindId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
  DECLARE vbUnitId Integer;
BEGIN

    vbUnitId := (SELECT Movement_Pretension_View.FromId FROM Movement_Pretension_View WHERE Movement_Pretension_View.Id = inMovementId);

    -- ��������� ��� �� ������ �����������. 
    IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
        RAISE EXCEPTION '� ��������� ������� �� ��� ������ �����������';
    END IF;

    -- ��������� � ���� �� ������� ��������� ���. 
    SELECT ObjectId INTO vbNDSKindId 
    FROM 
        MovementLinkObject AS MovementLinkObject_NDSKind
    WHERE 
        MovementLinkObject_NDSKind.MovementId = inMovementId
        AND 
        MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind();

    SELECT MIN(GoodsId) INTO vbGoodsId
    FROM 
        MovementItem_Pretension_View 
        JOIN Object_Goods_View ON MovementItem_Pretension_View.GoodsId = Object_Goods_View.Id
    WHERE 
        MovementId = inMovementId 
        AND 
        Object_Goods_View.NDSKindId <> vbNDSKindId;

    IF COALESCE(vbGoodsId, 0) <> 0 
    THEN 
        SELECT ValueData INTO vbGoodsName 
        FROM Object WHERE Id = vbGoodsId;
        RAISE EXCEPTION '� "%" �� ��������� ��� ��� � ����������', vbGoodsName;
    END IF;

    --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
    SELECT MI_Pretension.GoodsName
         , COALESCE(MI_Pretension.Amount,0)
         , COALESCE(SUM(Container.Amount),0)
    INTO
        vbGoodsName
      , vbAmount
      , vbSaldo
    FROM MovementItem_Pretension_View AS MI_Pretension
        LEFT OUTER JOIN Container ON MI_Pretension.GoodsId = Container.ObjectId
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE MI_Pretension.MovementId = inMovementId
      AND MI_Pretension.isErased = FALSE
    GROUP BY MI_Pretension.GoodsId
           , MI_Pretension.GoodsName
           , MI_Pretension.Amount
    HAVING COALESCE (MI_Pretension.Amount, 0) > COALESCE (SUM (Container.Amount) ,0);

    IF (COALESCE(vbGoodsName,'') <> '')
    THEN
        RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.12.21                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

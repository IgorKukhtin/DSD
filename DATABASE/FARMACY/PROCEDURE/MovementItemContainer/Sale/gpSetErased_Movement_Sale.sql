-- Function: gpSetErased_Movement_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Sale(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Sale());
    vbUserId := inSession::Integer; 
    -- �������� - ���� <Master> ��������, �� <������>
    --PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

    -- �������� - ���� ���� <Child> ��������, �� <������>
    PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

    SELECT Movement_Sale.UnitId
    INTO vbUnitId
    FROM Movement_Sale_View AS Movement_Sale
    WHERE Movement_Sale.Id = inMovementId;
        
    -- ��������� VIP ��� ��� �������         
    IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) 
              WHERE GoodsId IN (SELECT DISTINCT MovementItem.ObjectId
                                FROM MovementItemContainer
                                     INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                                WHERE MovementItemContainer.MovementId = inMovementId
                                  AND MovementItemContainer.DescId = zc_MIContainer_Count()))
    THEN
      PERFORM gpInsertUpdate_MovementItem_Check_VIPforSales (inUnitId   := vbUnitId
                                                           , inGoodsId  := MovementItem.ObjectId
                                                           , inAmount   := - SUM(MovementItemContainer.Amount)
                                                           , inSession  := inSession
                                                            )
      FROM MovementItemContainer
           INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
           INNER JOIN (SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession)) AS GoodsVIP 
                      ON GoodsVIP.GoodsId = MovementItem.ObjectId 
      WHERE MovementItemContainer.MovementId =inMovementId
        AND MovementItemContainer.DescId = zc_MIContainer_Count()
      GROUP BY MovementItem.ObjectId;                  
    END IF;

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

    IF COALESCE ((SELECT ValueData FROM MovementBoolean 
                  WHERE MovementId = inMovementId
                    AND DescId = zc_MovementBoolean_Deferred()), FALSE)= TRUE
    THEN
       -- ��������� �������
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, FALSE);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
 04.08.19                                                                                      *
 13.10.15                                                                       *
*/



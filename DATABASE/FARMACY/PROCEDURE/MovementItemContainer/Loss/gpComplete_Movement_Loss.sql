-- Function: gpComplete_Movement_Loss()

DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
BEGIN
  vbUserId:= inSession;
    vbGoodsName := '';
  --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
    SELECT Object_Goods.ValueData, COALESCE(MovementItem_Loss.Amount,0), COALESCE(SUM(Container.Amount),0) INTO vbGoodsName, vbAmount, vbSaldo 
    FROM
        Movement AS Movement_Loss
        INNER JOIN MovementLinkObject AS MLO_UNIT
                                      ON MLO_Unit.MovementId = Movement_Loss.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit() 
        INNER JOIN MovementItem AS MovementItem_Loss
                                ON MovementItem_Loss.MovementId = Movement_Loss.Id
                               AND MovementItem_Loss.DescId = zc_MI_Master()
                               AND MovementItem_Loss.isErased = FALSE
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = MovementItem_Loss.ObjectId  
        LEFT OUTER JOIN ContainerLinkObject AS CLO_Unit
                                            ON CLO_Unit.ObjectId = MLO_Unit.ObjectId
                                           AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit() 
        LEFT OUTER JOIN Container ON MovementItem_Loss.ObjectId = Container.ObjectId
                                 AND CLO_Unit.ContainerId = Container.Id
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE
        Movement_Loss.Id = inMovementId
    GROUP BY MovementItem_Loss.ObjectId, Object_Goods.ValueData, MovementItem_Loss.Amount
    HAVING COALESCE(MovementItem_Loss.Amount,0) > COALESCE(SUM(Container.Amount),0);
    
  IF (COALESCE(vbGoodsName,'') <> '') 
  THEN
    RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� �������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbSaldo;
  END IF;
  -- ����������� �������� �����
  PERFORM lpInsertUpdate_MovementFloat_TotalSummLoss (inMovementId);
  -- ���������� ��������
  PERFORM lpComplete_Movement_Loss(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������                          
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 21.07.15                                                         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Loss (inMovementId:= 29207, inSession:= '2')

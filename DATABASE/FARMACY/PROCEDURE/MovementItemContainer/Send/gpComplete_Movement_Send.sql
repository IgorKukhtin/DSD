-- Function: gpComplete_Movement_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_Send  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
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
  DECLARE vbUnit_From Integer;
  DECLARE vbUnit_To   Integer;
  DECLARE vbOperDate  TDateTime;
  
BEGIN
    vbUserId:= inSession;


    -- ��������� ���������
    SELECT
        Movement.OperDate,
        Movement_From.ObjectId AS Unit_From,
        Movement_To.ObjectId AS Unit_To
    INTO
        vbOperDate,
        vbUnit_From,
        vbUnit_To
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS Movement_To
                                      ON Movement_To.MovementId = Movement.Id
                                     AND Movement_To.DescId = zc_MovementLinkObject_To()
    WHERE Movement.Id = inMovementId;

    --
    vbGoodsName := '';

    -- �������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
    SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountRemains
           INTO vbGoodsName, vbAmount, vbSaldo 
    FROM (WITH tmpMI AS (SELECT MovementItem.ObjectId     AS GoodsId
                              , SUM (MovementItem.Amount) AS Amount
                         FROM MovementItem
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                         GROUP BY MovementItem.ObjectId
                        )
      , tmpContainer AS (SELECT Container.ObjectId     AS GoodsId
                              , SUM (Container.Amount) AS Amount
                         FROM tmpMI
                              INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                  AND Container.DescId = zc_Container_Count()
                                                  AND Container.Amount <> 0
                              INNER JOIN ContainerLinkObject AS CLO_From
                                                             ON CLO_From.ContainerId = Container.Id
                                                            AND CLO_From.ObjectId    = vbUnit_From
                                                            AND CLO_From.DescId      = zc_ContainerLinkObject_Unit()
                         GROUP BY Container.ObjectId
                        )
          SELECT tmpMI.GoodsId, tmpMI.Amount, COALESCE (tmpContainer.Amount, 0) AS AmountRemains
          FROM tmpMI
               LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI.GoodsId
          WHERE tmpMI.Amount > COALESCE (tmpContainer.Amount, 0)
         ) AS tmp
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
    LIMIT 1
   ;
    
    IF (COALESCE(vbGoodsName,'') <> '') 
    THEN
        RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ����������� <%> ������, ��� ���� �� ������� <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;

    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    /*IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId in (vbUnit_From,vbUnit_To)
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION '������. �� ������ ��� ����� ������� ���� �������� ��������� ����� ���� �������� �����������. ���������� ��������� ���������!';
    END IF;*/
  
  -- ����������� �������� �����
  PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (inMovementId);
  -- ���������� ��������
  PERFORM lpComplete_Movement_Send(inMovementId, -- ���� ���������
                                   vbUserId);    -- ������������  

    --�������� ����� �� ���������� ����� ����� ����������
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, SUM(ABS(MIContainer_Count.Amount*MIFloat_Price.ValueData)))
    FROM 
        MovementItemContainer AS MIContainer_Count
        INNER JOIN ContainerLinkObject AS CLI_MI 
                                       ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                      AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
        INNER JOIN OBJECT AS Object_PartionMovementItem 
                          ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
        INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
        INNER JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MovementItem.ID
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
    WHERE 
        MIContainer_Count. MovementId = inMovementId
        AND
        MIContainer_Count.DescId = zc_Container_Count()
        AND
        MIContainer_Count.IsActive = True;
    
                                   
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 29.07.15                                                         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 29207, inSession:= '2')

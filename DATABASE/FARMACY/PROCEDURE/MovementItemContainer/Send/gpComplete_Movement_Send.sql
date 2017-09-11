-- Function: gpComplete_Movement_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_Send  (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Send  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsCurrentData     Boolean               , -- ���� ��������� ������� �� /���
   OUT outOperDate         TDateTime             , --
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS TDateTime
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbGoodsName     TVarChar;
  DECLARE vbAmount        TFloat;
  DECLARE vbAmountManual  TFloat;
  DECLARE vbSaldo         TFloat;
  DECLARE vbUnit_From     Integer;
  DECLARE vbUnit_To       Integer;
  
  DECLARE vbTotalSummMVAT TFloat;
  DECLARE vbTotalSummPVAT TFloat;
  DECLARE vbInvNumber TVarChar;
BEGIN
    vbUserId:= inSession;


    -- ��������� ���������
    SELECT
        Movement.OperDate,
        Movement.InvNumber,
        Movement_From.ObjectId AS Unit_From,
        Movement_To.ObjectId AS Unit_To
    INTO
        outOperDate,
        vbInvNumber,
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

    -- ���� ��������� ����������� ������ ��������� � ������� �����.
    -- ���� �������� �������� ���-� ������ ����� - ������ ��������������
    IF ((outOperDate <> CURRENT_DATE) OR (outOperDate <> CURRENT_DATE + INTERVAL '1 MONTH')) AND (inIsCurrentData = TRUE)
    THEN
         --RAISE EXCEPTION '������. ��������� ���� ��������� �� �������.';
        outOperDate:= CURRENT_DATE;
        -- ��������� <��������> c ����� ����� 
        PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_Send(), vbInvNumber, outOperDate, NULL);
        
    ELSE
         IF ((outOperDate <> CURRENT_DATE) OR (outOperDate <> CURRENT_DATE + INTERVAL '1 MONTH')) AND (inIsCurrentData = FALSE)
         THEN
             -- �������� ���� �� ���������� ������ ������
             vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompleteDate_Send());
         END IF;
    END IF;

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
          SELECT tmpMI.GoodsId, tmpMI.Amount
               , COALESCE (tmpContainer.Amount, 0) AS AmountRemains
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


    -- ��������: �� ��������� ��������� ����������� - � ������� ������� - "���-�� ����������" ���������� �� ���-�� "���� ���-��". 
    vbGoodsName := '';
    SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountManual
           INTO vbGoodsName, vbAmount, vbAmountManual
    FROM (SELECT MovementItem.ObjectId     AS GoodsId
               , SUM (MovementItem.Amount) AS Amount
               , SUM (COALESCE(MIFloat_AmountManual.ValueData,0)) AS AmountManual
          FROM MovementItem
               LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                           ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId = zc_MI_Master()
            AND MovementItem.isErased = FALSE
          GROUP BY MovementItem.ObjectId
         ) AS tmp
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
    WHERE tmp.Amount <> tmp.AmountManual
    LIMIT 1
   ;

    IF (COALESCE(vbGoodsName,'') <> '') AND outOperDate <> CURRENT_DATE + INTERVAL '1 MONTH'
       AND vbUserId NOT IN (375661, 2301972) -- ����� ���� �����������
    THEN
        RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ���������� <%> ���������� �� ���� ���-�� <%>.', vbGoodsName, vbAmount, vbAmountManual;
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
                  Movement_Inventory.OperDate >= outOperDate
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
    
    --������������ � ���������� ����� ����� ������� � �����. ����� � ��. % ���-�� (� ���)   TotalSummMVAT
    --                                ����� ������� � �����. ����� (� ���)                  TotalSummPVAT
       SELECT
            COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))),0)                               ::TFloat  AS Summa           --MVat
           , COALESCE(ABS(SUM(MIContainer_Count.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))),0)                                 ::TFloat  AS SummaWithVAT   --PVat
      INTO vbTotalSummMVAT, vbTotalSummPVAT

       FROM MovementItem AS MovementItem_Send
            LEFT OUTER JOIN MovementItemContainer AS MIContainer_Count
                                                  ON MIContainer_Count.MovementItemId = MovementItem_Send.Id 
                                                 AND MIContainer_Count.DescId = zc_Container_Count()
                                                 AND MIContainer_Count.isActive = True
            LEFT OUTER  JOIN ContainerLinkObject AS CLI_MI 
                                                 ON CLI_MI.ContainerId = MIContainer_Count.ContainerId
                                                AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER  JOIN OBJECT AS Object_PartionMovementItem 
                                    ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            LEFT OUTER  JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
            -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� NULL)
            LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                        ON MIFloat_JuridicalPrice.MovementItemId = MovementItem.ID
                                       AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
            -- ���� � ������ ���, ��� �������� ������� �� ���������� ��� % �������������  (��� NULL)
            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
        WHERE MovementItem_Send.MovementId = inMovementId
          AND MovementItem_Send.DescId = zc_MI_Master()
          AND MovementItem_Send.isErased = FALSE;         

     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbTotalSummMVAT);
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbTotalSummPVAT);
--                           

  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 13.05.16         *
 29.07.15                                                         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 29207, inIsCurrentData:= TRUe,  inSession:= '2')

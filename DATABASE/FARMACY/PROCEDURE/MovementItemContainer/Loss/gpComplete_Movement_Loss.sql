-- Function: gpComplete_Movement_Loss()

DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsCurrentData     Boolean               , -- ���� ��������� ������� �� /���
   OUT outOperDate         TDateTime             , --
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS TDateTime
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
  DECLARE vbUnitId    Integer;
  DECLARE vbisCat_5 boolean;
BEGIN
    vbUserId:= inSession;
    vbGoodsName := '';
    SELECT Movement.OperDate           AS OperDate,
           Movement.InvNumber          AS InvNumber,
           MovementLinkObject.ObjectId AS UnitId, 
           MovementLinkObject_ArticleLoss.ObjectId = 23653195
    INTO outOperDate
        ,vbInvNumber
        ,vbUnitId
        ,vbisCat_5
    FROM Movement
        INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                     AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                     ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                    AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
    WHERE Movement.Id = inMovementId;

    -- ���� ��������� ����������� ������ ��������� � ������� �����.
    -- ���� �������� �������� ���-� ������ ����� - ������ ��������������
    IF (outOperDate <> CURRENT_DATE) AND (inIsCurrentData = TRUE)
    THEN
        --RAISE EXCEPTION '������. ��������� ���� ��������� �� �������.';
        outOperDate:= CURRENT_DATE;
        -- ��������� <��������> c ����� ����� 
        PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_Loss(), vbInvNumber, outOperDate, NULL);
        
    ELSE 
        IF (outOperDate <> CURRENT_DATE) AND (inIsCurrentData = FALSE)
         THEN
              -- �������� ���� �� ���������� ������ ������
              vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompleteDate_Loss());
         END IF;
    END IF;

  --�������� �� �� ��� �� �� ������� ������ ��� ���� �� �������
    WITH tmpContainerPD AS (SELECT Container.ParentId                                                           AS ContainerId 
                             , (Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat AS Amount
                        FROM Container

                             INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                          AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                             INNER JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                      ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                     AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                                     AND ObjectBoolean_PartionGoods_Cat_5.ValueData = TRUE

                             INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                  ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                 AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                             LEFT JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                            AND date_trunc('day', MovementItemContainer.Operdate) > outOperDate

                        WHERE Container.DescId = zc_Container_CountPartionDate()
                          AND Container.WhereObjectId = vbUnitId
                          AND COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()) <= outOperDate
                        GROUP BY Container.Id, Container.Amount
                        HAVING (Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0)) > 0),
         REMAINS AS ( --������� �� ���� ���������
                                SELECT 
                                    T0.ObjectId
                                   ,SUM(T0.Amount)::TFloat as Amount
                                FROM(
                                        SELECT 
                                               Container.Id 
                                             , Container.ObjectId --�����
                                             , CASE WHEN vbisCat_5 = TRUE
                                                    THEN MAX(tmpContainerPD.Amount)
                                                    ELSE (Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0)) END::TFloat AS Amount  --���. ������� - �������� ����� ���� ���������
                                        FROM Container
                                            LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                                 AND date_trunc('day', MovementItemContainer.Operdate) > outOperDate
                                                                                 
                                            LEFT JOIN (SELECT tmpContainerPD.ContainerId, 
                                                              SUM(tmpContainerPD.Amount)   AS Amount
                                                       FROM tmpContainerPD 
                                                       GROUP BY tmpContainerPD.ContainerId 
                                                       HAVING SUM(tmpContainerPD.Amount) > 0) AS tmpContainerPD ON tmpContainerPD.ContainerId = Container.Id  
                                            
                                        WHERE Container.DescID = zc_Container_Count()
                                          AND Container.WhereObjectId = vbUnitId
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP By ObjectId
                                HAVING SUM(T0.Amount) <> 0
                            )
    
    SELECT Object_Goods.ValueData, COALESCE(MovementItem_Loss.Amount,0), COALESCE(REMAINS.Amount,0) INTO vbGoodsName, vbAmount, vbSaldo 
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
        LEFT OUTER JOIN REMAINS ON MovementItem_Loss.ObjectId = REMAINS.ObjectId
    WHERE
        Movement_Loss.Id = inMovementId
        AND
        COALESCE(MovementItem_Loss.Amount,0) > COALESCE(REMAINS.Amount,0)
    LIMIT 1;
    
  IF (COALESCE(vbGoodsName,'') <> '') 
  THEN
    RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� �������� <%> ������, ��� ���� �� ������� <%>%.', vbGoodsName, vbAmount, vbSaldo, 
          CASE WHEN vbisCat_5 = TRUE THEN ' ��������� �������� ����� 5 ��������� ������� � �����������.' ELSE '' END;
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
                                               AND Movement_Inventory_Unit.ObjectId = vbUnitId
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
        RAISE EXCEPTION '������. �� ������ ��� ����� ������� ���� �������� ��������� ����� ���� �������� ��������. ���������� ��������� ���������!';
    END IF;*/
    
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
-- SELECT * FROM gpComplete_Movement_Loss (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')

-- select * from gpComplete_Movement_Loss(inmovementid := 34457829 , inIsCurrentData := 'False' ,  inSession := '3');
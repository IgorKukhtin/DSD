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
  DECLARE vbAmountStorage TFloat;
  DECLARE vbSaldo         TFloat;
  DECLARE vbUnit_From     Integer;
  DECLARE vbUnit_To       Integer;
  
  DECLARE vbTotalSummMVAT TFloat;
  DECLARE vbTotalSummPVAT TFloat;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
  DECLARE vbisDefSUN      Boolean;
  DECLARE vbisSUN      Boolean;
  DECLARE vbisReceived Boolean;
  DECLARE vbPartionDateKindId Integer;
  DECLARE vbInsertDate TDateTime;
BEGIN
    vbUserId:= inSession;

     -- ��������
    IF COALESCE ((SELECT MovementBoolean_Deferred.ValueData FROM MovementBoolean  AS MovementBoolean_Deferred
                  WHERE MovementBoolean_Deferred.MovementId = inMovementId
                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE
    THEN
         RAISE EXCEPTION '������.�������� �������, ���������� ���������!';
    END IF;
     
    -- ��������� ���������
    SELECT
        Movement.OperDate,
        Movement.InvNumber,
        Movement_From.ObjectId AS Unit_From,
        Movement_To.ObjectId AS Unit_To,
        COALESCE (MovementBoolean_DefSUN.ValueData, FALSE),
        COALESCE (MovementBoolean_SUN.ValueData, FALSE),
        COALESCE (MovementBoolean_Received.ValueData, FALSE),
        COALESCE (MovementLinkObject_PartionDateKind.ObjectId, 0),
        DATE_TRUNC ('DAY', MovementDate_Insert.ValueData)
        
    INTO
        outOperDate,
        vbInvNumber,
        vbUnit_From,
        vbUnit_To,
        vbisDefSUN,
        vbisSUN,
        vbisReceived,
        vbPartionDateKindId,
        vbInsertDate
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS Movement_To
                                      ON Movement_To.MovementId = Movement.Id
                                     AND Movement_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                  ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                 AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                  ON MovementBoolean_Received.MovementId = Movement.Id
                                 AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                     ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- ��� ���� "������ ������"
    THEN
      vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
      IF vbUnitKey = '' THEN
        vbUnitKey := '0';
      END IF;
      vbUserUnitId := vbUnitKey::Integer;
        
      IF COALESCE (vbUserUnitId, 0) = 0
      THEN 
        RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
      END IF;     

      IF vbPartionDateKindId = zc_Enum_PartionDateKind_0() OR vbUnit_To = 11299914 
      THEN 
        RAISE EXCEPTION '������. ��������� ����������� �� ����������� ����� ������ ��� ���������.';     
      END IF;     

      IF COALESCE (vbUnit_From, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnit_To, 0) <> COALESCE (vbUserUnitId, 0) 
      THEN 
        RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
      END IF;     

      IF vbIsSUN = TRUE AND EXISTS(SELECT 1
                                   FROM Object AS Object_CashSettings
                                        LEFT JOIN ObjectDate AS ObjectDate_CashSettings_DateBanSUN
                                                             ON ObjectDate_CashSettings_DateBanSUN.ObjectId = Object_CashSettings.Id 
                                                            AND ObjectDate_CashSettings_DateBanSUN.DescId = zc_ObjectDate_CashSettings_DateBanSUN()
                                   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                                     AND ObjectDate_CashSettings_DateBanSUN.ValueData = vbInsertDate)
      THEN
        RAISE EXCEPTION '������. ������ ��� ���� ����������, �������� ��������� IT.';
      END IF;                                
    END IF;     

    IF vbisDefSUN = TRUE
    THEN
      RAISE EXCEPTION '������. �������, ���������� ����������� �� ��� ��������� ������.';
    END IF;
    
    IF COALESCE (vbisSUN, FALSE) = True AND COALESCE (vbisReceived, False) = False
    THEN
      RAISE EXCEPTION '������. �������, ����������� �� ��� ����� ��������� ������ � ��������� "��������-��".';
    END IF;
    

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
                           AND MovementItem.Amount <> 0
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

    -- �������� �� �� ��� �� �� ������� ������ ��� ���� �� ������� �� �������������� �������� 
    IF EXISTS (SELECT 1
               FROM MovementItem AS MI_Child
               WHERE MI_Child.MovementId = inMovementId
                 AND MI_Child.DescId     = zc_MI_Child()
                 AND MI_Child.IsErased   = FALSE
                 AND MI_Child.Amount     <> 0
              ) 
    THEN
      SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountRemains
             INTO vbGoodsName, vbAmount, vbSaldo
      FROM (WITH tmpMI AS (SELECT MI_Master.ObjectId     AS GoodsId
                                , MI_Child.Amount        AS Amount
                                , Container.Id           AS ContainerId
                                , Container.Amount       AS ContainerAmount
                           FROM MovementItem AS MI_Master
                                LEFT JOIN MovementItem AS MI_Child
                                               ON MI_Child.MovementId = inMovementId
                                              AND MI_Child.DescId     = zc_MI_Child()
                                              AND MI_Child.ParentId   = MI_Master.Id
                                              AND MI_Child.IsErased   = FALSE
                                              AND MI_Child.Amount     > 0
                                -- ��� zc_Container_CountPartionDate
                                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                            ON MIFloat_ContainerId.MovementItemId = MI_Child.Id
                                                           AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                LEFT JOIN Container ON Container.Id = MIFloat_ContainerId.ValueData :: Integer
                                              
                           WHERE MI_Master.MovementId = inMovementId
                             AND MI_Master.DescId     = zc_MI_Master()
                             AND MI_Master.IsErased   = FALSE
                          )

            SELECT tmpMI.GoodsId, SUM(tmpMI.Amount) AS Amount, tmpMI.ContainerAmount AS AmountRemains
            FROM tmpMI
            GROUP BY tmpMI.GoodsId, tmpMI.ContainerId, tmpMI.ContainerAmount
            HAVING SUM(tmpMI.Amount) > COALESCE (tmpMI.ContainerAmount, 0)
           ) AS tmp
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
      LIMIT 1
     ;
     
      IF (COALESCE(vbGoodsName,'') <> '') 
      THEN
          RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ������������ <%> ������, ��� ���� �� ������� <%> �� ������.', vbGoodsName, vbAmount, vbSaldo;
      END IF;
    END IF;
    


    -- ��������: �� ��������� ��������� ����������� - � ������� ������� - "���-�� ����������" ���������� �� ���-�� "���� ���-��". 
    vbGoodsName := '';
    SELECT Object_Goods.ValueData, tmp.Amount, tmp.AmountManual, tmp.AmountStorage
    INTO vbGoodsName, vbAmount, vbAmountManual, vbAmountStorage
    FROM (SELECT MovementItem.ObjectId                             AS GoodsId
               , SUM (MovementItem.Amount)                         AS Amount
               , SUM (COALESCE(MIFloat_AmountManual.ValueData,0))  AS AmountManual
               , SUM (COALESCE(MIFloat_AmountStorage.ValueData,0)) AS AmountStorage
          FROM MovementItem
               LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                           ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
               LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                           ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId = zc_MI_Master()
            AND MovementItem.isErased = FALSE
          GROUP BY MovementItem.ObjectId
         ) AS tmp
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
    WHERE (tmp.Amount <> tmp.AmountManual OR tmp.Amount <> tmp.AmountStorage)
      AND zfCalc_AccessKey_SendAll (vbUserId) = FALSE -- !!!���� ������������� - ���������!!!
    LIMIT 1
   ;

    IF vbGoodsName <> '' AND (-- outOperDate <> CURRENT_DATE + INTERVAL '1 MONTH' OR
       vbUserId NOT IN (375661, 2301972) -- ����� ���� �����������
       )
    THEN
        RAISE EXCEPTION '������. �� ������ <%> ��� ����� ������� ���-�� ���������� <%> ���������� �� ���� ���-�� �����-���������� <%> ��� �� ���� ���-�� �����-����������� <%>.', vbGoodsName, vbAmount, vbAmountManual, vbAmountStorage;
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  ������ �.�.
 19.12.18                                                                        *  
 13.05.16         *
 29.07.15                                                         *
 

-- ����
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 29207, inIsCurrentData:= TRUe,  inSession:= '2')
*/

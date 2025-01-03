  -- Function: grInsert_Movement_LossOverdueUnit()

  DROP FUNCTION IF EXISTS grInsert_Movement_LossOverdueUnit (Integer, TVarChar);

  CREATE OR REPLACE FUNCTION grInsert_Movement_LossOverdueUnit(
      IN inUnitID              Integer  , -- �������������
     OUT outMovementID         Integer  , -- ����� ��������
      IN inSession             TVarChar   -- ������������
  )
  RETURNS Integer AS
  $BODY$
     DECLARE vbUserId Integer;
     DECLARE vbStatusId Integer;
     DECLARE vbOperDate TDateTime;
  BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);
    outMovementID := 0;

    IF NOT EXISTS(SELECT 1 FROM ObjectBoolean
                  WHERE ObjectBoolean.ObjectId = inUnitID
                    AND ObjectBoolean.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()
                    AND ObjectBoolean.ValueData = TRUE)
    THEN
      RETURN;
    END IF;
    
    vbOperDate := CURRENT_DATE; -- INTERVAL '1 DAY';

      -- �������� ������� �� ���� �����������
    IF EXISTS(SELECT 1
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                 ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                                AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                AND MovementLinkObject_From.ObjectId = inUnitID

                   INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                              ON MovementBoolean_Deferred.MovementId = Movement.Id
                                             AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

              WHERE Movement.DescId = zc_Movement_Send()
                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE)
    THEN
      PERFORM gpUpdate_Movement_Send_Deferred (Movement.ID, FALSE, inSession)
      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                        AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                        AND MovementLinkObject_From.ObjectId = inUnitID

           INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                     AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

      WHERE Movement.DescId = zc_Movement_Send()
        AND Movement.StatusId = zc_Enum_Status_UnComplete()
        AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE;
    END IF;

      -- ��������� ������� ��� ������� �� ��������
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpcontaineroverdueloss'))
    THEN
      CREATE TEMP TABLE tmpContainerOverdueLoss (
        GoodsId             Integer,
        ContainerId         Integer,
        Amount              TFloat
      ) ON COMMIT DROP;
    ELSE
      DELETE FROM tmpContainerOverdueLoss;
    END IF;

      -- ��������� ��������� ������� ��� ������� �� ��������
    WITH
         -- ���������
         tmpContainer AS (SELECT Container.Id                                         AS Id,
                                 Container.ObjectId                                   AS GoodsID,
                                 Container.Amount                                     AS Amount,
                                 Container.ParentId                                   AS ParentId,
                                 ContainerLinkObject.ObjectId                         AS PartionGoodsId,
                                 ObjectDate_ExpirationDate.ValueData                  AS ExpirationDate

                          FROM Container

                             LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

                             LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                            AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                             LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                  ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                 AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                     ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                    AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = inUnitID
                            AND Container.Amount > 0
                            AND ObjectDate_ExpirationDate.ValueData < date_trunc('month', vbOperDate - INTERVAL '120 DAY')
                            AND COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE),
         --  ����������� � ��������
         tmpMovementSend AS (SELECT MovementItem.ObjectId                   AS GoodsId 
                                  , Sum(MovementItem.Amount)                AS Amount
                             FROM Movement 
                                  INNER JOIN MovementBoolean AS MovementBoolean_SendLoss
                                                             ON MovementBoolean_SendLoss.MovementId = Movement.Id
                                                            AND MovementBoolean_SendLoss.DescId = zc_MovementBoolean_SendLoss()
                                                            AND MovementBoolean_SendLoss.ValueData = TRUE
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.Amount > 0
                                                         AND MovementItem.isErased = FALSE 
                              WHERE Movement.OperDate BETWEEN date_trunc('month', vbOperDate) AND date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'  
                                AND Movement.DescId = zc_Movement_Send() 
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND (MovementLinkObject_From.ObjectId =  inUnitID
                                  OR MovementLinkObject_To.ObjectId = inUnitID)
                              GROUP BY MovementItem.ObjectId  
                              HAVING Sum(MovementItem.Amount) > 0)
         -- ���������� ���������

    INSERT INTO tmpContainerOverdueLoss (GoodsId, ContainerId, Amount)
    SELECT Container.GoodsId
         , Container.Id
         , Container.Amount
    FROM tmpContainer AS Container
    UNION ALL 
    SELECT tmpMovementSend.GoodsId
         , 0
         , tmpMovementSend.Amount  
    FROM tmpMovementSend;

    IF EXISTS(SELECT Movement.Id
              FROM Movement 

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_UNit.DescId     = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId   = inUnitID

                   INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                 ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                AND MovementLinkObject_ArticleLoss.DescId     = zc_MovementLinkObject_ArticleLoss()
                                                AND MovementLinkObject_ArticleLoss.ObjectId   = 13892113

              WHERE Movement.DescId = zc_Movement_Loss()
                AND Movement.StatusId <> zc_Enum_Status_Erased()
                AND Movement.OperDate = date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
    THEN
      SELECT Movement.Id, Movement.StatusId
      INTO outMovementID, vbStatusId
      FROM Movement 

           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_UNit.DescId     = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId   = inUnitID

           INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId     = zc_MovementLinkObject_ArticleLoss()
                                        AND MovementLinkObject_ArticleLoss.ObjectId   = 13892113

      WHERE Movement.DescId = zc_Movement_Loss()
        AND Movement.StatusId <> zc_Enum_Status_Erased()
        AND Movement.OperDate = date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
       
      IF vbStatusId = zc_Enum_Status_Complete()
      THEN
        PERFORM gpUnComplete_Movement_Loss (inMovementId  := outMovementID
                                          , inSession     := inSession);
      END IF;
      
    ELSE 
      outMovementID := 0;
    END IF;

    IF EXISTS(SELECT 1 FROM  tmpContainerOverdueLoss)
    THEN
        -- ��������� <��������>
        IF COALESCE (outMovementID, 0) = 0
        THEN
          outMovementID := lpInsertUpdate_Movement_Loss (ioId                 := 0
                                                       , inInvNumber          := CAST (NEXTVAL ('Movement_Loss_seq') AS TVarChar)
                                                       , inOperDate           := date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                                       , inUnitId             := inUnitId
                                                       , inArticleLossId      := 13892113
                                                       , inComment            := ''
                                                       , inConfirmedMarketing := ''
                                                       , inUserId             := vbUserId
                                                        );
        END IF;
        
        -- ��������� �������
        PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_FinalFormation(), outMovementID, True);
        
        PERFORM lpInsertUpdate_MovementItem_Loss (ioId                := MovementItem.Id
                                                , inMovementId        := outMovementID
                                                , inGoodsId           := tmpContainerOverdueLoss.GoodsId
                                                , inAmount            := Sum(tmpContainerOverdueLoss.Amount)
                                                , inUserId            := vbUserId)
        FROM tmpContainerOverdueLoss

           LEFT JOIN MovementItem ON MovementItem.MovementId = outMovementID
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.ObjectId   = tmpContainerOverdueLoss.GoodsId

        GROUP BY MovementItem.Id, GoodsId
        HAVING Sum(tmpContainerOverdueLoss.Amount) > 0;

        -- �������� ��������
        PERFORM gpComplete_Movement_Loss (inMovementId:= outMovementID, inIsCurrentData:= False, inSession:= inSession);
    END IF;

    -- ����������� ����������� ������
    PERFORM lpInsert_MovementUnit_SendOverdue (inUnitID         := Object_Unit.Id
                                             , inUnitOverdueID  := ObjectLink_Unit_UnitOverdue.ChildObjectId
                                             , inSession        := inSession)
    FROM Object AS Object_Unit

         INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                 ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                AND ObjectBoolean_DividePartionDate.ValueData = True

         INNER JOIN ObjectLink AS ObjectLink_Unit_UnitOverdue
                               ON ObjectLink_Unit_UnitOverdue.ObjectId = Object_Unit.Id
                              AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()

    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND Object_Unit.Id = inUnitID
      AND COALESCE (ObjectLink_Unit_UnitOverdue.ChildObjectId, 0) <> 0;
      
  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ������� ����������: ����, �����
                 ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.03.20                                                         *
   */

-- ���� SELECT * FROM grInsert_Movement_LossOverdueUnit (inUnitID := 11152911 , inSession:= '3')
-- SELECT grInsert_Movement_LossOverdue (inSession := zfCalc_UserAdmin());
  -- Function: grUpdate_MovementUnit_SendOverdue()

  DROP FUNCTION IF EXISTS grUpdate_MovementUnit_SendOverdue (Integer, TVarChar);

  CREATE OR REPLACE FUNCTION grUpdate_MovementUnit_SendOverdue(
      IN inMovementID          Integer  , -- �������������
      IN inSession             TVarChar   -- ������������
  )
  RETURNS VOID AS
  $BODY$
     DECLARE vbUserId Integer;
     DECLARE vbUnitId Integer;
     DECLARE vbStatusId Integer;
     DECLARE vbOperDate TDateTime;
     DECLARE vbPartionDateKindID Integer;
  BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
    vbUserId:= lpGetUserBySession (inSession);

    IF NOT EXISTS(SELECT 1 FROM Movement WHERE Movement.Id = inMovementId)
    THEN
      RAISE EXCEPTION '������. �������� �� ������.';
    END IF;

      -- �������� ���������
    SELECT
        Movement.OperDate,
        Movement.StatusId,
        Movement_From.ObjectId AS Unit_From,
        MovementLinkObject_PartionDateKind.ObjectId
    INTO
        vbOperDate,
        vbStatusId,
        vbUnitId,
        vbPartionDateKindID
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
    WHERE Movement.Id = inMovementId;

    IF COALESCE(vbPartionDateKindID, 0) <> zc_Enum_PartionDateKind_0()
    THEN
      RAISE EXCEPTION '������������ ��������� ������ ��� ���������� ����������� ������������� ������.';
    END IF;

    -- ��������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
      RAISE EXCEPTION '������������ ��������� ������ ��� �������������� ����������.';
    END IF;

    IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = inMovementId)
    THEN
      RAISE EXCEPTION '������.�������� �������, ����������� �������� ��������� ���������!';
    END IF;

      -- ��������� ������� ��� ������� �� ��������
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpcontaineoverdue'))
    THEN
      CREATE TEMP TABLE tmpContainerOverdue (
        GoodsId             Integer,
        MIMasterID          Integer,
        MIChildId           Integer,
        ContainerId         Integer,
        Amount              TFloat
      ) ON COMMIT DROP;
    ELSE
      DELETE FROM tmpContainerOverdue;
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


                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount > 0
                            AND ObjectDate_ExpirationDate.ValueData <= vbOperDate)
         -- ���������� ���������
       , tmpMovement AS (SELECT
                                MovementItemMaster.ID                   AS MIMasterID
                              , MovementItemMaster.ObjectId             AS GoodsId
                              , MovementItemChild.ID                    AS MIChildId
                              , MIFloat_ContainerId.ValueData::Integer  AS ContainerId
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                        AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                           AND MovementLinkObject_From.ObjectId = vbUnitID

                              INNER JOIN MovementItem AS MovementItemMaster
                                                      ON MovementItemMaster.MovementId = Movement.Id
                                                     AND MovementItemMaster.DescId = zc_MI_Master()

                              INNER JOIN MovementItem AS MovementItemChild
                                                      ON MovementItemChild.MovementId = Movement.Id
                                                     AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                     AND MovementItemChild.DescId = zc_MI_Child()

                              LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                          ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                         AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                        WHERE Movement.Id = inMovementId)

    INSERT INTO tmpContainerOverdue (GoodsId, MIMasterID, MIChildId, ContainerId, Amount)
    SELECT Movement.GoodsId
         , Movement.MIMasterID
         , Movement.MIChildId
         , Movement.ContainerId
         , Container.Amount

    FROM tmpMovement AS Movement
         LEFT JOIN tmpContainer AS Container ON Movement.ContainerId = Container.Id;

      -- �������������� ��� ��������� ������
    PERFORM gpMovementItem_Send_SetUnerased (inMovementItemId        := MovementItem.Id,
                                             inSession               := inSession)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.IsErased = TRUE;

      -- �������������� ��������� ������ � �������� MIChildId
    PERFORM gpMovementItem_Send_SetUnerased (inMovementItemId        := MovementItem.Id,
                                             inSession               := inSession)
    FROM tmpContainerOverdue
         INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                AND MovementItem.ID = tmpContainerOverdue.MIChildId
                                AND MovementItem.IsErased = TRUE
    WHERE COALESCE(tmpContainerOverdue.Amount) > 0;

      -- �������������� ��������� ������ � �������� �������
    PERFORM gpMovementItem_Send_SetUnerased (inMovementItemId        := MovementItemMaster.Id,
                                             inSession               := inSession)
    FROM MovementItem AS MovementItemMaster

         INNER JOIN (SELECT DISTINCT MovementItemChild.ParentId
                     FROM MovementItem AS MovementItemChild
                     WHERE MovementItemChild.MovementId = inMovementId
                       AND MovementItemChild.DescId = zc_MI_Child()
                       AND MovementItemChild.IsErased = FALSE) AS MovementItemChild
                                                               ON MovementItemChild.ParentId = MovementItemMaster.ID

    WHERE MovementItemMaster.MovementId = inMovementId
      AND MovementItemMaster.DescId = zc_MI_Master()
      AND MovementItemMaster.IsErased = TRUE;

      -- ������ ������ �������
    PERFORM lpInsertUpdate_MovementItem_Send (ioId                   := tmpContainerOverdue.MIMasterID,
                                              inMovementId           := inMovementID,
                                              inGoodsId              := tmpContainerOverdue.GoodsId,
                                              inAmount               := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inAmountManual         := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inAmountStorage        := COALESCE(SUM(tmpContainerOverdue.Amount), 0)::TFloat,
                                              inReasonDifferencesId  := 0,
                                              inCommentTRID          := 0,
                                              inUserId               := vbUserId)
    FROM tmpContainerOverdue
         INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                AND MovementItem.ID = tmpContainerOverdue.MIMasterID
    GROUP BY tmpContainerOverdue.MIMasterID, tmpContainerOverdue.GoodsId, MovementItem.Amount
    HAVING COALESCE(SUM(tmpContainerOverdue.Amount), 0) <> MovementItem.Amount;

      -- ������ ������ Child
    PERFORM lpInsertUpdate_MovementItem_Send_Child(ioId            := tmpContainerOverdue.MIChildId,
                                                   inParentId      := tmpContainerOverdue.MIMasterID,
                                                   inMovementId    := inMovementID,
                                                   inGoodsId       := tmpContainerOverdue.GoodsId,
                                                   inAmount        := COALESCE(tmpContainerOverdue.Amount, 0),
                                                   inContainerId   := tmpContainerOverdue.ContainerId,
                                                   inUserId        := vbUserId)
    FROM tmpContainerOverdue
         INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                AND MovementItem.ID = tmpContainerOverdue.MIChildId
    WHERE COALESCE(tmpContainerOverdue.Amount, 0) <> MovementItem.Amount;

      -- �������� ��������� �������� Child
    PERFORM gpMovementItem_Send_SetErased (inMovementItemId        := tmpContainerOverdue.MIChildId,
                                           inSession               := inSession)
    FROM tmpContainerOverdue
    WHERE COALESCE(tmpContainerOverdue.Amount, 0) <= 0;

      -- �������� ��������� �������� �������
    PERFORM gpMovementItem_Send_SetErased (inMovementItemId        := MovementItemMaster.ID,
                                           inSession               := inSession)
    FROM MovementItem AS MovementItemMaster

         LEFT JOIN MovementItem AS MovementItemChild
                                ON MovementItemChild.MovementId = inMovementId
                               AND MovementItemChild.ParentId = MovementItemMaster.Id
                               AND MovementItemChild.DescId = zc_MI_Child()
                               AND MovementItemChild.IsErased = FALSE

    WHERE MovementItemMaster.MovementId = inMovementId
      AND MovementItemMaster.DescId = zc_MI_Master()
      AND MovementItemMaster.IsErased = FALSE
    GROUP BY MovementItemMaster.ID
    HAVING COALESCE(SUM(MovementItemChild.Amount), 0) = 0;

  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;

  /*
   ������� ����������: ����, �����
                 ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.06.19                                                         *
   */

-- ���� SELECT * FROM grUpdate_MovementUnit_SendOverdue (inMovementID := 7784783  , inSession:= '3')

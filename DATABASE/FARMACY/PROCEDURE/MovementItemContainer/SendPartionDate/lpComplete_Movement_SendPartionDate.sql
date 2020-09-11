 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_SendPartionDate (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_SendPartionDate(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMonth_6  Integer;
   DECLARE vbDay_6  Integer;
   DECLARE vbDate180 TDateTime;
   DECLARE vbTransfer Boolean;
BEGIN

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_insert'))
     THEN
         -- !!!�����������!!! �������� ������� ��������
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
     ELSE
         PERFORM lpComplete_Movement_Finance_CreateTemp();
     END IF;


     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ����������
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Unit());
     -- ����������
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- ����������
     vbTransfer := COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Transfer()), FALSE);


     -- ��������
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������������� �� �����������.';
     END IF;


     --
/*     vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                   FROM Object  AS Object_PartionDateKind
                        LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                              ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                             AND ObjectFloat_Month.DescId   = zc_ObjectFloat_PartionDateKind_Month()
                   WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                  );

      -- ���� + 6 �������, + 1 �����
      vbDate180 := vbOperDate+ (vbMonth_6||' MONTH' ) ::INTERVAL; */

      vbDay_6 := (SELECT ObjectFloat_Day.ValueData::Integer
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                             ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

      -- ���� + 6 �������, + 1 �����
      vbDate180 := vbOperDate + (vbDay_6||' DAY' ) ::INTERVAL;


     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_PartionDate'))
     THEN
         DELETE FROM _tmpItem_PartionDate;
     ELSE
         CREATE TEMP TABLE _tmpItem_PartionDate (MovementItemId Integer, GoodsId Integer, Amount TFloat
                                               , ContainerId_in Integer, ContainerId Integer
                                               , MovementId_in Integer, PartionId_in Integer
                                               , PartionGoodsId Integer
                                               , ExpirationDate TDateTime
                                               , PriceWithVAT TFloat, ChangePercentMin TFloat, ChangePercentLess TFloat, ChangePercent TFloat
                                               , ContainerId_Transfer Integer
                                                ) ON COMMIT DROP;
     END IF;    

     -- !!!����������� MI_Master.Amount - ������� �� ������ �� ������ ��� Movement.OperDate!!!
     IF vbTransfer = FALSE
     THEN
       PERFORM lpInsertUpdate_MovementItem (tmp.MovementItemId, zc_MI_Master(), tmp.GoodsId, inMovementId, tmp.Amount, NULL)
       FROM (SELECT MI_Master.Id AS MovementItemId, MI_Master.ObjectId AS GoodsId
                  , SUM (CASE WHEN COALESCE(MIDate_ExpirationDateIncome.ValueData, MIDate_ExpirationDate.ValueData) <= vbDate180 THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END) AS Amount
             FROM MovementItem AS MI_Master
                  LEFT JOIN MovementItem ON MI_Master.MovementId  = inMovementId
                                        AND MovementItem.ParentId = MI_Master.Id
                                        AND MovementItem.DescId   = zc_MI_Child()
                                        AND MovementItem.isErased = FALSE
                  LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                            AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
                  LEFT JOIN MovementItemDate AS MIDate_ExpirationDateIncome
                                             ON MIDate_ExpirationDateIncome.MovementItemId = MovementItem.Id
                                            AND MIDate_ExpirationDateIncome.DescId         = zc_MIDate_ExpirationDateIncome()
             WHERE MI_Master.MovementId = inMovementId
               AND MI_Master.DescId     = zc_MI_Master()
               AND MI_Master.isErased   = FALSE
             GROUP BY MI_Master.Id, MI_Master.ObjectId
            ) AS tmp;

       -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
       INSERT INTO _tmpItem_PartionDate (MovementItemId, GoodsId, Amount, ContainerId_in, ContainerId, MovementId_in, PartionId_in, 
                                         PartionGoodsId, ExpirationDate, PriceWithVAT, ChangePercentMin, ChangePercentLess, ChangePercent, ContainerId_Transfer)
          SELECT MovementItem.Id                    AS MovementItemId
               , MovementItem.ObjectId              AS GoodsId
               , CASE WHEN COALESCE(MIDate_ExpirationDateIncome.ValueData, MIDate_ExpirationDate.ValueData) <= vbDate180 THEN MovementItem.Amount ELSE 0 END AS Amount
               , MIFloat_ContainerId.ValueData      AS ContainerId_in
               , 0                                  AS ContainerId
               , MIFloat_MovementId.ValueData       AS MovementId_in
               , CLO_MI.ObjectId                    AS PartionId_in
               , 0                                  AS PartionGoodsId
                 -- ���� "���� ��������"
               , MIDate_ExpirationDate.ValueData    AS ExpirationDate
                 -- ���� � ���
               , MIFloat_PriceWithVAT.ValueData     AS PriceWithVAT
                 -- % ������(���� ������ ������)
               , CASE WHEN MIFloat_ChangePercentMin.ValueData <> 0 THEN MIFloat_ChangePercentMin.ValueData
                      WHEN MF_ChangePercentMin.ValueData      <> 0 THEN MF_ChangePercentMin.ValueData
                      ELSE 0
                 END AS ChangePercentMin
                 -- % ������(���� �� 1 ��� �� 3 ���)
               , CASE WHEN MIFloat_ChangePercentLess.ValueData <> 0 THEN MIFloat_ChangePercentLess.ValueData
                      WHEN MF_ChangePercentLess.ValueData      <> 0 THEN MF_ChangePercentLess.ValueData
                      ELSE 0
                 END AS ChangePercent
                 -- % ������(���� �� 3 ��� �� 6 ���)
               , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 THEN MIFloat_ChangePercent.ValueData
                      WHEN MF_ChangePercent.ValueData      <> 0 THEN MF_ChangePercent.ValueData
                      ELSE 0
                 END AS ChangePercent
               , 0
          FROM MovementItem
              INNER JOIN MovementItem AS MI_Master ON MI_Master.MovementId = inMovementId
                                                  AND MI_Master.DescId     = zc_MI_Master()
                                                  AND MI_Master.Id         = MovementItem.ParentId
                                                  AND MI_Master.isErased   = FALSE
              LEFT JOIN MovementFloat AS MF_ChangePercent
                                      ON MF_ChangePercent.MovementId = MovementItem.MovementId
                                     AND MF_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
              LEFT JOIN MovementFloat AS MF_ChangePercentLess
                                      ON MF_ChangePercentLess.MovementId = MovementItem.MovementId
                                     AND MF_ChangePercentLess.DescId     = zc_MovementFloat_ChangePercentLess()
              LEFT JOIN MovementFloat AS MF_ChangePercentMin
                                      ON MF_ChangePercentMin.MovementId = MovementItem.MovementId
                                     AND MF_ChangePercentMin.DescId     = zc_MovementFloat_ChangePercentMin()

              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.ParentId
                                         AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentLess
                                          ON MIFloat_ChangePercentLess.MovementItemId = MovementItem.ParentId
                                         AND MIFloat_ChangePercentLess.DescId         = zc_MIFloat_ChangePercentLess()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                          ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.ParentId
                                         AND MIFloat_ChangePercentMin.DescId         = zc_MIFloat_ChangePercentMin()

              LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                          ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                         AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
              LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                          ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                         AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                         ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                        AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
              LEFT JOIN MovementItemDate AS MIDate_ExpirationDateIncome
                                         ON MIDate_ExpirationDateIncome.MovementItemId = MovementItem.Id
                                        AND MIDate_ExpirationDateIncome.DescId         = zc_MIDate_ExpirationDateIncome()
              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                          ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                         AND MIFloat_PriceWithVAT.DescId         = zc_MIFloat_PriceWithVAT()
              INNER JOIN ContainerLinkObject AS CLO_MI
                                             ON CLO_MI.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                            AND CLO_MI.DescId      = zc_ContainerLinkObject_PartionMovementItem()

          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE
            AND CASE WHEN COALESCE(MIDate_ExpirationDateIncome.ValueData, MIDate_ExpirationDate.ValueData) <= vbDate180 THEN MovementItem.Amount ELSE 0 END > 0
         ;
     ELSE

       -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
       INSERT INTO _tmpItem_PartionDate (MovementItemId, GoodsId, Amount, ContainerId_in, ContainerId, MovementId_in, PartionId_in, PartionGoodsId, 
                                         ExpirationDate, PriceWithVAT, ChangePercentMin, ChangePercentLess, ChangePercent, ContainerId_Transfer)
          SELECT MovementItem.Id                    AS MovementItemId
               , MovementItem.ObjectId              AS GoodsId
               , MovementItem.Amount                AS Amount
               , MIFloat_ContainerId.ValueData      AS ContainerId_in
               , 0                                  AS ContainerId
               , MIFloat_MovementId.ValueData       AS MovementId_in
               , CLO_MI.ObjectId                    AS PartionId_in
               , 0                                  AS PartionGoodsId
                 -- ���� "���� ��������"
               , MIDate_ExpirationDate.ValueData    AS ExpirationDate
                 -- ���� � ���
               , MIFloat_PriceWithVAT.ValueData     AS PriceWithVAT
                 -- % ������(���� ������ ������)
               , CASE WHEN MIFloat_ChangePercentMin.ValueData <> 0 THEN MIFloat_ChangePercentMin.ValueData
                      WHEN MF_ChangePercentMin.ValueData      <> 0 THEN MF_ChangePercentMin.ValueData
                      ELSE 0
                 END AS ChangePercentMin
                 -- % ������(���� �� 1 ��� �� 3 ���)
               , CASE WHEN MIFloat_ChangePercentLess.ValueData <> 0 THEN MIFloat_ChangePercentLess.ValueData
                      WHEN MF_ChangePercentLess.ValueData      <> 0 THEN MF_ChangePercentLess.ValueData
                      ELSE 0
                 END AS ChangePercent
                 -- % ������(���� �� 3 ��� �� 6 ���)
               , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 THEN MIFloat_ChangePercent.ValueData
                      WHEN MF_ChangePercent.ValueData      <> 0 THEN MF_ChangePercent.ValueData
                      ELSE 0
                 END AS ChangePercent
               , COALESCE (MIF_ContainerId_Transfer.ValueData, 0)::Integer
          FROM MovementItem
              INNER JOIN MovementItem AS MI_Master ON MI_Master.MovementId = inMovementId
                                                  AND MI_Master.DescId     = zc_MI_Master()
                                                  AND MI_Master.Id         = MovementItem.ParentId
                                                  AND MI_Master.isErased   = FALSE
              LEFT JOIN MovementFloat AS MF_ChangePercent
                                      ON MF_ChangePercent.MovementId = MovementItem.MovementId
                                     AND MF_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
              LEFT JOIN MovementFloat AS MF_ChangePercentLess
                                      ON MF_ChangePercentLess.MovementId = MovementItem.MovementId
                                     AND MF_ChangePercentLess.DescId     = zc_MovementFloat_ChangePercentLess()
              LEFT JOIN MovementFloat AS MF_ChangePercentMin
                                      ON MF_ChangePercentMin.MovementId = MovementItem.MovementId
                                     AND MF_ChangePercentMin.DescId     = zc_MovementFloat_ChangePercentMin()

              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.ParentId
                                         AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentLess
                                          ON MIFloat_ChangePercentLess.MovementItemId = MovementItem.ParentId
                                         AND MIFloat_ChangePercentLess.DescId         = zc_MIFloat_ChangePercentLess()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                          ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.ParentId
                                         AND MIFloat_ChangePercentMin.DescId         = zc_MIFloat_ChangePercentMin()

              LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                          ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                         AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
              LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                          ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                         AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                         ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                        AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
              LEFT JOIN MovementItemDate AS MIDate_ExpirationDateIncome
                                         ON MIDate_ExpirationDateIncome.MovementItemId = MovementItem.Id
                                        AND MIDate_ExpirationDateIncome.DescId         = zc_MIDate_ExpirationDateIncome()
              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                          ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                         AND MIFloat_PriceWithVAT.DescId         = zc_MIFloat_PriceWithVAT()
              INNER JOIN ContainerLinkObject AS CLO_MI
                                             ON CLO_MI.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                            AND CLO_MI.DescId      = zc_ContainerLinkObject_PartionMovementItem()

              LEFT JOIN MovementItemFloat AS MIF_ContainerId_Transfer
                                          ON MIF_ContainerId_Transfer.MovementItemId = MovementItem.ParentId
                                         AND MIF_ContainerId_Transfer.DescId         = zc_MIFloat_ContainerId()

          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Child()
            AND MovementItem.isErased   = FALSE
         ;

     END IF;

    -- �������� - ������� ������ � ����� ������ ���������, ���� ��� - �� �������������� �� ��������� ��� ������ ������ ������ �������
    IF NOT EXISTS (SELECT 1 FROM _tmpItem_PartionDate WHERE _tmpItem_PartionDate.Amount > 0)
    THEN
        RAISE EXCEPTION 'Error. ��� �������� �������.';
    END IF;

     -- ��������
     UPDATE _tmpItem_PartionDate SET PartionGoodsId = lpInsertFind_Object_PartionGoods (-- �������� "������ �� ����������"
                                                                                        inMovementId      := _tmpItem_PartionDate.MovementId_in
                                                                                        -- �������� zc_Movement_SendPartionDate
                                                                                      , inMovementId_send := inMovementId
                                                                                        -- ���� �������� - �� ���� ����
                                                                                      , inOperDate        := _tmpItem_PartionDate.ExpirationDate
                                                                                        -- �������������
                                                                                      , inUnitId          := vbUnitId
                                                                                        -- �����
                                                                                      , inGoodsId         := _tmpItem_PartionDate.GoodsId
                                                                                        -- % ������ �� ���� �� 0 ���. �� 1 ���.
                                                                                      , inChangePercentMin:= _tmpItem_PartionDate.ChangePercentMin
                                                                                        -- % ������ �� ���� �� 1 ���. �� 3 ���.
                                                                                      , inChangePercentLess:= _tmpItem_PartionDate.ChangePercentLess
                                                                                        -- % ������ �� ���� �� 3 ���. �� 6 ���.
                                                                                      , inChangePercent   := _tmpItem_PartionDate.ChangePercent
                                                                                        -- ���� ������� � ���
                                                                                      , inPriceWithVAT    := _tmpItem_PartionDate.PriceWithVAT
                                                                                       );
     -- �������� - zc_Container_CountPartionDate
     UPDATE _tmpItem_PartionDate SET ContainerId = lpInsertFind_Container (inContainerDescId   := zc_Container_CountPartionDate()
                                                                         , inParentId          := _tmpItem_PartionDate.ContainerId_in
                                                                         , inObjectId          := _tmpItem_PartionDate.GoodsId
                                                                         , inJuridicalId_basis := 0
                                                                         , inBusinessId        := NULL
                                                                         , inObjectCostDescId  := NULL
                                                                         , inObjectCostId      := NULL
                                                                         , inDescId_1          := zc_ContainerLinkObject_Unit()
                                                                         , inObjectId_1        := vbUnitId
                                                                         , inDescId_2          := zc_ContainerLinkObject_PartionMovementItem()
                                                                         , inObjectId_2        := _tmpItem_PartionDate.PartionId_in
                                                                         , inDescId_3          := zc_ContainerLinkObject_PartionGoods()
                                                                         , inObjectId_3        := _tmpItem_PartionDate.PartionGoodsId
                                                                          );

    -- ��������� - ������������ �������� �� ����� "������� ��������������� ����� (�� ���� ������)"
    INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                      , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_analyzer
                                       )
         SELECT zc_MIContainer_CountPartionDate()   AS DescId
              , zc_Movement_SendPartionDate()       AS MovementDescId
              , inMovementId                        AS MovementId
              , _tmpItem_PartionDate.MovementItemId AS MovementItemId
              , _tmpItem_PartionDate.ContainerId    AS ContainerId
              , NULL                                AS AccountId
              , _tmpItem_PartionDate.Amount         AS OperSumm
              , vbOperDate                          AS OperDate
              , _tmpItem_PartionDate.GoodsId        AS ObjectId_analyzer
              , vbUnitId                            AS WhereObjectId_analyzer
              , _tmpItem_PartionDate.PartionId_in   AS ObjectIntId_analyzer
         FROM _tmpItem_PartionDate;

    IF vbTransfer = TRUE 
    THEN
        IF EXISTS (SELECT 1 FROM _tmpItem_PartionDate WHERE _tmpItem_PartionDate.ContainerId_Transfer = 0)
        THEN
            RAISE EXCEPTION 'Error. �� ��������� ��������� ��� ��������.';
        END IF;
        
        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                          , ObjectId_analyzer, WhereObjectId_analyzer, ObjectIntId_analyzer
                                           )
         SELECT zc_MIContainer_CountPartionDate()            AS DescId
              , zc_Movement_SendPartionDate()                AS MovementDescId
              , inMovementId                                 AS MovementId
              , _tmpItem_PartionDate.MovementItemId          AS MovementItemId
              , _tmpItem_PartionDate.ContainerId_Transfer    AS ContainerId
              , NULL                                         AS AccountId
              , -1 * _tmpItem_PartionDate.Amount             AS OperSumm
              , vbOperDate                                   AS OperDate
              , _tmpItem_PartionDate.GoodsId                 AS ObjectId_analyzer
              , vbUnitId                                     AS WhereObjectId_analyzer
              , _tmpItem_PartionDate.PartionId_in            AS ObjectIntId_analyzer
         FROM _tmpItem_PartionDate
              INNER JOIN Container ON Container.DescId = zc_Container_CountPartionDate()
                                  AND Container.Id = _tmpItem_PartionDate.ContainerId_Transfer;

     END IF;

     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_SendPartionDate()
                                , inUserId     := inUserId
                                 );

     -- ������������� ����� ��������� �� ��������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.07.20                                                       *
 15.07.19                                                       * 
 07.07.19                                                       *
 27.06.19                                                       *
 21.06.19                                                       *
 15.08.18         *
*/

-- ����
--
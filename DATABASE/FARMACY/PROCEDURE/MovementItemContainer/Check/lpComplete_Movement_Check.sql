-- Function: lpComplete_Movement_Check (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Check (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Check(
    IN inMovementId        Integer  , -- ���� ���������
   OUT outMessageText      Text     ,
    IN inUserId            Integer    -- ������������
)
RETURNS Text
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbMovementItemId Integer;
   DECLARE vbMovementItemId_partion Integer;
   DECLARE vbContainerId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbNDSKindId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmount_remains TFloat;

   DECLARE curRemains refcursor;
   DECLARE curSale refcursor;
BEGIN

     -- �������� ���� �������� ����� ��� ���������� � ������� � ��� �������
     IF EXISTS(SELECT 1
               FROM MovementItem AS MI
                    INNER JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                      ON MILinkObject_PartionDateKind.MovementItemId        = MI.Id
                                                     AND MILinkObject_PartionDateKind.DescId                = zc_MILinkObject_PartionDateKind()
                                                     AND COALESCE(MILinkObject_PartionDateKind.ObjectId, 0) <> 0
                    LEFT JOIN MovementItem AS MIChild
                                           ON MIChild.MovementId = MI.MovementId
                                          AND MIChild.ParentId   = MI.Id
                                          AND MIChild.DescId     = zc_MI_Child()
                                          AND MIChild.Amount     > 0
                                          AND MIChild.isErased   = FALSE
                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                ON MIFloat_ContainerId.MovementItemId = MIChild.Id
                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                    LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer
               WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Amount > 0 AND MI.isErased = FALSE
               GROUP BY MI.Id, MI.Amount
               HAVING MI.Amount <> COALESCE(SUM(MIChild.Amount), 0)
                   OR MI.Amount <> COALESCE(SUM(CASE WHEN COALESCE(Container.Amount, 0) < COALESCE(MIChild.Amount, 0) THEN COALESCE(Container.Amount, 0) ELSE COALESCE(MIChild.Amount, 0) END), 0))
     THEN
           -- ������ ����/���� ������� :
           outMessageText:= '' || (SELECT STRING_AGG (tmp.Value, ' (***) ')
                                     FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') ||
                                                  ' � ����: ' || zfConvert_FloatToString (MI.Amount) || COALESCE (Object_Measure.ValueData, '') ||
                                                  '; ������������: ' || zfConvert_FloatToString (COALESCE(SUM(MIChild.Amount), 0)) || COALESCE (Object_Measure.ValueData, '') ||
                                                  '; �������: ' || zfConvert_FloatToString (COALESCE(SUM(CASE WHEN COALESCE(Container.Amount, 0) < COALESCE(MIChild.Amount, 0) THEN COALESCE(Container.Amount, 0) ELSE COALESCE(MIChild.Amount, 0) END), 0)) || COALESCE (Object_Measure.ValueData, '') AS Value
                                           FROM MovementItem AS MI
                                                INNER JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                                  ON MILinkObject_PartionDateKind.MovementItemId   =    MI.Id
                                                                                 AND MILinkObject_PartionDateKind.DescId                = zc_MILinkObject_PartionDateKind()
                                                                                 AND COALESCE(MILinkObject_PartionDateKind.ObjectId, 0) <> 0
                                                LEFT JOIN MovementItem AS MIChild
                                                                        ON MIChild.MovementId = MI.MovementId
                                                                       AND MIChild.ParentId   = MI.Id
                                                                       AND MIChild.DescId     = zc_MI_Child()
                                                                       AND MIChild.Amount     > 0
                                                                       AND MIChild.isErased   = FALSE
                                                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                            ON MIFloat_ContainerId.MovementItemId = MIChild.Id
                                                                           AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                                LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer
                                                LEFT JOIN Object ON Object.Id = MI.ObjectId
                                                LEFT JOIN ObjectLink ON ObjectLink.ObjectId = MI.ObjectId
                                                                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                           WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Amount > 0 AND MI.isErased = FALSE
                                           GROUP BY MI.Id, MI.Amount, Object.ObjectCode, Object.ValueData, Object_Measure.ValueData
                                           HAVING MI.Amount <> COALESCE(SUM(MIChild.Amount), 0)
                                               OR MI.Amount <> COALESCE(SUM(CASE WHEN COALESCE(Container.Amount, 0) < COALESCE(MIChild.Amount, 0) THEN COALESCE(Container.Amount, 0) ELSE COALESCE(MIChild.Amount, 0) END), 0)
                                         ) AS tmp
                                    )
                         || '';

           -- ��������� ������
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, outMessageText :: TVarChar);

           -- ������ ����/���� ������� :
           outMessageText:= '������.����������� ������: ' || outMessageText;

           -- ����� ������
           IF 0 = 0/* OR inUserId <> 3*/
           THEN
               -- ������ ������ �� ������
               RETURN;
           END IF;

     END IF;

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
    vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);

    -- ����������
    vbAccountId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000()         -- ������
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_20100()     -- C����
                                             , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId);
    -- ����������
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject
                WHERE MovementLinkObject.MovementId = inMovementId
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());


    -- ������ ����� ���
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_remains'))
    THEN
        -- DELETE FROM _tmpItem_remains;
        DROP TABLE _tmpItem_remains;
        -- ������� - ������ ����� ���
        CREATE TEMP TABLE _tmpItem_remains (MovementItemId_partion Integer, GoodsId Integer, ContainerId Integer, NDSKindId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
    ELSE
        -- ������� - ������ ����� ���
        CREATE TEMP TABLE _tmpItem_remains (MovementItemId_partion Integer, GoodsId Integer, ContainerId Integer, NDSKindId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;
    END IF;

    -- �������������� ��������� �������
    INSERT INTO _tmpItem (MovementItemId, ObjectId, NDSKindId, OperSumm, Price)
       SELECT MI.Id, MI.ObjectId, COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId), MI.Amount, COALESCE (MIFloat_Price.ValueData, 0)
       FROM MovementItem AS MI
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MI.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItem AS MIChild
                                   ON MIChild.MovementId = MI.MovementId
                                  AND MIChild.ParentId   = MI.Id
                                  AND MIChild.DescId     = zc_MI_Child()
                                  AND MIChild.Amount     > 0
                                  AND MIChild.isErased   = FALSE
            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MIChild.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MI.ObjectId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                             ON MILinkObject_NDSKind.MovementItemId = MI.Id
                                            AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

       WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Amount > 0 AND MI.isErased = FALSE
         AND COALESCE (MIChild.Id, 0) = 0;

    -- �������������� ��������� �������
    INSERT INTO _tmpItem_remains (MovementItemId_partion, GoodsId, ContainerId, NDSKindId, Amount, OperDate)
       SELECT CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0 THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS MovementItemId_partion
            , Container.ObjectId AS GoodsId
            , Container.Id       AS ContainerId
            , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = FALSE
                     OR COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) = 0
                   THEN Object_Goods.NDSKindId ELSE MovementLinkObject_NDSKind.ObjectId END  AS NDSKindId
            , Container.Amount                                                               AS Amount
            , Movement.OperDate
       FROM (SELECT DISTINCT ObjectId FROM _tmpItem) AS tmp
            INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.ObjectId = tmp.ObjectId
                                AND Container.Amount > 0
            LEFT JOIN Container AS PDContainer
                                ON PDContainer.DescId = zc_Container_CountPartionDate()
                               AND PDContainer.ParentId = Container.Id
                               AND PDContainer.WhereObjectId = vbUnitId
                               AND PDContainer.ObjectId = tmp.ObjectId
                               AND PDContainer.Amount > 0
            LEFT OUTER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Container.ObjectId
            LEFT OUTER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

            -- ������
            INNER JOIN ContainerLinkObject AS CLI_MI
                                           ON CLI_MI.ContainerId = Container.Id
                                          AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            -- ������� �������
            INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
            -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
            -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                            ON MovementBoolean_UseNDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MovementItem.MovementId)
                                           AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MovementItem.MovementId)
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
       WHERE COALESCE (PDContainer.id, 0) = 0
       ;

    -- �������� ��� � ��� ������� � �����
    IF EXISTS (SELECT 1
               FROM (SELECT ObjectId AS GoodsId, NDSKindId, SUM (OperSumm) AS Amount FROM _tmpItem GROUP BY ObjectId, NDSKindId) AS tmpFrom
                     LEFT JOIN (SELECT _tmpItem_remains.GoodsId, _tmpItem_remains.NDSKindId, SUM (Amount) AS Amount
                                FROM _tmpItem_remains
                                GROUP BY _tmpItem_remains.GoodsId, _tmpItem_remains.NDSKindId) AS tmpTo
                                                                                               ON tmpTo.GoodsId = tmpFrom.GoodsId
                                                                                              AND tmpTo.NDSKindId = tmpFrom.NDSKindId
               WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0))
    THEN
           -- ������ ����/���� ������� :
           outMessageText:= '' || (SELECT STRING_AGG (tmp.Value, ' (***) ')
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') || ' � ����: ' || zfConvert_FloatToString (AmountFrom) || COALESCE (Object_Measure.ValueData, '') || '; �������: ' || zfConvert_FloatToString (AmountTo) || COALESCE (Object_Measure.ValueData, '') AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo FROM (SELECT ObjectId AS GoodsId, NDSKindId, SUM (OperSumm) AS Amount FROM _tmpItem GROUP BY ObjectId, NDSKindId) AS tmpFrom LEFT JOIN (SELECT _tmpItem_remains.GoodsId, _tmpItem_remains.NDSKindId, SUM (Amount) AS Amount FROM _tmpItem_remains GROUP BY _tmpItem_remains.GoodsId, _tmpItem_remains.NDSKindId) AS tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId AND tmpTo.NDSKindId = tmpFrom.NDSKindId WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                               LEFT JOIN ObjectLink ON ObjectLink.ObjectId = tmp.GoodsId
                                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_Measure()
                                               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink.ChildObjectId
                                         ) AS tmp
                                    )
                         || '';

           -- ��������� ������
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, outMessageText :: TVarChar);

           -- ������ ����/���� ������� :
           outMessageText:= '������.������ ��� � �������: ' || outMessageText;

           -- ����� ������
           IF 1 = 1 /*OR inUserId <> 3*/
           THEN
               -- ������ ������ �� ������
               RETURN;
           END IF;

     END IF;

    -- !!!������ ���� ����� ����������� - ����������� �� ��������!!!
    IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY ObjectId, NDSKindId HAVING COUNT (*) > 1)
    THEN
        -- ������1 - �������� �������
        OPEN curSale FOR SELECT MovementItemId, ObjectId, NDSKindId, OperSumm AS Amount FROM _tmpItem;
        -- ������ ����� �� �������1 - ��������
        LOOP
                -- ������ �� ��������
                FETCH curSale INTO vbMovementItemId, vbGoodsId, vbNDSKindId, vbAmount;
                -- ���� ������ �����������, ����� �����
                IF NOT FOUND THEN EXIT; END IF;

                -- ������2. - ������� ����� ������� ��� ������������ ��� vbGoodsId
                OPEN curRemains FOR
                   SELECT _tmpItem_remains.ContainerId, _tmpItem_remains.MovementItemId_partion, _tmpItem_remains.GoodsId, _tmpItem_remains.Amount - COALESCE (tmp.Amount, 0)
                   FROM _tmpItem_remains
                        LEFT JOIN (SELECT ContainerId, -1 * SUM (_tmpMIContainer_insert.Amount) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId
                                  ) AS tmp ON tmp.ContainerId = _tmpItem_remains.ContainerId
                   WHERE _tmpItem_remains.GoodsId = vbGoodsId
                     AND _tmpItem_remains.NDSKindId = vbNDSKindId
                     AND _tmpItem_remains.Amount - COALESCE (tmp.Amount, 0) > 0
                   ORDER BY _tmpItem_remains.OperDate DESC, _tmpItem_remains.ContainerId DESC
                  ;
                -- ������ ����� �� �������2. - �������
                LOOP
                    -- ������ �� ��������
                    FETCH curRemains INTO vbContainerId, vbMovementItemId_partion, vbGoodsId, vbAmount_remains;
                    -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

                    --
                    IF vbAmount_remains > vbAmount
                    THEN
                        -- ���������� � �������� ������ ��� ������, !!!��������� � ����-��������� - �������� ���-��!!!
                        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                                           )
                           SELECT zc_MIContainer_Count()
                                , zc_Movement_Check()
                                , inMovementId
                                , vbMovementItemId
                                , vbContainerId
                                , vbAccountId
                                , -1 * vbAmount
                                , vbOperDate
                                , vbGoodsId                AS ObjectId_analyzer
                                , vbUnitId                 AS WhereObjectId_analyzer
                                , vbMovementItemId_partion AS AnalyzerId
                                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
                                , (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId) AS Price
                                 ;
                        -- �������� ���-�� ��� �� ������ �� ������
                        vbAmount:= 0;
                    ELSE
                        -- ���������� � �������� ������ ��� ������, !!!��������� � ����-��������� - �������� ���-��!!!
                        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                                           )
                           SELECT zc_MIContainer_Count()
                                , zc_Movement_Check()
                                , inMovementId
                                , vbMovementItemId
                                , vbContainerId
                                , vbAccountId
                                , -1 * vbAmount_remains
                                , vbOperDate
                                , vbGoodsId                AS ObjectId_analyzer
                                , vbUnitId                 AS WhereObjectId_analyzer
                                , vbMovementItemId_partion AS AnalyzerId
                                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = vbMovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
                                , (SELECT _tmpItem.Price FROM _tmpItem WHERE _tmpItem.MovementItemId = vbMovementItemId) AS Price
                                 ;
                        -- ��������� �� ���-�� ������� ����� � ���������� �����
                        vbAmount:= vbAmount - vbAmount_remains;
                    END IF;

                END LOOP; -- ����� ����� �� �������2. - �������
                CLOSE curRemains; -- ������� ������2. - �������

            END LOOP; -- ����� ����� �� �������1 - �������
            CLOSE curSale; -- ������� ������1 - �������

    ELSE
        -- !!!�����!!! - ��������� - �������� ���-��
        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                           )
           WITH tmpContainer AS (SELECT MI_Sale.MovementItemId
                                      , MI_Sale.ObjectId        AS GoodsId
                                      , MI_Sale.OperSumm        AS SaleAmount
                                      , MI_Sale.Price
                                      , Container.Amount        AS ContainerAmount
                                      , Container.ContainerId
                                      , Container.MovementItemId_partion
                                      , SUM (Container.Amount) OVER (PARTITION BY Container.GoodsId, Container.NDSKindId ORDER BY Container.OperDate, Container.ContainerId, MI_Sale.MovementItemId) AS ContainerAmountSUM
                                      , ROW_NUMBER() OVER (PARTITION BY /*MI_Sale.ObjectId*/ MI_Sale.MovementItemId ORDER BY Container.OperDate DESC, Container.ContainerId DESC, MI_Sale.MovementItemId DESC) AS DOrd
                                 FROM _tmpItem AS MI_Sale
                                      INNER JOIN _tmpItem_remains AS Container
                                                                  ON Container.GoodsId = MI_Sale.ObjectId
                                                                 AND Container.NDSKindId = MI_Sale.NDSKindId
                                )
           -- ���������
           SELECT zc_MIContainer_Count()
                , zc_Movement_Check()
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.ContainerId
                , vbAccountId
                , -1 * Amount
                , vbOperDate
                , tmpItem.GoodsId                AS ObjectId_analyzer
                , vbUnitId                       AS WhereObjectId_analyzer
                , tmpItem.MovementItemId_partion AS AnalyzerId
                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer WHERE MIContainer.MovementItemId = tmpItem.MovementItemId_partion AND MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
                , tmpItem.Price
              FROM (SELECT DD.ContainerId
                         , DD.GoodsId
                         , DD.MovementItemId
                         , DD.MovementItemId_partion
                         , DD.Price
                         , CASE WHEN DD.SaleAmount - DD.ContainerAmountSUM > 0 AND DD.DOrd <> 1
                                     THEN DD.ContainerAmount
                                ELSE DD.SaleAmount - DD.ContainerAmountSUM + DD.ContainerAmount
                           END AS Amount
                    FROM (SELECT * FROM tmpContainer) AS DD
                    WHERE DD.SaleAmount - (DD.ContainerAmountSUM - DD.ContainerAmount) > 0
                   ) AS tmpItem;

    END IF;

        -- !!!�����!!! - ��������� - �������� ���-�� �� �������� ����������
    IF EXISTS(SELECT 1 FROM MovementItem AS MIChild
              WHERE MIChild.MovementId = inMovementId
                AND MIChild.DescId     = zc_MI_Child()
                AND MIChild.Amount     > 0
                AND MIChild.isErased   = FALSE)
    THEN
        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                           )
           -- ���������
           SELECT zc_MIContainer_Count()
                , zc_Movement_Check()
                , inMovementId
                , MI.ParentId
                , Container.ParentId
                , vbAccountId
                , -1 * MI.Amount
                , vbOperDate
                , MI.ObjectId                    AS ObjectId_analyzer
                , vbUnitId                       AS WhereObjectId_analyzer
                , CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS AnalyzerId
                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer
                   WHERE MIContainer.MovementItemId =  CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END
                      AND MIContainer.DescId = zc_MIContainer_Count()
                      AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
                , COALESCE (MIFloat_Price.ValueData, 0)
           FROM MovementItem AS MI
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MI.ParentId
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MI.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer

                -- ������
                INNER JOIN ContainerLinkObject AS CLI_MI
                                               ON CLI_MI.ContainerId = Container.ParentId
                                              AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                -- ������� �������
                INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                            ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
           WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.Amount > 0 AND MI.isErased = FALSE;


        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate
                                          , ObjectId_analyzer, WhereObjectId_analyzer, AnalyzerId, ObjectIntId_analyzer, Price
                                           )
           -- ���������
           SELECT zc_MIContainer_CountPartionDate()
                , zc_Movement_Check()
                , inMovementId
                , MI.Id
                , Container.ID
                , NULL
                , -1 * MI.Amount
                , vbOperDate
                , MI.ObjectId                    AS ObjectId_analyzer
                , vbUnitId                       AS WhereObjectId_analyzer
                , CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END AS AnalyzerId
                , (SELECT MIContainer.ObjectIntId_analyzer FROM MovementItemContainer AS MIContainer
                   WHERE MIContainer.MovementItemId =  CASE WHEN Movement.DescId = zc_Movement_Inventory() AND MIFloat_MovementItem.ValueData > 0
                      THEN MIFloat_MovementItem.ValueData :: Integer ELSE MovementItem.Id END
                      AND MIContainer.DescId = zc_MIContainer_Count()
                      AND MIContainer.ObjectIntId_analyzer <> 0) AS ObjectIntId_analyzer
                , COALESCE (MIFloat_Price.ValueData, 0)
           FROM MovementItem AS MI
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MI.ParentId
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MI.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                LEFT JOIN Container ON Container.ID = MIFloat_ContainerId.ValueData::Integer

                -- ������
                INNER JOIN ContainerLinkObject AS CLI_MI
                                               ON CLI_MI.ContainerId = Container.ParentId
                                              AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                -- ������� �������
                INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                            ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
           WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.Amount > 0 AND MI.isErased = FALSE;
    END IF;

     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

      -- ��������� ���������� ������������� ����������� �����
     IF COALESCE((SELECT MovementFloat.ValueData
                  FROM MovementFloat
                  WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMID()
                    AND MovementFloat.MovementId = inMovementId), 0) <> 0
     THEN
       PERFORM gpUpdate_LoyaltySaveMoney_Summa (inMovementId, MovementFloat_LoyaltySMID.ValueData::INTEGER, inUserId::TVarChar)
       FROM MovementFloat AS MovementFloat_LoyaltySMID
       WHERE MovementFloat_LoyaltySMID.DescID = zc_MovementFloat_LoyaltySMID()
         AND MovementFloat_LoyaltySMID. MovementId = inMovementId;
     END IF;

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Check()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ������ �.�.
 06.06.19                                                                   *
 11.02.14                        *
 05.02.14                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ���� ���������
--    IN inUserId            Integer    -- ������������
-- SELECT * FROM lpComplete_Movement_Check (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671`

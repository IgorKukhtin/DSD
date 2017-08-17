-- Function: lpComplete_Movement_Send (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbUnitId_From              Integer;
  DECLARE vbUnitId_To                Integer;
  DECLARE vbAccountDirectionId_From  Integer;
  DECLARE vbAccountDirectionId_To    Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId               Integer; -- �������� ���� �� ������������

  DECLARE vbCurrencyDocumentId     Integer;
  DECLARE vbCurrencyValue          TFloat;
  DECLARE vbParValue               TFloat;

  DECLARE vbWhereObjectId_Analyzer_From Integer; -- ��������� ��� ��������
  DECLARE vbWhereObjectId_Analyzer_To   Integer; -- ��������� ��� ��������

BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��������� �� ���������
     SELECT _tmp.MovementDescId, _tmp.OperDate, _tmp.UnitId_From, _tmp.UnitId_To
          , _tmp.AccountDirectionId_From, _tmp.AccountDirectionId_To
            INTO vbMovementDescId
               , vbOperDate
               , vbUnitId_From
               , vbUnitId_To
               , vbAccountDirectionId_From
               , vbAccountDirectionId_To
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE 0 END, 0) AS UnitId_From
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit() THEN Object_To.Id   ELSE 0 END, 0) AS UnitId_To

                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ��������
                , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From
                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ��������
                , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100())   AS AccountDirectionId_To

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                                     ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_UnitTo_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- ������������ - ��������� ��� ��������
     vbWhereObjectId_Analyzer_From:= CASE WHEN vbUnitId_From <> 0 THEN vbUnitId_From END;
     vbWhereObjectId_Analyzer_To  := CASE WHEN vbUnitId_To   <> 0 THEN vbUnitId_To   END;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_SummFrom, ContainerId_GoodsFrom
                         , ContainerId_SummTo, ContainerId_GoodsTo
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperSumm, OperSumm_Currency
                         , AccountId_From, AccountId_To, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- ���������
        SELECT _tmp.MovementItemId
             , 0 AS ContainerId_SummFrom          -- ���������� �����
             , 0 AS ContainerId_GoodsFrom         -- ���������� �����
             , 0 AS ContainerId_SummTo            -- ���������� �����
             , 0 AS ContainerId_GoodsTo           -- ���������� �����
             , _tmp.GoodsId
             , _tmp.PartionId
             , _tmp.GoodsSizeId
             , _tmp.OperCount

               -- ����� �� �/�
             , _tmp.OperSumm
               -- ����� � ������ �� �/�
             , _tmp.OperSumm_Currency

             , 0 AS AccountId_From                 -- ����(�����������), ���������� �����
             , 0 AS AccountId_To                   -- ����(�����������), ���������� �����

               -- ��
             , _tmp.InfoMoneyGroupId
             , _tmp.InfoMoneyDestinationId
             , _tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                  AS MovementItemId
                   , MovementItem.ObjectId            AS GoodsId
                   , MovementItem.PartionId           AS PartionId
                   , Object_PartionGoods.GoodsSizeId  AS GoodsSizeId
                   , MovementItem.Amount              AS OperCount

                     -- ����� �� ����������� � ������ ������� - � ����������� �� 2-� ������
                   , CAST (MovementItem.Amount
                         * CASE WHEN Object_PartionGoods.CurrencyId <> zc_Currency_Basis()
                                     -- ��� ����������� � ������ zc_Currency_Basis - � ����������� �� 2-� ������
                                     THEN CAST (COALESCE (MIFloat_OperPrice.ValueData, 0) * COALESCE (MIFloat_CurrencyValue.ValueData, 0) / CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END AS NUMERIC (16, 2))
                                ELSE COALESCE (MIFloat_OperPrice.ValueData, 0)
                           END
                         / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                     AS NUMERIC (16, 2)) AS OperSumm

                     -- ����� �� ����������� � ������ - � ����������� �� 2-� ������
                   , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0) / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS NUMERIC (16, 2)) AS OperSumm_Currency
                   
                     -- �������������� ������
                   , View_InfoMoney.InfoMoneyGroupId
                     -- �������������� ����������
                   , View_InfoMoney.InfoMoneyDestinationId
                     -- ������ ����������
                   , View_InfoMoney.InfoMoneyId

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                   LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId

                   LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                               ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!��������!!! ������ + ������ + ������

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Send()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
            ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_GoodsFrom = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId_From
                                                                                    , inMemberId               := NULL
                                                                                    , inClientId               := NULL
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inPartionId              := _tmpItem.PartionId
                                                                                    , inPartionId_MI           := NULL
                                                                                    , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                    , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                     )
                       , ContainerId_GoodsTo   = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                    , inUnitId                 := vbUnitId_To
                                                                                    , inMemberId               := NULL
                                                                                    , inClientId               := NULL
                                                                                    , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                    , inGoodsId                := _tmpItem.GoodsId
                                                                                    , inPartionId              := _tmpItem.PartionId
                                                                                    , inPartionId_MI           := NULL
                                                                                    , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                    , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                     );

     -- 2.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem SET AccountId_From = _tmpItem_byAccount.AccountId_From
                       , AccountId_To   = _tmpItem_byAccount.AccountId_To
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_From
                , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_To
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId_To
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
    ;

     -- 2.2. ������������ ContainerId_Summ ��� �������� �� ��������� �����
     UPDATE _tmpItem SET ContainerId_SummFrom = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                  , inUnitId                 := vbUnitId_From
                                                                                  , inMemberId               := NULL
                                                                                  , inClientId               := NULL
                                                                                  , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                  , inBusinessId             := vbBusinessId
                                                                                  , inAccountId              := _tmpItem.AccountId_From
                                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                  , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                  , inContainerId_Goods      := _tmpItem.ContainerId_GoodsFrom
                                                                                  , inGoodsId                := _tmpItem.GoodsId
                                                                                  , inPartionId              := _tmpItem.PartionId
                                                                                  , inPartionId_MI           := NULL
                                                                                  , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                   )
                       , ContainerId_SummTo   = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                  , inUnitId                 := vbUnitId_To
                                                                                  , inMemberId               := NULL
                                                                                  , inClientId               := NULL
                                                                                  , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                  , inBusinessId             := vbBusinessId
                                                                                  , inAccountId              := _tmpItem.AccountId_To
                                                                                  , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                  , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                  , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTo
                                                                                  , inGoodsId                := _tmpItem.GoodsId
                                                                                  , inPartionId              := _tmpItem.PartionId
                                                                                  , inPartionId_MI           := NULL
                                                                                  , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                   );

     -- 3.1. ����������� �������� - ������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsFrom
            , 0                                       AS ParentId
            , _tmpItem.AccountId_From                 AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem.AccountId_To                   AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem.ContainerId_SummTo             AS ContainerIntId_Analyzer-- ��������� - ������������� - �� �������
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� ����
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
      UNION ALL
       -- �������� - ������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_GoodsTo
            , 0                                       AS ParentId
            , _tmpItem.AccountId_To                   AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem.AccountId_From                 AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem.ContainerId_SummFrom           AS ContainerIntId_Analyzer-- ��������� - ������������� - �� �������
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� �� ����
            , 1 * _tmpItem.OperCount                  AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem;


     -- 3.2. ����������� �������� - ������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- �������� - ������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_SummFrom
            , 0                                       AS ParentId
            , _tmpItem.AccountId_From                 AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_From           AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem.AccountId_To                   AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem.ContainerId_SummTo             AS ContainerIntId_Analyzer-- ��������� - ������������� - �� �������
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_To                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� ����
            , -1 * _tmpItem.OperSumm                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
      UNION ALL
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_SummTo
            , 0                                       AS ParentId
            , _tmpItem.AccountId_To                   AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbWhereObjectId_Analyzer_To             AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem.AccountId_From                 AS AccountId_Analyzer     -- ���� - ������������� - �� �������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem.ContainerId_SummFrom           AS ContainerIntId_Analyzer-- ��������� - ������������� - �� �������
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbUnitId_From                           AS ObjectExtId_Analyzer   -- ������������� ���������� - ������������� �� ����
            , 1 * _tmpItem.OperSumm                   AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
     

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Send()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 28.06.17                                        *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 39, inSession:= zfCalc_UserAdmin())

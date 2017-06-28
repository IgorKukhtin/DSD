-- Function: lpComplete_Movement_ReturnOut (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnOut (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnOut(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId           Integer;
  DECLARE vbOperDate                 TDateTime;
  DECLARE vbPartnerId                Integer;
  DECLARE vbUnitId                   Integer;
  DECLARE vbAccountDirectionId_From  Integer;
  DECLARE vbJuridicalId_Basis        Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId               Integer; -- �������� ���� �� ������������

  DECLARE vbCurrencyDocumentId     Integer;
  DECLARE vbCurrencyValue          TFloat;
  DECLARE vbParValue               TFloat;

  DECLARE vbWhereObjectId_Analyzer Integer; -- ��������� ��� ��������

BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPartner;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��������� �� ���������
     SELECT _tmp.MovementDescId, _tmp.OperDate, _tmp.PartnerId, _tmp.UnitId
          , _tmp.CurrencyDocumentId, _tmp.CurrencyValue, _tmp.ParValue
          , _tmp.AccountDirectionId_From
            INTO vbMovementDescId
               , vbOperDate
               , vbPartnerId
               , vbUnitId
               , vbCurrencyDocumentId
               , vbCurrencyValue
               , vbParValue
               , vbAccountDirectionId_From
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Partner() THEN Object_To.Id   ELSE 0 END, 0) AS PartnerId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()    THEN Object_From.Id ELSE 0 END, 0) AS UnitId

                , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Currency_Basis()) AS CurrencyDocumentId
                , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                          AS CurrencyValue
                , COALESCE (MovementFloat_ParValue.ValueData, 0)                               AS ParValue

                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ��������
                , COALESCE (ObjectLink_UnitFrom_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_From

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()

                LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                        ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                       AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                        ON MovementFloat_ParValue.MovementId = Movement.Id
                                       AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_ReturnOut()
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- ������������ - ��������� ��� ��������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId END;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId, GoodsSizeId
                         , OperCount, OperSumm, OperSumm_Currency
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- ���������
        SELECT _tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- ���������� �����
             , 0 AS ContainerId_Goods         -- ���������� �����
             , _tmp.GoodsId
             , _tmp.PartionId
             , _tmp.GoodsSizeId
             , _tmp.OperCount

               -- ����� �� �����������
             , _tmp.OperSumm
               -- ����� � ������ �� �����������
             , _tmp.OperSumm_Currency

             , 0 AS AccountId                 -- ����(�����������), ���������� �����

               -- �� ��� ReturnOut = �� ���� �����������
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
                         * CASE WHEN vbCurrencyDocumentId <> zc_Currency_Basis()
                                     -- ��� ����������� � ������ zc_Currency_Basis - � ����������� �� 2-� ������
                                     THEN CAST (COALESCE (MIFloat_OperPrice.ValueData, 0) * vbCurrencyValue / CASE WHEN vbParValue > 0 THEN vbParValue ELSE 1 END AS NUMERIC (16, 2))
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
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) -- !!!��������!!! ������ + ������ + ������

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_ReturnOut()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
            ;


     -- ��������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_SummPartner (MovementItemId, ContainerId, ContainerId_Currency, AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId, GoodsId, PartionId, OperSumm, OperSumm_Currency)
        SELECT _tmpItem.MovementItemId
             , 0 AS ContainerId, 0 AS ContainerId_Currency, 0 AS AccountId
             , _tmpItem.InfoMoneyGroupId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId
             , _tmpItem.GoodsId
             , _tmpItem.PartionId
             , (_tmpItem.OperSumm)          AS OperSumm
             , (_tmpItem.OperSumm_Currency) AS OperSumm_Currency
        FROM _tmpItem
        ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 1. ������������ ContainerId_Goods ��� ��������������� �����
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inMemberId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inPartionId              := _tmpItem.PartionId
                                                                                , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 );

     -- 2.1. ������������ ����(�����������) ��� �������� �� ��������� �����
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_From
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
    ;

     -- 2.2. ������������ ContainerId_Summ ��� �������� �� ��������� �����
     UPDATE _tmpItem SET ContainerId_Summ = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                              , inUnitId                 := vbUnitId
                                                                              , inMemberId               := NULL
                                                                              , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                              , inBusinessId             := vbBusinessId
                                                                              , inAccountId              := _tmpItem.AccountId
                                                                              , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                              , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                              , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                              , inGoodsId                := _tmpItem.GoodsId
                                                                              , inPartionId              := _tmpItem.PartionId
                                                                              , inGoodsSizeId            := _tmpItem.GoodsSizeId
                                                                               );


     -- 3.1. ������������ ����(�����������) ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner SET AccountId  = _tmpItem_byAccount.AccountId
     FROM
          (SELECT lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT
                        zc_Enum_AccountGroup_60000()      AS AccountGroupId     -- ���������
                      , zc_Enum_AccountDirection_60100()  AS AccountDirectionId -- ����������
                      , _tmpItem_SummPartner.InfoMoneyDestinationId
                 FROM _tmpItem_SummPartner
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem_SummPartner.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;

     -- 3.2.1. ������������ ContainerId ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner SET ContainerId          = tmp.ContainerId
     FROM (SELECT tmp.InfoMoneyId
                  -- � ������ �������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := tmp.AccountId
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Partner()
                                        , inObjectId_1        := vbPartnerId
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := tmp.InfoMoneyId
                                         ) AS ContainerId
           FROM (SELECT DISTINCT
                        _tmpItem_SummPartner.AccountId
                      , _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner.InfoMoneyId = tmp.InfoMoneyId
    ;
     -- 3.2.2. ������������ ContainerId ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner SET ContainerId_Currency = tmp.ContainerId_Currency
     FROM (SELECT tmp.InfoMoneyId
                  -- � ������ ��������� - ���� ����
                , lpInsertFind_Container (inContainerDescId   := zc_Container_SummCurrency()
                                        , inParentId          := tmp.ContainerId
                                        , inObjectId          := tmp.AccountId
                                        , inPartionId         := NULL
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Partner()
                                        , inObjectId_1        := vbPartnerId
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := tmp.InfoMoneyId
                                        , inDescId_3          := zc_ContainerLinkObject_Currency()
                                        , inObjectId_3        := vbCurrencyDocumentId
                                         ) AS ContainerId_Currency
           FROM (SELECT DISTINCT
                        _tmpItem_SummPartner.ContainerId
                      , _tmpItem_SummPartner.AccountId
                      , _tmpItem_SummPartner.InfoMoneyId
                 FROM _tmpItem_SummPartner
                 WHERE vbCurrencyDocumentId <> zc_Currency_Basis()
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner.InfoMoneyId = tmp.InfoMoneyId
    ;




     -- 4.1. ����������� �������� - ������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- ���� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummPartner.AccountId          AS AccountId_Analyzer     -- ���� - ������������� - �� ������ ����������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem_SummPartner.ContainerId        AS ContainerIntId_Analyzer-- ��������� - ������������� - �� ������ ����������
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbPartnerId                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , -1 * _tmpItem.OperCount                 AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.MovementItemId = _tmpItem.MovementItemId;


     -- 4.2. ����������� �������� - ������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Summ
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- ����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummPartner.AccountId          AS AccountId_Analyzer     -- ���� - ������������� - �� ������ ����������
            , 0                                       AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem_SummPartner.ContainerId        AS ContainerIntId_Analyzer-- ��������� - ������������� - �� ������ ����������
            , _tmpItem.GoodsSizeId                    AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbPartnerId                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , -1 * _tmpItem.OperSumm                  AS Amount
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.MovementItemId = _tmpItem.MovementItemId;


     -- 4.3. ����������� �������� - ���� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerIntId_Analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��� 2 ��������
       SELECT 0, _tmpItem_group.DescId, vbMovementDescId, inMovementId
            , 0                               AS MovementItemId
            , _tmpItem_group.ContainerId      AS ContainerId
            , 0                               AS ParentId
            , _tmpItem_group.AccountId        AS AccountId               -- ����
            , 0                               AS AnalyzerId              -- ���� �������� (��������)
            , vbPartnerId                     AS ObjectId_Analyzer       -- ���������
            , 0                               AS PartionId               -- ������
            , 0                               AS WhereObjectId_Analyzer  -- ����� �����
            , 0                               AS AccountId_Analyzer      -- ���� - �������������
            , 0                               AS ContainerId_Analyzer    -- ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , 0                               AS ContainerIntId_Analyzer -- ��������� - �������������
            , 0                               AS ObjectIntId_Analyzer    -- ������������� ����������
            , 0                               AS ObjectExtId_Analyzer    -- ������������� ����������
            , 1 * _tmpItem_group.OperSumm     AS Amount
            , vbOperDate                      AS OperDate
            , TRUE                            AS isActive

       FROM (-- !!!����!!! �������� � ������ �������
             SELECT zc_MIContainer_Summ() AS DescId, tmp.ContainerId, tmp.AccountId, SUM (tmp.OperSumm) AS OperSumm FROM _tmpItem_SummPartner AS tmp GROUP BY tmp.ContainerId, tmp.AccountId
            UNION ALL
             -- !!!����!!! �������� ��� "�������������" ��������� ����� - ���� ����
             SELECT zc_MIContainer_SummCurrency() AS DescId, tmp.ContainerId_Currency AS ContainerId, tmp.AccountId, SUM (tmp.OperSumm_Currency) AS OperSumm FROM _tmpItem_SummPartner AS tmp WHERE vbCurrencyDocumentId <> zc_Currency_Basis() GROUP BY tmp.ContainerId_Currency, tmp.AccountId
            ) AS _tmpItem_group
       -- !!!�� ����� ������������, �.�. ��� �������� ?�����? ����������� � �������!!!
       -- WHERE _tmpItem_group.OperSumm <> 0
      ;


     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReturnOut()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 28.06.17                                        *
 25.04.17         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_ReturnOut (inMovementId:= 39, inSession:= zfCalc_UserAdmin())

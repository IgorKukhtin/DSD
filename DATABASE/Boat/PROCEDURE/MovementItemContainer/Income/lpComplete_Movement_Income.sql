DROP FUNCTION IF EXISTS lpComplete_Movement_Income (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Income(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId          Integer;
  DECLARE vbStatusId                Integer;
  DECLARE vbOperDate                TDateTime;
  DECLARE vbPartnerId               Integer;
  DECLARE vbPartnerId_VAT           Integer;
  DECLARE vbUnitId                  Integer;
  DECLARE vbPaidKindId              Integer;
  DECLARE vbInfoMoneyId_Partner     Integer;
  DECLARE vbInfoMoneyId_Partner_VAT Integer;
  DECLARE vbAccountDirectionId_To   Integer;
  DECLARE vbJuridicalId_Basis       Integer; -- �������� ���� �� ������������
  DECLARE vbBusinessId              Integer; -- �������� ���� �� ������������

  DECLARE vbPriceWithVAT            Boolean;
  DECLARE vbVATPercent              TFloat;
  DECLARE vbDiscountTax             TFloat;

  DECLARE vbWhereObjectId_Analyzer Integer; -- ��������� ��� ��������
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     -- !!!�����������!!! �������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem_SummPartner;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- ��������� �� ���������
     SELECT tmp.MovementDescId, tmp.StatusId, tmp.OperDate, tmp.PartnerId, tmp.PartnerId_VAT, tmp.UnitId, tmp.PaidKindId
          , tmp.InfoMoneyId_Partner, tmp.InfoMoneyId_Partner_VAT
          , tmp.AccountDirectionId_To
          , tmp.PriceWithVAT, tmp.VATPercent, tmp.DiscountTax
            INTO vbMovementDescId, vbStatusId
               , vbOperDate
               , vbPartnerId, vbPartnerId_VAT
               , vbUnitId
               , vbPaidKindId
               , vbInfoMoneyId_Partner, vbInfoMoneyId_Partner_VAT
               , vbAccountDirectionId_To
               , vbPriceWithVAT, vbVATPercent, vbDiscountTax
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.StatusId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId
                  -- Partner Official Tax
                , 35138 AS PartnerId_VAT
                  --
                , COALESCE (CASE WHEN Object_To.DescId   = zc_Object_Unit()    THEN Object_To.Id   ELSE 0 END, 0) AS UnitId

                , COALESCE (MovementLinkObject_PaidKind.ObjectId, zc_Enum_PaidKind_FirstForm()) AS PaidKindId

                  -- ��-������ - ���� ����������
                , COALESCE (ObjectLink_Partner_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101()) AS InfoMoneyId_Partner
                  -- ��-������ - Partner Official Tax
                , 35042 AS InfoMoneyId_Partner_VAT -- ������� � �������� ��������� ������� ���

                  -- ��������� ������ - ����������� - !!!�������� - zc_Enum_AccountDirection_10100!!! ������ + ������
                , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, zc_Enum_AccountDirection_10100()) AS AccountDirectionId_To

                , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
                , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
                , COALESCE (MovementFloat_DiscountTax.ValueData, 0)       AS DiscountTax

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()

                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                          ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                         AND MovementBoolean_PriceWithVAT.DescId     = zc_MovementBoolean_PriceWithVAT()
                LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                        ON MovementFloat_VATPercent.MovementId = Movement.Id
                                       AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()
                LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                        ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                       AND MovementFloat_DiscountTax.DescId     = zc_MovementFloat_DiscountTax()

                LEFT JOIN ObjectLink AS ObjectLink_Partner_InfoMoney
                                     ON ObjectLink_Partner_InfoMoney.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Partner_InfoMoney.DescId   = zc_ObjectLink_Partner_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                     ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_Unit_AccountDirection.DescId   = zc_ObjectLink_Unit_AccountDirection()

           WHERE Movement.Id       = inMovementId
             AND Movement.DescId   = zc_Movement_Income()
           --AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS tmp;


     -- ��������
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         RAISE EXCEPTION '������.�������� ��� ��������.';
     END IF;

     -- ������������ - ��������� ��� ��������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId END;


     -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Summ, ContainerId_Goods
                         , GoodsId, PartionId
                         , OperCount, OperPrice_orig, OperPrice, CountForPrice, OperSumm, OperSumm_VAT
                         , AccountId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                          )
        -- ���������
        SELECT tmp.MovementItemId
             , 0 AS ContainerId_Summ          -- ���������� �����
             , 0 AS ContainerId_Goods         -- ���������� �����

             , tmp.GoodsId
             , tmp.PartionId
             , tmp.OperCount
             
               -- ���� ��. ��� ���, ��� ����� ������
             , tmp.OperPrice AS OperPrice_orig
               -- ���� ��. ��� ���, � ������ ������
             , zfCalc_SummDiscountTax (tmp.OperPrice, vbDiscountTax) AS OperPrice
               -- 
             , tmp.CountForPrice

              -- �������� ����� �� ���������� - ��� ���
            , tmp.OperSumm
              -- ����� ���
            , CASE WHEN vbVATPercent > 0
                        THEN zfCalc_SummWVAT (tmp.OperSumm, vbVATPercent) - tmp.OperSumm
                   ELSE 0
              END AS OperSumm_VAT

               -- ����(�����������), ���������� �����
             , 0 AS AccountId

               -- �� ��� Goods
             , tmp.InfoMoneyGroupId
             , tmp.InfoMoneyDestinationId
             , tmp.InfoMoneyId

        FROM (SELECT MovementItem.Id                    AS MovementItemId
                   , MovementItem.ObjectId              AS GoodsId
                   , MovementItem.Id                    AS PartionId -- !!!����� ����� ���� � � MovementItem.PartionId!!!
                   , MovementItem.Amount                AS OperCount
                     -- ���� ��� ���, ��� ����� ������
                   , CASE WHEN vbPriceWithVAT = TRUE THEN zfCalc_Summ_NoVAT (MIFloat_OperPrice.ValueData, vbVATPercent) ELSE MIFloat_OperPrice.ValueData END AS OperPrice
                   , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                    -- ��������� % ������ ��� ����� ��� ���
                   , CASE WHEN vbPriceWithVAT = TRUE
                               THEN zfCalc_SummDiscountTax
                                   (zfCalc_Summ_NoVAT 
                                   (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData), vbVATPercent), vbDiscountTax)
                               ELSE zfCalc_SummDiscountTax
                                   (zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData), vbDiscountTax)
                     END AS OperSumm

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

                   LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                               ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                       AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                   -- !!!��������!!! �������������
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = COALESCE (ObjectLink_Goods_InfoMoney.ChildObjectId, zc_Enum_InfoMoney_10101())

              WHERE Movement.Id       = inMovementId
                AND Movement.DescId   = zc_Movement_Income()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS tmp
            ;


     -- ��������� ������� - �������� �� �����������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem_SummPartner (MovementItemId, ContainerId, AccountId, ContainerId_VAT, AccountId_VAT, GoodsId, PartionId, OperSumm, OperSumm_VAT)
        SELECT _tmpItem.MovementItemId
             , 0 AS ContainerId, 0 AS AccountId
             , 0 AS ContainerId_VAT, 0 AS AccountId_VAT
             , _tmpItem.GoodsId
             , _tmpItem.PartionId
               -- ���������� - ����� � ���
             , (_tmpItem.OperSumm + _tmpItem.OperSumm_VAT) AS OperSumm
               -- � ��������� - ����� ���
             , _tmpItem.OperSumm_VAT                       AS OperSumm_VAT
        FROM _tmpItem
        ;

     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1. ������������ ContainerId_Goods ��� ��������������� ����� - �������
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inMemberId               := NULL
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inPartionId              := _tmpItem.PartionId
                                                                                , inIsReserve              := FALSE
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 );

     -- 2.1. ������������ ����(�����������) ��� �������� �� ��������� ����� - �������
     UPDATE _tmpItem SET AccountId = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_10000() -- ������
                                             , inAccountDirectionId     := vbAccountDirectionId_To
                                             , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT DISTINCT _tmpItem.InfoMoneyDestinationId FROM _tmpItem) AS _tmpItem_group
          ) AS _tmpItem_byAccount
     WHERE _tmpItem.InfoMoneyDestinationId  = _tmpItem_byAccount.InfoMoneyDestinationId
    ;

     -- 2.2. ������������ ContainerId_Summ ��� �������� �� ��������� ����� - �������
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
                                                                              , inIsReserve              := FALSE
                                                                               );


     -- 3.1. ������������ ����(�����������) ��� �������� �� ���� ���������� + ���
     UPDATE _tmpItem_SummPartner SET AccountId     = _tmpItem_byAccount.AccountId
                                   , AccountId_VAT = _tmpItem_byAccount.AccountId
     FROM
          (SELECT -- ���������
                  lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                             , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
                  -- ���
                , CASE WHEN _tmpItem_group.OperSumm_VAT <> 0 THEN
                  lpInsertFind_Object_Account (inAccountGroupId         := _tmpItem_group.AccountGroupId_VAT
                                             , inAccountDirectionId     := _tmpItem_group.AccountDirectionId_VAT
                                             , inInfoMoneyDestinationId := View_InfoMoney_VAT.InfoMoneyDestinationId
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              )
                  ELSE 0
                  END AS AccountId_VAT
           FROM (SELECT zc_Enum_AccountGroup_60000()      AS AccountGroupId     -- ���������
                      , zc_Enum_AccountDirection_60100()  AS AccountDirectionId -- ����������
                      , vbInfoMoneyId_Partner             AS InfoMoneyId
                        --
                      , zc_Enum_AccountGroup_80000()      AS AccountGroupId_VAT     -- ������� � ��������
                      , zc_Enum_AccountDirection_80500()  AS AccountDirectionId_VAT -- ���
                      , vbInfoMoneyId_Partner_VAT         AS InfoMoneyId_VAT

                      , SUM (_tmpItem_SummPartner.OperSumm_VAT) AS OperSumm_VAT
                 FROM _tmpItem_SummPartner
                ) AS _tmpItem_group
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney     ON View_InfoMoney.InfoMoneyId     = _tmpItem_group.InfoMoneyId
                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_VAT ON View_InfoMoney_VAT.InfoMoneyId = _tmpItem_group.InfoMoneyId_VAT
        ) AS _tmpItem_byAccount
      WHERE 1=1;

     -- 3.2.1. ������������ ContainerId ��� �������� �� ���� ����������
     UPDATE _tmpItem_SummPartner SET ContainerId          = tmp.ContainerId
                                   , ContainerId_VAT      = tmp.ContainerId_VAT
     FROM (SELECT tmp.AccountId
                  -- ���������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := tmp.AccountId
                                        , inPartionId         := NULL
                                        , inIsReserve         := FALSE
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Partner()
                                        , inObjectId_1        := vbPartnerId
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := vbInfoMoneyId_Partner
                                         ) AS ContainerId
                  -- ���
                , CASE WHEN tmp.AccountId_VAT > 0 THEN
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := tmp.AccountId_VAT
                                        , inPartionId         := NULL
                                        , inIsReserve         := FALSE
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := vbBusinessId
                                        , inDescId_1          := zc_ContainerLinkObject_Partner()
                                        , inObjectId_1        := vbPartnerId_VAT
                                        , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                        , inObjectId_2        := vbInfoMoneyId_Partner_VAT
                                         )
                  ELSE 0
                  END AS ContainerId_VAT
           FROM (SELECT DISTINCT
                        _tmpItem_SummPartner.AccountId
                      , _tmpItem_SummPartner.AccountId_VAT
                 FROM _tmpItem_SummPartner
                ) AS tmp
          ) AS tmp
     WHERE _tmpItem_SummPartner.AccountId = tmp.AccountId
    ;

     -- 4.1. ����������� �������� - ������� ����������
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_analyzer
                                       , ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , Amount, OperDate, IsActive
                                        )
       -- ��������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId
            , _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS ParentId
            , _tmpItem.AccountId                      AS AccountId              -- ��� ����� �� ��������� �����
            , 0                                       AS AnalyzerId             -- ��� - ���� �������� (��������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- �����
            , _tmpItem.PartionId                      AS PartionId              -- ������
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- ����� �����
            , _tmpItem_SummPartner.AccountId          AS AccountId_Analyzer     -- ���� - ������������� - �� ������ ����������
            , _tmpItem_SummPartner.ContainerId_VAT    AS ContainerId_Analyzer   -- ��������� - ������������� - �� ������ ���
            , _tmpItem_SummPartner.ContainerId        AS ContainerExtId_analyzer-- ��������� - ������������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbPartnerId                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , _tmpItem.OperCount                      AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.MovementItemId = _tmpItem.MovementItemId;


     -- 4.2. ����������� �������� - ������� �����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
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
            , _tmpItem_SummPartner.ContainerId_VAT    AS ContainerId_Analyzer   -- ��� - ��������� ���� - ������ ���� ��� ���������� � �������/�������
            , _tmpItem_SummPartner.ContainerId        AS ContainerExtId_Analyzer-- ��������� - ������������� - �� ������ ����������
            , 0                                       AS ObjectIntId_Analyzer   -- ������������� ����������
            , vbPartnerId                             AS ObjectExtId_Analyzer   -- ������������� ���������� - ����������
            , _tmpItem.OperSumm                       AS Amount
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            LEFT JOIN _tmpItem_SummPartner ON _tmpItem_SummPartner.MovementItemId = _tmpItem.MovementItemId;


     -- 4.3. ����������� �������� - ���� ���������� + ���
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId
                                       , MovementItemId, ContainerId, ParentId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, PartionId, WhereObjectId_Analyzer
                                       , AccountId_Analyzer
                                       , ContainerId_Analyzer, ContainerExtId_Analyzer
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
            , 0                               AS ContainerExtId_Analyzer -- ��������� - �������������
            , 0                               AS ObjectIntId_Analyzer    -- ������������� ����������
            , 0                               AS ObjectExtId_Analyzer    -- ������������� ����������
            , -1 * _tmpItem_group.OperSumm    AS Amount
            , vbOperDate                      AS OperDate
            , FALSE                           AS isActive

       FROM (-- !!!����!!! �������� � ������ �������
             SELECT zc_MIContainer_Summ() AS DescId, tmp.ContainerId, tmp.AccountId, SUM (tmp.OperSumm) AS OperSumm FROM _tmpItem_SummPartner AS tmp GROUP BY tmp.ContainerId, tmp.AccountId
            UNION ALL
             -- !!!����!!! �������� ��� "�������������" ��������� ����� - ���� ����
             SELECT zc_MIContainer_Summ() AS DescId, tmp.ContainerId_VAT AS ContainerId, tmp.AccountId_VAT AS AccountId, -1 * SUM (tmp.OperSumm_VAT) AS OperSumm FROM _tmpItem_SummPartner AS tmp GROUP BY tmp.ContainerId_VAT, tmp.AccountId_VAT
            ) AS _tmpItem_group
       -- !!!�� ����� ������������, �.�. ��� �������� ?�����? ����������� � �������!!!
       -- WHERE _tmpItem_group.OperSumm <> 0
      ;



     -- 5.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Income()
                                , inUserId     := inUserId
                                 );

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- �������� - ���-�� + ����
     UPDATE Object_PartionGoods SET Amount        = _tmpItem.OperCount
                                  , EKPrice_orig  = _tmpItem.OperPrice_orig
                                  , EKPrice       = _tmpItem.OperPrice
                                  , CountForPrice = _tmpItem.CountForPrice
                                  , OperDate      = vbOperDate
                                  , isErased      = FALSE
                                  , isArc         = FALSE
     FROM _tmpItem
     WHERE Object_PartionGoods.MovementItemId = _tmpItem.MovementItemId
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_Income(inMovementId := 76 , inStatusCode := 2 ,  inSession := '5');

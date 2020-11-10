-- Function: lpComplete_Movement_Loss (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Loss (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;
  DECLARE vbAnalyzerId Integer;

  DECLARE vbOperDate      TDateTime;
  DECLARE vbUnitId        Integer;
  DECLARE vbMemberId      Integer;
  DECLARE vbCarId         Integer;
  DECLARE vbToId          Integer;
  DECLARE vbArticleLossId Integer;
  DECLARE vbBranchId_Unit Integer;
  DECLARE vbAccountDirectionId Integer;
  DECLARE vbIsPartionDate_Unit Boolean;
  DECLARE vbIsPartionGoodsKind_Unit Boolean;
  DECLARE vbInfoMoneyId_ArticleLoss Integer;
  DECLARE vbBranchId_Unit_ProfitLoss Integer;
  DECLARE vbProfitLossGroupId Integer;
  DECLARE vbProfitLossDirectionId Integer;
  DECLARE vbJuridicalId_Basis Integer;
  DECLARE vbBusinessId_ProfitLoss Integer;
  DECLARE vbUnitId_ProfitLoss Integer;

  DECLARE vbContractId_send Integer;
  DECLARE vbJuridicalId_send Integer;
  DECLARE vbPaidKindId_send Integer;
  DECLARE vbJuridicalId_Basis_send Integer;
  DECLARE vbContainerId_send Integer;
  DECLARE vbAccountId_Send Integer;
  DECLARE vbInfoMoneyId_send Integer;

  DECLARE vbIsContainer_Asset Boolean;
BEGIN
     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItemSumm;
     -- !!!обязательно!!! очистили таблицу - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     -- Эти параметры нужны для формирования Аналитик в проводках
     WITH tmpMember AS (SELECT lfSelect.MemberId, lfSelect.UnitId
                        FROM lfSelect_Object_Member_findPersonal (inUserId :: TVarChar) AS lfSelect
                        WHERE lfSelect.Ord = 1
                       )
     SELECT _tmp.MovementDescId, _tmp.OperDate
          , _tmp.UnitId, _tmp.MemberId, _tmp.CarId, _tmp.ToId, _tmp.ArticleLossId
          , _tmp.BranchId_Unit, _tmp.AccountDirectionId, _tmp.isPartionDate_Unit, _tmp.isPartionGoodsKind_Unit
          , _tmp.InfoMoneyId_ArticleLoss, _tmp.BranchId_ProfitLoss
          , _tmp.ProfitLossGroupId, _tmp.ProfitLossDirectionId
          , _tmp.JuridicalId_Basis, _tmp.BusinessId_ProfitLoss, _tmp.UnitId_ProfitLoss
          , _tmp.ObjectExtId_Analyzer, _tmp.AnalyzerId
          , _tmp.ContractId_send , _tmp.JuridicalId_send , _tmp.InfoMoneyId_send, _tmp.PaidKindId_send , _tmp.JuridicalId_Basis_send
            INTO vbMovementDescId, vbOperDate
               , vbUnitId, vbMemberId, vbCarId, vbToId, vbArticleLossId
               , vbBranchId_Unit, vbAccountDirectionId, vbIsPartionDate_Unit, vbIsPartionGoodsKind_Unit
               , vbInfoMoneyId_ArticleLoss, vbBranchId_Unit_ProfitLoss
               , vbProfitLossGroupId, vbProfitLossDirectionId
               , vbJuridicalId_Basis, vbBusinessId_ProfitLoss, vbUnitId_ProfitLoss
               , vbObjectExtId_Analyzer, vbAnalyzerId

               , vbContractId_send, vbJuridicalId_send, vbInfoMoneyId_send, vbPaidKindId_send, vbJuridicalId_Basis_send

     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()   THEN Object_From.Id ELSE 0 END, 0) AS UnitId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id ELSE 0 END, 0) AS MemberId
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Car()    THEN Object_From.Id ELSE 0 END, 0) AS CarId
                , COALESCE (Object_To.Id, MovementLinkObject_ArticleLoss.ObjectId)                               AS ToId
                , MovementLinkObject_ArticleLoss.ObjectId                                                        AS ArticleLossId
                , COALESCE (ObjectLink_UnitFrom_Branch.ChildObjectId, 0) AS BranchId_Unit -- это филиал по подразделнию от кого (нужен для товарных остатков)
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit()
                                      THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId
                                 WHEN Object_From.DescId = zc_Object_Member()
                                      THEN zc_Enum_AccountDirection_20500() -- Запасы + сотрудники (МО)
                            END, 0) AS AccountDirectionId -- Аналитики счетов - направления !!!нужны только для подразделения!!!
                , COALESCE (ObjectBoolean_PartionDate_From.ValueData, FALSE)     AS isPartionDate_Unit
                , COALESCE (ObjectBoolean_PartionGoodsKind_From.ValueData, TRUE) AS isPartionGoodsKind_Unit

                , COALESCE (ObjectLink_ArticleLoss_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_ArticleLoss
                , COALESCE (ObjectLink_Branch.ChildObjectId, 0)                AS BranchId_ProfitLoss -- по подразделению (у авто,!!!физ.лица!!!, кому, от кого)

                  -- Группы ОПиУ (!!!приоритет - ArticleLoss!!!)
                , COALESCE (View_ProfitLossDirection.ProfitLossGroupId, COALESCE (lfSelect.ProfitLossGroupId, 0)) AS ProfitLossGroupId
                  -- Аналитики ОПиУ - направления (!!!приоритет - ArticleLoss!!!)
                , COALESCE (ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId, CASE WHEN COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (MovementLinkObject_ArticleLoss.ObjectId, 0)))) = 0
                                                                                                THEN CASE /*WHEN Object_From.DescId = zc_Object_Member()
                                                                                                               THEN COALESCE (lfSelect.ProfitLossDirectionId, 0)*/ -- !!!исключение!!!
                                                                                                          WHEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId IN (zc_Enum_AccountDirection_20100() -- Запасы + на складах ГП
                                                                                                                                                                    , zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                                                                                                                                    , zc_Enum_AccountDirection_20400() -- Запасы + на производстве
                                                                                                                                                                    , zc_Enum_AccountDirection_20800() -- Запасы + на упаковке
                                                                                                                                                                     )
                                                                                                               THEN zc_Enum_ProfitLossDirection_20500() -- Общепроизводственные расходы + Прочие потери (Списание+инвентаризация)
                                                                                                          WHEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId IN (zc_Enum_AccountDirection_20700() -- Запасы + на филиалах
                                                                                                                                                                     )
                                                                                                               THEN zc_Enum_ProfitLossDirection_40400() -- Расходы на сбыт + Прочие потери (Списание+инвентаризация)
                                                                                                          ELSE 0 -- !!!будет ошибка!!!
                                                                                                     END
                                                                                           ELSE COALESCE (lfSelect.ProfitLossDirectionId, 0)
                                                                                      END) AS ProfitLossDirectionId

                , COALESCE (ObjectLink_UnitFrom_Juridical.ChildObjectId, zc_Juridical_Basis()) AS JuridicalId_Basis
                , COALESCE (ObjectLink_ArticleLoss_Business.ChildObjectId, COALESCE (ObjectLink_Business.ChildObjectId, 0)) AS BusinessId_ProfitLoss -- по подразделению (у авто,!!!физ.лица!!!, кому, от кого)
                , COALESCE (MovementLinkObject_ArticleLoss.ObjectId, lfSelect.UnitId)          AS UnitId_ProfitLoss
                  -- Подраделение кому или Юр.Лицо - перевыставление
                , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId) AS ObjectExtId_Analyzer
                , MovementLinkObject_ArticleLoss.ObjectId AS AnalyzerId

                , COALESCE (ObjectLink_Unit_Contract.ChildObjectId, 0)           AS ContractId_send
                , COALESCE (ObjectLink_Contract_Juridical.ChildObjectId, 0)      AS JuridicalId_send
                , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0)      AS InfoMoneyId_send
                , COALESCE (ObjectLink_Contract_PaidKind.ChildObjectId, 0)       AS PaidKindId_send
                , COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, 0) AS JuridicalId_Basis_send

           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            -- AND MovementLinkObject_To.ObjectId <> MovementLinkObject_From.ObjectId -- что б однозначно получить - Прочие потери (Списание+инвентаризация)
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                             ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                            AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney
                                     ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = MovementLinkObject_ArticleLoss.ObjectId
                                    AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                     ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = MovementLinkObject_ArticleLoss.ObjectId
                                    AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
                LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_AccountDirection
                                     ON ObjectLink_UnitFrom_AccountDirection.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate_From
                                        ON ObjectBoolean_PartionDate_From.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectBoolean_PartionDate_From.DescId = zc_ObjectBoolean_Unit_PartionDate()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind_From
                                        ON ObjectBoolean_PartionGoodsKind_From.ObjectId = MovementLinkObject_From.ObjectId
                                       AND ObjectBoolean_PartionGoodsKind_From.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()

                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Branch
                                     ON ObjectLink_UnitFrom_Branch.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_Branch.DescId = zc_ObjectLink_Unit_Branch()
                LEFT JOIN ObjectLink AS ObjectLink_UnitFrom_Juridical
                                     ON ObjectLink_UnitFrom_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_UnitFrom_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Unit
                                     ON ObjectLink_PersonalTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_PersonalTo_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                    AND Object_To.DescId = zc_Object_Personal()
                LEFT JOIN ObjectLink AS ObjectLink_CarTo_Unit
                                     ON ObjectLink_CarTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_CarTo_Unit.DescId = zc_ObjectLink_Car_Unit()
                                    AND Object_To.DescId = zc_Object_Car()
                LEFT JOIN tmpMember AS tmpMemberTo ON tmpMemberTo.MemberId = MovementLinkObject_To.ObjectId
                                                  AND Object_To.DescId = zc_Object_Member()

                LEFT JOIN tmpMember AS tmpMemberFrom ON tmpMemberFrom.MemberId = MovementLinkObject_From.ObjectId
                                                    AND Object_From.DescId = zc_Object_Member()

                LEFT JOIN ObjectLink AS ObjectLink_Branch
                                     ON ObjectLink_Branch.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                                    AND ObjectLink_Branch.DescId = zc_ObjectLink_Unit_Branch()
                LEFT JOIN ObjectLink AS ObjectLink_Business
                                     ON ObjectLink_Business.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                                    AND ObjectLink_Business.DescId = zc_ObjectLink_Unit_Business()
                LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_Business
                                     ON ObjectLink_ArticleLoss_Business.ObjectId = MovementLinkObject_ArticleLoss.ObjectId
                                    AND ObjectLink_ArticleLoss_Business.DescId   = zc_ObjectLink_ArticleLoss_Business()
                -- для затрат (!!!если не указан ArticleLoss!!!)
                LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfSelect
                       ON lfSelect.UnitId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                      AND MovementLinkObject_ArticleLoss.ObjectId IS NULL
                -- для Перевыставление затрат на Юр Лицо (!!!даже если указан ArticleLoss!!!)
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = COALESCE (ObjectLink_CarTo_Unit.ChildObjectId, COALESCE (ObjectLink_PersonalTo_Unit.ChildObjectId, COALESCE (tmpMemberTo.UnitId, COALESCE (MovementLinkObject_To.ObjectId, COALESCE (tmpMemberFrom.UnitId, MovementLinkObject_From.ObjectId)))))
                                                                AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney ON ObjectLink_Contract_InfoMoney.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                     AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                     AND ObjectLink_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind ON ObjectLink_Contract_PaidKind.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                    AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
                LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                                                          AND ObjectLink_Contract_JuridicalBasis.DescId   = zc_ObjectLink_Contract_JuridicalBasis()

           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_Loss(), zc_Movement_LossAsset())
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
          ) AS _tmp;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_asset, ObjectDescId, GoodsId, GoodsKindId, GoodsKindId_complete, AssetId, PartionGoods, PartionGoodsDate, PartionGoodsId_Item
                         , OperCount, Summ_service
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId
                          )
        WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                            , MovementItem.ObjectId AS GoodsId
                            , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                    AND vbIsPartionGoodsKind_Unit = TRUE
                                        THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                   ELSE 0
                              END AS GoodsKindId
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete
                            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset() AND Object_Goods.DescId = zc_Object_Asset() THEN Object_Goods.Id ELSE COALESCE (MILinkObject_Asset.ObjectId, 0) END AS AssetId
                            , COALESCE (MIString_PartionGoods.ValueData, '')         AS PartionGoods
                            , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

                            , COALESCE (MIFloat_ContainerId.ValueData, 0) :: Integer AS ContainerId_asset
                            , COALESCE (CLO_PartionGoods.ObjectId, 0)                AS PartionGoodsId_asset

                            , MovementItem.Amount    AS OperCount
                            , MIFloat_Summ.ValueData AS Summ_service

                             -- Управленческая группа
                           , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                             -- Управленческие назначения
                           , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                             -- Статьи назначения
                           , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                              -- Бизнес баланса: не используется
                            , 0 AS BusinessId

                            , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE) AS isPartionCount
                            , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)  AS isPartionSumm

                       FROM Movement
                            JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                         ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                                                        AND vbMovementDescId                   = zc_Movement_LossAsset()
                             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                        AND vbMovementDescId                   = zc_Movement_LossAsset()
                             LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                           ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                                    ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                                   AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                                    ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                                   AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                                            ON View_InfoMoney.InfoMoneyId = CASE WHEN Object_Goods.DescId = zc_Object_Asset()
                                                                                                      THEN -- !!!временно захардкодил!!! - Капитальные инвестиции + Производственное оборудование
                                                                                                           zc_Enum_InfoMoney_70102()
                                                                                                 ELSE ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                            END

                       WHERE Movement.Id = inMovementId
                         AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                      )
, tmpContainer_asset AS (SELECT tmpMI.ContainerId_asset
                                -- тоже на всякий случай - Капитальные инвестиции + Производственное оборудование
                              , COALESCE (CLO_InfoMoney.ObjectId, zc_Enum_InfoMoney_70102()) AS InfoMoneyId
                              , ROW_NUMBER()     OVER (PARTITION BY tmpMI.ContainerId_asset ORDER BY CLO_InfoMoney.ObjectId ASC) AS Ord -- !!!на всякий случай!!!
                         FROM tmpMI
                              LEFT JOIN Container ON Container.ParentId = tmpMI.ContainerId_asset
                                                 AND Container.DescId   IN (zc_Container_Summ(), zc_Container_SummAsset())
                              LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                            ON CLO_InfoMoney.ContainerId = Container.Id
                                                           AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                         WHERE tmpMI.ContainerId_asset > 0
                        )
        , tmpContainer_find
                   AS (SELECT tmpMI.MovementItemId
                            , tmpMI.GoodsId
                            , tmpMI.OperCount    AS Amount
                            , tmpMI.Summ_service AS Summ_service
                            , Container.Id       AS ContainerId
                            , Container.Amount   AS Amount_container
                            , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionDate
                            , CLO_PartionGoods.ObjectId AS PartionGoodsId
                       FROM tmpMI
                            INNER JOIN Container ON Container.ObjectId = tmpMI.GoodsId
                                                AND Container.DescId   IN (zc_Container_Count(), zc_Container_CountAsset())
                                              --AND Container.Amount   > 0
                            LEFT JOIN ContainerLinkObject AS CLO_Member
                                                           ON CLO_Member.ContainerId = Container.Id
                                                          AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
                            LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = Container.Id
                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                            INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                           ON CLO_PartionGoods.ContainerId = Container.Id
                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                            LEFT JOIN ObjectDate as ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                    AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                       WHERE tmpMI.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                            , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                            , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                             )
                         AND ((CLO_Unit.ObjectId   = vbUnitId   AND vbUnitId    > 0)
                           OR (CLO_Member.ObjectId = vbMemberId AND vbMemberId  > 0)
                             )
                         -- только не ОС
                         AND tmpMI.ContainerId_asset = 0
                      )
        , tmpContainer_calc
                   AS (SELECT tmpContainer_find.ContainerId
                            , tmpContainer_find.Amount_container - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_container
                       FROM tmpContainer_find
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = tmpContainer_find.ContainerId
                                                           AND MIContainer.DescId      = zc_MIContainer_Count()
                                                           AND MIContainer.OperDate    >= vbOperDate
                       GROUP BY tmpContainer_find.ContainerId
                              , tmpContainer_find.Amount_container
                       HAVING tmpContainer_find.Amount_container - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) > 0
                      )
        , tmpContainer_all
                   AS (SELECT tmpContainer_find.MovementItemId
                            , tmpContainer_find.GoodsId
                            , tmpContainer_find.Amount
                            , tmpContainer_find.ContainerId
                            , tmpContainer_calc.Amount_container
                            , SUM (tmpContainer_calc.Amount_container) OVER (PARTITION BY tmpContainer_find.GoodsId ORDER BY tmpContainer_find.PartionDate ASC, tmpContainer_find.ContainerId ASC) AS AmountSUM --
                            , ROW_NUMBER() OVER (PARTITION BY tmpContainer_find.GoodsId ORDER BY tmpContainer_find.PartionDate DESC, tmpContainer_find.ContainerId DESC) AS Ord       -- !!!Надо отловить ПОСЛЕДНИЙ!!!
                            , tmpContainer_find.PartionGoodsId
                       FROM tmpContainer_find
                            INNER JOIN tmpContainer_calc ON tmpContainer_calc.ContainerId = tmpContainer_find.ContainerId
                      )
    , tmpContainer AS (SELECT DD.ContainerId
                            , DD.GoodsId
                            , DD.MovementItemId
                            , DD.PartionGoodsId
                            , CASE WHEN DD.Amount - DD.AmountSUM > 0 AND DD.Ord <> 1
                                        THEN DD.Amount_container
                                   ELSE DD.Amount - DD.AmountSUM + DD.Amount_container
                              END AS Amount
                       FROM (SELECT * FROM tmpContainer_all) AS DD
                       WHERE DD.Amount - (DD.AmountSUM - DD.Amount_container) > 0
                      )
        -- Результат
        SELECT
              tmpMI.MovementItemId
              -- !!!ИЛИ факт партия ОС или подбор партий!!!
            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset() THEN tmpMI.ContainerId_asset ELSE COALESCE (tmpContainer.ContainerId, 0) END AS ContainerId_Goods
              -- ПЕРЕВОД в забаланс, определим позже
            , 0 AS ContainerId_asset

            , Object.DescId AS ObjectDescId
            , tmpMI.GoodsId
            , tmpMI.GoodsKindId
            , tmpMI.GoodsKindId_complete
            , 0 AS AssetId -- tmpMI.AssetId -- !!!временно отключил, т.к. не должно участвовать в партии!!!
            , tmpMI.PartionGoods
            , tmpMI.PartionGoodsDate
            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset() THEN tmpMI.PartionGoodsId_asset ELSE COALESCE (tmpContainer.PartionGoodsId, 0) END AS PartionGoodsId_Item

            , COALESCE (tmpContainer.Amount, tmpMI.OperCount)  AS OperCount
            , COALESCE (tmpMI.Summ_service, 0)                 AS Summ_service

            , COALESCE (View_InfoMoney.InfoMoneyGroupId, tmpMI.InfoMoneyGroupId)             AS InfoMoneyGroupId       -- Управленческая группа
            , COALESCE (View_InfoMoney.InfoMoneyDestinationId, tmpMI.InfoMoneyDestinationId) AS InfoMoneyDestinationId -- Управленческие назначения
            , COALESCE (View_InfoMoney.InfoMoneyId, tmpMI.InfoMoneyId)                       AS InfoMoneyId            -- Статьи назначения

              -- Бизнес баланса: не используется
            , tmpMI.BusinessId

            , tmpMI.isPartionCount
            , tmpMI.isPartionSumm

              -- Партии товара, сформируем позже
            , CASE WHEN vbMovementDescId = zc_Movement_LossAsset() THEN tmpMI.PartionGoodsId_asset ELSE 0 END AS PartionGoodsId

        FROM tmpMI
             LEFT JOIN Object ON Object.Id = tmpMI.GoodsId
             LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpMI.MovementItemId
             LEFT JOIN tmpContainer_asset ON tmpContainer_asset.ContainerId_asset = tmpMI.ContainerId_asset
                                         AND tmpContainer_asset.Ord               = 1
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney
                                             ON View_InfoMoney.InfoMoneyId = tmpContainer_asset.InfoMoneyId
     ;

     -- определяется = будет ли при списании переброска на забалансовый счет ОС: Расх ОС Произв забаланс + Расх ОС Админ забаланс
     vbIsContainer_Asset:= vbArticleLossId IN (5670650, 5670651) AND NOT EXISTS (SELECT 1 FROM _tmpItem INNER JOIN Container ON Container.Id = _tmpItem.ContainerId_Goods AND Container.DescId IN (zc_Container_CountAsset(), zc_Container_SummAsset()));
     -- для ЗАБАЛАНСА - перевыставления НЕТ
     IF vbIsContainer_Asset = TRUE THEN vbContractId_send:= 0; END IF;



/*     IF inUserId = 5
     THEN
          RAISE EXCEPTION 'Ошибка. PartionGoodsId_Item = <%>'
              , (SELECT _tmpItem.PartionGoodsId_Item FROM _tmpItem WHERE _tmpItem.MovementItemId = 165388198)
               ;
     END IF;*/

     -- Проверка - для ОС
     IF vbMovementDescId = zc_Movement_LossAsset()
        AND EXISTS (SELECT 1
                    FROM _tmpItem
                    WHERE COALESCE (_tmpItem.ContainerId_Goods, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId, 0) = 0
                   )
     THEN
          RAISE EXCEPTION 'Ошибка.Для ОС <%> должна быть указана партия.'
                        , lfGet_Object_ValueData_sh ((SELECT _tmpItem.GoodsId
                                                      FROM _tmpItem
                                                      WHERE COALESCE (_tmpItem.ContainerId_Goods, 0) = 0 OR COALESCE (_tmpItem.PartionGoodsId, 0) = 0
                                                      LIMIT 1
                                                     ))
                                                     ;
     END IF;

     -- Проверка - т.к.для этих УП-статей могли искать партии - надо что б товар был уникальным
     IF EXISTS (SELECT _tmpItem.GoodsId FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId
                                              FROM _tmpItem
                                              WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                       )
                                             ) AS _tmpItem
                GROUP BY _tmpItem.GoodsId
                HAVING COUNT(*) > 1)
     THEN
          RAISE EXCEPTION 'Ошибка.В документе нельзя дублировать товар <%>.'
              , lfGet_Object_ValueData (
               (SELECT _tmpItem.GoodsId FROM (SELECT DISTINCT _tmpItem.MovementItemId, _tmpItem.GoodsId
                                              FROM _tmpItem
                                              WHERE _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                       )
                                             ) AS _tmpItem
                GROUP BY _tmpItem.GoodsId
                HAVING COUNT(*) > 1
                LIMIT 1));
     END IF;

     -- формируются Партии товара, ЕСЛИ надо ...
     UPDATE _tmpItem SET PartionGoodsId      = CASE WHEN _tmpItem.ContainerId_Goods > 0
                                                        THEN _tmpItem.PartionGoodsId_Item -- !!!Партию уже нашли из остатка!!!

                                                    WHEN vbOperDate >= zc_DateStart_PartionGoods()
                                                     AND vbAccountDirectionId = zc_Enum_AccountDirection_20200() -- Запасы + на складах
                                                     AND (_tmpItem.isPartionCount = TRUE OR _tmpItem.isPartionSumm = TRUE)
                                                        THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                                    WHEN vbIsPartionDate_Unit = TRUE
                                                     AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN lpInsertFind_Object_PartionGoods (inOperDate             := _tmpItem.PartionGoodsDate
                                                                                             , inGoodsKindId_complete := _tmpItem.GoodsKindId_complete
                                                                                              )

                                                    WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100()  -- Доходы + Продукция
                                                                                           , zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                        THEN 0

                                                    WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                      OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                                        THEN 0 -- !!!ВРЕМЕННО ОТКЛ!!! -- _tmpItem.PartionGoodsId_Item

                                                    ELSE lpInsertFind_Object_PartionGoods ('')

                                               END
     WHERE (_tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
         OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
          )
       AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
     ;

     -- определили
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId <> 0 THEN vbUnitId WHEN vbMemberId <> 0 THEN vbMemberId WHEN vbCarId <> 0 THEN vbCarId END;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem SET ContainerId_Goods = CASE WHEN _tmpItem.ContainerId_Goods > 0 THEN _tmpItem.ContainerId_Goods
                                                  ELSE
                                             lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId
                                                                                , inCarId                  := vbCarId
                                                                                , inMemberId               := vbMemberId
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_Unit
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
                                             END;

     -- 1.1.2. определяется ContainerId_asset для количественного учета - ПЕРЕВОД в забаланс
     UPDATE _tmpItem SET ContainerId_asset = lpInsertUpdate_ContainerCount_Asset (inOperDate               := vbOperDate
                                                                                , inUnitId                 := CLO_Unit.ObjectId
                                                                                , inCarId                  := CLO_Car.ObjectId
                                                                                , inMemberId               := CLO_Member.ObjectId
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                , inAssetId                := CLO_Asset.ObjectId
                                                                                , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                 )
     FROM Container
          LEFT JOIN ContainerLinkObject AS CLO_Unit
                                        ON CLO_Unit.ContainerId = Container.Id
                                       AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
          LEFT JOIN ContainerLinkObject AS CLO_Car
                                        ON CLO_Car.ContainerId = Container.Id
                                       AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
          LEFT JOIN ContainerLinkObject AS CLO_Member
                                        ON CLO_Member.ContainerId = Container.Id
                                       AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                        ON CLO_PartionGoods.ContainerId = Container.Id
                                       AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS CLO_Asset
                                        ON CLO_Asset.ContainerId = Container.Id
                                       AND CLO_Asset.DescId      = zc_ContainerLinkObject_AssetTo()
     WHERE vbIsContainer_Asset = TRUE AND vbMovementDescId = zc_Movement_LossAsset()
       AND _tmpItem.ContainerId_Goods = Container.Id
       -- !!!если НЕ перевыставление!!!
       AND vbContractId_send = 0
       -- !!!если НЕ услуги!!!
       AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
    ;

     -- 1.1.3. !!! ContainerId - при ПЕРЕВОД в забаланс, связываем кол-во забаланс с кол-вом баланс!!!!
     UPDATE Container SET ParentId = _tmpItem.ContainerId_Goods
     FROM _tmpItem
     WHERE Container.Id = _tmpItem.ContainerId_asset
       -- !!!если НЕ услуги!!!
       AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
     ;
     

     -- 1.2.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_Goods, ContainerId_ProfitLoss, ContainerDescId, ContainerId, ContainerId_asset, AccountId, OperSumm)
        SELECT
              _tmpItem.MovementItemId
            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END AS ContainerId_Goods
              -- корреспонденция - в прибыль
            , 0 AS ContainerId_ProfitLoss
            , 0 AS ContainerDescId
              -- отсюда списание
            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN _tmpItem.ContainerId_Goods ELSE COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ.Id, 0)) END AS ContainerId
              -- ПЕРЕВОД в забаланс, определим позже
            , 0 AS ContainerId_asset

            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN Container_asset.ObjectId ELSE COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ.ObjectId, 0)) END AS AccountId
            , SUM (CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney()
                        THEN _tmpItem.Summ_service
                        WHEN ABS (Container_Summ.Amount - _tmpItem.OperCount * COALESCE (HistoryCost.Price, 0)) < 0.01
                        THEN Container_Summ.Amount 
                        ELSE CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))
                           + CASE WHEN _tmpItem.MovementItemId = HistoryCost.MovementItemId_diff AND ABS (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) >= -1 * HistoryCost.Summ_diff
                                       THEN HistoryCost.Summ_diff -- !!!если есть "погрешность" при округлении, добавили сумму!!!
                                  ELSE 0
                             END
              END) AS OperSumm
        FROM _tmpItem
             -- так находим для тары
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId -- !!!пока не понятно с проводками по Бизнесу!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
             -- так находим для остальных
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId   = zc_Container_Summ()
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate

             -- так находим ОС - услуги
             LEFT JOIN Container AS Container_asset ON Container_asset.Id     = _tmpItem.ContainerId_Goods
                                                   AND Container_asset.DescId = zc_Container_Summ()

        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0 -- здесь нули !!!НЕ НУЖНЫ!!!
           -- !!!если услуги!!!
            OR _tmpItem.ObjectDescId = zc_Object_InfoMoney()
              )
        GROUP BY _tmpItem.MovementItemId
               , _tmpItem.ContainerId_Goods
               , _tmpItem.ObjectDescId
               , Container_asset.ObjectId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId

       UNION ALL
        -- если с ЗАБАЛАНСА
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                           AS ContainerId_ProfitLoss
            , zc_Container_SummAsset()    AS ContainerDescId
              -- отсюда списание
            , Container_Summ.Id           AS ContainerId
              -- ПЕРЕВОД в забаланс, здесь его нет
            , 0                           AS ContainerId_asset
            , Container_Summ.ObjectId     AS AccountId
            , CASE WHEN _tmpItem.OperCount = Container_GoodsAsset.Amount OR Container_GoodsAsset.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_GoodsAsset.Amount * _tmpItem.OperCount
              END AS OperSumm
        FROM _tmpItem
             -- так находим
             INNER JOIN Container AS Container_GoodsAsset ON Container_GoodsAsset.Id     = _tmpItem.ContainerId_Goods
                                                         AND Container_GoodsAsset.DescId = zc_Container_CountAsset()
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId   = zc_Container_SummAsset()
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND vbMovementDescId = zc_Movement_LossAsset()
          AND CASE WHEN _tmpItem.OperCount = Container_GoodsAsset.Amount OR Container_GoodsAsset.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_GoodsAsset.Amount * _tmpItem.OperCount
              END <> 0
        --AND inUserId = 5 -- !!! временно, т.к. нет с/с в HistoryCost для "будущих" месяцев

       /*UNION ALL
        SELECT
              _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0 AS ContainerId_ProfitLoss
            , Container_Summ.Id       AS ContainerId
            , 0                       AS ContainerId_asset
            , Container_Summ.ObjectId AS AccountId
            , CASE WHEN _tmpItem.OperCount = Container_Goods.Amount OR Container_Goods.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_Goods.Amount * _tmpItem.OperCount
              END AS OperSumm
        FROM _tmpItem
             -- так находим
             LEFT JOIN Container AS Container_Goods ON Container_Goods.Id = _tmpItem.ContainerId_Goods
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId   = zc_Container_Summ()
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND vbMovementDescId = zc_Movement_LossAsset()
          AND CASE WHEN _tmpItem.OperCount = Container_Goods.Amount OR Container_Goods.Amount = 0
                        THEN Container_Summ.Amount
                   ELSE Container_Summ.Amount / Container_Goods.Amount * _tmpItem.OperCount
              END <> 0
          AND inUserId = 5 -- !!! временно, т.к. нет с/с в HistoryCost для "будущих" месяцев
       */
       ;


     -- 2.1.1. создаем контейнеры для Проводки - Прибыль
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss = _tmpItem_byDestination.ContainerId_ProfitLoss -- Счет - прибыль
     FROM _tmpItem
          JOIN (-- нашли ContainerId_ProfitLoss, оставили InfoMoneyDestinationId
                SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                             , inParentId          := NULL
                                             , inObjectId          := zc_Enum_Account_100301 () -- прибыль текущего периода
                                             , inJuridicalId_basis := vbJuridicalId_Basis
                                             , inBusinessId        := vbBusinessId_ProfitLoss -- !!!подставляем Бизнес для Прибыль!!!
                                             , inObjectCostDescId  := NULL
                                             , inObjectCostId      := NULL
                                             , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                             , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId
                                             , inDescId_2          := zc_ContainerLinkObject_Branch()
                                             , inObjectId_2        := vbBranchId_Unit_ProfitLoss

                                              ) AS ContainerId_ProfitLoss
                     , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                FROM (-- нашли ProfitLossId - для InfoMoneyDestinationId_calc, оставили InfoMoneyDestinationId
                      SELECT CASE WHEN _tmpItem_group.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_70100() -- Капитальные инвестиции
                                    OR vbMovementDescId = zc_Movement_LossAsset()
                                       THEN CASE WHEN _tmpItem_group.InfoMoneyId = zc_Enum_InfoMoney_70102() -- Производственное оборудование
                                                          -- !!!...!!!
                                                     THEN (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60201) -- Расходы строительные + Производственные ОС + Основные средства*****
                                                     -- !!!...!!!
                                                ELSE (SELECT Id FROM Object WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = 60101) -- Расходы строительные + Административные ОС + Основные средства*****
                                           END
                                  ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := vbProfitLossGroupId
                                                                     , inProfitLossDirectionId  := vbProfitLossDirectionId
                                                                     , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                     , inInfoMoneyId            := NULL
                                                                     , inUserId                 := inUserId
                                                                      )
                             END AS ProfitLossId

                           , _tmpItem_group.InfoMoneyDestinationId
                      FROM (SELECT -- еще раз сгруппировали
                                   DISTINCT
                                   _tmpItem.InfoMoneyDestinationId_calc
                                 , _tmpItem.InfoMoneyDestinationId
                                 , _tmpItem.InfoMoneyId
                            FROM (-- сгруппировали и "заменили"
                                  SELECT DISTINCT
                                         _tmpItem.InfoMoneyDestinationId
                                       , _tmpItem.InfoMoneyId
                                       , _tmpItem.GoodsKindId
                                       , CASE WHEN vbInfoMoneyId_ArticleLoss > 0
                                                   THEN (SELECT InfoMoneyDestinationId FROM Object_InfoMoney_View WHERE InfoMoneyId = vbInfoMoneyId_ArticleLoss) -- !!!статья не зависит от товара!!!

                                              WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Ирна
                                                OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Доходы + Продукция
                                                OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Доходы + Мясное сырье
                                                OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- Запасы + на производстве AND Ирна
                                                OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- Запасы + на производстве AND Доходы + Продукция
                                                OR (vbAccountDirectionId = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- Запасы + на производстве AND Доходы + Мясное сырье
                                                   THEN zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство

                                              WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                   THEN zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция

                                              ELSE _tmpItem.InfoMoneyDestinationId

                                         END AS InfoMoneyDestinationId_calc
                                  FROM _tmpItemSumm
                                       JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                                  -- !!!если НЕ перевыставление!!!
                                  WHERE vbContractId_send = 0
                                    -- !!!если НЕ с ЗАБАЛАНСА!!!
                                    AND  _tmpItemSumm.ContainerDescId <> zc_Container_SummAsset()
                                 ) AS _tmpItem

                           ) AS _tmpItem_group
                     ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId
       -- !!!если НЕ перевыставление!!!
       AND vbContractId_send = 0
    ;

     -- 2.1.2. создаем контейнер для Проводки - Перевыставление затрат на Юр Лицо
     IF vbContractId_send > 0
     THEN
         -- временно :)
         vbAccountId_Send:= zc_Enum_Account_30205(); -- ЕКСПЕРТ-АГРОТРЕЙД
         --
         vbContainerId_send:= lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                    , inParentId          := NULL
                                                    , inObjectId          := vbAccountId_Send
                                                    , inJuridicalId_basis := vbJuridicalId_Basis_send
                                                    , inBusinessId        := 0                       -- Бизнес Баланс: не используется
                                                    , inObjectCostDescId  := NULL
                                                    , inObjectCostId      := NULL
                                                    , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                    , inObjectId_1        := vbJuridicalId_send
                                                    , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                    , inObjectId_2        := vbContractId_send
                                                    , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                    , inObjectId_3        := vbInfoMoneyId_send
                                                    , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                    , inObjectId_4        := vbPaidKindId_send
                                                    , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                    , inObjectId_5        := 0
                                                    , inDescId_6          := NULL
                                                    , inObjectId_6        := NULL
                                                    , inDescId_7          := NULL
                                                    , inObjectId_7        := NULL
                                                    , inDescId_8          := NULL
                                                    , inObjectId_8        := NULL
                                                     );
     END IF;


     -- 2.1.3. создаем ContainerId_asset для суммового учета - ПЕРЕВОД в забаланс
     UPDATE _tmpItemSumm SET ContainerId_asset = lpInsertUpdate_ContainerSumm_Asset (inOperDate               := vbOperDate
                                                                                   , inUnitId                 := CLO_Unit.ObjectId
                                                                                   , inCarId                  := CLO_Car.ObjectId
                                                                                   , inMemberId               := CLO_Member.ObjectId
                                                                                   , inBranchId               := NULL -- эта аналитика нужна для филиала
                                                                                   , inJuridicalId_basis      := vbJuridicalId_Basis
                                                                                   , inBusinessId             := NULL
                                                                                   , inAccountId              := _tmpItemSumm.AccountId
                                                                                   , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                   , inInfoMoneyId            := (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpItemSumm.ContainerId AND CLO.DescId = zc_ContainerLinkObject_InfoMoney())
                                                                                   , inInfoMoneyId_Detail     := (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpItemSumm.ContainerId AND CLO.DescId = zc_ContainerLinkObject_InfoMoneyDetail())
                                                                                   , inContainerId_Goods      := CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN _tmpItem.ContainerId_goods ELSE _tmpItem.ContainerId_asset END
                                                                                   , inGoodsId                := _tmpItem.GoodsId
                                                                                   , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                   , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                   , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                   , inAssetId                := CLO_Asset.ObjectId
                                                                                    )
     FROM _tmpItem
          LEFT JOIN ContainerLinkObject AS CLO_Unit
                                        ON CLO_Unit.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
          LEFT JOIN ContainerLinkObject AS CLO_Car
                                        ON CLO_Car.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Car.DescId      = zc_ContainerLinkObject_Car()
          LEFT JOIN ContainerLinkObject AS CLO_Member
                                        ON CLO_Member.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Member.DescId      = zc_ContainerLinkObject_Member()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                        ON CLO_PartionGoods.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS CLO_Asset
                                        ON CLO_Asset.ContainerId = _tmpItem.ContainerId_Goods
                                       AND CLO_Asset.DescId      = zc_ContainerLinkObject_AssetTo()
     WHERE vbIsContainer_Asset = TRUE AND vbMovementDescId = zc_Movement_LossAsset()
       AND _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
       AND _tmpItemSumm.ContainerId_Goods = CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END
       -- !!!если НЕ перевыставление!!!
       AND vbContractId_send = 0
      ;


     -- 2.1.2. проверка контейнеры для Проводки - Прибыль должен быть один
     IF vbContractId_send = 0 AND EXISTS (SELECT 1 FROM (SELECT DISTINCT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm) AS tmp GROUP BY tmp.MovementItemId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'Ошибка. COUNT > 1 by ContainerId_ProfitLoss';
     END IF;

     -- 2.2.1. формируются Проводки - Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm_group.MovementItemId
            , _tmpItemSumm_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId              -- прибыль текущего периода
            , vbAnalyzerId                            AS AnalyzerId             -- есть аналитика: Статья списания
            , _tmpItemSumm_group.GoodsId              AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , _tmpItemSumm_group.GoodsKindId          AS ObjectIntId_Analyzer   -- вид товара
              -- !!!замена!!! иначе - Подраделение кому или...
            , CASE WHEN vbUnitId_ProfitLoss <> 0 THEN vbUnitId_ProfitLoss ELSE vbObjectExtId_Analyzer END AS ObjectExtId_Analyzer
            , 0                                       AS ParentId
            , _tmpItemSumm_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.ContainerId_ProfitLoss
                  , _tmpItem.GoodsId
                  , _tmpItem.GoodsKindId
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END = _tmpItemSumm.ContainerId_Goods
             -- !!!если НЕ перевыставление!!!
             WHERE vbContractId_send = 0
              -- !!!если НЕ с ЗАБАЛАНСА!!!
              AND  _tmpItemSumm.ContainerDescId <> zc_Container_SummAsset()
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId_ProfitLoss
                    , _tmpItem.GoodsId
                    , _tmpItem.GoodsKindId
            ) AS _tmpItemSumm_group;

     -- 2.2.2. формируются Проводки - Перевыставление затрат на Юр Лицо
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm_group.MovementItemId
            , _tmpItemSumm_group.ContainerId_Send
            , _tmpItemSumm_group.AccountId_Send       AS AccountId              -- долг Юр Лица
            , vbAnalyzerId                            AS AnalyzerId             -- есть аналитика: Статья списания
            , vbJuridicalId_send                      AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
            , _tmpItemSumm_group.ContainerId          AS ContainerId_Analyzer   -- в перевыставлениеи - пусть будет нужен
            , vbToId                                  AS ObjectIntId_Analyzer   -- vbToId - авто, подразделение, сотрудник
              -- Товар
            , _tmpItemSumm_group.GoodsId              AS ObjectExtId_Analyzer   -- Товар
            , 0                                       AS ParentId
            , _tmpItemSumm_group.OperSumm
            , vbOperDate
            , FALSE
       FROM (SELECT _tmpItemSumm.MovementItemId
                  , vbContainerId_send  AS ContainerId_Send
                  , vbAccountId_Send    AS AccountId_Send
                  , _tmpItemSumm.ContainerId
                  , _tmpItem.GoodsId
                  , SUM (_tmpItemSumm.OperSumm) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId    = _tmpItemSumm.MovementItemId
                                     AND _tmpItem.ContainerId_Goods = _tmpItemSumm.ContainerId_Goods
             -- !!!если перевыставление!!!
             WHERE vbContractId_send > 0
             GROUP BY _tmpItemSumm.MovementItemId
                    , _tmpItemSumm.ContainerId
                    , _tmpItem.GoodsId
            ) AS _tmpItemSumm_group;

     -- 1.1.2. формируются Проводки для количественного учета, !!!после прибыли, т.к. нужен ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId --, ParentId, Amount, OperDate, IsActive)
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_Goods
            , 0                                       AS AccountId              -- нет счета
            , vbAnalyzerId                            AS AnalyzerId             -- есть аналитика: Статья списания
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
              -- Контейнер ОПиУ - ИЛИ Контейнер Юр.Лицо - перевыставление
            , CASE WHEN vbContractId_send > 0 THEN vbContainerId_send ELSE tmpProfitLoss.ContainerId_ProfitLoss END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- Подраделение кому или...
            , 0                                       AS ParentId
            , -1 * _tmpItem.OperCount
            , vbOperDate
            , FALSE
       FROM _tmpItem
            LEFT JOIN (SELECT DISTINCT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId_ProfitLoss FROM _tmpItemSumm
                      ) AS tmpProfitLoss ON tmpProfitLoss.MovementItemId = _tmpItem.MovementItemId

       WHERE _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
      UNION ALL
       -- 1.1.3. формируются Проводки для количественного учета, ContainerId_asset - ПЕРЕВОД в забаланс
       SELECT 0, zc_MIContainer_CountAsset() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , _tmpItem.ContainerId_asset
            , 0                                       AS AccountId              -- нет счета
            , vbAnalyzerId                            AS AnalyzerId             -- есть аналитика: Статья списания
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
              -- Контейнер количественного учета
            , _tmpItem.ContainerId_Goods              AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- Подраделение кому или...
            , 0                                       AS ParentId
            , 1 * _tmpItem.OperCount
            , vbOperDate
            , TRUE
       FROM _tmpItem
       WHERE _tmpItem.ContainerId_asset > 0
         AND _tmpItem.ObjectDescId <> zc_Object_InfoMoney()
       ;

     -- 1.2.2. формируются Проводки для суммового учета, !!!после прибыли, т.к. нужен ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId
            , _tmpItemSumm.AccountId                  AS AccountId              -- счет есть всегда
            , vbAnalyzerId                            AS AnalyzerId             -- есть аналитика: Статья списания
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
              -- Контейнер ОПиУ ИЛИ Контейнер Юр.Лицо - перевыставление
            , CASE WHEN vbContractId_send > 0 THEN vbContainerId_send ELSE _tmpItemSumm.ContainerId_ProfitLoss END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- Подраделение кому или...
            , 0                                       AS ParentId
            , -1 * _tmpItemSumm.OperSumm
            , vbOperDate
            , FALSE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_Goods = CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END

      UNION ALL
       -- 1.2.3. формируются Проводки для суммового учета, ContainerId_asset - ПЕРЕВОД в забаланс
       SELECT 0, zc_MIContainer_SummAsset() AS DescId, vbMovementDescId, inMovementId, _tmpItemSumm.MovementItemId
            , _tmpItemSumm.ContainerId_asset
            , _tmpItemSumm.AccountId                  AS AccountId              -- счет есть всегда
            , vbAnalyzerId                            AS AnalyzerId             -- есть аналитика: Статья списания
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer      -- Товар
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer -- Подраделение или...
              -- Контейнер суммового учета / или это услуги, в ContainerId_Goods - суммовой учет
            , CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN _tmpItem.ContainerId_Goods ELSE _tmpItemSumm.ContainerId_asset END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- Подраделение кому или...
            , 0                                       AS ParentId
            , 1 * _tmpItemSumm.OperSumm
            , vbOperDate
            , TRUE
       FROM _tmpItem
            JOIN _tmpItemSumm ON _tmpItemSumm.MovementItemId    = _tmpItem.MovementItemId
                             AND _tmpItemSumm.ContainerId_Goods = CASE WHEN _tmpItem.ObjectDescId = zc_Object_InfoMoney() THEN 0 ELSE _tmpItem.ContainerId_Goods END
                             AND _tmpItemSumm.ContainerId_asset > 0
      ;


     -- убрал, т.к. св-во пишется теперь в ОПиУ
     -- DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     -- !!!6.0. формируются свойства в элементах документа из данных для проводок!!!
     /*PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), tmp.MovementItemId, vbBranchId_Unit_ProfitLoss)
     FROM (SELECT _tmpItem.MovementItemId
           FROM _tmpItem
          ) AS tmp;*/

     -- 6.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();


     -- 6.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := vbMovementDescId
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.10.14                                        * all
 07.09.14                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpComplete_Movement_Loss (inMovementId:= 5869019 , inSession:= zfCalc_UserAdmin())

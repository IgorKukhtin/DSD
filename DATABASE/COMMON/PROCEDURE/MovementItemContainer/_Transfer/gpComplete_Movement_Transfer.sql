-- Function: gpComplete_Movement_Transfer()

-- DROP FUNCTION gpComplete_Movement_Transfer (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Transfer(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)                              
RETURNS VOID AS
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, PersonalId_From Integer, UnitId Integer, BranchId_Unit Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionMovementId Integer, PartionGoodsId Integer) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Packer_byItem TFloat;

  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Packer TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Income());
     vbUserId:=2; -- CAST (inSession AS Integer);


     -- таблица - Аналитики остатка
     CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;
     -- таблица - Аналитики <элемент с/с>
     CREATE TEMP TABLE _tmpObjectCost (DescId Integer, ObjectId Integer) ON COMMIT DROP;

     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, PersonalId_From Integer, UnitId_To Integer, PersonalId_To Integer
                               , BranchId_From Integer, BranchId_To Integer
                               , ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar
                               , OperCount TFloat
                               , AccountDirectionId_To Integer, InfoMoneyDestinationId_To Integer, InfoMoneyId_To Integer
                               , JuridicalId_basis_To Integer, BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_From Integer
                                   , OperSumm TFloat
                                   , ObjectCostId_From Integer, AccountId_From Integer, InfoMoneyId_Detail_From Integer) ON COMMIT DROP;
     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, UnitId_From, PersonalId_From, UnitId_To, PersonalId_To, BranchId_From, BranchId_To
                         , ContainerId_GoodsFrom, ContainerId_GoodsTo, GoodsId, GoodsKindId, AssetId, PartionGoods
                         , OperCount, OperSumm
                         , AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId
                         , JuridicalId_basis_From, BusinessId_From, JuridicalId_basis_To, BusinessId_To
                         , isPartionCount, isPartionSumm
                         , PartionGoodsId)
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementId
            , _tmp.OperDate
            , _tmp.UnitId_From
            , _tmp.PersonalId_From
            , _tmp.UnitId_To
            , _tmp.PersonalId_To
            , _tmp.BranchId_From
            , _tmp.BranchId_To

            , 0 AS ContainerId_GoodsFrom
            , 0 AS ContainerId_GoodsTo
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods

            , _tmp.OperCount
            , _tmp.OperSumm

              -- Аналитики счетов - направления
            , _tmp.AccountDirectionId_From
            , _tmp.AccountDirectionId_To
              -- Управленческие назначения
            , _tmp.InfoMoneyDestinationId
              -- Статьи назначения
            , _tmp.InfoMoneyId

            , _tmp.JuridicalId_basis_From
            , _tmp.JuridicalId_basis_To
            , _tmp.BusinessId_From
            , _tmp.BusinessId_To

            , _tmp.isPartionCount
            , _tmp.isPartionSumm 
              -- Партии товара, сформируем позже
            , 0 AS PartionGoodsId
        FROM 
             (SELECT
                  MovementItem.Id AS MovementItemId
                , MovementItem.MovementId
                , Movement.OperDate
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS UnitId_From
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Personal() THEN MovementLinkObject_From.ObjectId ELSE 0 END, 0) AS PersonalId_From
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS UnitId_To
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Personal() THEN MovementLinkObject_To.ObjectId ELSE 0 END, 0) AS PersonalId_To
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Branch.ObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Branch.ObjectId ELSE 0 END, 0) AS BranchId_From
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Branch.ObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Branch.ObjectId ELSE 0 END, 0) AS BranchId_To

                , MovementItem.ObjectId AS GoodsId
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                , COALESCE (MIString_PartionGoods.ValueData, '') AS PartionGoods
 
                , MovementItem.Amount AS OperCount
                , _tmpSumm.OperSumm AS OperSumm_

                  -- Аналитики счетов - направления
                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_AccountDirection.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN zc_Enum_AccountDirection_20500() END, 0) AS AccountDirectionId_From
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_AccountDirection.ChildObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN zc_Enum_AccountDirection_20500() END, 0) AS AccountDirectionId_To
                  -- Управленческие назначения
                , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                  -- Статьи назначения
                , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Juridical.ObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Juridical.ObjectId ELSE 0 END, 0) AS JuridicalId_basis_From
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Juridical.ObjectId ELSE 0 END, 0) AS JuridicalId_basis_To

                , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN ObjectLink_UnitFrom_Business.ObjectId WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Business.ObjectId ELSE 0 END, 0) AS BusinessId_From
                , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Business.ObjectId ELSE 0 END, 0) AS BusinessId_To

                , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE) AS isPartionCount
                , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)  AS isPartionSumm

            FROM Movement
                 JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.isErased = FALSE

                 LEFT JOIN (SELECT
                            FROM MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                  ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                             ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                             ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                            AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                 LEFT JOIN MovementItemString AS MIString_PartionGoods
                                              ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                 LEFT JOIN MovementItemString AS MIString_PartionGoodsCalc
                                              ON MIString_PartionGoodsCalc.MovementItemId = MovementItem.Id
                                             AND MIString_PartionGoodsCalc.DescId = zc_MIString_PartionGoodsCalc()

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                             AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                 LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                              ON MovementLinkObject_PersonalPacker.MovementId = MovementItem.MovementId
                                             AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                              ON MovementLinkObject_PaidKind.MovementId = MovementItem.MovementId
                                             AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                              ON MovementLinkObject_Contract.MovementId = MovementItem.MovementId
                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                      ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                     AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                      ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                      ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                     AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
                 LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                         ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

                 LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                      ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                     AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                      ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                      ON ObjectLink_Unit_Business.ObjectId = MovementLinkObject_To.ObjectId
                                     AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                         ON ObjectBoolean_PartionCount.ObjectId = MovementItem.ObjectId
                                        AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                         ON ObjectBoolean_PartionSumm.ObjectId = MovementItem.ObjectId
                                        AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()
                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                      ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                     AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                 LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_isCorporate ON lfObject_InfoMoney_isCorporate.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
            WHERE Movement.Id = inMovementId
              AND Movement.StatusId = zc_Enum_Status_UnComplete()
           ) AS _tmp;


   -- Расчет Итоговой суммы по Контрагенту
   SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                            ELSE SUM (tmpOperSumm_Partner)
                       END
               WHEN vbVATPercent > 0
                  -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                       END
               WHEN vbVATPercent > 0
                  -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Partner) AS NUMERIC (16, 2))
                       END
          END
          INTO vbOperSumm_Partner
   FROM _tmpItem;

   -- Расчет Итоговой суммы по Заготовителю (точно так же как и для Клиента)
   SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            ELSE SUM (tmpOperSumm_Packer)
                       END
               WHEN vbVATPercent > 0
                  -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                       END
               WHEN vbVATPercent > 0
                  -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                       END
          END
          INTO vbOperSumm_Packer
   FROM _tmpItem;

   -- Расчет Итоговой суммы по Контрагенту (по элементам)
   SELECT SUM (OperSumm_Partner) INTO vbOperSumm_Partner_byItem FROM _tmpItem;
   -- Расчет Итоговой суммы по Заготовителю (по элементам)
   SELECT SUM (OperSumm_Packer) INTO vbOperSumm_Packer_byItem FROM _tmpItem;


   -- если не равны ДВЕ Итоговые суммы по Контрагенту
   IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
   THEN
       -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
       UPDATE _tmpItem SET OperSumm_Partner = OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
       WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Partner IN (SELECT MAX (OperSumm_Partner) FROM _tmpItem)
                               );
   END IF;

   -- если не равны ДВЕ Итоговые суммы по Заготовителю
   IF COALESCE (vbOperSumm_Packer, 0) <> COALESCE (vbOperSumm_Packer_byItem, 0)
   THEN
       -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
       UPDATE _tmpItem SET OperSumm_Packer = OperSumm_Packer - (vbOperSumm_Packer_byItem - vbOperSumm_Packer)
       WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Packer IN (SELECT MAX (OperSumm_Packer) FROM _tmpItem)
                               );
   END IF;

   -- формируются Партии накладной, если Управленческие назначения = 10100; "Мясное сырье" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
   UPDATE _tmpItem SET PartionMovementId = lpInsertFind_Object_PartionMovement (MovementId) WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100();

   -- формируются Партии товара, если PartionGoods <> ''
   UPDATE _tmpItem SET PartionGoodsId = lpInsertFind_Object_PartionGoods (PartionGoods) WHERE isPartionCount OR isPartionSumm;

   -- RETURN QUERY SELECT _tmpItem.MovementItemId, _tmpItem.MovementId, _tmpItem.OperDate, _tmpItem.JuridicalId_From, _tmpItem.isCorporate, _tmpItem.PersonalId_From, _tmpItem.UnitId, _tmpItem.BranchId_Unit, _tmpItem.PersonalId_Packer, _tmpItem.PaidKindId, _tmpItem.ContractId, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.OperCount, _tmpItem.tmpOperSumm_Partner, _tmpItem.OperSumm_Partner, _tmpItem.tmpOperSumm_Packer, _tmpItem.OperSumm_Packer, _tmpItem.AccountDirectionId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.InfoMoneyDestinationId_isCorporate, _tmpItem.InfoMoneyId_isCorporate, _tmpItem.JuridicalId_basis, _tmpItem.BusinessId                         , _tmpItem.isPartionCount, _tmpItem.isPartionSumm, _tmpItem.PartionMovementId, _tmpItem.PartionGoodsId FROM _tmpItem;

   -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   -- !!! Ну а теперь - ПРОВОДКИ !!!
   -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   -- определяется ContainerId для количественного учета
   UPDATE _tmpItem SET ContainerId_Goods = CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                        -- 0)Товар 1)Подразделение 2)!!!Партия товара!!!
                                                   THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                              , inParentId:= NULL
                                                                              , inObjectId:= GoodsId
                                                                              , inJuridicalId_basis:= NULL
                                                                              , inBusinessId       := NULL
                                                                              , inObjectCostDescId := NULL
                                                                              , inObjectCostId     := NULL
                                                                              , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                              , inObjectId_1 := UnitId
                                                                              , inDescId_2   := zc_ContainerLinkObject_PartionGoods()
                                                                              , inObjectId_2 := CASE WHEN isPartionCount THEN PartionGoodsId ELSE NULL END
                                                                               )
                                                WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                        -- 0)Товар 1)Подразделение 2)Основные средства(для которого закуплено ТМЦ)
                                                   THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                              , inParentId:= NULL
                                                                              , inObjectId:= GoodsId
                                                                              , inJuridicalId_basis:= NULL
                                                                              , inBusinessId       := NULL
                                                                              , inObjectCostDescId := NULL
                                                                              , inObjectCostId     := NULL
                                                                              , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                              , inObjectId_1 := UnitId
                                                                              , inDescId_2   := zc_ContainerLinkObject_AssetTo()
                                                                              , inObjectId_2 := AssetId
                                                                               )
                                                WHEN InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- Товары    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                              , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                        -- 0)Товар 1)Подразделение 2)Вид товара
                                                   THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                              , inParentId:= NULL
                                                                              , inObjectId:= GoodsId
                                                                              , inJuridicalId_basis:= NULL
                                                                              , inBusinessId       := NULL
                                                                              , inObjectCostDescId := NULL
                                                                              , inObjectCostId     := NULL
                                                                              , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                              , inObjectId_1 := UnitId
                                                                              , inDescId_2   := zc_ContainerLinkObject_GoodsKind()
                                                                              , inObjectId_2 := GoodsKindId
                                                                               )
                                                        -- 0)Товар 1)Подразделение
                                                   ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                              , inParentId:= NULL
                                                                              , inObjectId:= GoodsId
                                                                              , inJuridicalId_basis:= NULL
                                                                              , inBusinessId       := NULL
                                                                              , inObjectCostDescId := NULL
                                                                              , inObjectCostId     := NULL
                                                                              , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                              , inObjectId_1 := UnitId
                                                                               )
                                           END;

           -- формируются Проводки для количественного учета
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MIContainer_Count()
                                               , inMovementId:= MovementId
                                               , inContainerId:= ContainerId_Goods -- был опеределен выше
                                               , inAmount:= OperCount
                                               , inOperDate:= OperDate
                                                )
           -- формируются Проводки для суммового учета + Аналитика <элемент с/с>
         , lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MIContainer_Summ()
                                               , inMovementId:= MovementId
                                               , inContainerId:= CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)!!!Партии товара!!! 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inParentId:= ContainerId_Goods
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                            -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!!!Подразделение!!! 5)Товар 6)!!!Партии товара!!! 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                                                    , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                   , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                   , inObjectId_1 := JuridicalId_basis
                                                                                                                                                   , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                   , inObjectId_2 := BusinessId
                                                                                                                                                   , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                   , inObjectId_3 := BranchId_Unit
                                                                                                                                                   , inDescId_4   := zc_ObjectCostLink_Unit()
                                                                                                                                                   , inObjectId_4 := CASE WHEN OperDate >= zc_DateStart_ObjectCostOnUnit() THEN UnitId ELSE NULL END
                                                                                                                                                   , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                   , inObjectId_5 := GoodsId
                                                                                                                                                   , inDescId_6   := zc_ObjectCostLink_PartionGoods()
                                                                                                                                                   , inObjectId_6 := CASE WHEN isPartionSumm THEN PartionGoodsId ELSE NULL END
                                                                                                                                                   , inDescId_7   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                   , inObjectId_7 := InfoMoneyId
                                                                                                                                                   , inDescId_8   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                   , inObjectId_8 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                                                                    )
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_PartionGoods()
                                                                                                    , inObjectId_3 := CASE WHEN isPartionSumm THEN PartionGoodsId ELSE NULL END
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)Основные средства(для которого закуплено ТМЦ) 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inParentId:= ContainerId_Goods
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                            -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!!!Подразделение!!! 5)Товар 6)Основные средства(для которого закуплено ТМЦ) 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                                                    , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                   , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                   , inObjectId_1 := JuridicalId_basis
                                                                                                                                                   , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                   , inObjectId_2 := BusinessId
                                                                                                                                                   , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                   , inObjectId_3 := BranchId_Unit
                                                                                                                                                   , inDescId_4   := zc_ObjectCostLink_Unit()
                                                                                                                                                   , inObjectId_4 := CASE WHEN OperDate >= zc_DateStart_ObjectCostOnUnit() THEN UnitId ELSE NULL END
                                                                                                                                                   , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                   , inObjectId_5 := GoodsId
                                                                                                                                                   , inDescId_6   := zc_ObjectCostLink_AssetTo()
                                                                                                                                                   , inObjectId_6 := AssetId
                                                                                                                                                   , inDescId_7   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                   , inObjectId_7 := InfoMoneyId
                                                                                                                                                   , inDescId_8   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                   , inObjectId_8 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                                                                    )
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_AssetTo()
                                                                                                    , inObjectId_3 := AssetId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- Товары    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                                                    , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)Виды товаров 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inParentId:= ContainerId_Goods
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                            -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Подразделение 5)Товар 6)Виды товаров 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                                                    , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                   , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                   , inObjectId_1 := JuridicalId_basis
                                                                                                                                                   , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                   , inObjectId_2 := BusinessId
                                                                                                                                                   , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                   , inObjectId_3 := BranchId_Unit
                                                                                                                                                   , inDescId_4   := zc_ObjectCostLink_Unit()
                                                                                                                                                   , inObjectId_4 := UnitId
                                                                                                                                                   , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                   , inObjectId_5 := GoodsId
                                                                                                                                                   , inDescId_6   := zc_ObjectCostLink_GoodsKind()
                                                                                                                                                   , inObjectId_6 := GoodsKindId
                                                                                                                                                   , inDescId_7   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                   , inObjectId_7 := InfoMoneyId
                                                                                                                                                   , inDescId_8   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                   , inObjectId_8 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                                                                    )
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_GoodsKind()
                                                                                                    , inObjectId_3 := GoodsKindId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)Статьи назначения 4)Статьи назначения(детализация с/с)
                                                                         ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inParentId:= ContainerId_Goods
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inObjectCostDescId := zc_ObjectCost_Basis()
                                                                                                                            -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!!!Подразделение!!! 5)Товар 6)Статьи назначения 7)Статьи назначения(детализация с/с)
                                                                                                    , inObjectCostId     := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                                                                   , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                                                                   , inObjectId_1 := JuridicalId_basis
                                                                                                                                                   , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                                                                   , inObjectId_2 := BusinessId
                                                                                                                                                   , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                                                                   , inObjectId_3 := BranchId_Unit
                                                                                                                                                   , inDescId_4   := zc_ObjectCostLink_Unit()
                                                                                                                                                   , inObjectId_4 := CASE WHEN OperDate >= zc_DateStart_ObjectCostOnUnit() THEN UnitId ELSE NULL END
                                                                                                                                                   , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                                                                   , inObjectId_5 := GoodsId
                                                                                                                                                   , inDescId_6   := zc_ObjectCostLink_InfoMoney()
                                                                                                                                                   , inObjectId_6 := InfoMoneyId
                                                                                                                                                   , inDescId_7   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                                                                   , inObjectId_7 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                                                                    )
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_3 := InfoMoneyId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_4 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                 END
                                               , inAmount:= OperSumm_Partner + OperSumm_Packer
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem;

   -- формируются Проводки - долг Поставщику или Сотруднику (подотчетные лица)
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MIContainer_Summ()
                                               , inMovementId:= MovementId
                                               , inContainerId:= CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                       AND PersonalId_From = 0
                                                                       AND NOT isCorporate
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения 5)Партии накладной
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inParentId:= NULL
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000() -- Кредиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                                                                                                                                              , inAccountDirectionId     := zc_Enum_AccountDirection_70100() -- Поставщики -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70100())
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inObjectCostDescId := NULL
                                                                                                    , inObjectCostId     := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Juridical()
                                                                                                    , inObjectId_1 := JuridicalId_From
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_PaidKind()
                                                                                                    , inObjectId_2 := PaidKindId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_Contract()
                                                                                                    , inObjectId_3 := ContractId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_PartionMovement()
                                                                                                    , inObjectId_5 := PartionMovementId
                                                                                                     )
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Юридические лица 2)Виды форм оплаты 3)Договора 4)Статьи назначения
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудники(подотчетные лица) 2)NULL 3)NULL 4)Статьи назначения
                                                                         ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inParentId:= NULL
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := CASE WHEN PersonalId_From <> 0 THEN zc_Enum_AccountGroup_30000() WHEN isCorporate THEN zc_Enum_AccountGroup_30000() ELSE zc_Enum_AccountGroup_70000() END -- then Дебиторы then Дебиторы else Кредиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000(), zc_Enum_AccountGroup_30000(), zc_Enum_AccountGroup_70000())
                                                                                                                                              , inAccountDirectionId     := CASE WHEN PersonalId_From <> 0 THEN zc_Enum_AccountDirection_30500() WHEN isCorporate THEN zc_Enum_AccountDirection_30200() ELSE zc_Enum_AccountDirection_70100() END -- then сотрудники (подотчетные лица) then наши компании else поставщики -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500(), zc_Enum_AccountDirection_30200(), zc_Enum_AccountDirection_70100())
                                                                                                                                              , inInfoMoneyDestinationId := CASE WHEN isCorporate THEN InfoMoneyDestinationId_isCorporate ELSE InfoMoneyDestinationId END
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inObjectCostDescId := NULL
                                                                                                    , inObjectCostId     := NULL
                                                                                                    , inDescId_1   := CASE WHEN PersonalId_From <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Juridical() END
                                                                                                    , inObjectId_1 := CASE WHEN PersonalId_From <> 0 THEN PersonalId_From ELSE JuridicalId_From END
                                                                                                    , inDescId_2   := CASE WHEN PersonalId_From <> 0 THEN NULL ELSE zc_ContainerLinkObject_PaidKind() END
                                                                                                    , inObjectId_2 := PaidKindId
                                                                                                    , inDescId_3   := CASE WHEN PersonalId_From <> 0 THEN NULL ELSE zc_ContainerLinkObject_Contract() END
                                                                                                    , inObjectId_3 := ContractId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                 END
                                               , inAmount:= - SUM (OperSumm_Partner)
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem
    GROUP BY MovementId, OperDate, JuridicalId_From, isCorporate, PersonalId_From, PaidKindId, ContractId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyDestinationId_isCorporate, InfoMoneyId_isCorporate, JuridicalId_basis, BusinessId, PartionMovementId;


   -- формируются Проводки - доплата Заготовителю
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MIContainer_Summ()
                                               , inMovementId:= MovementId
                                                                              -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1) Сотрудники(поставщики) 3)Статьи назначения
                                               , inContainerId:=              lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inParentId:= NULL
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000() -- Кредиторы -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                                                                                                                                              , inAccountDirectionId     := zc_Enum_AccountDirection_70600() -- сотрудники (заготовители) -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70600())
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inObjectCostDescId := NULL
                                                                                                    , inObjectCostId     := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Personal()
                                                                                                    , inObjectId_1 := PersonalId_Packer
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_2 := InfoMoneyId
                                                                                                     )
                                               , inAmount:= - SUM (OperSumm_Packer)
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem
    WHERE OperSumm_Packer <> 0
    GROUP BY MovementId, OperDate, PersonalId_Packer, InfoMoneyDestinationId, InfoMoneyId, JuridicalId_basis, BusinessId;


  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId = zc_Enum_Status_UnComplete();


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 17.07.13                                        * all
 12.07.13                                        * add PartionGoods
 11.07.13                                        * add ObjectCost
 04.07.13                                        * !!! finich !!!
 02.07.13                                        *

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 5028, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Transfer (inMovementId:= 5028, inSession:= '2')

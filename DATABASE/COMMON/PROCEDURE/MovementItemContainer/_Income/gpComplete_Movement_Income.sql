-- Function: gpComplete_Movement_Income()

-- DROP FUNCTION gpComplete_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)                              
--  RETURNS VOID AS
  RETURNS TABLE (a1 TFloat, a2 TFloat, b1 TFloat, b2 TFloat) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbOperSumm_Client_byItem TFloat;
  DECLARE vbOperSumm_Packer_byItem TFloat;

  DECLARE vbOperSumm_Client TFloat;
  DECLARE vbOperSumm_Packer TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Income());
   vbUserId:= inSession;


   -- Эти параметры нужны для расчета конечных сумм по Клиенту и Заготовителю
   SELECT
         COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
       , COALESCE (MovementFloat_VATPercent.ValueData, 0)
       , COALESCE (MovementFloat_DiscountPercent.ValueData, 0)
       , COALESCE (MovementFloat_ExtraChargesPercent.ValueData, 0)
         INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
   FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                 ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                 ON MovementFloat_VATPercent.MovementId = Movement.Id
                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
        LEFT JOIN MovementFloat AS MovementFloat_DiscountPercent
                 ON MovementFloat_DiscountPercent.MovementId = Movement.Id
                AND MovementFloat_DiscountPercent.DescId = zc_MovementFloat_DiscountPercent()
        LEFT JOIN MovementFloat AS MovementFloat_ExtraChargesPercent
                 ON MovementFloat_ExtraChargesPercent.MovementId = Movement.Id
                AND MovementFloat_ExtraChargesPercent.DescId = zc_MovementFloat_ExtraChargesPercent()
   WHERE Movement.Id = inMovementId
     AND Movement.StatusId = zc_Enum_Status_UnComplete();

if inMovementId = 0 then
 vbPriceWithVAT:=false;
 vbVATPercent:= 20;
 vbDiscountPercent:= 0;
 vbExtraChargesPercent:= 0;
end if;


   -- таблица - Аналитики остатка
   CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;

   -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
   CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, MemberId_From Integer, UnitId Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar
                            , OperCount TFloat, tmpOperSumm_Client TFloat, OperSumm_Client TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                            , AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                            , JuridicalId_basis Integer, BusinessId Integer
                            , PartionMovementId Integer, PartionGoodsId Integer) ON COMMIT DROP;
   -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
   INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, JuridicalId_From, MemberId_From, UnitId, PersonalId_Packer, PaidKindId, ContractId, GoodsId, GoodsKindId, AssetId, PartionGoods
                      , OperCount, tmpOperSumm_Client, OperSumm_Client, tmpOperSumm_Packer, OperSumm_Packer
                      , AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId
                      , JuridicalId_basis, BusinessId
                      , PartionMovementId, PartionGoodsId)
      SELECT
            MovementItemId
          , MovementId
          , OperDate
          , JuridicalId_From
          , MemberId_From
          , UnitId
          , PersonalId_Packer
          , PaidKindId
          , ContractId

          , GoodsId
          , GoodsKindId
          , AssetId
          , PartionGoods

          , OperCount

            -- промежуточная сумма по Клиенту - с округлением до 2-х знаков
          , tmpOperSumm_Client
            -- конечная сумма по Клиенту
          , CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Client)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Client

            -- промежуточная сумма по Заготовителю - с округлением до 2-х знаков
          , tmpOperSumm_Packer
            -- конечная сумма по Заготовителю
          , CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
                    -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Packer

            -- Аналитики счетов - направления
          , AccountDirectionId
            -- Управленческие назначения
          , InfoMoneyDestinationId
            -- Статьи назначения
          , InfoMoneyId

          , JuridicalId_basis
          , BusinessId

            -- Партии накладной, сформируем позже
          , 0 AS PartionMovementId
            -- Партии товара, сформируем позже
          , 0 AS PartionGoodsId
      FROM (
      SELECT
            MovementItem.Id AS MovementItemId
          , MovementItem.MovementId
          , Movement.OperDate
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id ELSE 0 END, 0) AS MemberId_From
          , COALESCE (MovementLinkObject_To.ObjectId, 0) AS UnitId
          , COALESCE (MovementLinkObject_PersonalPacker.ObjectId, 0) AS PersonalId_Packer
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , MovementItem.ObjectId AS GoodsId
          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
          , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
          , CASE WHEN COALESCE (MIString_PartionGoods.ValueData, '') <> '' THEN MIString_PartionGoods.ValueData ELSE '' END AS PartionGoods

          , MovementItem.Amount AS OperCount

            -- промежуточная сумма по Клиенту - с округлением до 2-х знаков
          , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                         ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
            END AS tmpOperSumm_Client
          -- , 0 AS OperSumm_Client

            -- промежуточная сумма по Заготовителю - с округлением до 2-х знаков
          , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                         ELSE COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
            END AS tmpOperSumm_Packer
          -- , 0 AS OperSumm_Packer

            -- Аналитики счетов - направления
          , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, 0) AS AccountDirectionId
            -- Управленческие назначения
          , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
            -- Статьи назначения
          , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

          , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0) AS JuridicalId_basis
          , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId

      FROM Movement
           JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.isErased = FALSE

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

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

           LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                    ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                   AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                    ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                   AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                    ON ObjectLink_Unit_Business.ObjectId = MovementLinkObject_To.ObjectId
                   AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()

           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                    ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                   AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
           LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

      WHERE (Movement.Id = inMovementId OR inMovementId = 0)
        AND Movement.StatusId = zc_Enum_Status_UnComplete()
      ) AS _tmp;


   -- Расчет Итоговой суммы по Клиенту
   SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
                  -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            ELSE SUM (tmpOperSumm_Client)
                       END
               WHEN vbVATPercent > 0
                  -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                       END
               WHEN vbVATPercent > 0
                  -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                       END
          END
          INTO vbOperSumm_Client
   FROM _tmpItem;

   -- Расчет Итоговой суммы по Заготовителю (точно так же как и для Клиента)
   SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
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

   -- Расчет Итоговой суммы по Клиенту (по элементам)
   SELECT SUM (OperSumm_Client) INTO vbOperSumm_Client_byItem FROM _tmpItem;
   -- Расчет Итоговой суммы по Заготовителю (по элементам)
   SELECT SUM (OperSumm_Packer) INTO vbOperSumm_Packer_byItem FROM _tmpItem;


   -- если не равны ДВЕ Итоговые суммы по Клиенту
   IF COALESCE (vbOperSumm_Client, 0) <> COALESCE (vbOperSumm_Client_byItem, 0)
   THEN
       -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
       UPDATE _tmpItem SET OperSumm_Client = OperSumm_Client - (vbOperSumm_Client_byItem - vbOperSumm_Client)
       WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Client IN (SELECT MAX (OperSumm_Client) FROM _tmpItem)
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


   RETURN QUERY SELECT vbOperSumm_Client as a1, vbOperSumm_Client_byItem as a2, vbOperSumm_Packer as b1, vbOperSumm_Packer_byItem as b2; 

--  return;

   -- формируются Партии накладной, если Управленческие назначения = 10100; "Мясное сырье" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
   UPDATE _tmpItem SET PartionMovementId = lpInsertFind_Object_PartionMovement (MovementId)
   WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100(); 

   -- формируются Партии накладной, если PartionGoods <> ''
   UPDATE _tmpItem SET PartionGoodsId = lpInsertFind_Object_PartionGoods (PartionGoods, NULL) WHERE PartionGoods <> '';


   -- формируются Проводки для товарного учета в количестве 
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MovementItemContainer_Count()
                                               , inMovementId:= MovementId
                                               , inContainerId:= CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- 10100; "Мясное сырье" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := NULL
                                                                                                    , inObjectId_2 := NULL
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_PartionGoods()
                                                                                                    , inObjectId_3 := PartionGoodsId
                                                                                                    , inDescId_4   := NULL, inObjectId_4 := NULL, inDescId_5   := NULL, inObjectId_5 := NULL, inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- 20100; "Запчасти и Ремонты" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := NULL
                                                                                                    , inObjectId_2 := NULL
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_AssetTo()
                                                                                                    , inObjectId_3 := AssetId
                                                                                                    , inDescId_4   := NULL, inObjectId_4 := NULL, inDescId_5   := NULL, inObjectId_5 := NULL, inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- 30100; "Продукция" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := NULL
                                                                                                    , inObjectId_2 := NULL
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_GoodsKind()
                                                                                                    , inObjectId_3 := GoodsKindId
                                                                                                    , inDescId_4   := NULL, inObjectId_4 := NULL, inDescId_5   := NULL, inObjectId_5 := NULL, inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                         ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := NULL
                                                                                                    , inObjectId_2 := NULL
                                                                                                    , inDescId_3   := NULL
                                                                                                    , inObjectId_3 := NULL
                                                                                                    , inDescId_4   := NULL, inObjectId_4 := NULL, inDescId_5   := NULL, inObjectId_5 := NULL, inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                 END
                                               , inAmount:= OperCount
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem;
   -- формируются Проводки для товарного учета в сумме
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MovementItemContainer_Summ()
                                               , inMovementId:= MovementId
                                               , inContainerId:= CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- 10100; "Мясное сырье" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- 20000; "Запасы" -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_PartionGoods()
                                                                                                    , inObjectId_3 := PartionGoodsId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := InfoMoneyId
                                                                                                    , inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- 20100; "Запчасти и Ремонты" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- 20000; "Запасы" -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_AssetTo()
                                                                                                    , inObjectId_3 := AssetId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := InfoMoneyId
                                                                                                    , inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- 30100; "Продукция" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- 20000; "Запасы" -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_GoodsKind()
                                                                                                    , inObjectId_3 := GoodsKindId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := InfoMoneyId
                                                                                                    , inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                         ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- 20000; "Запасы" -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := NULL
                                                                                                    , inObjectId_3 := NULL
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := InfoMoneyId
                                                                                                    , inDescId_6:= NULL, inObjectId_6:=NULL, inDescId_7:= NULL, inObjectId_7:=NULL, inDescId_8:= NULL, inObjectId_8:=NULL, inDescId_9:= NULL, inObjectId_9:=NULL, inDescId_10:= NULL, inObjectId_10:=NULL
                                                                                                     )
                                                                 END
                                               , inAmount:= OperSumm_Client + OperSumm_Packer
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem;




  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Object_Status_Complete() WHERE Id = inMovementId AND StatusId = zc_Enum_Status_UnComplete();


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 02.07.13                                        *

*/

-- тест
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 5241, inSession:= '2')

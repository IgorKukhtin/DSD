-- Function: gpComplete_Movement_Income()

-- DROP FUNCTION gpComplete_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
    IN inMovementId        Integer,   	-- ключ Документа <Приходная накладная> */
    IN inSession           TVarChar       -- сессия пользователя
)                              
  RETURNS void AS
$BODY$
  DECLARE AccountId Integer;
  DECLARE UnitId Integer;
  DECLARE JuridicalId Integer;
  DECLARE OperDate TDateTime;
  DECLARE MovementSumm TFloat;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Income());
  return;
   -- таблица 
   CREATE TEMP TABLE tmpItem (MovementItemId Integer, MovementId Integer, JuridicalId_From Integer, MemberId_From Integer, UnitId Integer, PersonalId_Packer Integer, AssetId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoods TVarChar
                            , OperCount TFloat, tmpOperSumm_Client TFloat, OperSumm_Client TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                            , AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                            , JuridicalId_main Integer, BusinessId Integer);
   INSERT INTO tmpItem (MovementItemId, MovementId, JuridicalId_From, MemberId_From, UnitId, PersonalId_Packer, AssetId, GoodsId, GoodsKindId, PartionGoods
                      , OperCount, tmpOperSumm_Client, OperSumm_Client, tmpOperSumm_Packer, OperSumm_Packer
                      , AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId
                      , JuridicalId_main, BusinessId)
      SELECT
            MovementItem.Id
          , MovementItem.MovementId
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From
          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id ELSE 0 END, 0) AS MemberId_From
          , COALESCE (MovementLinkObject_To.ObjectId, 0) AS UnitId
          , COALESCE (MovementLinkObject_PersonalPacker.ObjectId, 0) AS PersonalId_Packer
          , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId

          , MovementItem.ObjectId AS GoodsId
          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
          , CASE WHEN COALESCE (MIString_PartionGoods.ValueData, '') <> '' THEN MIString_PartionGoods.ValueData ELSE '' END AS PartionGoods

          , MovementItem.Amount AS OperCount
            -- промежуточная сумма по клиенту - с округлением до 2-х знаков
          , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                   ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
            END AS tmpOperSumm_Client
            -- конечная сумма по клиенту, расчитаем позже
          , 0 AS OperSumm_Client
            -- промежуточная сумма по заготовителю - с округлением до 2-х знаков
          , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                                   ELSE COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
            END AS tmpOperSumm_Packer
            -- конечная сумма по клиенту, расчитаем позже
          , 0 AS OperSumm_Packer

            -- Аналитики счетов - направления
          , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, 0) AS AccountDirectionId
            -- Управленческие назначения
          , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
            -- Статьи назначения
          , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

          , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0) AS JuridicalId_main
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
                   AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Juridical()


           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                    ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                   AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()

           LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON ObjectLink_Unit_AccountDirection.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId

      WHERE Movement.Id = inMovementId
        AND Movement.StatusId = zc_Enum_Status_UnComplete();


  -- Делаем товарные проводки

  -- Делаем проводки по счету учета товаров
  -- Нашли счет товара
  AccountId := zc_Object_Account_InventoryStoreEmpties();

  -- Определили подразделение
  SELECT 
    MovementLink_To.ObjectId INTO UnitId
  FROM MovementLinkObject AS MovementLink_To 
 WHERE MovementLink_To.DescId = zc_MovementLink_To()
   AND MovementLink_To.MovementId = inMovementId;
  
  -- Определили дату
  SELECT
    Movement.OperDate INTO OperDate
  FROM Movement 
 WHERE Movement.Id = inMovementId;

  PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Summ(), inMovementId,
                                               lpget_containerid(zc_Container_Summ(), AccountId, 
                                                                 UnitId, zc_ContainerLinkObject_Unit(), 
                                                                 MovementItem.ObjectId, zc_ContainerLinkObject_Goods()),
                                               MovementItem.Amount * MIFloat_Price.ValueData,
                                               OperDate)
     FROM 
          MovementItem 
LEFT JOIN MovementItemFloat AS MIFloat_Price
       ON MIFloat_Price.MovementItemId = MovementItem.Id AND MIFloat_Price.DescId = zc_MIFloat_Price()
    WHERE MovementId = inMovementId; 

  -- Делаем товарный проводки

  PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Count(), inMovementId,
                                               lpget_containerid(zc_Container_Count(), AccountId, 
                                                                 UnitId, zc_ContainerLinkObject_Unit(), 
                                                                 MovementItem.ObjectId, zc_ContainerLinkObject_Goods()),
                                               MovementItem.Amount,
                                               OperDate)
     FROM 
          MovementItem 
    WHERE MovementId = inMovementId; 
 
  -- Делаем проводки по счету задолженности
  -- Нашли счет 
  AccountId := zc_Object_Account_CreditorsSupplierMeat();

  -- Определили юр лицо
  SELECT 
    MovementLink_From.ObjectId INTO JuridicalId
  FROM MovementLinkObject AS MovementLink_From 
 WHERE MovementLink_From.DescId = zc_MovementLink_From()
   AND MovementLink_From.MovementId = inMovementId;

     SELECT
       SUM(MovementItem.Amount * MIFloat_Price.ValueData) INTO MovementSumm
     FROM 
          MovementItem 
LEFT JOIN MovementItemFloat AS MIFloat_Price
       ON MIFloat_Price.MovementItemId = MovementItem.Id AND MIFloat_Price.DescId = zc_MIFloat_Price()
    WHERE MovementId = inMovementId; 


  PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Summ(), inMovementId,
                                               lpget_containerid(zc_Container_Summ(), AccountId, 
                                                                 JuridicalId, zc_ContainerLinkObject_Juridical()),
                                               - MovementSumm,
                                               OperDate);


  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Object_Status_Complete() WHERE Id = inMovementId;

END;$BODY$ LANGUAGE plpgsql;

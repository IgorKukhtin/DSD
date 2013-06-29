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
   CREATE TEMP TABLE tmpItem (MovementItemId Integer, JuridicalId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer
                            , OperCount TFloat, OperCount_Partner TFloat, OperCount_Packer TFloat, OperSumm TFloat, OperSumm_Client TFloat, OperSumm_Packer TFloat
                            , AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer);
   INSERT INTO tmpItem (MovementItemId, JuridicalId, UnitId, GoodsId, GoodsKindId
                      , OperCount, OperCount_Partner, OperCount_Packer, OperSumm, OperSumm_Client, OperSumm_Packer
                      , AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId)
      SELECT
            MovementItem.Id
          , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
          , MovementLinkObject_To.ObjectId AS UnitId
          , MovementItem.ObjectId AS GoodsId
          , MovementItemLink_GoodsKind.ObjectId AS GoodsKindId
          , MovementItem.Amount AS OperCount
          , MovementItemFloat_AmountPartner.ValueData AS OperCount_Partner
          , MovementItemFloat_AmountPacker.ValueData AS OperCount_Packer
          , CASE WHEN MovementItemFloat_CountForPrice.ValueData <> 0 THEN CAST (MovementItemFloat_AmountPartner.ValueData * MovementItemFloat_Price.ValueData / MovementItemFloat_CountForPrice.ValueData  AS NUMERIC (16, 2))
                                                                     ELSE CAST (MovementItemFloat_AmountPartner.ValueData * MovementItemFloat_Price.ValueData  AS NUMERIC (16, 2))
            END AS OperSumm
      FROM Movement
           JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.isErased = FALSE

           LEFT JOIN MovementItemLinkObject AS MovementItemLink_GoodsKind
                    ON MovementItemLink_GoodsKind.MovementItemId = MovementItem.Id
                   AND MovementItemLink_GoodsKind.DescId = zc_MovementItemLink_GoodsKind()

           LEFT JOIN MovementItemFloat AS MovementItemFloat_AmountPartner
                    ON MovementItemFloat_AmountPartner.MovementItemId = MovementItem.Id
                   AND MovementItemFloat_AmountPartner.DescId = zc_MovementItemFloat_AmountPartner()
           LEFT JOIN MovementItemFloat AS MovementItemFloat_AmountPacker
                    ON MovementItemFloat_AmountPacker.MovementItemId = MovementItem.Id
                   AND MovementItemFloat_AmountPacker.DescId = zc_MovementItemFloat_AmountPacker()

           LEFT JOIN MovementItemFloat AS MovementItemFloat_Price
                    ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                   AND MovementItemFloat_Price.DescId = zc_MovementItemFloat_Price()
           LEFT JOIN MovementItemFloat AS MovementItemFloat_CountForPrice
                    ON MovementItemFloat_CountForPrice.MovementItemId = MovementItem.Id
                   AND MovementItemFloat_CountForPrice.DescId = zc_MovementItemFloat_CountForPrice()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                    ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                   AND MovementLinkObject_From.DescId = zc_MovementLink_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                    ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                   AND MovementLinkObject_To.DescId = zc_MovementLink_To()

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

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
                                               MovementItem.Amount * MovementItemFloat_Price.ValueData,
                                               OperDate)
     FROM 
          MovementItem 
LEFT JOIN MovementItemFloat AS MovementItemFloat_Price
       ON MovementItemFloat_Price.MovementItemId = MovementItem.Id AND MovementItemFloat_Price.DescId = zc_MovementItemFloat_Price()
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
       SUM(MovementItem.Amount * MovementItemFloat_Price.ValueData) INTO MovementSumm
     FROM 
          MovementItem 
LEFT JOIN MovementItemFloat AS MovementItemFloat_Price
       ON MovementItemFloat_Price.MovementItemId = MovementItem.Id AND MovementItemFloat_Price.DescId = zc_MovementItemFloat_Price()
    WHERE MovementId = inMovementId; 


  PERFORM lpInsertUpdate_MovementItemContainer(0, zc_MovementItemContainer_Summ(), inMovementId,
                                               lpget_containerid(zc_Container_Summ(), AccountId, 
                                                                 JuridicalId, zc_ContainerLinkObject_Juridical()),
                                               - MovementSumm,
                                               OperDate);


  -- Обязательно меняем статус документа
  UPDATE Movement SET StatusId = zc_Object_Status_Complete() WHERE Id = inMovementId;

END;$BODY$ LANGUAGE plpgsql;
  
                            
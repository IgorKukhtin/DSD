-- Function: gpComplete_Movement_Income()

-- DROP FUNCTION gpComplete_Movement_Income(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
   IN inMovementId        Integer,   	/* ключ объекта <Приходная накладная> */
   IN inSession           TVarChar       /* текущий пользователь */
)                              
  RETURNS void AS
$BODY$
  DECLARE AccountId Integer;
  DECLARE UnitId Integer;
  DECLARE JuridicalId Integer;
  DECLARE OperDate TDateTime;
  DECLARE MovementSumm TFloat;
BEGIN
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
  
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

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            
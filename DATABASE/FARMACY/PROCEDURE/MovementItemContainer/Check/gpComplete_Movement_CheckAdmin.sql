-- Function: gpComplete_Movement_IncomeAdmin()

DROP FUNCTION IF EXISTS gpComplete_Movement_CheckAdmin (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_CheckAdmin (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_CheckAdmin (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_CheckAdmin(
    IN inMovementId        Integer              , -- ключ Документа
    IN inPaidType          Integer              , --Тип оплаты 0-деньги, 1-карта, 1-смешенная
    IN inCashRegisterId    Integer              , --№ кассового аппарата
   OUT outMessageText      Text      ,
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPaidTypeId Integer;
  DECLARE vbOperDate    TDateTime;
  DECLARE vbUnit        Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
    vbUserId:= inSession;
    
    IF NOT EXISTS(SELECT 1 
                  FROM 
                      Movement
                  WHERE
                      ID = inMovementId
                      AND
                      DescId = zc_Movement_Check()
                      AND
                      StatusId = zc_Enum_Status_Uncomplete()
                 )
    THEN
        RAISE EXCEPTION 'Ошибка. Документ не сохранен, либо не находится в состоянии "не проведен"!';
    END IF;
    
    -- Проверить, что бы не было переучета позже даты документа
    /*SELECT
        date_trunc('day', Movement.OperDate),
        Movement_Unit.ObjectId AS Unit
    INTO
        vbOperDate,
        vbUnit
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnit
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущей продажи. Проведение документа запрещено!';
    END IF; */   
    
    -- Сохранили связь с тип оплаты
    if inPaidType = 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Cash());
    ELSEIF inPaidType = 1 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),inMovementId,zc_Enum_PaidType_Card());
    ELSEIF inPaidType = 2 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType() ,inMovementId, zc_Enum_PaidType_CardAdd());
    ELSE
        RAISE EXCEPTION 'Ошибка.Не определен тип оплаты %', inPaidType;
    END IF;

    -- Сохранили связь с кассовым аппаратом
    IF inCashRegisterId <> 0 THEN
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),inMovementId,inCashRegisterId);
    END IF;

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    -- формируются проводки
    outMessageText:= lpComplete_Movement_Check (inMovementId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpComplete_Movement_CheckAdmin (Integer,Integer, Integer, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 22.11.14                                                                                    *
 07.08.15                                                                       *
 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

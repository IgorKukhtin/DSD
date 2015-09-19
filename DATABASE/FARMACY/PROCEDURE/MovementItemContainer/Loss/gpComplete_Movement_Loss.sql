-- Function: gpComplete_Movement_Loss()

DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Loss  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbUnitId    Integer;
BEGIN
    vbUserId:= inSession;
    vbGoodsName := '';
    SELECT
        Movement.OperDate,
        MovementLinkObject.ObjectId
    INTO
        vbOperDate,
        vbUnitId
    FROM
        Movement
        INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                     AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit()
    WHERE
        MovementId = inMovementId;
  --Проверка на то что бы не списали больше чем есть на остатке
    WITH REMAINS AS ( --остатки на дату документа
                                SELECT 
                                    T0.ObjectId
                                   ,SUM(T0.Amount)::TFloat as Amount
                                FROM(
                                        SELECT 
                                            Container.Id 
                                           ,Container.ObjectId --Товар
                                           ,(Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat as Amount  --Тек. остаток - Движение после даты переучета
                                        FROM Container
                                            LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                                 AND 
                                                                                 (
                                                                                    date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                                 )
                                            JOIN ContainerLinkObject AS CLI_Unit 
                                                                     ON CLI_Unit.containerid = Container.Id
                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                    AND CLI_Unit.ObjectId = vbUnitId                                   
                                        WHERE 
                                            Container.DescID = zc_Container_Count()
                                        GROUP BY 
                                            Container.Id 
                                           ,Container.ObjectId
                                    ) as T0
                                GROUP By ObjectId
                                HAVING SUM(T0.Amount) <> 0
                            )
    
    SELECT Object_Goods.ValueData, COALESCE(MovementItem_Loss.Amount,0), COALESCE(REMAINS.Amount,0) INTO vbGoodsName, vbAmount, vbSaldo 
    FROM
        Movement AS Movement_Loss
        INNER JOIN MovementLinkObject AS MLO_UNIT
                                      ON MLO_Unit.MovementId = Movement_Loss.Id
                                     AND MLO_Unit.DescId = zc_MovementLinkObject_Unit() 
        INNER JOIN MovementItem AS MovementItem_Loss
                                ON MovementItem_Loss.MovementId = Movement_Loss.Id
                               AND MovementItem_Loss.DescId = zc_MI_Master()
                               AND MovementItem_Loss.isErased = FALSE
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = MovementItem_Loss.ObjectId  
        LEFT OUTER JOIN REMAINS ON MovementItem_Loss.ObjectId = REMAINS.ObjectId
    WHERE
        Movement_Loss.Id = inMovementId
        AND
        COALESCE(MovementItem_Loss.Amount,0) > COALESCE(REMAINS.Amount,0)
    LIMIT 1;
    
  IF (COALESCE(vbGoodsName,'') <> '') 
  THEN
    RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во списания <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
  END IF;
  
    -- Проверить, что бы не было переучета позже даты документа

    IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnitId
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
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущего списания. Проведение документа запрещено!';
    END IF;
    
  -- пересчитали Итоговые суммы
  PERFORM lpInsertUpdate_MovementFloat_TotalSummLoss (inMovementId);
  -- собственно проводки
  PERFORM lpComplete_Movement_Loss(inMovementId, -- ключ Документа
                                        vbUserId);    -- Пользователь                          
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 21.07.15                                                         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_Loss (inMovementId:= 29207, inSession:= '2')

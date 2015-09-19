-- Function: gpComplete_Movement_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_Send  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
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
  DECLARE vbUnit_From Integer;
  DECLARE vbUnit_To   Integer;
  DECLARE vbOperDate  TDateTime;
  
BEGIN
  vbUserId:= inSession;
    vbGoodsName := '';
  --Проверка на то что бы не списали больше чем есть на остатке
    SELECT Object_Goods.ValueData, COALESCE(MovementItem_Send.Amount,0), COALESCE(SUM(Container.Amount),0) INTO vbGoodsName, vbAmount, vbSaldo 
    FROM
        Movement AS Movement_Send
        INNER JOIN MovementLinkObject AS MLO_From
                                      ON MLO_From.MovementId = Movement_Send.Id
                                     AND MLO_From.DescId = zc_MovementLinkObject_From() 
        INNER JOIN MovementItem AS MovementItem_Send
                                ON MovementItem_Send.MovementId = Movement_Send.Id
                               AND MovementItem_Send.DescId = zc_MI_Master()
        INNER JOIN Object AS Object_Goods
                          ON Object_Goods.Id = MovementItem_Send.ObjectId  
        LEFT OUTER JOIN ContainerLinkObject AS CLO_From
                                            ON CLO_From.ObjectId = MLO_From.ObjectId
                                           AND CLO_From.DescId = zc_ContainerLinkObject_Unit() 
        LEFT OUTER JOIN Container ON MovementItem_Send.ObjectId = Container.ObjectId
                                 AND CLO_From.ContainerId = Container.Id
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE
        Movement_Send.Id = inMovementId AND
        MovementItem_Send.DescId = zc_MI_Master() AND
        MovementItem_Send.isErased = FALSE
    GROUP BY MovementItem_Send.ObjectId, Object_Goods.ValueData, MovementItem_Send.Amount
    HAVING COALESCE(MovementItem_Send.Amount,0) > COALESCE(SUM(Container.Amount),0);
    
    IF (COALESCE(vbGoodsName,'') <> '') 
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во перемещения <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;
    -- Проверить, что бы не было переучета позже даты документа
    SELECT
        Movement.OperDate,
        Movement_From.ObjectId AS Unit_From,
        Movement_To.ObjectId AS Unit_To
    INTO
        vbOperDate,
        vbUnit_From,
        vbUnit_To
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS Movement_To
                                      ON Movement_To.MovementId = Movement.Id
                                     AND Movement_To.DescId = zc_MovementLinkObject_To()
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
                                               AND Movement_Inventory_Unit.ObjectId in (vbUnit_From,vbUnit_To)
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
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущего перемещения. Проведение документа запрещено!';
    END IF;
  
  -- пересчитали Итоговые суммы
  PERFORM lpInsertUpdate_MovementFloat_TotalSummSend (inMovementId);
  -- собственно проводки
  PERFORM lpComplete_Movement_Send(inMovementId, -- ключ Документа
                                   vbUserId);    -- Пользователь                          
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 29.07.15                                                         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 29207, inSession:= '2')

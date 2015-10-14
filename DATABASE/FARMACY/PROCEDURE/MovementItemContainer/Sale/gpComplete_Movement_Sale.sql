-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale(
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
  DECLARE vbUnitId    Integer;
  DECLARE vbOperDate  TDateTime;
  
BEGIN
    vbUserId:= inSession;
    vbGoodsName := '';
    --Проверка на то что бы не продали больше чем есть на остатке
    SELECT 
        MI_Sale.GoodsName
      , COALESCE(MI_Sale.Amount,0)
      , COALESCE(SUM(Container.Amount),0) 
    INTO 
        vbGoodsName
      , vbAmount
      , vbSaldo 
    FROM
        Movement_Sale_View AS Movement_Sale
        INNER JOIN MovementItem_Sale_View AS MI_Sale
                                          ON MI_Sale.MovementId = Movement_Sale.Id
        LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                 AND Container.WhereObjectId = Movement_Sale.UnitId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE
        Movement_Sale.Id = inMovementId AND
        MI_Sale.isErased = FALSE
    GROUP BY 
        MI_Sale.GoodsId
      , MI_Sale.GoodsName
      , MI_Sale.Amount
    HAVING 
        COALESCE(MI_Sale.Amount,0) > COALESCE(SUM(Container.Amount),0);
    
    IF (COALESCE(vbGoodsName,'') <> '') 
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во продажи <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;
    -- Проверить, что бы не было переучета позже даты документа
    SELECT
        Movement_Sale.OperDate,
        Movement_Sale.UnitId
    INTO
        vbOperDate,
        vbUnitId
    FROM 
        Movement_Sale_View AS Movement_Sale
    WHERE 
        Movement_Sale.Id = inMovementId;

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
                  INNER JOIN MovementItem AS MI_Sale
                                          ON MI_Inventory.ObjectId = MI_Sale.ObjectId
                                         AND MI_Sale.DescId = zc_MI_Master()
                                         AND MI_Sale.IsErased = FALSE
                                         AND MI_Sale.Amount > 0
                                         AND MI_Sale.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущей продажи. Проведение документа запрещено!';
    END IF;
  
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);
    -- собственно проводки
    PERFORM lpComplete_Movement_Sale(inMovementId, -- ключ Документа
                                     vbUserId);    -- Пользователь  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 13.10.15                                                         *
 */
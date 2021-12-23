-- Function: gpUnComplete_Movement_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate  TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Sale());
    vbUserId := inSession::Integer;

/*     -- Разрешаем только сотрудникам с правами админа    
    IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId) = zc_Enum_Status_Complete()
    THEN
      IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_UnComplete()))
      THEN
        RAISE EXCEPTION 'Распроведение вам запрещено, обратитесь к системному администратору';
      END IF;
    END IF;
*/

    -- фармацевт может только создать и удалить документ Продажи Постановление 1303, но не может его распроизвести - 
    -- распровести может только Колеуш И. И. (ID 235009)
    IF (SELECT MovementLinkObject_SPKind.ObjectId AS SPKindId
        FROM Movement 
             LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                          ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                         AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
        WHERE Movement.Id = inMovementId) = zc_Enum_SPKind_1303()                    -- Постановление 1303
    THEN
      IF  (vbUserId <> 235009) AND (vbUserId <> 3)
      THEN
        RAISE EXCEPTION 'Распроведение Продажи Постановление 1303 вам запрещено.';
      END IF;
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

    /*IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnitId
                  Inner Join MovementItem AS MI_Sale
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
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущего перемещения. Отмена проведения документа запрещена!';
    END IF;*/


    -- Проверяем VIP чек для продажи         
    IF EXISTS(SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession) 
              WHERE GoodsId IN (SELECT DISTINCT MovementItem.ObjectId
                                FROM MovementItemContainer
                                     INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
                                WHERE MovementItemContainer.MovementId = inMovementId
                                  AND MovementItemContainer.DescId = zc_MIContainer_Count()))
    THEN
      PERFORM gpInsertUpdate_MovementItem_Check_VIPforSales (inUnitId   := vbUnitId
                                                           , inGoodsId  := MovementItem.ObjectId
                                                           , inAmount   := - SUM(MovementItemContainer.Amount)
                                                           , inSession  := inSession
                                                            )
      FROM MovementItemContainer
           INNER JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId
           INNER JOIN (SELECT * FROM gpSelect_Goods_AutoVIPforSalesCash (inUnitId := vbUnitId , inSession:= inSession)) AS GoodsVIP 
                      ON GoodsVIP.GoodsId = MovementItem.ObjectId 
      WHERE MovementItemContainer.MovementId =inMovementId
        AND MovementItemContainer.DescId = zc_MIContainer_Count()
      GROUP BY MovementItem.ObjectId;                  
    END IF;

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А   Шаблий О.В.
 02.07.19                                                                                     *
 13.10.15                                                                       *
*/

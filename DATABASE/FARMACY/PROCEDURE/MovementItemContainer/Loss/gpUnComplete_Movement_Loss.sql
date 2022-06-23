-- Function: gpUnComplete_Movement_Loss (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Loss (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbUnitiD    Integer;
  DECLARE vbArticleLossId Integer;
  DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- Разрешаем только сотрудникам с правами админа    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_UnComplete()))
    THEN
      vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Loss());
    END IF;

    -- проверка - если <Master> Удален, то <Ошибка>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

    -- Проверить, что бы не было переучета позже даты документа
    SELECT
        Movement.OperDate,
        Movement_Unit.ObjectId AS Unit,
        MovementLinkObject_ArticleLoss.ObjectId,
        Movement.StatusId
    INTO
        vbOperDate,
        vbUnitiD,
        vbArticleLossId,
        vbStatusId
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                     ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                    AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
    WHERE Movement.Id = inMovementId;

    /*IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnitiD
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
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущего возврата. Отмена проведения документа запрещена!';
    END IF;*/
    
     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
    --пересчитываем сумму документа по приходным ценам
    PERFORM lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete(inMovementId);    
    
    --Пересчет полного списания в зарплате
    IF COALESCE(vbArticleLossId, 0) = 13892113
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesFullCharge (vbUnitiD, vbOperDate, inSession); 
    END IF;

    --Использование фонда
    IF EXISTS(SELECT 1 FROM MovementFloat WHERE MovementFloat.MovementId = inMovementId
                                            AND MovementFloat.DescId = zc_MovementFloat_SummaFund())
    THEN
      PERFORM gpSelect_Calculation_Retail_FundUsed (inSession);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 02.07.19                                                                                     *
 21.07.15                                                                    *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_Loss (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
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

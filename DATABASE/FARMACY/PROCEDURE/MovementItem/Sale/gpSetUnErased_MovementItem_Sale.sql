-- Function: gpSetUnErased_MovementItem_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItem_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem_Sale(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsName  TVarChar;
   DECLARE vbAmount     TFloat;
   DECLARE vbSaldo      TFloat;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
  vbUserId:= lpGetUserBySession (inSession);

  -- устанавливаем новое значение
  outIsErased:= gpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- Востанавливаем проводки для отложенных
  IF COALESCE ((SELECT ValueData FROM MovementBoolean 
                WHERE MovementId = (SELECT MovementId FROM MovementItem WHERE ID = inMovementItemId)
                  AND DescId = zc_MovementBoolean_Deferred()), FALSE)= TRUE
  THEN

    --Проверка на то что бы не продали больше чем есть на остатке
    SELECT MI_Sale.GoodsName
         , COALESCE(MI_Sale.Amount,0)
         , COALESCE(SUM(Container.Amount),0) 
    INTO 
        vbGoodsName
      , vbAmount
      , vbSaldo 
    FROM MovementItem_Sale_View AS MI_Sale
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = MI_Sale.MovementId
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT OUTER JOIN Container ON MI_Sale.GoodsId = Container.ObjectId
                                 AND Container.WhereObjectId = MovementLinkObject_Unit.ObjectId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE MI_Sale.Id = inMovementItemId	
      AND MI_Sale.isErased = FALSE
    GROUP BY MI_Sale.GoodsId
           , MI_Sale.GoodsName
           , MI_Sale.Amount
    HAVING COALESCE (MI_Sale.Amount, 0) > COALESCE (SUM (Container.Amount) ,0);
  
    IF (COALESCE(vbGoodsName,'') <> '') 
    THEN
       RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во продажи <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;

    -- собственно проводки
    PERFORM lpComplete_Movement_Sale((SELECT MovementId FROM MovementItem WHERE ID = inMovementItemId), -- ключ Документа
                                     inMovementItemId,         -- ключ содержимое Документа
                                     vbUserId);    -- Пользователь       
  END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSetUnErased_MovementItem_Sale (inMovementItemId:= 0, inSession:= '2')

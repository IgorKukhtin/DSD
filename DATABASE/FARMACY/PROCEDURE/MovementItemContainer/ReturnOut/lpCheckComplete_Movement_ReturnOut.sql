-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpCheckComplete_Movement_ReturnOut (Integer);

CREATE OR REPLACE FUNCTION lpCheckComplete_Movement_ReturnOut(
    IN inMovementId        Integer              -- ключ Документа
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer;
  DECLARE vbNDSKindId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
  DECLARE vbUnitId Integer;
BEGIN

    vbUnitId := (SELECT Movement_ReturnOut_View.FromId FROM Movement_ReturnOut_View WHERE Movement_ReturnOut_View.Id = inMovementId);

    -- Проверяем все ли товары состыкованы. 
    IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
        RAISE EXCEPTION 'В документе прихода не все товары состыкованы';
    END IF;

    -- Проверяем у всех ли товаров совпадает НДС. 
    SELECT ObjectId INTO vbNDSKindId 
    FROM 
        MovementLinkObject AS MovementLinkObject_NDSKind
    WHERE 
        MovementLinkObject_NDSKind.MovementId = inMovementId
        AND 
        MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind();

    SELECT MIN(GoodsId) INTO vbGoodsId
    FROM 
        MovementItem_ReturnOut_View 
        JOIN Object_Goods_View ON MovementItem_ReturnOut_View.GoodsId = Object_Goods_View.Id
    WHERE 
        MovementId = inMovementId 
        AND 
        Object_Goods_View.NDSKindId <> vbNDSKindId;

   /* IF COALESCE(vbGoodsId, 0) <> 0 
    THEN 
        SELECT ValueData INTO vbGoodsName 
        FROM Object WHERE Id = vbGoodsId;
        RAISE EXCEPTION 'У "%" не совпадает тип НДС с документом', vbGoodsName;
    END IF;*/
    
    --Проверяем, достаточно ли остатка партии для возврата
/*    SELECT MIN(MovementItem_ReturnOut.ObjectId) INTO vbGoodsId
    FROM MovementItem AS MovementItem_ReturnOut
        LEFT OUTER JOIN MovementItem AS MovementItem_Income
                                     ON MovementItem_ReturnOut.ParentId = MovementItem_Income.Id
        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem_Income.Id
                                        AND MovementItemContainer.DescId = zc_MIContainer_Count()
        LEFT OUTER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                 AND Container.DescId = zc_Container_Count() 
    WHERE 
        MovementItem_ReturnOut.MovementId = inMovementId
        AND
        (
            MovementItem_ReturnOut.Amount > COALESCE(MovementItem_Income.Amount,0)
            or
            MovementItem_ReturnOut.Amount > COALESCE(Container.Amount,0)
        );
    IF COALESCE(vbGoodsId, 0) <> 0 
    THEN 
        SELECT ValueData INTO vbGoodsName 
        FROM Object WHERE Id = vbGoodsId;
        RAISE EXCEPTION 'По товару "%" Вы возвращаете больше чем есть на остатке по партии прихода', vbGoodsName;
    END IF;
*/

    --Проверка на то что бы не продали больше чем есть на остатке
    SELECT MI_ReturnOut.GoodsName
         , COALESCE(MI_ReturnOut.Amount,0)
         , COALESCE(SUM(Container.Amount),0)
    INTO
        vbGoodsName
      , vbAmount
      , vbSaldo
    FROM MovementItem_ReturnOut_View AS MI_ReturnOut
        LEFT OUTER JOIN Container ON MI_ReturnOut.GoodsId = Container.ObjectId
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE MI_ReturnOut.MovementId = inMovementId
      AND MI_ReturnOut.isErased = FALSE
    GROUP BY MI_ReturnOut.GoodsId
           , MI_ReturnOut.GoodsName
           , MI_ReturnOut.Amount
    HAVING COALESCE (MI_ReturnOut.Amount, 0) > COALESCE (SUM (Container.Amount) ,0);

    IF (COALESCE(vbGoodsName,'') <> '')
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во продажи <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.11.19                                                                     *
 26.01.15                         *
 26.12.14                         *

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
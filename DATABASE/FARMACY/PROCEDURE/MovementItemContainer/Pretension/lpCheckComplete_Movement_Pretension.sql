-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS lpCheckComplete_Movement_Pretension (Integer);

CREATE OR REPLACE FUNCTION lpCheckComplete_Movement_Pretension(
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

    vbUnitId := (SELECT Movement_Pretension_View.FromId FROM Movement_Pretension_View WHERE Movement_Pretension_View.Id = inMovementId);

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
        MovementItem_Pretension_View 
        JOIN Object_Goods_View ON MovementItem_Pretension_View.GoodsId = Object_Goods_View.Id
    WHERE 
        MovementId = inMovementId 
        AND 
        Object_Goods_View.NDSKindId <> vbNDSKindId;

    IF COALESCE(vbGoodsId, 0) <> 0 
    THEN 
        SELECT ValueData INTO vbGoodsName 
        FROM Object WHERE Id = vbGoodsId;
        RAISE EXCEPTION 'У "%" не совпадает тип НДС с документом', vbGoodsName;
    END IF;

    --Проверка на то что бы не продали больше чем есть на остатке
    SELECT MI_Pretension.GoodsName
         , COALESCE(MI_Pretension.Amount,0)
         , COALESCE(SUM(Container.Amount),0)
    INTO
        vbGoodsName
      , vbAmount
      , vbSaldo
    FROM MovementItem_Pretension_View AS MI_Pretension
        LEFT OUTER JOIN Container ON MI_Pretension.GoodsId = Container.ObjectId
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.DescId = zc_Container_Count()
                                 AND Container.Amount > 0
    WHERE MI_Pretension.MovementId = inMovementId
      AND MI_Pretension.isErased = FALSE
    GROUP BY MI_Pretension.GoodsId
           , MI_Pretension.GoodsName
           , MI_Pretension.Amount
    HAVING COALESCE (MI_Pretension.Amount, 0) > COALESCE (SUM (Container.Amount) ,0);

    IF (COALESCE(vbGoodsName,'') <> '')
    THEN
        RAISE EXCEPTION 'Ошибка. По одному <%> или более товарам кол-во продажи <%> больше, чем есть на остатке <%>.', vbGoodsName, vbAmount, vbSaldo;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.12.21                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

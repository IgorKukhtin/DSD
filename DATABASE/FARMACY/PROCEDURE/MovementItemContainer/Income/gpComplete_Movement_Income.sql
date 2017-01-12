-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbOperDate    TDateTime;
  DECLARE vbUnit        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
     vbUserId:= inSession;
     
     -- поиск <Торговой сети>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     -- !!!Проверка что б второй раз не провели накладную и проводки не задвоились!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;

     -- Проверили что установлены все связи
     PERFORM lpCheckComplete_Movement_Income (inMovementId);

    -- Проверить, что бы не было переучета позже даты документа
    SELECT
        Movement.OperDate,
        Movement_Unit.ObjectId AS Unit
    INTO
        vbOperDate,
        vbUnit
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
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
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущего прихода. Проведение документа запрещено!';
    END IF;*/


    -- Определить
    vbJuridicalId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From());


    -- Тут устанавливаем связь между товарами покупателей и главным товаром
    PERFORM gpInsertUpdate_Object_LinkGoods(0                                 -- ключ объекта <Условия договора>
                                          , DD.GoodsMainId
                                          , DD.PartnerGoodsId
                                          , inSession
                                            )
    FROM (WITH tmpMI AS (SELECT DISTINCT
                                MovementItem.ObjectId       AS GoodsId
                              , MILinkObject_Goods.ObjectId AS PartnerGoodsId
                         FROM MovementItem
                              INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                                               AND MILinkObject_Goods.ObjectId       > 0
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.IsErased   = FALSE
                        )
      , tmpGoodsMain AS (SELECT DISTINCT
                                tmpMI.GoodsId
                              , tmpMI.PartnerGoodsId
                              , ObjectLink_LinkGoods_GoodsMain.ChildObjectId  AS GoodsMainId
                         FROM tmpMI
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                    ON ObjectLink_LinkGoods_Goods.ChildObjectId = tmpMI.GoodsId
                                                   AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                    ON ObjectLink_LinkGoods_GoodsMain.ObjectId  = ObjectLink_LinkGoods_Goods.ObjectId
                                                   AND ObjectLink_LinkGoods_GoodsMain.DescId    = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                    ON ObjectLink_Goods_Object.ObjectId      = tmpMI.GoodsId
                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                        )
 , tmpGoodsJuridical AS (SELECT DISTINCT
                                tmpGoodsMain.GoodsId
                              , ObjectLink_LinkGoods_GoodsMain.ObjectId  AS Id
                         FROM tmpGoodsMain
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                                    ON ObjectLink_LinkGoods_GoodsMain.ChildObjectId  = tmpGoodsMain.GoodsMainId
                                                   AND ObjectLink_LinkGoods_GoodsMain.DescId         = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                                    ON ObjectLink_LinkGoods_Goods.ObjectId      = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                                   AND ObjectLink_LinkGoods_Goods.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                                   AND ObjectLink_LinkGoods_Goods.ChildObjectId = tmpGoodsMain.PartnerGoodsId
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                    ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_LinkGoods_Goods.ChildObjectId
                                                   AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                                   AND ObjectLink_Goods_Object.ChildObjectId = vbJuridicalId
                        )
         -- резульат
         SELECT DISTINCT tmpGoodsMain.GoodsMainId -- Главный товар
                       , tmpMI.PartnerGoodsId     -- товар из группы
         FROM tmpMI
              LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = tmpMI.GoodsId
              LEFT JOIN tmpGoodsJuridical ON tmpGoodsJuridical.GoodsId = tmpMI.GoodsId
           WHERE tmpGoodsJuridical.Id IS NULL
          ) AS DD;


      -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);


     -- собственно проводки
     PERFORM lpComplete_Movement_Income(inMovementId, -- ключ Документа
                                        vbUserId);    -- Пользователь                          

     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.15                         * 

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

-- Function: gpInsertUpdate_MovementItem_Inventory_Amount (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Amount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Amount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbInventoryDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId :=  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

    SELECT MovementLinkObject_Unit.ObjectId, OperDate INTO vbUnitID,vbInventoryDate
    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE (tmp.MovementItemId, 0)
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmp.GoodsId
                                                  , inAmount             := COALESCE(tmp.Amount_End,0)
                                                  , inPrice              := COALESCE(tmp.Price,0)
                                                  , inSumm               := COALESCE(tmp.Amount_End,0)*COALESCE(tmp.Price,0)::TFloat
                                                  , inComment            := NULL::TVarChar
                                                  , inUserId             := vbUserId
                                                   )
     FROM (SELECT tmpMI.MovementItemId                                   AS MovementItemId
                , COALESCE (tmpContainer.GoodsId, tmpMI.GoodsId)         AS GoodsId
                , COALESCE (tmpContainer.Amount_End,0)                   AS Amount_End
                , COALESCE (Object_Price.Price,0)                        AS Price
           FROM (SELECT tmpContainer.GoodsId
                      , SUM (tmpContainer.Amount_End)        AS Amount_End
                 FROM
                    (SELECT Container.Id                                                AS ContainerId
                          , Container.ObjectId                                          AS GoodsId
                          , Container.Amount  - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_End
                     FROM Container
                          INNER JOIN ContainerLinkObject AS CLO_Unit
                                                         ON CLO_Unit.ObjectId = vbUnitId
                                                        AND CLO_Unit.ContainerId = Container.Id
                                                        AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.ContainerId = Container.Id
                                                         AND MIContainer.OperDate > vbInventoryDate -- т.к. остаток на Дата + 1
                     WHERE Container.DescId = zc_Container_Count()
                     GROUP BY Container.Id
                            , Container.ObjectId
                            , Container.Amount
                     HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                    ) tmpContainer
                 GROUP BY tmpContainer.GoodsId
                 HAVING SUM (tmpContainer.Amount_End) <> 0
                ) tmpContainer
                                             
                FULL JOIN (SELECT MovementItem.Id                               AS MovementItemId
                                , MovementItem.ObjectId                         AS GoodsId
                           FROM MovementItem
                           WHERE MovementItem.MovementId =  inMovementId
                             AND MovementItem.isErased = FALSE
                          ) AS tmpMI ON tmpMI.GoodsId = tmpContainer.GoodsId
                LEFT OUTER JOIN (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                      , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                                 FROM ObjectLink AS ObjectLink_Price_Unit
                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                   AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId  
                                 ) AS Object_Price ON Object_Price.GoodsId  = COALESCE(tmpMI.GoodsId,tmpContainer.GoodsId)
                                                 
                                                              
           ) AS tmp;
   
        -- записываем чайлд
        PERFORM lpInsertUpdate_MI_Inventory_Child(inId                 := 0
                                                , inMovementId         := inMovementId
                                                , inParentId           := MovementItem.Id
                                                , inAmountUser         := MovementItem.Amount
                                                , inUserId             := vbUserId
                                                  )
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.isErased = FALSE;

       
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.06.17         * убрали Object_Price_View
 05.01.17         *
 26.04.15                                        * all
 24.04.15         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Amount

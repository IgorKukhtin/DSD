-- Function: gpInsert_MI_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsert_MI_SendPartionDate (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_SendPartionDate(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- 
    IN inOperDate            TDateTime , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + INTERVAL '6 MONTH';
    vbDate30  := CURRENT_DATE + INTERVAL '1 MONTH';

     -- снимаем удаление со всех строк
     UPDATE MovementItem
     SET isErased = FALSE
     WHERE MovementItem.MovementId = inMovementId
--       AND MovementItem.isErased = TRUE
;

    -- остатки по подразделению
    CREATE TEMP TABLE tmpRemains (ContainerId Integer, MovementId_Income Integer, GoodsId Integer, Amount TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO tmpRemains (ContainerId, MovementId_Income, GoodsId, Amount, ExpirationDate)
           SELECT tmp.ContainerId
                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                , tmp.GoodsId
                , SUM (tmp.Amount) AS Amount                                                                    -- остаток
                , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) ::TDateTime AS ExpirationDate        -- Срок годности
           FROM (SELECT Container.Id  AS ContainerId
                      , Container.ObjectId            AS GoodsId
                      , SUM(Container.Amount)::TFloat AS Amount
                 FROM Container
                 WHERE Container.DescId = zc_Container_Count()
                   AND Container.WhereObjectId = inUnitId
                   AND Container.Amount <> 0
                 GROUP BY Container.Id
                        , Container.ObjectId   
                 HAVING SUM(Container.Amount) <> 0
                 ) AS tmp
              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                            ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
              -- элемент прихода
              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                         
              LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
          -- WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
           GROUP BY tmp.ContainerId
                  , tmp.GoodsId
                  , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                  , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
           ;

    CREATE TEMP TABLE tmpMaster (Id Integer, GoodsId Integer, Amount TFloat, AmountRemains TFloat, Price TFloat, PriceExp TFloat) ON COMMIT DROP;
          INSERT INTO tmpMaster (Id, GoodsId, Amount, AmountRemains, Price, PriceExp)
    WITH
      MI_Master AS (SELECT MovementItem.Id                    AS Id
                         , MovementItem.ObjectId              AS GoodsId
                         , MIFloat_Price.ValueData            AS Price
                         , COALESCE (MIFloat_PriceExp.ValueData, MIFloat_Price.ValueData) AS PriceExp
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         LEFT JOIN MovementItemFloat AS MIFloat_PriceExp
                                                     ON MIFloat_PriceExp.MovementItemId = MovementItem.Id
                                                    AND MIFloat_PriceExp.DescId = zc_MIFloat_PriceExp()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      --AND MovementItem.IsErased = FALSE
                    )

    , tmpPrice AS (SELECT Price_Goods.ChildObjectId                AS GoodsId
                        , ROUND(Price_Value.ValueData, 2) ::TFloat AS Price
                   FROM ObjectLink AS ObjectLink_Price_Unit
                        LEFT JOIN ObjectFloat AS Price_Value
                                              ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                        LEFT JOIN ObjectLink AS Price_Goods
                                             ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                   WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit() 
                     AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                   )
    
    SELECT COALESCE(MI_Master.Id,0)                     AS Id
          , COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId) AS GoodsId
          , tmpRemains.Amount                            AS Amount
          , tmpRemains.AmountRemains          ::TFloat   AS AmountRemains
          , COALESCE(MI_Master.Price, tmpPrice.Price)    AS Price
          , COALESCE(MI_Master.PriceExp, tmpPrice.Price) AS PriceExp
    FROM (SELECT tmpRemains.GoodsId
               , SUM (tmpRemains.Amount) AS AmountRemains
               , SUM (CASE WHEN tmpRemains.ExpirationDate <= vbDate180 THEN tmpRemains.Amount ELSE 0 END) AS Amount
          FROM tmpRemains 
          GROUP BY tmpRemains.GoodsId
          HAVING SUM (CASE WHEN tmpRemains.ExpirationDate <= vbDate180 THEN tmpRemains.Amount ELSE 0 END) <> 0
          ) AS tmpRemains
        FULL OUTER JOIN MI_Master ON MI_Master.GoodsId = tmpRemains.GoodsId
        LEFT JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (MI_Master.GoodsId, tmpRemains.GoodsId);

    --- сохраняем MI_Master
    PERFORM lpInsertUpdate_MI_SendPartionDate_Master(ioId            := tmpMaster.Id
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := tmpMaster.GoodsId  
                                                   , inAmount        := COALESCE (tmpMaster.Amount,0)        :: TFloat     -- Количество
                                                   , inAmountRemains := COALESCE (tmpMaster.AmountRemains,0) :: TFloat     --
                                                   , inPrice         := COALESCE (tmpMaster.Price,0)         :: TFloat     -- цена (срок от 1 мес до 6 мес)
                                                   , inPriceExp      := COALESCE (tmpMaster.PriceExp,0)      :: TFloat     -- цена (срок меньше месяца)
                                                   , inUserId       := vbUserId)
    FROM tmpMaster; 
                                  
    
    -- теперь к мастеру сохраним чайлды
    -- выбираем сохр мастер
    CREATE TEMP TABLE tmpChild (Id Integer, ParentId Integer, GoodsId Integer, Amount TFloat, ContainerId Integer, MovementId_Income Integer, Expired TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO tmpChild (Id, ParentId, GoodsId, Amount, ContainerId, MovementId_Income, Expired, ExpirationDate)
    WITH
      MI_Master AS (SELECT MovementItem.Id       AS Id
                         , MovementItem.ObjectId AS GoodsId
                    FROM  MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.IsErased = FALSE
                    )   

    , MI_Child AS (SELECT MovementItem.Id                    AS Id
                        , MovementItem.ParentId              AS ParentId
                        , MovementItem.ObjectId              AS GoodsId
                        , MIFloat_ContainerId.ValueData      AS ContainerId
                   FROM  MovementItem
                        LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                    ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Child() 
                     AND MovementItem.isErased = FALSE
                    )

    --связвываем чайлд с мастером
    SELECT COALESCE (MI_Child.Id,0)                        AS Id
         , COALESCE (MI_Master.Id, MI_Child.ParentId, 0)      AS ParentId
         , COALESCE (MI_Child.GoodsId, tmpRemains.GoodsId) AS GoodsId
         , tmpRemains.Amount                               AS Amount
         , tmpRemains.ContainerId                 ::Integer
         , tmpRemains.MovementId_Income
         , CASE WHEN tmpRemains.ExpirationDate < inOperDate THEN 0
                WHEN tmpRemains.ExpirationDate <= vbDate30 THEN 1
                ELSE 2
           END                                    ::TFloat AS Expired
         , tmpRemains.ExpirationDate
    FROM (SELECT tmpRemains.*
          FROM tmpRemains 
          WHERE tmpRemains.ExpirationDate <= vbDate180
          ) AS tmpRemains
        FULL JOIN MI_Child ON MI_Child.GoodsId = tmpRemains.GoodsId
                          AND MI_Child.ContainerId = tmpRemains.ContainerId
        LEFT JOIN MI_Master ON MI_Master.GoodsId = COALESCE (MI_Child.GoodsId, tmpRemains.GoodsId);
    


    --- сохраняем MI_Child
    PERFORM lpInsertUpdate_MI_SendPartionDate_Child(ioId            := tmpChild.Id
                                                  , inParentId      := tmpChild.ParentId
                                                  , inMovementId    := inMovementId
                                                  , inGoodsId       := tmpChild.GoodsId  
                                                  , inExpirationDate:= tmpChild.ExpirationDate
                                                  , inAmount        := COALESCE (tmpChild.Amount,0)        :: TFloat
                                                  , inContainerId   := COALESCE (tmpChild.ContainerId,0)   :: TFloat
                                                  , inMovementId_Income  := COALESCE (tmpChild.MovementId_Income,0)   :: TFloat
                                                  , inExpired       := COALESCE (tmpChild.Expired,0)       :: TFloat
                                                  , inUserId        := vbUserId)
    FROM tmpChild
    WHERE COALESCE (tmpChild.Amount,0) <> 0;

     -- удаляем строки, которые нам не нужны
     UPDATE MovementItem 
     SET isErased = TRUE
     WHERE MovementItem.Id IN (SELECT tmpMaster.Id
                               FROM tmpMaster 
                               WHERE COALESCE (tmpMaster.AmountRemains, 0) = 0
                                 AND tmpMaster.Id <> 0);
     -- удаляем строки чайлд, которые нам не нужны
     UPDATE MovementItem 
     SET isErased = TRUE
     WHERE MovementItem.Id IN (SELECT tmpChild.Id
                               FROM tmpChild 
                               WHERE COALESCE (tmpChild.Amount, 0) = 0
                                 AND COALESCE (tmpChild.Id, 0) <> 0);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.19         *
*/
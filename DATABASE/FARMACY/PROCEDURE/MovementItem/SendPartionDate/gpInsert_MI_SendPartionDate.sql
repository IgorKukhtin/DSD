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
   DECLARE vbDate90   TDateTime;
   DECLARE vbDate30   TDateTime;
   DECLARE vbDate0    TDateTime;
   DECLARE vbOperDate TDateTime;

   DECLARE vbId_err            Integer;
   DECLARE vbAmount_master_err TFloat;
   DECLARE vbAmount_child_err  TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;
--    raise notice 'Unit ID: %', inUnitId;

    -- дата документа
    vbOperDate := (SELECT Movement.Operdate FROM Movement WHERE Movement.Id = inMovementId);

    -- получаем значения из справочника
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate180, vbDate90, vbDate30, vbDate0
    FROM lpSelect_PartionDateKind_SetDate ();


    -- !!!снимаем удаление со всех строк!!!
    UPDATE MovementItem SET isErased = FALSE WHERE MovementItem.MovementId = inMovementId;


    -- остатки по подразделению
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpRemains'))
     THEN
         DELETE FROM tmpRemains;
     ELSE
         CREATE TEMP TABLE tmpRemains (ContainerId Integer, MovementId_Income Integer, GoodsId Integer, Amount TFloat, ExpirationDate TDateTime, PriceWithVAT TFloat, ExpirationDateIncome TDateTime) ON COMMIT DROP;
     END IF;    
          INSERT INTO tmpRemains (ContainerId, MovementId_Income, GoodsId, Amount, ExpirationDate, PriceWithVAT, ExpirationDateIncome)
          WITH
          -- просрочка
          tmpContainer_PartionDate AS (SELECT DISTINCT Container.ParentId AS ContainerId
                                       FROM Container
                                       WHERE Container.DescId        = zc_Container_CountPartionDate()
                                         AND Container.WhereObjectId = inUnitId
                                         AND Container.Amount <> 0
                                      )
          -- Текущий остаток
        , tmpContainer_tek AS (SELECT Container.Id               
                                    , Container.ObjectId         
                                    , Container.Amount 
                               FROM Container

                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_NotTransferTime
                                                            ON ObjectBoolean_Goods_NotTransferTime.ObjectId =  Container.ObjectId 
                                                           AND ObjectBoolean_Goods_NotTransferTime.DescId = zc_ObjectBoolean_Goods_NotTransferTime()

                               WHERE Container.DescId        = zc_Container_Count()
                                 AND Container.WhereObjectId = inUnitId
                                 AND Container.Amount <> 0
                                 AND COALESCE (ObjectBoolean_Goods_NotTransferTime.ValueData, False) = False
                              )
          -- остатки на начало
        , tmpContainer_all AS (SELECT Container.Id                                             AS ContainerId
                                    , Container.ObjectId                                       AS GoodsId
                                    , Container.Amount - SUM (COALESCE (MIContainer.Amount,0)) AS Amount
                               FROM tmpContainer_tek as Container
                                    LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.ContainerId = Container.Id
                                                                         AND MIContainer.Operdate >= vbOperDate
                               GROUP BY Container.Id
                                      , Container.ObjectId
                                      , Container.Amount
                               HAVING (Container.Amount - SUM (COALESCE (MIContainer.Amount,0))) <> 0
                              )
          -- остатки - нашли Срок годности
        , tmpContainer_Date AS (SELECT tmp.ContainerId
                                  -- , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS MovementId_Income
                                     , MI_Income.MovementId                                       AS MovementId_Income
                                     , tmp.GoodsId
                                     , tmp.Amount
                                     , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())   AS ExpirationDate        --
                                     , COALESCE (MI_Income_find.Id,MI_Income.Id)                  AS MovementItemId_Income
                                     , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)  AS MovementItemMovementId_Income
                                FROM tmpContainer_all AS tmp
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
                                   LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                        -- AND 1=0

                                   LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                     ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                    AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                -- WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
                               )
          -- остатки - нашли Срок c перемещений
        , tmpContainer_In AS (SELECT tmp.ContainerId
                                     , tmp.MovementId_Income
                                     , tmp.GoodsId
                                     , tmp.Amount
                                     , tmp.ExpirationDate
                                     , tmp.MovementItemId_Income
                                     , tmp.MovementItemMovementId_Income
                                     , MIC_Send.DescId                          AS MIC_DescId
                                     , MIC_Send.MovementDescId                  AS MIC_MovementDescId
                                     , MIC_Send.MovementItemId                  AS MIC_MovementItemId
                                FROM tmpContainer_Date AS tmp
                                     INNER JOIN MovementItemContainer AS MIC_Send
                                                                      ON MIC_Send.ContainerId = tmp.ContainerId
                                                                     AND MIC_Send.Amount > 0
                               )
        , tmpContainer_Send AS (SELECT tmp.ContainerId
                                     , MAX(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))      AS ExpirationDateIn
                                FROM tmpContainer_In AS tmp
                                     INNER JOIN MovementItemContainer AS MIC_Send
                                                                      ON MIC_Send.MovementItemId = tmp.MIC_MovementItemId
                                                                     AND MIC_Send.DescId = zc_Container_CountPartionDate()
                                                                     AND MIC_Send.Amount < 0
                                     LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MIC_Send.ContainerId
                                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                          ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                         AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                WHERE tmp.MIC_DescId = zc_MIContainer_Count()
                                  AND tmp.MIC_MovementDescId = zc_Movement_Send()
                                GROUP BY tmp.ContainerId
                               )
          -- остатки - нашли Срок c перемещений
        , tmpContainer_term AS (SELECT tmp.ContainerId
                                     , tmp.MovementId_Income
                                     , tmp.GoodsId
                                     , tmp.Amount
                                     , tmp.ExpirationDate
                                     , tmp.MovementItemId_Income
                                     , tmp.MovementItemMovementId_Income
                                     , tmpContainer_Send.ExpirationDateIn
                                FROM tmpContainer_Date AS tmp
                                     LEFT JOIN tmpContainer_Send ON tmpContainer_Send.ContainerId = tmp.ContainerId
                               )
          -- остатки - все партии, если есть хоть один <= vbDate180 + отбросили tmpContainer_PartionDate
        , tmpContainer AS (SELECT tmpContainer_term.ContainerId
                                , tmpContainer_term.MovementId_Income
                                , tmpContainer_term.GoodsId
                                , tmpContainer_term.Amount
                                , COALESCE(tmpContainer_term.ExpirationDateIn, tmpContainer_term.ExpirationDate)  AS ExpirationDate
                                , ROUND(CASE WHEN MovementBoolean_PriceWithVAT.ValueData THEN MIFloat_Price.ValueData
                                       ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) END, 2)::TFloat  AS PriceWithVAT
                                , tmpContainer_term.ExpirationDate                                                AS ExpirationDateIncome
                           FROM (SELECT DISTINCT tmpContainer_term.GoodsId
                                 FROM tmpContainer_term
                                 -- !!!отбросили!!!
                                 LEFT JOIN tmpContainer_PartionDate ON tmpContainer_PartionDate.ContainerId = tmpContainer_term.ContainerId
                                 -- !!!ограничили!!!
                                 WHERE (tmpContainer_term.ExpirationDateIn <= vbDate180 OR tmpContainer_term.ExpirationDate <= vbDate180)
                                   AND tmpContainer_PartionDate.ContainerId IS NULL 
                                ) AS tmpContainer
                                LEFT JOIN tmpContainer_term        ON tmpContainer_term.GoodsId = tmpContainer.GoodsId
                                 -- !!!отбросили!!!
                                LEFT JOIN tmpContainer_PartionDate ON tmpContainer_PartionDate.ContainerId = tmpContainer_term.ContainerId
                                 -- закупочная цена
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = tmpContainer_term.MovementItemId_Income
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                          ON MovementBoolean_PriceWithVAT.MovementId = tmpContainer_term.MovementItemMovementId_Income
                                                         AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                             ON MovementLinkObject_NDSKind.MovementId = tmpContainer_term.MovementItemMovementId_Income
                                                            AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                           WHERE tmpContainer_PartionDate.ContainerId IS NULL
                          )
          SELECT tmpContainer.ContainerId
               , tmpContainer.MovementId_Income
               , tmpContainer.GoodsId
               , tmpContainer.Amount
               , tmpContainer.ExpirationDate
               , tmpContainer.PriceWithVAT
               , tmpContainer.ExpirationDateIncome
          FROM tmpContainer
         ;
         
    -- собрали мастер
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMaster'))
     THEN
         DELETE FROM tmpMaster;
     ELSE
         CREATE TEMP TABLE tmpMaster (Id Integer, GoodsId Integer, Amount TFloat, AmountRemains TFloat, ChangePercent TFloat, ChangePercentLess TFloat, ChangePercentMin TFloat, isErased Boolean) ON COMMIT DROP;
     END IF;    
     
    INSERT INTO tmpMaster (Id, GoodsId, Amount, AmountRemains, ChangePercent, ChangePercentLess, ChangePercentMin, isErased)
       WITH -- существующие
            MI_Master AS (SELECT MovementItem.Id                    AS Id
                               , MovementItem.ObjectId              AS GoodsId
                               , MIFloat_ChangePercent.ValueData    AS ChangePercent
                               , MIFloat_ChangePercentLess.ValueData AS ChangePercentLess
                               , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin
                          FROM MovementItem
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                           ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentLess
                                                           ON MIFloat_ChangePercentLess.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercentLess.DescId         = zc_MIFloat_ChangePercentLess()
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                           ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercentMin.DescId         = zc_MIFloat_ChangePercentMin()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                          )
           -- Результат
           SELECT COALESCE (MI_Master.Id, 0)                 AS Id
                 , tmpRemains.GoodsId                        AS GoodsId
                 , tmpRemains.Amount                         AS Amount
                 , tmpRemains.AmountRemains                  AS AmountRemains
                 , COALESCE (MI_Master.ChangePercent, 0)     AS ChangePercent
                 , COALESCE (MI_Master.ChangePercentLess, 0) AS ChangePercentLess
                 , COALESCE (MI_Master.ChangePercentMin, 0)  AS ChangePercentMin
                   -- удалим если лишний
                 , CASE WHEN tmpRemains.GoodsId > 0 THEN FALSE ELSE TRUE END AS isErased
           FROM (SELECT tmpRemains.GoodsId
                        -- все остатки
                      , SUM (tmpRemains.Amount) AS AmountRemains
                        -- только просрочка
                      , SUM (CASE WHEN tmpRemains.ExpirationDate <= vbDate180
                                   AND tmpRemains.ExpirationDate > zc_DateStart()
                                    OR tmpRemains.ExpirationDateIncome <= vbDate180
                                   AND tmpRemains.ExpirationDateIncome > zc_DateStart()
                                       THEN tmpRemains.Amount
                                  ELSE 0
                             END) AS Amount
                 FROM tmpRemains
                 GROUP BY tmpRemains.GoodsId
                ) AS tmpRemains
                FULL JOIN MI_Master ON MI_Master.GoodsId = tmpRemains.GoodsId
               ;

    --- сохраняем MI_Master
    PERFORM lpInsertUpdate_MI_SendPartionDate_Master(ioId            := tmpMaster.Id
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := tmpMaster.GoodsId
                                                   , inAmount        := COALESCE (tmpMaster.Amount,0)        :: TFloat     -- Количество
                                                   , inAmountRemains := COALESCE (tmpMaster.AmountRemains,0) :: TFloat     --
                                                   , inChangePercent    := COALESCE (tmpMaster.ChangePercent,0)         :: TFloat     -- % скидки(срок от 1 мес до 3 мес)
                                                   , inChangePercentLess:= COALESCE (tmpMaster.ChangePercentLess,0)     :: TFloat     -- % скидки(срок от 3 мес до 6 мес)
                                                   , inChangePercentMin := COALESCE (tmpMaster.ChangePercentMin,0)      :: TFloat     -- % скидки(срок меньше месяца)
                                                   , inUserId        := vbUserId)
    FROM tmpMaster
    WHERE tmpMaster.isErased = FALSE;


    -- удаляем строки MI_Master, которые нам не нужны
    UPDATE MovementItem SET isErased = TRUE
    WHERE MovementItem.Id IN (SELECT tmpMaster.Id FROM tmpMaster WHERE tmpMaster.isErased = TRUE);



    -- собрали чайлд
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpChild'))
     THEN
         DELETE FROM tmpChild;
     ELSE
         CREATE TEMP TABLE tmpChild (Id Integer, ParentId Integer, GoodsId Integer, Amount TFloat, ContainerId Integer, MovementId_Income Integer, ExpirationDate TDateTime, PriceWithVAT TFloat, ExpirationDateIncome TDateTime, isErased Boolean) ON COMMIT DROP;
     END IF;    
          INSERT INTO tmpChild (Id, ParentId, GoodsId, Amount, ContainerId, MovementId_Income, ExpirationDate, PriceWithVAT, ExpirationDateIncome, isErased)
       WITH -- существующие - Master
            MI_Master AS (SELECT MovementItem.Id       AS Id
                               , MovementItem.ObjectId AS GoodsId
                          FROM MovementItem
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
            -- существующие - Child
          , MI_Child AS (SELECT MovementItem.Id                       AS Id
                              , MovementItem.ObjectId                 AS GoodsId
                              , MIFloat_ContainerId.ValueData         AS ContainerId
                              , MIDate_ExpirationDate.ValueData       AS ExpirationDate
                              , MIFloat_PriceWithVAT.ValueData        AS PriceWithVAT
                              , MIDate_ExpirationDateIncome.ValueData AS ExpirationDateIncome
                              , MovementItem.Amount                   AS Amount
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                          ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = MovementItem.Id
                                                        AND MIDate_ExpirationDate.DescId         = zc_MIDate_ExpirationDate()
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                          ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                         AND MIFloat_PriceWithVAT.DescId         = zc_MIFloat_PriceWithVAT()
                              LEFT JOIN MovementItemDate AS MIDate_ExpirationDateIncome
                                                         ON MIDate_ExpirationDateIncome.MovementItemId = MovementItem.Id
                                                        AND MIDate_ExpirationDateIncome.DescId         = zc_MIDate_ExpirationDateIncome()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Child()
                           AND MovementItem.isErased   = FALSE
                        )

           -- Результат
           SELECT COALESCE (MI_Child.Id,0)                        AS Id
                , MI_Master.Id                                    AS ParentId
                , tmpRemains.GoodsId                              AS GoodsId
                  -- !!!сохранили то Кол-во, которое корректировали!!!
                , COALESCE (MI_Child.Amount, tmpRemains.Amount)   AS Amount
                , tmpRemains.ContainerId
                , tmpRemains.MovementId_Income
                  -- сохранили тот Срок годности, который корректировали
                , COALESCE (MI_Child.ExpirationDate, tmpRemains.ExpirationDate) AS ExpirationDate
                , tmpRemains.PriceWithVAT                         AS PriceWithVAT
                , COALESCE (MI_Child.ExpirationDateIncome, tmpRemains.ExpirationDateIncome) AS ExpirationDateIncome
                  -- удалим если лишний
                , CASE WHEN tmpRemains.GoodsId > 0 THEN FALSE ELSE TRUE END AS isErased
           FROM tmpRemains
                LEFT JOIN MI_Master ON MI_Master.GoodsId   = tmpRemains.GoodsId
                FULL JOIN MI_Child ON MI_Child.GoodsId     = tmpRemains.GoodsId
                                  AND MI_Child.ContainerId = tmpRemains.ContainerId
          ;


    --- сохраняем MI_Child
    PERFORM lpInsertUpdate_MI_SendPartionDate_Child(ioId                    := tmpChild.Id
                                                  , inParentId              := tmpChild.ParentId
                                                  , inMovementId            := inMovementId
                                                  , inGoodsId               := tmpChild.GoodsId
                                                  , inExpirationDate        := tmpChild.ExpirationDate
                                                  , inExpirationDateIncome  := tmpChild.ExpirationDateIncome
                                                  , inPriceWithVAT          := COALESCE (tmpChild.PriceWithVAT, 0)
                                                  , inAmount                := COALESCE (tmpChild.Amount,0)        :: TFloat
                                                  , inContainerId           := COALESCE (tmpChild.ContainerId,0)   :: TFloat
                                                  , inMovementId_Income     := COALESCE (tmpChild.MovementId_Income,0):: TFloat
                                                  , inUserId                := vbUserId)
    FROM tmpChild
    WHERE tmpChild.isErased = FALSE;

    -- удаляем строки MI_Child, которые нам не нужны
    UPDATE MovementItem SET isErased = TRUE
    WHERE MovementItem.Id IN (SELECT tmpChild.Id FROM tmpChild WHERE tmpChild.isErased = TRUE);


    -- проверка - Остатки Мастер и Чайлд должны совпадать, если нет - то корректировали не правильно или задним числом съехал остаток
    SELECT tmp.Id, tmp.Amount_master, tmp.Amount_child
           INTO vbId_err, vbAmount_master_err, vbAmount_child_err
    FROM (WITH -- существующие - Master
               MI_Master AS (SELECT MovementItem.Id
                                  , COALESCE (MIFloat_AmountRemains.ValueData, 0) AS Amount
                             FROM MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                              ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountRemains.DescId         = zc_MIFloat_AmountRemains()
                             WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                            )
               -- существующие - Child
             , MI_Child AS (SELECT MovementItem.ParentId     AS ParentId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM MovementItem
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Child()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ParentId
                           )
          SELECT COALESCE (MI_Child.ParentId, MI_Master.Id) AS Id
               , COALESCE (MI_Master.Amount, 0)             AS Amount_master
               , COALESCE (MI_Child.Amount, 0)              AS Amount_child
          FROM MI_Master
               FULL JOIN MI_Child ON MI_Child.ParentId = MI_Master.Id
          WHERE COALESCE (MI_Master.Amount, 0) <>  COALESCE (MI_Child.Amount, 0)
         ) AS tmp;


   IF vbId_err > 0
   THEN
       RAISE EXCEPTION 'Для товара <%> расчетный остаток = <%> не соответствует по партиям = <%>.'
                      , lfGet_Object_ValueData ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = vbId_err))
                      , zfConvert_FloatToString (vbAmount_master_err)
                      , zfConvert_FloatToString (vbAmount_child_err)
                      ;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 10.09.20                                                      *
 06.07.20                                                      *
 18.09.19                                                      * 
 15.07.19                                                      * 
 07.07.19                                                      *
 21.06.19                                                      *
 27.05.19         *
 05.04.19         *
*/

-- select * from gpInsert_MI_SendPartionDate(inMovementId := 20202202 , inUnitId := 3457773 , inOperDate := ('10.09.2020')::TDateTime ,  inSession := '3');

-- select * from gpInsert_MI_SendPartionDate(inMovementId := 22700177 , inUnitId := 13311246 , inOperDate := ('27.03.2021')::TDateTime ,  inSession := '3');
-- Function: gpInsertUpdate_MI_SendPartionDate_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SendPartionDate_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountRemains       TFloat    , --
    IN inPrice               TFloat    , -- цена (срок от 1 мес до 6 мес)
    IN inPriceExp            TFloat    , -- цена (срок меньше месяца)
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;

    -- переопределяем
    IF COALESCE (inAmount,0) > COALESCE (inAmountRemains,0)
    THEN
        inAmount = inAmountRemains;
    END IF;

    --
    vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                 FROM MovementLinkObject AS MovementLinkObject_Unit
                 WHERE MovementLinkObject_Unit.MovementId = inMovementId
                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                );
    vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + INTERVAL '6 MONTH';
    vbDate30  := CURRENT_DATE + INTERVAL '1 MONTH';

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
    
    -- сохранили <цену>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceExp(), ioId, inPriceExp);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, inAmountRemains);

    -- и сразу формируем строки чайлд
    --по товару выбираем партии
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
                 WHERE Container.DescId        = zc_Container_Count()
                   AND Container.ObjectId      = inGoodsId
                   AND Container.WhereObjectId = vbUnitId
                   AND Container.Amount        <> 0
                 GROUP BY Container.Id
                        , Container.ObjectId   
                 HAVING SUM(Container.Amount) <> 0
                 ) AS tmp
              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                            ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
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
           --WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
           GROUP BY tmp.ContainerId
                  , tmp.GoodsId
                  , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                  , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId);

    CREATE TEMP TABLE tmpChild (Id Integer, ContainerId Integer, MovementId_Income Integer, Amount TFloat, Expired TFloat, ExpirationDate TDateTime) ON COMMIT DROP;
          INSERT INTO tmpChild (Id, ContainerId, MovementId_Income, Amount, Expired, ExpirationDate)
    WITH
      MI_Child AS (SELECT MovementItem.Id                    AS Id
                        , MovementItem.ParentId              AS ParentId
                        , MovementItem.ObjectId              AS GoodsId
                        , MIFloat_ContainerId.ValueData      AS ContainerId
                        
                   FROM MovementItem
                        LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                    ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                        LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                    ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                   AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.ParentId = ioId
                     AND MovementItem.DescId = zc_MI_Child() 
                    --AND MovementItem.isErased = FALSE
                    )
                    
    , tmpOrd AS (SELECT inAmount                 AS AmountMaster
                      , tmpRemains.GoodsId
                      , tmpRemains.ExpirationDate
                      , tmpRemains.Amount        AS RemainsAmount
                      , tmpRemains.ContainerId
                      --, tmpRemains.MovementItemId_partion
                      , SUM (tmpRemains.Amount) OVER (PARTITION BY tmpRemains.GoodsId ORDER BY tmpRemains.ExpirationDate, tmpRemains.ContainerId) AS RemainsAmountSUM
                      , ROW_NUMBER() OVER (ORDER BY tmpRemains.ExpirationDate DESC, tmpRemains.ContainerId DESC) AS DOrd
                 FROM tmpRemains
                )
    -- расчет
    , tmpCalc AS(SELECT DD.*
                      , CASE WHEN DD.AmountMaster - DD.RemainsAmountSUM > 0 AND DD.DOrd <> 1
                                  THEN DD.RemainsAmount
                             ELSE DD.AmountMaster - DD.RemainsAmountSUM + DD.RemainsAmount
                        END AS Amount_Calc
                 FROM (SELECT * FROM tmpOrd) AS DD
                 WHERE DD.AmountMaster - (DD.RemainsAmountSUM - DD.RemainsAmount) > 0
                )
     SELECT COALESCE (MI_Child.Id,0)          AS Id
          , tmpCalc.ContainerId
          , tmpRemains.MovementId_Income
          , tmpCalc.Amount_Calc               AS Amount
          , CASE WHEN tmpCalc.ExpirationDate < vbOperDate THEN 0
                 WHEN tmpCalc.ExpirationDate <= vbDate30 THEN 1
                 WHEN tmpCalc.ExpirationDate <= vbDate180 THEN 2
                 ELSE 999
            END                      ::TFloat AS Expired
          , tmpCalc.ExpirationDate
     FROM tmpRemains 
          FULL JOIN tmpCalc ON tmpCalc.GoodsId     = tmpRemains.GoodsId
                           AND tmpCalc.ContainerId = tmpRemains.ContainerId
          LEFT JOIN MI_Child ON MI_Child.GoodsId    = tmpRemains.GoodsId
                           AND MI_Child.ContainerId = tmpRemains.ContainerId;

     -- снимаем удаление со строк чайлд, которые нам нужны
     UPDATE MovementItem 
     SET isErased = FALSE
     WHERE MovementItem.Id IN (SELECT tmpChild.Id
                               FROM tmpChild 
                               WHERE COALESCE (tmpChild.Amount, 0) <> 0
                                 AND COALESCE (tmpChild.Id, 0) <> 0);

     -- удаляем строки чайлд, которые нам не нужны
     UPDATE MovementItem 
     SET isErased = TRUE
     WHERE MovementItem.Id IN (SELECT tmpChild.Id
                               FROM tmpChild 
                               WHERE COALESCE (tmpChild.Amount, 0) = 0
                                 AND COALESCE (tmpChild.Id, 0) <> 0);
     
     -- сохраняем нужные строки
     PERFORM lpInsertUpdate_MI_SendPartionDate_Child(ioId            := tmpChild.Id
                                                   , inParentId      := ioId
                                                   , inMovementId    := inMovementId
                                                   , inGoodsId       := inGoodsId  
                                                   , inExpirationDate:= tmpChild.ExpirationDate
                                                   , inAmount        := tmpChild.Amount        :: TFloat
                                                   , inContainerId   := tmpChild.ContainerId   :: TFloat
                                                   , inMovementId_Income  := COALESCE (tmpChild.MovementId_Income,0) :: TFloat
                                                   , inExpired       := tmpChild.Expired       :: TFloat
                                                   , inUserId        := vbUserId)
     FROM tmpChild
     WHERE COALESCE (tmpChild.Amount, 0) <> 0;

    -- пересчитали Итоговые суммы по накладной
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.19         *
*/
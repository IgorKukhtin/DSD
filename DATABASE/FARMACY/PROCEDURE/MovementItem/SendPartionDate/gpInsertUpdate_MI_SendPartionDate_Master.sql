-- Function: gpInsertUpdate_MI_SendPartionDate_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SendPartionDate_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountRemains       TFloat    , --
    IN inChangePercent       TFloat    , -- % (срок от 3 мес до 6 мес)
    IN inChangePercentLess   TFloat    , -- % (срок от 1 мес до 3 мес)
    IN inChangePercentMin    TFloat    , -- % (срок меньше месяца)
    IN inContainerId         Integer   , -- Контейнер для изменения срока
    IN inExpirationDate      TDateTime , -- Срок годности перемещеемого товара
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
   DECLARE vbDate90   TDateTime;
   DECLARE vbDate30   TDateTime;
   DECLARE vbDate0    TDateTime;
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

    -- получаем значения из справочника
    -- получаем значения из справочника
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate180, vbDate90, vbDate30, vbDate0
    FROM lpSelect_PartionDateKind_SetDate ();

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- сохранили <цену>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentLess(), ioId, inChangePercentLess);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentMin(), ioId, inChangePercentMin);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, inAmountRemains);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);

    -- и сразу формируем строки чайлд
    --по товару выбираем партии
    -- остатки по подразделению
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpRemains'))
    THEN
      DELETE FROM tmpRemains;
    ELSE
      CREATE TEMP TABLE tmpRemains (ContainerId Integer, MovementId_Income Integer, GoodsId Integer, Amount TFloat, ExpirationDate TDateTime, ExpirationDateIncome TDateTime, PriceWithVAT TFloat) ON COMMIT DROP;
    END IF;
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpChild'))
    THEN
      DELETE FROM tmpChild;    
    ELSE
      CREATE TEMP TABLE tmpChild (Id Integer, ContainerId Integer, MovementId_Income Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, ExpirationDateIncome TDateTime, PriceWithVAT TFloat) ON COMMIT DROP;
    END IF;

    IF COALESCE (inContainerId, 0) = 0
    THEN
      INSERT INTO tmpRemains (ContainerId, MovementId_Income, GoodsId, Amount, ExpirationDate, ExpirationDateIncome, PriceWithVAT)
           SELECT tmp.ContainerId
                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                , tmp.GoodsId
                , SUM (tmp.Amount) AS Amount                                                                    -- остаток
                , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) ::TDateTime AS ExpirationDate        -- Срок годности
                , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) ::TDateTime AS ExpirationDate        -- Срок годности
                , ROUND(CASE WHEN MovementBoolean_PriceWithVAT.ValueData THEN MIFloat_Price.ValueData
                  ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) END, 2)::TFloat  AS PriceWithVAT
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
               -- закупочная цена
              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                        ON MovementBoolean_PriceWithVAT.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                           ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                          AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                    ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                   AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
           --WHERE COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180
           GROUP BY tmp.ContainerId
                  , tmp.GoodsId
                  , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())
                  , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                  , ROUND(CASE WHEN MovementBoolean_PriceWithVAT.ValueData THEN MIFloat_Price.ValueData
                    ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) END, 2);
    ELSE
      INSERT INTO tmpRemains (ContainerId, MovementId_Income, GoodsId, Amount, ExpirationDate, ExpirationDateIncome, PriceWithVAT)
           SELECT tmp.ContainerId
                , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                , tmp.GoodsId
                , tmp.Amount                                                                                    -- остаток
                , COALESCE (inExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()) ::TDateTime AS ExpirationDate        -- Срок годности
                , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) ::TDateTime AS ExpirationDateIncome        -- Срок годности
                , ROUND(CASE WHEN MovementBoolean_PriceWithVAT.ValueData THEN MIFloat_Price.ValueData
                  ELSE (MIFloat_Price.ValueData * (1 + ObjectFloat_NDSKind_NDS.ValueData / 100)) END, 2)::TFloat  AS PriceWithVAT
           FROM (SELECT Container.Id  AS ContainerId
                      , Container.ObjectId            AS GoodsId
                      , Container.Amount              AS Amount
                 FROM Container
                 WHERE Container.DescId        = zc_Container_Count()
                   AND Container.Id            = CASE WHEN EXISTS(SELECT Container.ParentId FROM Container 
                                                                  WHERE Container.DescId = zc_Container_CountPartionDate() AND Container.ID = inContainerId)
                                                 THEN (SELECT Container.ParentId FROM Container WHERE Container.ID = inContainerId) ELSE inContainerId END
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
               -- закупочная цена
              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                        ON MovementBoolean_PriceWithVAT.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                           ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                          AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                    ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                   AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS();
    END IF;
    
    
    INSERT INTO tmpChild (Id, ContainerId, MovementId_Income, Amount, PartionDateKindId, ExpirationDate, ExpirationDateIncome, PriceWithVAT)
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
                      , tmpRemains.ExpirationDateIncome
                      , tmpRemains.PriceWithVAT
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
          , CASE WHEN tmpCalc.ExpirationDate <= vbDate0   THEN zc_Enum_PartionDateKind_0()
                 WHEN tmpCalc.ExpirationDate <= vbDate30  THEN zc_Enum_PartionDateKind_1()
                 WHEN tmpCalc.ExpirationDate <= vbDate90  THEN zc_Enum_PartionDateKind_3()
                 WHEN tmpCalc.ExpirationDate <= vbDate180 THEN zc_Enum_PartionDateKind_6()
                 ELSE 0
            END                       AS PartionDateKindId
          , tmpCalc.ExpirationDate
          , tmpCalc.ExpirationDateIncome
          , tmpCalc.PriceWithVAT

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
     PERFORM lpInsertUpdate_MI_SendPartionDate_Child(ioId                    := tmpChild.Id
                                                   , inParentId              := ioId
                                                   , inMovementId            := inMovementId
                                                   , inGoodsId               := inGoodsId
                                                   --, inPartionDateKindId     := tmpChild.PartionDateKindId
                                                   , inExpirationDate        := tmpChild.ExpirationDate
                                                   , inExpirationDateIncome  := tmpChild.ExpirationDate
                                                   , inPriceWithVAT          := tmpChild.PriceWithVAT
                                                   , inAmount                := tmpChild.Amount        :: TFloat
                                                   , inContainerId           := tmpChild.ContainerId   :: TFloat
                                                   , inMovementId_Income     := COALESCE (tmpChild.MovementId_Income,0) :: TFloat
                                                   --, inExpired              := tmpChild.Expired       :: TFloat
                                                   , inUserId                := vbUserId)
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.20                                                       *
 15.07.19                                                       * 
 26.06.19                                                       *
 18.06.19                                                       *
 27.05.19         *
 03.04.19         *
*/
-- Function: gpSelect_CashRemains_Diff_ver2()

 DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff_ver2 (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Diff_ver2(
    IN inCashSessionId TVarChar,   -- Сессия кассового места
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    Id Integer,
    GoodsCode Integer,
    GoodsName TVarChar,
    Price TFloat,
    Remains TFloat,
    MCSValue TFloat,
    Reserved TFloat,
    MinExpirationDate TDateTime,
    PartionDateKindId  Integer,
    PartionDateKindName  TVarChar,
    NewRow Boolean,
    AccommodationId Integer,
    AccommodationName TVarChar,
    AmountMonth TFloat,
    PricePartionDate TFloat,
    Color_calc Integer
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbOperDate_StartBegin TDateTime;
   DECLARE vb1 TVarChar;

   DECLARE vbMonth_0  TFloat;
   DECLARE vbMonth_1  TFloat;
   DECLARE vbMonth_6  TFloat;

   DECLARE vbDay_0  Integer;
   DECLARE vbDay_1  Integer;
   DECLARE vbDay_6  Integer;

   DECLARE vbDate0 TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;

   DECLARE vbDividePartionDate   boolean;
BEGIN
-- if inSession = '3' then return; end if;


    -- !!!Протокол - отладка Скорости!!!
    vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    -- получаем значения из справочника для разделения по срокам
/*    vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbMonth_1 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                  FROM Object  AS Object_PartionDateKind
                       LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                             ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                            AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                  WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbMonth_1||' MONTH' ) ::INTERVAL;
    vbDate0   := CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL; */

    vbDay_0 := (SELECT COALESCE(ObjectFloat_Day.ValueData, 0)::Integer
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                           ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbDay_1 := (SELECT ObjectFloat_Day.ValueData::Integer
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                           ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbDay_6 := (SELECT ObjectFloat_Day.ValueData::Integer
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                           ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + (vbDay_6||' DAY' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbDay_1||' DAY' ) ::INTERVAL;
    vbDate0   := CURRENT_DATE + (vbDay_0||' DAY' ) ::INTERVAL;


    IF EXISTS(SELECT 1 FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
              WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
                AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate())
    THEN

      SELECT COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)
      INTO vbDividePartionDate
      FROM ObjectBoolean AS ObjectBoolean_DividePartionDate
      WHERE ObjectBoolean_DividePartionDate.ObjectId = vbUnitId
        AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate();

    ELSE
      vbDividePartionDate := False;
    END IF;

    -- Обновили дату последнего обращения по сессии
    PERFORM lpInsertUpdate_CashSession (inCashSessionId := inCashSessionId
                                      , inDateConnect   := CURRENT_TIMESTAMP :: TDateTime
                                      , inUserId        := vbUserId
                                       );

    --определяем разницу в остатках реальных и сессионных
    CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MinExpirationDate TDateTime
                           , PartionDateKindId  Integer
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean
                           , AccommodationId Integer
                           , PartionDateDiscount TFloat
                           , PriceWithVAT TFloat
                           , Color_calc Integer) ON COMMIT DROP;

    -- Данные
    WITH tmpMovContainerId AS (SELECT Movement.Id
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                 AND MovementLinkObject_Unit.ObjectId = vbUnitId
                               WHERE Movement.DescId = zc_Movement_Check()
                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                               )
       , ReserveContainer AS (SELECT MIFloat_ContainerId.ValueData::Integer      AS ContainerId
                                   , Sum(MovementItemChild.Amount)::TFloat       AS Amount
                              FROM tmpMovContainerId
                                   INNER JOIN MovementItem AS MovementItemMaster
                                                           ON MovementItemMaster.MovementId = tmpMovContainerId.Id
                                                          AND MovementItemMaster.DescId     = zc_MI_Master()
                                                          AND MovementItemMaster.isErased   = FALSE

                                   INNER JOIN MovementItem AS MovementItemChild
                                                           ON MovementItemChild.MovementId = tmpMovContainerId.Id
                                                          AND MovementItemChild.ParentId = MovementItemMaster.Id
                                                          AND MovementItemChild.DescId     = zc_MI_Child()
                                                          AND MovementItemChild.Amount     > 0
                                                          AND MovementItemChild.isErased   = FALSE

                                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                               ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                              GROUP BY MIFloat_ContainerId.ValueData
                              )
          -- Резервы
        , tmpMov AS (
            SELECT Movement.Id
            FROM MovementBoolean AS MovementBoolean_Deferred
                      INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                         AND Movement.DescId = zc_Movement_Check()
                                         AND Movement.StatusId = zc_Enum_Status_UnComplete()
                      INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                   AND MovementLinkObject_Unit.ObjectId = vbUnitId
                    WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                      AND MovementBoolean_Deferred.ValueData = TRUE
                   UNION ALL
                    SELECT Movement.Id
                    FROM MovementString AS MovementString_CommentError
                      INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                         AND Movement.DescId = zc_Movement_Check()
                                         AND Movement.StatusId = zc_Enum_Status_UnComplete()
                      INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                   AND MovementLinkObject_Unit.ObjectId = vbUnitId
                   WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                     AND MovementString_CommentError.ValueData <> ''
           )
          -- Остатки по срокам
       , tmpPDContainerAll AS (SELECT Container.Id,
                                     Container.ObjectId,
                                     Container.ParentId,
                                     Container.Amount,
                                     ContainerLinkObject.ObjectId                       AS PartionGoodsId,
                                     ReserveContainer.Amount                            AS Reserve
                              FROM Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                  LEFT OUTER JOIN ReserveContainer ON ReserveContainer.ContainerID = Container.Id

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.WhereObjectId = vbUnitId
                              AND (Container.Amount <> 0 OR COALESCE(ReserveContainer.Amount, 0) <> 0)
                              AND vbDividePartionDate = True)
       , tmpPDContainer AS (SELECT Container.Id,
                                   Container.ObjectId,
                                   Container.Amount,
                                   COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate,
                                   COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin,
                                   COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent,
                                   COALESCE (ObjectFloat_PartionGoods_PriceWithVAT.ValueData, 0) AS PriceWithVAT,
                                   CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0 AND 
                                             COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE 
                                                                                              THEN zc_Enum_PartionDateKind_Cat_5() -- 5 кат (просрочка без наценки)
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0   THEN zc_Enum_PartionDateKind_0()     -- просрочено
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate30  THEN zc_Enum_PartionDateKind_1()     -- Меньше 1 месяца
                                        WHEN ObjectDate_ExpirationDate.ValueData <= vbDate180 THEN zc_Enum_PartionDateKind_6()     -- Меньше 6 месяца
                                        ELSE zc_Enum_PartionDateKind_Good() END                  AS PartionDateKindId,             -- Востановлен с просрочки

                                   Container.Reserve                                             AS Reserve
                            FROM tmpPDContainerAll AS Container

                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.ID = Container.PartionGoodsId

                                 LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                       ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                        ON ObjectFloat_PartionGoods_Value.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()

                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                                                        ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  Container.PartionGoodsId
                                                      AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()

                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                         ON ObjectBoolean_PartionGoods_Cat_5.ObjectId =  Container.PartionGoodsId
                                                        AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5() 
                                  )
       , tmpCashGoodsPriceWithVAT AS (SELECT * FROM gpSelect_CashGoodsPriceWithVAT('3'))
       , tmpPDPriceWithVAT AS (SELECT ROW_NUMBER()OVER(PARTITION BY Container.ObjectId, Container.PartionDateKindId ORDER BY Container.Id DESC) as ORD
                                    , Container.ObjectId
                                    , Container.PartionDateKindId
                                    , CASE WHEN Container.PriceWithVAT <= 15 
                                           THEN COALESCE (tmpCashGoodsPriceWithVAT.PriceWithVAT, Container.PriceWithVAT)
                                           ELSE Container.PriceWithVAT END       AS PriceWithVAT
                               FROM tmpPDContainer AS Container
                                    LEFT JOIN tmpCashGoodsPriceWithVAT ON tmpCashGoodsPriceWithVAT.ID = Container.ObjectId
                               WHERE COALESCE (Container.PriceWithVAT , 0) <> 0
                               )
       , tmpPDGoodsRemains AS (SELECT Container.ObjectId
                                    , Container.PartionDateKindId                                       AS PartionDateKindId
                                    , SUM (Container.Amount)                                            AS Remains
                                    , SUM (Container.Reserve)                                           AS Reserve
                                    , MIN (Container.ExpirationDate)::TDateTime                         AS MinExpirationDate
                                    , MAX (tmpPDPriceWithVAT.PriceWithVAT)                              AS PriceWithVAT

                                    , MIN (CASE WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_Good()
                                                THEN 0
                                                WHEN Container.PartionDateKindId in (zc_Enum_PartionDateKind_6(), zc_Enum_PartionDateKind_Cat_5())
                                                THEN Container.Percent
                                                ELSE Container.PercentMin END)::TFloat                  AS PartionDateDiscount
                               FROM tmpPDContainer AS Container

                                    LEFT JOIN tmpPDPriceWithVAT ON tmpPDPriceWithVAT.ObjectId = Container.ObjectId
                                                               AND tmpPDPriceWithVAT.PartionDateKindId = Container.PartionDateKindId
                                                               AND tmpPDPriceWithVAT.Ord = 1

                               GROUP BY Container.ObjectId
                                      , Container.PartionDateKindId
                               )
       , tmpPDGoodsRemainsAll AS (SELECT tmpPDGoodsRemains.ObjectId
                                       , SUM (tmpPDGoodsRemains.Remains)                                                         AS Remains
                                       , SUM (tmpPDGoodsRemains.Reserve)                                                         AS Reserve
                                  FROM tmpPDGoodsRemains
                                  GROUP BY tmpPDGoodsRemains.ObjectId
                                 )
          -- Остатки по основным контейнерам
       , tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpExpirationDate AS (SELECT tmp.Id       AS ContainerId
                                    , MIDate_ExpirationDate.ValueData
                               FROM tmpContainer AS tmp
                                  LEFT JOIN  tmpPDContainerAll on tmpPDContainerAll.ParentId = tmp.Id
                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                ON ContainerLinkObject_MovementItem.Containerid = tmp.Id
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
                               WHERE COALESCE (tmpPDContainerAll.ParentId, 0) = 0
                               )
       , tmpGoodsRemains AS (SELECT Container.ObjectId
                                  , SUM (Container.Amount) AS Remains
                                  , MIN (COALESCE (tmpExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- Срок годности
                             FROM tmpContainer AS Container
                                  -- находим партию
                                  LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
                                GROUP BY Container.ObjectId
                             )

      , Reserve
        AS
        (
            SELECT MovementItem.ObjectId                       AS GoodsId
                 , Sum(MovementItem.Amount)::TFloat            AS Amount
            FROM tmpMov
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                                                AND MovementItem.Amount    <> 0

            GROUP BY MovementItem.ObjectId
         )
          -- Непосредственно остатки
       , GoodsRemains AS (SELECT Container.ObjectId
                               , Container.Remains - COALESCE(tmpPDGoodsRemainsAll.Remains, 0)                   AS Remains
                               , COALESCE(Reserve.Amount, 0) - COALESCE(tmpPDGoodsRemainsAll.Reserve, 0)::TFloat AS Reserve
                               , Container.MinExpirationDate
                               , NULL                                                                            AS PartionDateKindId
                               , NULL                                                                            AS PartionDateDiscount
                               , NULL                                                                            AS PriceWithVAT
                          FROM tmpGoodsRemains AS Container
                               LEFT JOIN tmpPDGoodsRemainsAll ON tmpPDGoodsRemainsAll.ObjectId = Container.ObjectId
                               LEFT JOIN Reserve ON Reserve.GoodsId = Container.ObjectId
                          UNION ALL
                          SELECT tmpPDGoodsRemains.ObjectId
                               , tmpPDGoodsRemains.Remains
                               , tmpPDGoodsRemains.Reserve
                               , tmpPDGoodsRemains.MinExpirationDate
                               , tmpPDGoodsRemains.PartionDateKindId
                               , NULLIF (tmpPDGoodsRemains.PartionDateDiscount, 0)
                               , tmpPDGoodsRemains.PriceWithVAT
                          FROM tmpPDGoodsRemains
                          UNION ALL
                          SELECT Reserve.GoodsId                                                       AS GoodsId
                               , 0::TFloat                                                             AS Remains
                               , (Reserve.Amount - COALESCE(tmpPDGoodsRemainsAll.Reserve, 0))::TFloat  AS Reserved
                               , Null::TDateTime                                                       AS MinExpirationDate
                               , NULL                                                                  AS PartionDateKindId
                               , NULL                                                                  AS PartionDateDiscount
                               , NULL                                                                  AS PriceWithVAT
                          FROM Reserve
                             LEFT OUTER JOIN tmpGoodsRemains ON Reserve.GoodsId = tmpGoodsRemains.ObjectId
                             LEFT OUTER JOIN tmpPDGoodsRemainsAll ON tmpPDGoodsRemainsAll.ObjectId = Reserve.GoodsId
                          WHERE COALESCE(tmpGoodsRemains.ObjectId, 0) = 0
                            AND (Reserve.Amount - COALESCE(tmpPDGoodsRemainsAll.Reserve, 0)) <> 0
                         )
                 -- состояние в сессии
      , SESSIONDATA AS (SELECT CashSessionSnapShot.ObjectId
                             , CashSessionSnapShot.Price
                             , CashSessionSnapShot.Remains
                             , CashSessionSnapShot.MCSValue
                             , CashSessionSnapShot.Reserved
                             , CashSessionSnapShot.MinExpirationDate
                             , CashSessionSnapShot.PartionDateKindId
                             , CashSessionSnapShot.AccommodationId
                             , CashSessionSnapShot.PartionDateDiscount
                             , CashSessionSnapShot.PriceWithVAT
                        FROM CashSessionSnapShot
                        WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
                       )
       , tmpGoods AS (SELECT DISTINCT ObjectId FROM (SELECT tmpContainer.ObjectId FROM tmpContainer
                     UNION ALL
                      SELECT SESSIONDATA.ObjectId FROM SESSIONDATA
                     UNION ALL
                      SELECT RESERVE.GoodsId FROM RESERVE) AS GID
                     )
       , tmpObjPrice AS (SELECT tmpGoods.ObjectId, ObjectLink_Goods.ObjectId AS PriceId
                      FROM tmpGoods
                           INNER JOIN ObjectLink AS ObjectLink_Goods
                                                 ON ObjectLink_Goods.ChildObjectId = tmpGoods.ObjectId
                                                AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                           INNER JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                AND ObjectLink_Unit.ChildObjectId = vbUnitId
                     )
       , tmpOF AS (SELECT ObjectFloat.* FROM ObjectFloat WHERE ObjectFloat.ObjectId IN (SELECT DISTINCT tmpObjPrice.PriceId FROM tmpObjPrice)
                                                           AND ObjectFloat.DescId   IN (zc_ObjectFloat_Price_Value(), zc_ObjectFloat_Price_MCSValue())
                                                           AND ObjectFloat.ValueData <> 0
                  )
       , tmpOF_goods AS (SELECT ObjectFloat.* FROM ObjectFloat WHERE ObjectFloat.ObjectId IN (SELECT DISTINCT tmpObjPrice.ObjectId FROM tmpObjPrice)
                                                                 AND ObjectFloat.DescId   IN (zc_ObjectFloat_Goods_Price())
                                                                 AND ObjectFloat.ValueData <> 0
                  )
       , tmpOB_goods AS (SELECT ObjectBoolean.* FROM ObjectBoolean WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpObjPrice.ObjectId FROM tmpObjPrice)
                                                                     AND ObjectBoolean.DescId   IN (zc_ObjectBoolean_Goods_TOP())
                                                                     AND ObjectBoolean.ValueData = TRUE
                  )
       , tmpPrice AS (SELECT tmpObjPrice.ObjectId
                           , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE COALESCE (ROUND (ObjectFloat_Value.ValueData, 2), 0)
                               END AS Price
                           , COALESCE (ObjectFloat_MCS.ValueData, 0) AS MCSValue
                      FROM tmpObjPrice
                           LEFT JOIN tmpOF AS ObjectFloat_Value
                                           ON ObjectFloat_Value.ObjectId = tmpObjPrice.PriceId
                                          AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Price_Value()
                           LEFT JOIN tmpOF AS ObjectFloat_MCS
                                           ON ObjectFloat_MCS.ObjectId = tmpObjPrice.PriceId
                                          AND ObjectFloat_MCS.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- Фикс цена для всей Сети
                           LEFT JOIN tmpOF_goods  AS ObjectFloat_Goods_Price
                                            ON ObjectFloat_Goods_Price.ObjectId = tmpObjPrice.ObjectId
                                           AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN tmpOB_goods AS ObjectBoolean_Goods_TOP
                                           ON ObjectBoolean_Goods_TOP.ObjectId = tmpObjPrice.ObjectId
                                          AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                     )

    -- РЕЗУЛЬТАТ - заливаем разницу
    INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MinExpirationDate, PartionDateKindId,
                       MCSValue, Reserved, NewRow, AccommodationId, PartionDateDiscount, PriceWithVAT, Color_calc)
       WITH tmpDiff AS (SELECT tmpPrice.ObjectId                                                 AS ObjectId
                             , tmpPrice.Price                                                    AS Price
                             , tmpPrice.MCSValue                                                 AS MCSValue
                             , COALESCE (GoodsRemains.Remains, 0)
                                         - COALESCE(GoodsRemains.Reserve,0)                      AS Remains
                             , NULLIF (GoodsRemains.Reserve, 0)::TFloat                          AS Reserved
                             , CASE WHEN SESSIONDATA.ObjectId IS NULL
                                         THEN TRUE
                                     ELSE FALSE
                               END                                                               AS NewRow
                             , Accommodation.AccommodationId                                     AS AccommodationID
                             , GoodsRemains.MinExpirationDate                                    AS MinExpirationDate
                             , GoodsRemains.PartionDateKindId                                    AS PartionDateKindId
                             , GoodsRemains.PartionDateDiscount                                  AS PartionDateDiscount
                             , GoodsRemains.PriceWithVAT                                         AS PriceWithVAT
                        FROM GoodsRemains
                             LEFT JOIN tmpPrice ON tmpPrice.ObjectId = GoodsRemains.ObjectId
                             LEFT JOIN SESSIONDATA  ON SESSIONDATA.ObjectId  = GoodsRemains.ObjectId
                                                   AND COALESCE (SESSIONDATA.PartionDateKindId,0) = COALESCE (GoodsRemains.PartionDateKindId, 0)
                             LEFT JOIN AccommodationLincGoods AS Accommodation
                                                              ON Accommodation.UnitId = vbUnitId
                                                             AND Accommodation.GoodsId = GoodsRemains.ObjectId
                        WHERE COALESCE (tmpPrice.Price, 0)    <> COALESCE (SESSIONDATA.Price, 0)
                           OR COALESCE (tmpPrice.MCSValue, 0) <> COALESCE (SESSIONDATA.MCSValue, 0)
                           OR COALESCE (GoodsRemains.Remains, 0) - COALESCE(GoodsRemains.Reserve,0) <> COALESCE (SESSIONDATA.Remains, 0)
                           OR COALESCE(GoodsRemains.Reserve, 0) <> COALESCE (SESSIONDATA.Reserved, 0)
                           OR COALESCE (Accommodation.AccommodationID,0) <> COALESCE (SESSIONDATA.AccommodationId, 0)
                           OR COALESCE (GoodsRemains.MinExpirationDate, zc_DateEnd()) <> COALESCE (SESSIONDATA.MinExpirationDate, zc_DateEnd())
                           OR COALESCE (GoodsRemains.PartionDateKindId,0) <> COALESCE (SESSIONDATA.PartionDateKindId, 0)
                           OR COALESCE (GoodsRemains.PartionDateDiscount,0) <> COALESCE (SESSIONDATA.PartionDateDiscount, 0)
                           OR COALESCE (GoodsRemains.PriceWithVAT,0) <> COALESCE (SESSIONDATA.PriceWithVAT, 0)
                        UNION ALL
                        SELECT tmpPrice.ObjectId                                                       AS ObjectId
                             , tmpPrice.Price                                                          AS Price
                             , tmpPrice.MCSValue                                                       AS MCSValue
                             , COALESCE(tmpPDGoodsRemainsAll.Reserve, 0) - COALESCE (Reserve.Amount,0) AS Remains
                             , COALESCE (Reserve.Amount,0) - COALESCE(tmpPDGoodsRemainsAll.Reserve, 0) AS Reserved
                             , CASE WHEN SESSIONDATA.ObjectId IS NULL
                                         THEN TRUE
                                     ELSE FALSE
                               END                                                                     AS NewRow
                             , Accommodation.AccommodationId                                           AS AccommodationID
                             , SESSIONDATA.MinExpirationDate                                          AS MinExpirationDate
                             , SESSIONDATA.PartionDateKindId                                          AS PartionDateKindId
                             , SESSIONDATA.PartionDateDiscount                                        AS PartionDateDiscount
                             , SESSIONDATA.PriceWithVAT                                               AS PriceWithVAT
                        FROM SESSIONDATA
                             LEFT JOIN GoodsRemains  ON GoodsRemains.ObjectId = SESSIONDATA.ObjectId
                                                   AND COALESCE (GoodsRemains.PartionDateKindId, 0) = COALESCE (SESSIONDATA.PartionDateKindId,0)
                             LEFT JOIN tmpPDGoodsRemainsAll ON tmpPDGoodsRemainsAll.ObjectId = SESSIONDATA.ObjectId
                                                           AND  COALESCE (SESSIONDATA.PartionDateKindId,0) = 0
                             LEFT JOIN tmpPrice ON tmpPrice.ObjectId = SESSIONDATA.ObjectId
                             LEFT JOIN RESERVE      ON RESERVE.GoodsId       = SESSIONDATA.ObjectId
                                                   AND COALESCE (SESSIONDATA.PartionDateKindId, 0) = 0
                             LEFT JOIN AccommodationLincGoods AS Accommodation
                                                              ON Accommodation.UnitId = vbUnitId
                                                             AND Accommodation.GoodsId = SESSIONDATA.ObjectId
                        WHERE COALESCE(GoodsRemains.ObjectId, 0) = 0
                          AND COALESCE(tmpPDGoodsRemainsAll.Reserve, 0) - COALESCE (Reserve.Amount,0) <> 0
                          AND COALESCE (Reserve.Amount,0) - COALESCE(tmpPDGoodsRemainsAll.Reserve, 0) <> 0

                       )
       -- РЕЗУЛЬТАТ
       SELECT tmpDiff.ObjectId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , tmpDiff.Price 
            , tmpDiff.Remains
            , tmpDiff.MinExpirationDate
            , tmpDiff.PartionDateKindId
            , tmpDiff.MCSValue
            , tmpDiff.Reserved
            , tmpDiff.NewRow
            , tmpDiff.AccommodationID
            , tmpDiff.PartionDateDiscount
            , tmpDiff.PriceWithVAT
            , CASE WHEN COALESCE (ObjectBoolean_First.ValueData, FALSE) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc
       FROM tmpDiff
            INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpDiff.ObjectId
            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = tmpDiff.ObjectId
                                   AND ObjectBoolean_First.DescId   = zc_ObjectBoolean_Goods_First()
       ;


    --Обновляем данные в сессии
    UPDATE CashSessionSnapShot SET
        Price               = _DIFF.Price
      , Remains             = _DIFF.Remains
      , MCSValue            = _DIFF.MCSValue
      , Reserved            = _DIFF.Reserved
      , AccommodationId     = _DIFF.AccommodationId
      , MinExpirationDate   = _DIFF.MinExpirationDate
      , PartionDateKindId   = COALESCE (_DIFF.PartionDateKindId, 0)
      , PartionDateDiscount = _DIFF.PartionDateDiscount
      , PriceWithVAT        = _DIFF.PriceWithVAT
    FROM
        _DIFF
    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
      AND CashSessionSnapShot.ObjectId = _DIFF.ObjectId
      AND COALESCE(CashSessionSnapShot.PartionDateKindId, 0) = COALESCE(_DIFF.PartionDateKindId, 0)
    ;

    --доливаем те, что появились
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,PartionDateKindId,Price,Remains,MCSValue,Reserved,MinExpirationDate,
                                    AccommodationId,PartionDateDiscount,PriceWithVAT)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,COALESCE (_DIFF.PartionDateKindId, 0)
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
       ,_DIFF.MinExpirationDate
       ,_DIFF.AccommodationId
       ,_DIFF.PartionDateDiscount
       ,_DIFF.PriceWithVAT
    FROM
        _DIFF
    WHERE
        _DIFF.NewRow = TRUE
    ;

/*    --Удаляем что ушло
    DELETE FROM CashSessionSnapShot
    USING _DIFF
    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
      AND CashSessionSnapShot.ObjectId = _DIFF.ObjectId
      AND COALESCE (CashSessionSnapShot.PartionDateKindId, 0) = COALESCE (_DIFF.PartionDateKindId, 0)
      AND COALESCE(_DIFF.Remains, 0) = 0
      AND COALESCE(_DIFF.Reserved, 0) = 0
    ;
*/
/*
    vb1:= (SELECT COUNT (*) FROM _DIFF) :: TVarChar;

    -- !!!Протокол - отладка Скорости!!!
    INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
      VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin, CLOCK_TIMESTAMP(), vbUnitId, vbUserId
            , REPEAT ('0', 8 - LENGTH (vb1)) || vb1
    || ' '   || lfGet_Object_ValueData_sh (vbUnitId)
    || ' + ' || lfGet_Object_ValueData_sh (vbUserId)
    || ','   || vbUnitId              :: TVarChar
    || ','   || CHR (39) || inCashSessionId || CHR (39)
             );
*/
/*
-- TRUNCATE TABLE Log_Reprice
WITH tmp as (SELECT tmp.*, ROW_NUMBER() OVER (PARTITION BY TextValue_calc ORDER BY InsertDate) AS Ord, TextValue_int :: TVarChar || ' ' || TextValue_calc AS TextValue_new
             FROM
            (SELECT Log_Reprice.*, SUBSTRING (TextValue FROM 9 FOR LENGTH (TextValue) - 8) AS TextValue_calc, SUBSTRING (TextValue FROM 1 FOR 8) :: Integer AS TextValue_int
             FROM Log_Reprice
             WHERE InsertDate > CURRENT_DATE
--             AND UserId = 3
            ) AS tmp
            )
   , tmp_res AS (SELECT tmp.EndDate - tmp.StartDate AS diff_curr, tmp.TextValue_new, CASE WHEN tmp_old.Ord > 0 THEN tmp.StartDate - tmp_old.EndDate ELSE NULL :: INTERVAL END AS diff_prev, tmp.Ord, tmp.* FROM tmp LEFT JOIN tmp AS tmp_old on tmp_old.TextValue_calc = tmp.TextValue_calc AND tmp_old.Ord = tmp.Ord - 1
                 ORDER BY tmp.TextValue_calc, tmp.InsertDate DESC
                )
-- SELECT * FROM tmp_res
 SELECT (SELECT SUM (diff_curr) FROM tmp_res) AS summ_d, (SELECT MAX (EndDate) FROM Log_Reprice) - (SELECT MIN (StartDate) FROM Log_Reprice) AS diffD, (SELECT COUNT (*) FROM Log_Reprice) AS CD, (SELECT MIN (StartDate) FROM Log_Reprice) AS minD, (SELECT MAX (EndDate) FROM Log_Reprice) AS maxD
*/
    --Возвращаем разницу в клиента
    RETURN QUERY
           WITH tmpPartionDateKind AS (SELECT Object_PartionDateKind.Id           AS Id
                                            , Object_PartionDateKind.ObjectCode   AS Code
                                            , Object_PartionDateKind.ValueData    AS Name
                                            , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFLoat AS AmountMonth
                                       FROM Object AS Object_PartionDateKind
                                            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                       WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind()
                                      )

        SELECT
            _DIFF.ObjectId,
            _DIFF.GoodsCode,
            _DIFF.GoodsName,
            _DIFF.Price,
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.MinExpirationDate,
            NULLIF (_DIFF.PartionDateKindId, 0),
            Object_PartionDateKind.Name                              AS PartionDateKindName,
            _DIFF.NewRow,
            _DIFF.AccommodationId,
            Object_Accommodation.ValueData                           AS AccommodationName,
            CASE _DIFF.PartionDateKindId 
                 WHEN zc_Enum_PartionDateKind_Good() THEN vbDay_6 / 30.0 + 1.0  
                 WHEN zc_Enum_PartionDateKind_Cat_5() THEN vbDay_6 / 30.0 - 1.0 
                 ELSE Object_PartionDateKind.AmountMonth END::TFloat AS AmountMonth,
            CASE _DIFF.PartionDateKindId
                 WHEN zc_Enum_PartionDateKind_0() THEN ROUND(_DIFF.Price * (100.0 - _DIFF.PartionDateDiscount) / 100, 2)
                 WHEN zc_Enum_PartionDateKind_1() THEN ROUND(_DIFF.Price * (100.0 - _DIFF.PartionDateDiscount) / 100, 2)
                 WHEN zc_Enum_PartionDateKind_6() THEN
                    CASE WHEN _DIFF.Price > _DIFF.PriceWithVAT
                    THEN ROUND(_DIFF.Price - (_DIFF.Price - _DIFF.PriceWithVAT) * _DIFF.PartionDateDiscount / 100, 2)
                    ELSE _DIFF.Price END
                 WHEN zc_Enum_PartionDateKind_Cat_5() THEN
                    CASE WHEN _DIFF.Price > _DIFF.PriceWithVAT
                    THEN ROUND(_DIFF.Price - (_DIFF.Price - _DIFF.PriceWithVAT) * _DIFF.PartionDateDiscount / 100, 2)
                    ELSE _DIFF.Price END
                 ELSE NULL END::TFloat                                  AS PricePartionDate,
            _DIFF.Color_calc
        FROM _DIFF
            LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = _DIFF.AccommodationId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Diff_ver2 (TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 15.07.19                                                                                      * 
 28.05.19                                                                                      * PartionDateKindId
 16.03.16         *
 12.09.15                                                                       *CashSessionSnapShot
*/

-- тест
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{0B05C610-B172-4F81-99B8-25BF5385ADD6}' , '3')
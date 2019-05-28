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
    PartionDateDiscount TFloat,
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

   DECLARE vbDate0 TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;

   DECLARE vbPartion   boolean;
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
    vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
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
    vbDate0   := CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL;

    vbPartion := False;

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
                           , Color_calc Integer) ON COMMIT DROP;

    -- Данные
    WITH tmpContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_Count()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.Amount <> 0
                         )
       , tmpCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpCLO.ObjectId FROM tmpCLO))

       , tmpMIDate AS (SELECT MovementItemDate.*
                       FROM MovementItemDate
                       WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpObject.ObjectCode FROM tmpObject)
                         AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )

       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN tmpMIDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                                                        -- AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , tmpGoodsRemains AS (SELECT Container.ObjectId
                                  , SUM (Container.Amount) AS Remains
                                  , MIN (COALESCE (tmpExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- Срок годности
                             FROM tmpContainer AS Container
                                  -- находим партию
                                  LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
                                GROUP BY Container.ObjectId
                             )

          -- Остатки по срокам
       , tmpPDContainer AS (SELECT Container.Id, Container.ObjectId, Container.Amount
                            FROM Container
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.WhereObjectId = vbUnitId
                              AND Container.Amount <> 0)
       , tmpPDCLO AS (SELECT CLO.*
                    FROM ContainerlinkObject AS CLO
                    WHERE CLO.ContainerId IN (SELECT DISTINCT tmpPDContainer.Id FROM tmpPDContainer)
                      AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                   )
       , tmpPDObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpPDCLO.ObjectId FROM tmpPDCLO))

       , tmpPDMIDate AS (SELECT MovementItemDate.*
                       FROM MovementItemDate
                       WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpPDObject.ObjectCode FROM tmpPDObject)
                         AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )
       , tmpPDMIIncomeFind AS (SELECT MIFloat_MovementItem.MovementItemId        AS MovementItemId
                                    , MIFloat_MovementItem.ValueData::Integer    AS ID
                               FROM MovementItemFloat AS MIFloat_MovementItem
                               WHERE MIFloat_MovementItem.MovementItemId IN (SELECT DISTINCT tmpPDObject.ObjectCode FROM tmpPDObject)
                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId())
       , tmpPDMIDateFind AS (SELECT MovementItemDate.*
                             FROM MovementItemDate
                             WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpPDMIIncomeFind.ID FROM tmpPDMIIncomeFind)
                               AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                            )

       , tmpPDExpirationDate AS (SELECT tmpPDCLO.ContainerId, COALESCE(MIDate_ExpirationDateFind.ValueData, MIDate_ExpirationDate.ValueData) AS ExpirationDate
                                 FROM tmpPDCLO
                                      LEFT JOIN tmpPDObject ON tmpPDObject.Id = tmpPDCLO.ObjectId
                                      LEFT JOIN tmpPDMIDate AS MIDate_ExpirationDate
                                                            ON MIDate_ExpirationDate.MovementItemId = tmpPDObject.ObjectCode
                                      LEFT JOIN tmpPDMIIncomeFind ON tmpPDMIIncomeFind.MovementItemId = tmpPDObject.ObjectCode
                                      LEFT JOIN tmpPDMIDateFind AS MIDate_ExpirationDateFind
                                                            ON MIDate_ExpirationDateFind.MovementItemId = tmpPDMIIncomeFind.Id
                                )
       , tmpPDGoodsRemains AS (SELECT Container.ObjectId
                                    , Object_PartionDateKind.Id                                         AS PartionDateKindId
                                    , SUM (Container.Amount)                                            AS Remains
                                    , MIN (tmpPDExpirationDate.ExpirationDate)::TDateTime               AS MinExpirationDate
                               FROM tmpPDContainer AS Container

                                    LEFT JOIN tmpPDExpirationDate ON tmpPDExpirationDate.Containerid = Container.Id

                                    LEFT OUTER JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id =
                                         CASE WHEN tmpPDExpirationDate.ExpirationDate <= vbDate0 THEN zc_Enum_PartionDateKind_0() ELSE       -- просрочено
                                         CASE WHEN tmpPDExpirationDate.ExpirationDate <= vbDate30 THEN zc_Enum_PartionDateKind_1() ELSE      -- Меньше 1 месяца
                                         CASE WHEN tmpPDExpirationDate.ExpirationDate <= vbDate180 THEN zc_Enum_PartionDateKind_6() ELSE     -- Меньше 6 месяца
                                         NULL END END END

                               GROUP BY Container.ObjectId
                                      , Object_PartionDateKind.Id
                              )
       , tmpPDGoodsRemainsAll AS (SELECT tmpPDGoodsRemains.ObjectId
                                       , SUM (tmpPDGoodsRemains.Remains)                                                         AS Remains
                                  FROM tmpPDGoodsRemains
                                  GROUP BY tmpPDGoodsRemains.ObjectId
                                 )
          -- Непосредственно остатки
       , GoodsRemains AS (SELECT Container.ObjectId
                               , Container.Remains - COALESCE(tmpPDGoodsRemainsAll.Remains, 0)  AS Remains
                               , Container.MinExpirationDate
                               , NULL                                                           AS PartionDateKindId
                          FROM tmpGoodsRemains AS Container
                               LEFT JOIN tmpPDGoodsRemainsAll ON tmpPDGoodsRemainsAll.ObjectId = Container.ObjectId
                          UNION ALL
                          SELECT tmpPDGoodsRemains.ObjectId
                               , tmpPDGoodsRemains.Remains
                               , tmpPDGoodsRemains.MinExpirationDate
                               , tmpPDGoodsRemains.PartionDateKindId
                          FROM tmpPDGoodsRemains
                         )

    -- Отложенные чеки
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
  , RESERVE
    AS
    (
        SELECT MovementItem.ObjectId            AS GoodsId
             , Sum(MovementItem.Amount)::TFloat AS Amount
             , MovementLinkObject_PartionDateKind.ObjectId AS PartionDateKindId
        FROM tmpMov
                     INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE

                     LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                  ON MovementLinkObject_PartionDateKind.MovementId = tmpMov.Id
                                                 AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
        GROUP BY MovementItem.ObjectId, MovementLinkObject_PartionDateKind.ObjectId
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
                       MCSValue, Reserved, NewRow, AccommodationId, Color_calc)
       WITH tmpDiff AS (SELECT tmpPrice.ObjectId                                                 AS ObjectId
                             , tmpPrice.Price                                                    AS Price
                             , tmpPrice.MCSValue                                                 AS MCSValue
                             , COALESCE (GoodsRemains.Remains, 0) - COALESCE (Reserve.Amount,0)  AS Remains
                             , Reserve.Amount                                                    AS Reserved
                             , CASE WHEN SESSIONDATA.ObjectId IS NULL
                                         THEN TRUE
                                     ELSE FALSE
                               END                                                               AS NewRow
                             , Accommodation.AccommodationId                                     AS AccommodationID
                             , GoodsRemains.MinExpirationDate                                    AS MinExpirationDate
                             , GoodsRemains.PartionDateKindId                                    AS PartionDateKindId
                        FROM GoodsRemains
                             LEFT JOIN tmpPrice ON tmpPrice.ObjectId = GoodsRemains.ObjectId
                             LEFT JOIN SESSIONDATA  ON SESSIONDATA.ObjectId  = GoodsRemains.ObjectId
                                                   AND COALESCE (SESSIONDATA.PartionDateKindId,0) = COALESCE (GoodsRemains.PartionDateKindId, 0)
                             LEFT JOIN RESERVE      ON RESERVE.GoodsId       = GoodsRemains.ObjectId
                                                   AND COALESCE (RESERVE.PartionDateKindId,0) = COALESCE (GoodsRemains.PartionDateKindId, 0)
                             LEFT JOIN AccommodationLincGoods AS Accommodation
                                                              ON Accommodation.UnitId = vbUnitId
                                                             AND Accommodation.GoodsId = GoodsRemains.ObjectId
                        WHERE COALESCE (tmpPrice.Price, 0)    <> COALESCE (SESSIONDATA.Price, 0)
                           OR COALESCE (tmpPrice.MCSValue, 0) <> COALESCE (SESSIONDATA.MCSValue, 0)
                           OR COALESCE (GoodsRemains.Remains, 0) - COALESCE (Reserve.Amount, 0) <> COALESCE (SESSIONDATA.Remains, 0)
                           OR COALESCE (Reserve.Amount,0) <> COALESCE (SESSIONDATA.Reserved, 0)
                           OR COALESCE (Accommodation.AccommodationID,0) <> COALESCE (SESSIONDATA.AccommodationId, 0)
                           OR COALESCE (GoodsRemains.MinExpirationDate, zc_DateEnd()) <> COALESCE (SESSIONDATA.MinExpirationDate, zc_DateEnd())
                           OR COALESCE (GoodsRemains.PartionDateKindId,0) <> COALESCE (SESSIONDATA.PartionDateKindId, 0)
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
            , CASE WHEN COALESCE (ObjectBoolean_First.ValueData, FALSE) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc
       FROM tmpDiff
            INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpDiff.ObjectId
            LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                    ON ObjectBoolean_First.ObjectId = tmpDiff.ObjectId
                                   AND ObjectBoolean_First.DescId   = zc_ObjectBoolean_Goods_First()
       ;


    --Обновляем данные в сессии
    UPDATE CashSessionSnapShot SET
        Price             = _DIFF.Price
      , Remains           = _DIFF.Remains
      , MCSValue          = _DIFF.MCSValue
      , Reserved          = _DIFF.Reserved
      , AccommodationId   = _DIFF.AccommodationId
      , MinExpirationDate = _DIFF.MinExpirationDate
      , PartionDateKindId = COALESCE (_DIFF.PartionDateKindId, 0)
    FROM
        _DIFF
    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
      AND CashSessionSnapShot.ObjectId = _DIFF.ObjectId
      AND COALESCE(CashSessionSnapShot.PartionDateKindId, 0) = COALESCE(_DIFF.PartionDateKindId, 0)
    ;

    --доливаем те, что появились
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,PartionDateKindId,Price,Remains,MCSValue,Reserved,MinExpirationDate)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,COALESCE (_DIFF.PartionDateKindId, 0)
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
       ,_DIFF.MinExpirationDate
    FROM
        _DIFF
    WHERE
        _DIFF.NewRow = TRUE
    ;

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
              , tmpMovSendPartion AS (SELECT
                                             Movement.Id                               AS Id
                                           , MovementFloat_ChangePercent.ValueData     AS ChangePercent
                                           , MovementFloat_ChangePercentMin.ValueData  AS ChangePercentMin
                                      FROM Movement

                                           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                                   ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                           LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                                                   ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                                                  AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                      WHERE Movement.DescId = zc_Movement_SendPartionDate()
                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                      ORDER BY Movement.OperDate
                                      LIMIT 1
                                     )
              , tmpMovItemSendPartion AS (SELECT
                                                 MovementItem.ObjectId    AS GoodsId
                                               , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                               , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin

                                          FROM MovementItem

                                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                           ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                          AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                                           ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                                          AND MIFloat_ChangePercentMin.DescId = zc_MIFloat_ChangePercentMin()

                                          WHERE MovementItem.MovementId = (select tmpMovSendPartion.Id from tmpMovSendPartion)
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND (MIFloat_ChangePercent.ValueData is not Null OR MIFloat_ChangePercentMin.ValueData is not Null)

                                         )
              , tmpPDChangePercent AS (SELECT Object_PartionDateKind.Id           AS Id,
                                              CASE Object_PartionDateKind.Id
                                                   WHEN zc_Enum_PartionDateKind_0() THEN tmpMovSendPartion.ChangePercentMin
                                                   WHEN zc_Enum_PartionDateKind_1() THEN tmpMovSendPartion.ChangePercentMin
                                                   WHEN zc_Enum_PartionDateKind_6() THEN tmpMovSendPartion.ChangePercent END AS PartionDateDiscount
                                       FROM Object AS Object_PartionDateKind
                                            LEFT JOIN tmpMovSendPartion ON 1 = 1
                                       WHERE Object_PartionDateKind.DescId = zc_Object_PartionDateKind()
                                       )

              , tmpPDChangePercentGoods AS (SELECT Object_PartionDateKind.Id           AS Id
                                                 , tmpMovItemSendPartion.GoodsId
                                                 , CASE Object_PartionDateKind.Id
                                                        WHEN zc_Enum_PartionDateKind_0() THEN tmpMovItemSendPartion.ChangePercentMin
                                                        WHEN zc_Enum_PartionDateKind_1() THEN tmpMovItemSendPartion.ChangePercentMin
                                                        WHEN zc_Enum_PartionDateKind_6() THEN tmpMovItemSendPartion.ChangePercent END AS PartionDateDiscount
                                            FROM Object AS Object_PartionDateKind
                                                 LEFT JOIN tmpMovItemSendPartion ON 1 = 1
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
            Object_PartionDateKind.Name    AS PartionDateKindName,
            _DIFF.NewRow,
            _DIFF.AccommodationId,
            Object_Accommodation.ValueData AS AccommodationName,
            Object_PartionDateKind.AmountMonth                     AS AmountMonth,
            COALESCE(tmpPDChangePercentGoods.PartionDateDiscount,
                     tmpPDChangePercent.PartionDateDiscount, 0)::TFloat AS PartionDateDiscount,
            _DIFF.Color_calc
        FROM _DIFF
            LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = _DIFF.AccommodationId
            LEFT JOIN tmpPDChangePercent ON tmpPDChangePercent.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN tmpPDChangePercentGoods ON tmpPDChangePercentGoods.Id = NULLIF (_DIFF.PartionDateKindId, 0)
                                            AND tmpPDChangePercentGoods.GoodsId = _DIFF.ObjectId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Diff_ver2 (TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 28.05.19                                                                                      * PartionDateKindId
 16.03.16         *
 12.09.15                                                                       *CashSessionSnapShot
*/

-- тест
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{0B05C610-B172-4F81-99B8-25BF5385ADD6}' , '3')

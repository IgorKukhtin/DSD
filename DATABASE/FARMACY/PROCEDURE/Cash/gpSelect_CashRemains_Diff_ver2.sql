-- Function: gpSelect_CashRemains_Diff_ver2()

 DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff_ver2( Integer, TVarChar, TVarChar, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff_ver2 (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashRemains_Diff_ver2(
    IN inMovementId    Integer,    -- Текущая накладная
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
    NewRow Boolean,
    Color_calc Integer
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbOperDate_StartBegin TDateTime;
   DECLARE vb1 TVarChar;
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
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , NewRow    Boolean
                           , Color_calc Integer
                           , MinExpirationDate TDateTime) ON COMMIT DROP;

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
       , tmpObject AS (SELECT Object.Id, Object.ObjectCode FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpCLO.ObjectId FROM tmpCLO))

       , tmpExpirationDate2 AS (SELECT MIDate_ExpirationDate.MovementItemId, MIDate_ExpirationDate.ValueData
                                FROM MovementItemDate AS MIDate_ExpirationDate
                                WHERE MIDate_ExpirationDate.MovementItemId IN (SELECT DISTINCT tmpObject.ObjectCode FROM tmpObject)
                                  AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                               )
       , tmpExpirationDate AS (SELECT tmpCLO.ContainerId, MIDate_ExpirationDate.ValueData
                               FROM tmpCLO
                                    INNER JOIN tmpObject ON tmpObject.Id = tmpCLO.ObjectId
                                    INNER JOIN tmpExpirationDate2 AS MIDate_ExpirationDate
                                                                  ON MIDate_ExpirationDate.MovementItemId = tmpObject.ObjectCode
                              )
       , GoodsRemains AS
     (SELECT Container.ObjectId
           , SUM (Container.Amount) AS Remains
           , MIN (COALESCE (tmpExpirationDate.ValueData, zc_DateEnd())) :: TDateTime AS MinExpirationDate -- Срок годности
      FROM tmpContainer AS Container
          -- находим партию
          LEFT JOIN tmpExpirationDate ON tmpExpirationDate.Containerid = Container.Id
          /*
          -- находим партию
          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                        ON ContainerLinkObject_MovementItem.Containerid =  Container.Id
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

          LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                           ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                          AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()*/
      GROUP BY Container.ObjectId
     )
    -- Отложенные чеки
  , RESERVE AS (SELECT gpSelect.GoodsId      AS GoodsId
                     , SUM (gpSelect.Amount) AS Amount
                 FROM gpSelect_MovementItem_CheckDeferred (inSession) AS gpSelect
                 WHERE gpSelect.MovementId <> inMovementId
                 GROUP BY gpSelect.GoodsId
                )
    -- состояние в сессии
  , SESSIONDATA AS (SELECT CashSessionSnapShot.ObjectId
                         , CashSessionSnapShot.Price
                         , CashSessionSnapShot.Remains
                         , CashSessionSnapShot.MCSValue
                         , CashSessionSnapShot.Reserved
                         , CashSessionSnapShot.MinExpirationDate
                    FROM CashSessionSnapShot
                    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
                   )
       , tmpGoods AS (SELECT tmpContainer.ObjectId FROM tmpContainer
                     UNION
                      SELECT SESSIONDATA.ObjectId FROM SESSIONDATA
                     UNION
                      SELECT RESERVE.GoodsId FROM RESERVE
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
       , tmpPrice AS (SELECT tmpObjPrice.ObjectId, COALESCE (ROUND (ObjectFloat_Value.ValueData, 2), 0) AS Price, COALESCE (ObjectFloat_MCS.ValueData, 0) AS MCSValue
                      FROM tmpObjPrice
                           LEFT JOIN tmpOF AS ObjectFloat_Value
                                           ON ObjectFloat_Value.ObjectId = tmpObjPrice.PriceId
                                          AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Price_Value()
                           LEFT JOIN tmpOF AS ObjectFloat_MCS
                                           ON ObjectFloat_MCS.ObjectId = tmpObjPrice.PriceId
                                          AND ObjectFloat_MCS.DescId = zc_ObjectFloat_Price_MCSValue()
                     )
       /*, tmpPrice AS (SELECT ObjectLink_Goods.ChildObjectId AS ObjectId, COALESCE (ROUND (ObjectFloat_Value.ValueData, 2), 0) AS Price, COALESCE (ObjectFloat_MCS.ValueData, 0) AS MCSValue
                      -- FROM tmpGoods
                      --      INNER JOIN ObjectLink AS ObjectLink_Goods
                      --                            ON ObjectLink_Goods.ChildObjectId = tmpGoods.ObjectId
                      --                           AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                      FROM ObjectLink AS ObjectLink_Goods
                           INNER JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                AND ObjectLink_Unit.ChildObjectId = vbUnitId
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = ObjectLink_Goods.ObjectId
                                                 AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS ObjectFloat_MCS
                                                 ON ObjectFloat_MCS.ObjectId = ObjectLink_Goods.ObjectId
                                                AND ObjectFloat_MCS.DescId = zc_ObjectFloat_Price_MCSValue()
                      WHERE ObjectLink_Goods.ChildObjectId IN (SELECT DISTINCT tmpGoods.ObjectId FROM tmpGoods)
                        AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     )*/
    -- РЕЗУЛЬТАТ - заливаем разницу
    INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MCSValue, Reserved, NewRow, Color_calc,MinExpirationDate)
       WITH tmpDiff AS (SELECT tmpPrice.ObjectId                                                 AS ObjectId
                             , tmpPrice.Price                                                    AS Price
                             , tmpPrice.MCSValue                                                 AS MCSValue
                             , COALESCE (GoodsRemains.Remains, 0) - COALESCE (Reserve.Amount,0)  AS Remains
                             , Reserve.Amount                                                    AS Reserved
                             , CASE WHEN SESSIONDATA.ObjectId IS NULL
                                         THEN TRUE
                                     ELSE FALSE
                               END                                                               AS NewRow
                             , GoodsRemains.MinExpirationDate                                    AS MinExpirationDate
                        FROM tmpPrice
                             LEFT JOIN GoodsRemains ON GoodsRemains.ObjectId = tmpPrice.ObjectId
                             LEFT JOIN SESSIONDATA  ON SESSIONDATA.ObjectId  = tmpPrice.ObjectId
                             LEFT JOIN RESERVE      ON RESERVE.GoodsId       = tmpPrice.ObjectId
                        WHERE tmpPrice.Price    <> COALESCE (SESSIONDATA.Price, 0)
                           OR tmpPrice.MCSValue <> COALESCE (SESSIONDATA.MCSValue, 0)
                           OR COALESCE (GoodsRemains.Remains, 0) - COALESCE (Reserve.Amount, 0) <> COALESCE (SESSIONDATA.Remains, 0)
                           OR COALESCE (Reserve.Amount,0) <> COALESCE (SESSIONDATA.Reserved, 0)
                       )
       -- РЕЗУЛЬТАТ
       SELECT tmpDiff.ObjectId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , tmpDiff.Price
            , tmpDiff.Remains
            , tmpDiff.MCSValue
            , tmpDiff.Reserved
            , tmpDiff.NewRow
            , CASE WHEN COALESCE (ObjectBoolean_First.ValueData, FALSE) = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc
            , tmpDiff.MinExpirationDate
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
      , MinExpirationDate = _DIFF.MinExpirationDate
    FROM
        _DIFF
    WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
      AND CashSessionSnapShot.ObjectId = _DIFF.ObjectId
    ;

    --доливаем те, что появились
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,Price,Remains,MCSValue,Reserved,MinExpirationDate)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
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
    || ' : ' || inMovementId          :: TVarChar
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
        SELECT
            _DIFF.ObjectId,
            _DIFF.GoodsCode,
            _DIFF.GoodsName,
            _DIFF.Price,
            _DIFF.Remains,
            _DIFF.MCSValue,
            _DIFF.Reserved,
            _DIFF.NewRow,
            _DIFF.Color_calc
        FROM
            _DIFF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_CashRemains_Diff_ver2 (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 16.03.16         *
 12.09.15                                                                       *CashSessionSnapShot
*/

-- тест
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 (0, '{ACAF6C5B-24C4-43F0-B920-55444A167EC31}', '390016')
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 (0, 'tmp1', '3')

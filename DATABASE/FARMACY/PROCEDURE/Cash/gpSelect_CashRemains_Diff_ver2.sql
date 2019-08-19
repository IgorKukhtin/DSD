-- Function: gpSelect_CashRemains_Diff_ver2()

-- DROP FUNCTION IF EXISTS gpSelect_CashRemains_Diff_ver2_test (Integer, TVarChar, TVarChar);
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
    Color_calc Integer,
    DeferredSend TFloat,
    RemainsSun TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbOperDate_StartBegin TDateTime;
   DECLARE vb1 TVarChar;
   DECLARE vb2 TVarChar;

   DECLARE vbDay_6  Integer;
   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;

   DECLARE vbDividePartionDate Boolean;

   DECLARE vbAreaId   Integer;
   DECLARE vbObjectId Integer;
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

    -- сеть пользователя
    vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
    -- проверяем регион пользователя
    vbAreaId:= (SELECT outAreaId FROM gpGet_Area_byUser (inSession));
    --
    IF COALESCE (vbAreaId, 0) = 0
    THEN
        vbAreaId:= (SELECT AreaId FROM gpGet_User_AreaId (inSession));
    END IF;


    -- значения для разделения по срокам
    -- дата + 6 месяцев
    SELECT CURRENT_DATE + tmp.Date_6, tmp.Day_6
           INTO vbDate_6, vbDay_6
    FROM (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                            , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                       FROM Object  AS Object_PartionDateKind
                            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                  ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                 AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                       WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                      )
          SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL AS Date_6
               , tmp.Value AS Day_6
          FROM tmp
         ) AS tmp;
    -- дата + 1 месяц
    vbDate_1:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- дата + 0 месяцев
    vbDate_0:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


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

    -- определяем разницу в остатках реальных и сессионных
    CREATE TEMP TABLE _DIFF (ObjectId  Integer
                           , GoodsCode Integer
                           , GoodsName TVarChar
                           , Price     TFloat
                           , Remains   TFloat
                           , MinExpirationDate TDateTime
                           , PartionDateKindId  Integer
                           , MCSValue  TFloat
                           , Reserved  TFloat
                           , DeferredSend TFloat
                           , NewRow    Boolean
                           , AccommodationId Integer
                           , PartionDateDiscount TFloat
                           , PriceWithVAT TFloat
                           , Color_calc Integer) ON COMMIT DROP;

    -- Данные
    WITH
         GoodsRemains AS ( SELECT CashRemains.GoodsId                     AS ObjectId
                                , CashRemains.PartionDateKindId
                                , CashRemains.Price
                                , CashRemains.Remains
                                , CashRemains.MCSValue
                                , CashRemains.Reserved
                                , CashRemains.DeferredSend
                                , CashRemains.MinExpirationDate
                                , CashRemains.AccommodationId
                                , CashRemains.PartionDateDiscount
                                , CashRemains.PriceWithVAT
                          FROM gpSelect_CashRemains_CashSession(inSession) AS CashRemains
                         )
                 -- состояние в сессии
       , SESSIONDATA AS (SELECT CashSessionSnapShot.ObjectId
                              , CashSessionSnapShot.Price
                              , CashSessionSnapShot.Remains
                              , CashSessionSnapShot.MCSValue
                              , CashSessionSnapShot.Reserved
                              , CashSessionSnapShot.DeferredSend
                              , CashSessionSnapShot.MinExpirationDate
                              , CashSessionSnapShot.PartionDateKindId
                              , CashSessionSnapShot.AccommodationId
                              , CashSessionSnapShot.PartionDateDiscount
                              , CashSessionSnapShot.PriceWithVAT
                         FROM CashSessionSnapShot
                         WHERE CashSessionSnapShot.CashSessionId = inCashSessionId
                        )

    -- РЕЗУЛЬТАТ - заливаем разницу
    INSERT INTO _DIFF (ObjectId, GoodsCode, GoodsName, Price, Remains, MinExpirationDate, PartionDateKindId,
                       MCSValue, Reserved, DeferredSend, NewRow, AccommodationId, PartionDateDiscount, PriceWithVAT, Color_calc)
       WITH tmpDiff AS (SELECT GoodsRemains.ObjectId                                            AS ObjectId
                             , GoodsRemains.Price                                               AS Price
                             , GoodsRemains.MCSValue                                            AS MCSValue
                             , GoodsRemains.Remains                                             AS Remains
                             , GoodsRemains.Reserved                                            AS Reserved
                             , GoodsRemains.DeferredSend                                        AS DeferredSend
                             , CASE WHEN SESSIONDATA.ObjectId IS NULL
                                         THEN TRUE
                                     ELSE FALSE
                               END                                                              AS NewRow
                             , GoodsRemains.AccommodationId                                     AS AccommodationID
                             , GoodsRemains.MinExpirationDate                                   AS MinExpirationDate
                             , GoodsRemains.PartionDateKindId                                   AS PartionDateKindId
                             , GoodsRemains.PartionDateDiscount                                 AS PartionDateDiscount
                             , GoodsRemains.PriceWithVAT                                        AS PriceWithVAT
                        FROM GoodsRemains
                             LEFT JOIN SESSIONDATA ON SESSIONDATA.ObjectId  = GoodsRemains.ObjectId
                                                   AND COALESCE (SESSIONDATA.PartionDateKindId,0) = COALESCE (GoodsRemains.PartionDateKindId, 0)
                        WHERE COALESCE (GoodsRemains.Price, 0)    <> COALESCE (SESSIONDATA.Price, 0)
                           OR COALESCE (GoodsRemains.MCSValue, 0) <> COALESCE (SESSIONDATA.MCSValue, 0)
                           OR COALESCE (GoodsRemains.Remains, 0) <> COALESCE (SESSIONDATA.Remains, 0)
                           OR COALESCE (GoodsRemains.Reserved, 0) <> COALESCE (SESSIONDATA.Reserved, 0)
                           OR COALESCE (GoodsRemains.AccommodationID,0) <> COALESCE (SESSIONDATA.AccommodationId, 0)
                           OR COALESCE (GoodsRemains.MinExpirationDate, zc_DateEnd()) <> COALESCE (SESSIONDATA.MinExpirationDate, zc_DateEnd())
                           OR COALESCE (GoodsRemains.PartionDateKindId,0) <> COALESCE (SESSIONDATA.PartionDateKindId, 0)
                           OR COALESCE (GoodsRemains.PartionDateDiscount,0) <> COALESCE (SESSIONDATA.PartionDateDiscount, 0)
                           OR COALESCE (GoodsRemains.PriceWithVAT,0) <> COALESCE (SESSIONDATA.PriceWithVAT, 0)
                           OR COALESCE (GoodsRemains.DeferredSend,0) <> COALESCE (SESSIONDATA.DeferredSend, 0)
                        UNION ALL
                        SELECT SESSIONDATA.ObjectId                                                AS ObjectId
                             , SESSIONDATA.Price                                                   AS Price
                             , SESSIONDATA.MCSValue                                                AS MCSValue
                             , 0                                                                   AS Remains
                             , NULL                                                                AS Reserved
                             , NULL                                                                AS DeferredSend
                             , FALSE                                                               AS NewRow
                             , SESSIONDATA.AccommodationId                                         AS AccommodationID
                             , SESSIONDATA.MinExpirationDate                                       AS MinExpirationDate
                             , SESSIONDATA.PartionDateKindId                                       AS PartionDateKindId
                             , SESSIONDATA.PartionDateDiscount                                     AS PartionDateDiscount
                             , SESSIONDATA.PriceWithVAT                                            AS PriceWithVAT
                        FROM SESSIONDATA
                             LEFT JOIN GoodsRemains  ON GoodsRemains.ObjectId = SESSIONDATA.ObjectId
                                                   AND COALESCE (GoodsRemains.PartionDateKindId, 0) = COALESCE (SESSIONDATA.PartionDateKindId, 0)
                        WHERE COALESCE(GoodsRemains.ObjectId, 0) = 0
                          AND (COALESCE(SESSIONDATA.Remains, 0) <> 0
                               OR
                               COALESCE(SESSIONDATA.Reserved, 0) <> 0
                               OR
                               COALESCE(SESSIONDATA.DeferredSend, 0) <> 0)
                       )

       -- РЕЗУЛЬТАТ
       SELECT tmpDiff.ObjectId
            , Object_Goods.ObjectCode     AS GoodsCode
            , Object_Goods.ValueData      AS GoodsName
            , tmpDiff.Price
            , tmpDiff.Remains
            , tmpDiff.MinExpirationDate
            , NULLIF (tmpDiff.PartionDateKindId, 0)  AS PartionDateKindId
            , tmpDiff.MCSValue
            , tmpDiff.Reserved
            , tmpDiff.DeferredSend
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
      , DeferredSend        = _DIFF.DeferredSend
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
    Insert Into CashSessionSnapShot(CashSessionId,ObjectId,PartionDateKindId,Price,Remains,MCSValue,Reserved,DeferredSend,MinExpirationDate,
                                    AccommodationId,PartionDateDiscount,PriceWithVAT)
    SELECT
        inCashSessionId
       ,_DIFF.ObjectId
       ,COALESCE (_DIFF.PartionDateKindId, 0)
       ,_DIFF.Price
       ,_DIFF.Remains
       ,_DIFF.MCSValue
       ,_DIFF.Reserved
       ,_DIFF.DeferredSend
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

    vb1:= (SELECT COUNT (*) FROM _DIFF) :: TVarChar;
    vb2:= ((CLOCK_TIMESTAMP() - vbOperDate_StartBegin) :: INTERVAL) :: TVarChar;

    -- !!!Протокол - отладка Скорости!!!
    INSERT INTO Log_Reprice (InsertDate, StartDate, EndDate, MovementId, UserId, TextValue)
      VALUES (CURRENT_TIMESTAMP, vbOperDate_StartBegin, CLOCK_TIMESTAMP(), vbUnitId, vbUserId
            , vb2
    || ' '   || REPEAT ('0', 8 - LENGTH (vb1)) || vb1 || '-2'
    || ' '   || lfGet_Object_ValueData_sh (vbUnitId)
    || ' + ' || lfGet_Object_ValueData_sh (vbUserId)
    || ','   || vbUnitId              :: TVarChar
    || ','   || CHR (39) || inCashSessionId || CHR (39)
             );

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
                 -- Все перемещения по СУН
                ,tmpSendAll AS (SELECT DISTINCT Movement.Id AS MovementId
                                FROM Movement

                                     INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = Movement.Id
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()


                                WHERE Movement.DescId = zc_Movement_Send()
                                  AND COALESCE (MovementBoolean_SUN.ValueData, FALSE) = TRUE 
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                )
                   -- Перемещения по СУН основные контейнера
                 , tmpRenainsSUNCount AS (SELECT Container.Id
                                               , Container.ObjectId   
                                               , SUM(Container.Amount) AS Amount
                                          FROM tmpSendAll AS Movement

                                               INNER JOIN MovementItem ON MovementItem.MovementId =  Movement.MovementId
                                                                      AND MovementItem.DescId = zc_MI_Child()

                                               INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.MovementId
                                                                               AND MovementItemContainer.MovementItemId = MovementItem.Id
                                                                               AND MovementItemContainer.DescId = zc_Container_Count()
                                                                               AND MovementItemContainer.isActive = TRUE

                                               INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                                                   AND Container.WhereObjectId = vbUnitId

                                          WHERE Container.Amount <> 0
                                          GROUP BY Container.Id, Container.ObjectId 
                                          )
                   -- Перемещения по СУН полный набор
                 , tmpRenainsSUNAll AS (SELECT Container.Id                                       AS ID
                                          , Container.ObjectId                                 AS GoodsID
                                          , Container.Amount                                   AS Amount
                                          , ContainerPD.Id                                     AS PDID
                                          , ContainerPD.Amount                                 AS AmountPD
                                          , CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0 AND
                                                      COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = TRUE
                                                                                                       THEN zc_Enum_PartionDateKind_Cat_5()  -- 5 кат (просрочка без наценки)
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_0  THEN zc_Enum_PartionDateKind_0()      -- просрочено
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_1  THEN zc_Enum_PartionDateKind_1()      -- Меньше 1 месяца
                                                 WHEN ObjectDate_ExpirationDate.ValueData <= vbDate_6  THEN zc_Enum_PartionDateKind_6()      -- Меньше 6 месяца
                                                 ELSE  zc_Enum_PartionDateKind_Good() END  AS PartionDateKindId                              -- Востановлен с просрочки
                                     FROM tmpRenainsSUNCount AS Container

                                          LEFT JOIN Container AS ContainerPD
                                                              ON ContainerPD.ParentId = Container.Id
                                                             AND ContainerPD.DescId = zc_Container_CountPartionDate()

                                          LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = ContainerPD.Id
                                                                       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                          LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                               ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId 
                                                              AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                                  ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                                                 AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                                      )
                   -- Перемещения по СУН остатки
                 , tmpRenainsSUN AS (SELECT Container.GoodsID                                   AS GoodsID
                                          , COALESCE(Container.PartionDateKindId, 0)            AS PartionDateKindId
                                          , SUM(COALESCE(Container.AmountPD, Container.Amount)) AS Amount
                                     FROM tmpRenainsSUNAll AS Container

                                     GROUP BY Container.GoodsID, COALESCE(Container.PartionDateKindId, 0) 
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
            _DIFF.Color_calc,
            _DIFF.DeferredSend,
            RemainsSUN TFloat
        FROM _DIFF
            LEFT JOIN tmpPartionDateKind AS Object_PartionDateKind ON Object_PartionDateKind.Id = NULLIF (_DIFF.PartionDateKindId, 0)
            LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = _DIFF.AccommodationId
            -- Остаток товара по СУН
            LEFT JOIN tmpRenainsSUN ON tmpRenainsSUN.GoodsID = _DIFF.ObjectId
                                   AND tmpRenainsSUN.PartionDateKindId = _DIFF.PartionDateKindId;


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
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{85E257DE-0563-4B9E-BE1C-4D5C123FB33A}-', '10411288')
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{85E257DE-0563-4B9E-BE1C-4D5C123FB33A}-', '3998773') WHERE GoodsCode = 1240
-- SELECT * FROM gpSelect_CashRemains_Diff_ver2 ('{0B05C610-B172-4F81-99B8-25BF5385ADD6}', '3')
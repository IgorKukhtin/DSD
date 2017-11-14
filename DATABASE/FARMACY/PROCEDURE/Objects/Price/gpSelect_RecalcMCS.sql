-- Function: gpSelect_RecalcMCS (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_RecalcMCS (Integer, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_RecalcMCS (Integer, Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_RecalcMCS(
    IN inUnitId              Integer   , -- Подразделение
    IN inGoodsId             Integer   , -- Подразделение
    IN inPeriod              Integer   , -- Период для расчета продаж, т.е. будет с "inStartDate - inPeriod"
    IN inDay                 Integer   , -- Сколько дней брать в расчет
    IN inStartDate           TDateTime,  -- Дата остатка
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( MCSValue TFloat
              , GoodsId Integer
              , UnitId Integer 
              , GoodsCode Integer 
              , GoodsName TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- !!!только НЕ так определяется <Торговая сеть>!!!
    -- vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    -- !!!только так - определяется <Торговая сеть>!!!
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = ABS (inUnitId) :: Integer
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 );


    -- Проверка
    IF inPeriod < 1
    THEN
        RAISE EXCEPTION 'Ошибка. Количество дней для расчета<%> не может быть меньше 1',inPeriod;
    END IF;
    
    -- Проверка
    IF inDay < 1
    THEN
        RAISE EXCEPTION 'Ошибка. Количество дней страхового запаса<%> не может быть меньше 1',inDay;
    END IF;
  

    -- Таблица подразделений для распределения 
    CREATE TEMP TABLE tmpUnit(UnitId Integer) ON COMMIT DROP;
    -- определяем подразделения для распределения
    IF COALESCE (inUnitId,0) > 0 
    THEN
       INSERT INTO tmpUnit (UnitId)
                      SELECT inUnitId AS UnitId;
    ELSE
       INSERT INTO tmpUnit (UnitId)
                      SELECT ABS (inUnitId) :: Integer  AS UnitId
                     UNION
                      SELECT ObjectBoolean_Over.ObjectId  AS UnitId
                      FROM ObjectBoolean AS ObjectBoolean_Over    
                             /*INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                   ON ObjectLink_Unit_Juridical.ObjectId = ObjectBoolean_Over.ObjectId
                                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                             INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                   ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                  AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                  AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId*/
                      WHERE ObjectBoolean_Over.DescId = zc_ObjectBoolean_Unit_Over()
                        AND ObjectBoolean_Over.ValueData = TRUE;
 
    END IF;


    -- Таблица
    CREATE TEMP TABLE tmpSoldOneDay (UnitId Integer, GoodsId Integer, NumberDay Integer, SoldCount TFloat, PRIMARY KEY (GoodsId, UnitId, NumberDay)) ON COMMIT DROP;
    INSERT INTO tmpSoldOneDay (UnitId, GoodsId, NumberDay, SoldCount)
                         SELECT MIContainer.WhereObjectId_analyzer        AS UnitId
                              , MIContainer.ObjectId_analyzer AS GoodsId  
                              , inPeriod - DATE_PART ('DAY', inStartDate - MIContainer.OperDate) AS NumberDay   
                              , SUM (ROUND (CASE WHEN COALESCE (MovementBoolean_NotMCS.ValueData, FALSE) = FALSE THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END, 1)) AS SoldCount
                         FROM tmpUnit 
                             INNER JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.WhereObjectId_analyzer = tmpUnit.UnitId 
                                                             AND MIContainer.MovementDescId = zc_Movement_Check()
                                                             AND MIContainer.DescId = zc_MIContainer_Count()   
                                                             AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate :: Date - inPeriod) 
                                                             AND MIContainer.OperDate < DATE_TRUNC ('DAY', inStartDate :: Date)   

                             LEFT OUTER JOIN MovementBoolean AS MovementBoolean_NotMCS
                                                             ON MovementBoolean_NotMCS.MovementId = MIContainer.MovementId
                                                            AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()
                          GROUP BY MIContainer.WhereObjectId_analyzer
                                , MIContainer.ObjectId_analyzer   
                                , DATE_PART ('DAY', inStartDate - MIContainer.OperDate)
                         ;

     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE tmpSoldOneDay;


    -- РЕЗУЛЬТАТ
    RETURN QUERY
      WITH tmpResult AS (SELECT S1.UnitId, 
                                S1.GoodsId, 
                                S1.NumberDay, 
                                SUM (S2.SoldCount) AS SoldCount
                         FROM tmpSoldOneDay AS S1
                              LEFT OUTER JOIN tmpSoldOneDay AS S2 ON S2.GoodsId   = S1.GoodsId
                                                                 AND S2.UnitId    = S1.UnitId
                                                                 AND S2.NumberDay >= S1.NumberDay
                                                                 AND S2.NumberDay <= (S1.NumberDay + inDay - 1)
                         GROUP BY S1.UnitId,
                                  S1.GoodsId,
                                  S1.NumberDay
                        )      
   /*, tmpPrice AS (SELECT ObjectLink_Price_Unit.ChildObjectId      AS UnitId
                       , Price_Goods.ChildObjectId                AS GoodsId
                    FROM tmpUnit
                       LEFT JOIN ObjectLink AS ObjectLink_Price_Unit
                                            ON ObjectLink_Price_Unit.ChildObjectId = tmpUnit.UnitId
                                           AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()  
                       INNER JOIN ObjectLink AS Price_Goods
                                             ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                            AND (Price_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)                             
                       LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                               ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                       LEFT JOIN ObjectBoolean AS MCS_isClose
                                               ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()  
                       
                   WHERE COALESCE(MCS_NotRecalc.ValueData,False) = FALSE 
                     AND COALESCE(MCS_isClose.ValueData,False) = FALSE
                  ) 
          */                                
      SELECT MAX (tmpResult.SoldCount)::TFloat AS MCSValue -- Неснижаемый товарный запас
           , tmpResult.GoodsId
           , tmpResult.UnitId
           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
      FROM tmpResult
          LEFT OUTER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
          /*INNER JOIN tmpPrice AS Object_Price
                              ON Object_Price.GoodsId = tmpResult.GoodsId
                             AND Object_Price.UnitId = tmpResult.UnitId  */
      GROUP BY tmpResult.GoodsId, tmpResult.UnitId
             , Object_Goods.ObjectCode
             , Object_Goods.ValueData
       ;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.06.16         *
*/

-- SELECT * FROM gpSelect_RecalcMCS (inUnitId:= 377610 , inGoodsId := 0, inPeriod:= 30, inDay:= 5, inStartDate:= '01.02.2017', inSession := '3') --where goodscode = 1014; -- Аптека_1 пр_Правды_6
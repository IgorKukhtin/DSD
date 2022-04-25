-- Function: gpReport_RecalcMCS (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReport_RecalcMCS (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RecalcMCS(
    IN inUnitId              Integer   , -- Подразделение
    IN inPeriod              Integer   , -- С какого дня
    IN inDay                 Integer   , -- Сколько дней брать в расчет
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor 
AS
$BODY$
    DECLARE vbCounter integer;
    DECLARE vbSold    TFloat;
    DECLARE vbObjectId Integer;
    DECLARE vbUserId Integer;
    DECLARE cur1 refcursor; 
    DECLARE cur2 refcursor; 
    DECLARE curDate refcursor; 
    DECLARE vbNumberDay Integer;
    DECLARE vbQueryText TEXT;
BEGIN

    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите подразделение';
    END IF;
    IF inPeriod < 1
    THEN
        RAISE EXCEPTION 'Ошибка. Количество дней для расчета<%> не может быть меньше 1',inPeriod;
    END IF;
    
    IF inDay < 1
    THEN
        RAISE EXCEPTION 'Ошибка. Количество дней страхового запаса<%> не может быть меньше 1',inDay;
    END IF;
    
    vbUserId := inSession; 
    
/*    IF vbUserId = 3
    THEN
      raise notice 'Value 01: % % %', inUnitId, inPeriod, inDay;
      Return;
    END IF;
*/    
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmp_AllDayCount'))
    THEN
      DROP TABLE tmp_AllDayCount;    
    END IF;

    --пустографка с днями
    CREATE TEMP TABLE tmp_AllDayCount(
        NumberDay        Integer not null,
        primary key(NumberDay)
    ) ON COMMIT DROP;
    vbCounter := 1;
    WHILE vbCounter <= inPeriod LOOP
        INSERT INTO tmp_AllDayCount( NumberDay ) values( vbCounter );
        vbCounter := vbCounter + 1;
    END LOOP;
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmp_SoldGoodsOneDay'))
    THEN
      DROP TABLE tmp_SoldGoodsOneDay;    
    END IF;

    --товар / день / продажа
    CREATE TEMP TABLE tmp_SoldGoodsOneDay(
        GoodsId  integer not null,
        NumberOfDay      Integer not null,
        SoldCount        TFloat  not null,
        primary key(GoodsId,NumberOfDay)
    ) ON COMMIT DROP;   
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpPrice'))
    THEN
      DROP TABLE tmpPrice;    
    END IF;

    --
    CREATE TEMP TABLE tmpPrice  (UnitId Integer, GoodsId Integer, MCSValue TFloat, MCSValue_min TFloat, PercentMarkup TFloat, isTop Boolean, Fix Boolean) ON COMMIT DROP;  
    INSERT INTO tmpPrice (UnitId, GoodsId, MCSValue, MCSValue_min, PercentMarkup, isTop, Fix)  
                    SELECT ObjectLink_Price_Unit.ChildObjectId    AS UnitId
                       , Price_Goods.ChildObjectId                AS GoodsId     
                       , MCS_Value.ValueData                      AS MCSValue
                       , COALESCE(Price_MCSValueMin.ValueData,0)    ::TFloat AS MCSValue_min
                       , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                       , COALESCE(Price_Top.ValueData,False)      AS isTop        
                       , COALESCE(Price_Fix.ValueData,False)      AS Fix  
                    FROM ObjectLink AS ObjectLink_Price_Unit
                       INNER JOIN ObjectLink AS Price_Goods
                                             ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                       LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                               ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                       LEFT JOIN ObjectBoolean AS MCS_isClose
                                               ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()  
                       LEFT JOIN ObjectFloat AS Price_PercentMarkup
                                             ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()  
                       LEFT JOIN ObjectFloat AS MCS_Value
                                             ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue() 
                       LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                             ON Price_MCSValueMin.ObjectId = ObjectLink_Price_Unit.ObjectId
                                            AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()                                         
                       LEFT JOIN ObjectBoolean AS Price_Fix
                                               ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                       LEFT JOIN ObjectBoolean AS Price_Top
                                               ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                   WHERE ObjectLink_Price_Unit.ChildObjectId = inUnitId
                     AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()   
                     AND COALESCE(MCS_NotRecalc.ValueData,False) = FALSE 
                     AND COALESCE(MCS_isClose.ValueData,False) = FALSE;
    
    --залили пустографку для продаж по дням
    INSERT INTO tmp_SoldGoodsOneDay(GoodsId,NumberOfDay,SoldCount) 
       WITH 
           tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId AS Id
                        FROM ObjectLink AS ObjectLink_Goods_Object
                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
                        WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                          AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                          AND Object_Goods.isErased = FALSE
                        )
       SELECT Object_Goods.ID, NumberDay,0 
       FROM tmp_AllDayCount
           CROSS JOIN tmpGoods AS Object_Goods
           INNER JOIN tmpPrice AS Object_Price
                               ON Object_Price.GoodsId = Object_Goods.Id
                              AND Object_Price.UnitId = inUnitId;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmp_OneDaySold'))
    THEN
      DROP TABLE tmp_OneDaySold;    
    END IF;

    --Таблица для продаж
    CREATE TEMP TABLE tmp_OneDaySold(
        GoodsId   integer not null,
        DayCount  Integer not null,
        Sold      TFloat,
        primary key(GoodsId,DayCount)
    ) ON COMMIT DROP;
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmp_ResultSet'))
    THEN
      DROP TABLE tmp_ResultSet;    
    END IF;

    --результат вычислений
    CREATE TEMP TABLE tmp_ResultSet(
        GoodsId integer not null,
        Period  Integer not null,
        Sold    TFloat  not null,
        primary key(GoodsId,Period)
    ) ON COMMIT DROP;
        
    vbCounter := 1;
    --заливаем продажу на каждый день за inPeriod дней
    INSERT INTO tmp_OneDaySold(GoodsId,DayCount,Sold)
           SELECT MIContainer.ObjectId_analyzer AS GoodsId  
                , inPeriod - DATE_PART ('DAY', CURRENT_DATE - MIContainer.OperDate) AS Period   
                , SUM (round(COALESCE (-1 * MIContainer.Amount, 0),1))    AS Amount
           FROM MovementItemContainer AS MIContainer   
               LEFT OUTER JOIN MovementBoolean AS MovementBoolean_NotMCS
                                               ON MovementBoolean_NotMCS.MovementId = MIContainer.MovementId
                                              AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()
           WHERE MIContainer.WhereObjectId_analyzer = inUnitId
             AND MIContainer.MovementDescId = zc_Movement_Check()
             AND MIContainer.DescId = zc_MIContainer_Count()   
             AND MIContainer.OperDate >= DATE_TRUNC('day', CURRENT_DATE - inPeriod) + CASE WHEN date_part('HOUR',  CURRENT_TIME)::Integer < 12 THEN '0:00'::Time ELSE '12:00'::Time END
             AND MIContainer.OperDate < DATE_TRUNC('day', CURRENT_DATE) + CASE WHEN date_part('HOUR',  CURRENT_TIME)::Integer < 12 THEN '0:00'::Time ELSE '12:00'::Time END   
             AND COALESCE (MovementBoolean_NotMCS.ValueData, FALSE) = FALSE
           GROUP BY MIContainer.ObjectId_analyzer   
                  , DATE_PART ('DAY', CURRENT_DATE - MIContainer.OperDate)
                   ;
       
        
    UPDATE tmp_SoldGoodsOneDay AS DST SET 
        SoldCount = SRC.Sold
    FROM
        tmp_OneDaySold AS SRC
    WHERE
        DST.GoodsId = SRC.GoodsId
        and 
        DST.NumberOfDay = SRC.DayCount;
    
    INSERT INTO tmp_ResultSet(GoodsId,Period,Sold)
    SELECT 
        S1.GoodsId, 
        S1.NumberOfDay, 
        SUM(S2.SoldCount)
    FROM 
        tmp_SoldGoodsOneDay AS S1
        LEFT OUTER JOIN tmp_SoldGoodsOneDay AS S2
                                            ON S2.GoodsId = S1.GoodsId
                                           AND S2.NumberOfDay >= S1.NumberOfDay
                                           AND S2.NumberOfDay <= (S1.NumberOfDay + inDay - 1)
    GROUP BY 
        S1.GoodsId,
        S1.NumberOfDay;

 CREATE TEMP TABLE tmpResult ON COMMIT DROP AS       
    SELECT tmp_ResultSet.GoodsId
         , Object_Goods_Main.ObjectCode AS GoodsCode
         , Object_Goods_Main.Name       AS GoodsName
         , Object_Price.MCSValue
         , Max(tmp_ResultSet.Sold)::TFloat AS Sold
         , Max(tmpAVE.SoldAVE)::TFloat     AS SoldAVE
         , Max(tmpAVE.SoldMax)::TFloat     AS SoldMax
         
         , COALESCE(Max(tmp_ResultSet.Sold), 0) <> COALESCE(Object_Price.MCSValue,0)  AS isOk
         , CASE WHEN COALESCE(Max(tmp_ResultSet.Sold), 0) = COALESCE(Object_Price.MCSValue,0) 
                THEN zfCalc_Color (0, 255, 0) -- Lime 
                ELSE zfCalc_Color (255, 228, 225) -- MistyRose 
           END  AS Calc_Color

    FROM tmp_ResultSet 
        INNER JOIN tmpPrice AS Object_Price
                            ON Object_Price.GoodsId = tmp_ResultSet.GoodsId
                           AND Object_Price.UnitId = inUnitId 
        INNER JOIN (SELECT tmp_ResultSet.GoodsId
                         , (SUM(tmp_ResultSet.Sold) / COUNT(*))::TFloat AS SoldAVE
                         , MAX(tmp_ResultSet.Sold)::TFloat              AS SoldMax
                    FROM tmp_ResultSet
                    WHERE tmp_ResultSet.Sold <> 0
                    GROUP BY tmp_ResultSet.GoodsId) AS tmpAVE
                                                    ON tmpAVE.GoodsId = tmp_ResultSet.GoodsId
        INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmp_ResultSet.GoodsId
        INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainID
    WHERE tmp_ResultSet.Sold <= (tmpAVE.SoldAVE * 2)::TFloat
    GROUP BY tmp_ResultSet.GoodsId
           , Object_Goods_Main.ObjectCode
           , Object_Goods_Main.Name
           , Object_Price.MCSValue
    --HAVING COALESCE(Max(tmp_ResultSet.Sold), 0) <> COALESCE(Object_Price.MCSValue,0)
    ;
    
    -- Данные 
    OPEN curDate FOR
        SELECT tmp_AllDayCount.NumberDay AS ValueName
        FROM tmp_AllDayCount
        ORDER BY tmp_AllDayCount.NumberDay;
                  
     -- начало цикла по курсору1
     LOOP
        -- данные по курсору1
        FETCH curDate INTO vbNumberDay;
        -- если данные закончились, тогда выход
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Value'||vbNumberDay::TVarChar || ' TFloat';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpResult SET Value'||vbNumberDay::Text||' = tmp_ResultSet.Sold
           FROM tmp_ResultSet
           WHERE tmpResult.GoodsId = tmp_ResultSet.GoodsId
             AND tmp_ResultSet.Period = '||vbNumberDay::Text;
             
        EXECUTE vbQueryText;
        
    END LOOP; -- финиш цикла по курсору1
    CLOSE curDate; -- закрыли курсор1 
    
    -- Результат
    
    OPEN cur1 FOR SELECT tmp_AllDayCount.NumberDay ::TVarChar AS ValueName
                   FROM tmp_AllDayCount
                   ORDER BY tmp_AllDayCount.NumberDay;

    RETURN NEXT cur1;

    OPEN cur2 FOR SELECT * FROM tmpResult
                  ORDER BY tmpResult.GoodsName;  
    RETURN NEXT cur2;     
    
     raise notice 'Value 05: %', (SELECT COUNT(*) FROM tmpResult);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_RecalcMCS(Integer, Integer, Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 20.04.22                                                      *
 */
----
--select * from gpReport_RecalcMCS (inUnitId := 3457773 , inPeriod := 40 , inDay := 6 ,  inSession := '424351')
select * from gpReport_RecalcMCS(inUnitId := 18712420 , inPeriod := 30 , inDay := 6 ,  inSession := '3');
-- Function: gpSelect_RecalcMCS (Integer, Integer, Integer, TVarChar)


DROP FUNCTION IF EXISTS gpSelect_RecalcMCS (Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_RecalcMCS(
    IN inUnitId              Integer   , -- Подразделение
    IN inPeriod              Integer   , -- С какого дня
    IN inDay                 Integer   , -- Сколько дней брать в расчет
    IN inStartDate           TDateTime,  -- Дата остатка
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE ( MCSValue TFloat
              , GoodsId Integer
              , UnitId Integer 
              )
AS
$BODY$
    DECLARE vbCounter integer;
    DECLARE vbSold    TFloat;
    DECLARE vbObjectId Integer;
    DECLARE vbUserId Integer;
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
    
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
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
    
    --товар / день / продажа
    CREATE TEMP TABLE tmp_SoldGoodsOneDay(
        GoodsId  integer not null,
        NumberOfDay      Integer not null,
        SoldCount        TFloat  not null,
        primary key(UnitId,GoodsId,NumberOfDay)
    ) ON COMMIT DROP;

    --залили пустографку для продаж по дням
    INSERT INTO tmp_SoldGoodsOneDay( GoodsId,NumberOfDay,SoldCount) 
    SELECT Object_Goods.ID, NumberDay,0 
    from 
        tmp_AllDayCount
        CROSS JOIN Object_Goods_View AS Object_Goods
        LEFT OUTER JOIN Object_Price_View AS Object_Price
                                          ON Object_Price.GoodsId = Object_Goods.Id
                                         AND (Object_Price.UnitId = inUnitId )
    WHERE 
        Object_Goods.IsErased = FALSE
        AND
        Object_Goods.ObjectId = vbObjectId
        AND
        COALESCE(Object_Price.MCSNotRecalc,FALSE) = FALSE
        AND
        COALESCE(Object_Price.MCSIsClose,FALSE) = FALSE;

    --Таблица для продаж
    CREATE TEMP TABLE tmp_OneDaySold(
        GoodsId   integer not null,
        DayCount  Integer not null,
        Sold      TFloat,
        primary key(GoodsId,DayCount)
    ) ON COMMIT DROP;
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
    SELECT 
        MovementItem_Check.GoodsId,
        inPeriod - DATE_PART('day', inStartDate - Movement_Check.OperDate) AS Period,
        sum(round(MovementItem_Check.Amount,1))    AS Amount
    from 
        Movement_Check_View AS Movement_Check
        INNER JOIN MovementItem_Check_View AS MovementItem_Check
                                           ON MovementItem_Check.MovementId = Movement_Check.Id
                                          AND MovementItem_Check.isErased = False
                                          AND MovementItem_Check.Amount > 0
        INNER JOIN Object_Goods_View AS Object_Goods
                                     ON Object_Goods.Id = MovementItem_Check.GoodsId
                                    AND Object_Goods.isErased = False 
    WHERE
        Movement_Check.StatusId = zc_Enum_Status_Complete()
        AND
        (Movement_Check.UnitId = inUnitId )
        AND
        DATE_TRUNC('day', Movement_Check.OperDate) >= DATE_TRUNC('day', inStartDate::Date - inPeriod - 1)
        AND
        DATE_TRUNC('day', Movement_Check.OperDate) <= DATE_TRUNC('day', inStartDate::Date - 1)
        AND
        COALESCE(Movement_Check.NotMCS,FALSE) = FALSE
    GROUP BY 
        MovementItem_Check.GoodsId, 
        DATE_PART('day', inStartDate - Movement_Check.OperDate);

       
    UPDATE tmp_SoldGoodsOneDay AS DST SET 
        SoldCount = SRC.Sold
    FROM
        tmp_OneDaySold AS SRC
    WHERE DST.GoodsId = SRC.GoodsId
      and DST.NumberOfDay = SRC.DayCount;
    
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
    GROUP BY S1.GoodsId,
             S1.NumberOfDay;

    RETURN QUERY
    SELECT MAX(tmp_ResultSet.Sold)::TFloat   AS MCSValue    -- Неснижаемый товарный запас
         , tmp_ResultSet.GoodsId                            -- Товар
         , inUnitId                          AS UnitId      -- подразделение
    FROM tmp_ResultSet
        LEFT OUTER JOIN Object_Price_View AS Object_Price
                                          ON Object_Price.GoodsId = tmp_ResultSet.GoodsId
                                         AND Object_Price.UnitId = tmp_ResultSet.UnitId  
    WHERE COALESCE(Object_Price.MCSNotRecalc,FALSE) = FALSE
      AND COALESCE(Object_Price.MCSIsClose,FALSE) = FALSE
    GROUP BY  tmp_ResultSet.GoodsId
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

--select * from gpSelect_RecalcMCS(inUnitId := 377574 , inPeriod := 90 , inDay := 5 ,  inStartDate:= '01.06.2016', inSession := '3');
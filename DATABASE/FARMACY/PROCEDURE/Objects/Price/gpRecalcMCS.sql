-- Function: gpRecalcMCS (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpRecalcMCS (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpRecalcMCS(
    IN inUnitId              Integer   , -- �������������
    IN inPeriod              Integer   , -- � ������ ���
    IN inDay                 Integer   , -- ������� ���� ����� � ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
    DECLARE vbCounter integer;
    DECLARE vbSold    TFloat;
    DECLARE vbObjectId Integer;
    DECLARE vbUserId Integer;
BEGIN

    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� �������������';
    END IF;
    IF inPeriod < 1
    THEN
        RAISE EXCEPTION '������. ���������� ���� ��� �������<%> �� ����� ���� ������ 1',inPeriod;
    END IF;
    
    IF inDay < 1
    THEN
        RAISE EXCEPTION '������. ���������� ���� ���������� ������<%> �� ����� ���� ������ 1',inDay;
    END IF;
    
    vbUserId := inSession; 
    
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    --����������� � �����
    CREATE TEMP TABLE tmp_AllDayCount(
        NumberDay        Integer not null,
        primary key(NumberDay)
    ) ON COMMIT DROP;
    vbCounter := 1;
    WHILE vbCounter <= inPeriod LOOP
        INSERT INTO tmp_AllDayCount( NumberDay ) values( vbCounter );
        vbCounter := vbCounter + 1;
    END LOOP;
    
    --����� / ���� / �������
    CREATE TEMP TABLE tmp_SoldGoodsOneDay(
        GoodsId  integer not null,
        NumberOfDay      Integer not null,
        SoldCount        TFloat  not null,
        primary key(GoodsId,NumberOfDay)
    ) ON COMMIT DROP;   
    
    --
    CREATE TEMP TABLE tmpPrice  (UnitId Integer, GoodsId Integer, MCSValue TFloat, PercentMarkup TFloat, isTop Boolean, Fix Boolean) ON COMMIT DROP;  
    INSERT INTO tmpPrice (UnitId, GoodsId, PercentMarkup, isTop, Fix)  
                    SELECT ObjectLink_Price_Unit.ChildObjectId    AS UnitId
                       , Price_Goods.ChildObjectId                AS GoodsId     
                       , MCS_Value.ValueData                      AS MCSValue
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
                                             ON MCS_Value.ObjectId = Object_Price.Id
                                            AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()                                          
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
    
    --������ ����������� ��� ������ �� ����
    INSERT INTO tmp_SoldGoodsOneDay(GoodsId,NumberOfDay,SoldCount) 
    SELECT Object_Goods.ID, NumberDay,0 
    FROM tmp_AllDayCount
        CROSS JOIN Object_Goods_View AS Object_Goods
        INNER JOIN tmpPrice AS Object_Price
                            ON Object_Price.GoodsId = Object_Goods.Id
                           AND Object_Price.UnitId = inUnitId 
    WHERE Object_Goods.IsErased = FALSE
      AND Object_Goods.ObjectId = vbObjectId;

    --������� ��� ������
    CREATE TEMP TABLE tmp_OneDaySold(
        GoodsId   integer not null,
        DayCount  Integer not null,
        Sold      TFloat,
        primary key(GoodsId,DayCount)
    ) ON COMMIT DROP;
    --��������� ����������
    CREATE TEMP TABLE tmp_ResultSet(
        GoodsId integer not null,
        Period  Integer not null,
        Sold    TFloat  not null,
        primary key(GoodsId,Period)
    ) ON COMMIT DROP;
        
    vbCounter := 1;
    --�������� ������� �� ������ ���� �� inPeriod ����
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
             AND MIContainer.OperDate >= DATE_TRUNC('day', CURRENT_DATE - inPeriod - 1)
             AND MIContainer.OperDate < DATE_TRUNC('day', CURRENT_DATE - 1)   
             AND COALESCE (MovementBoolean_NotMCS.ValueData, FALSE) = FALSE
           GROUP BY MIContainer.ObjectId_analyzer   
                  , DATE_PART ('DAY', inStartDate - MIContainer.OperDate) ;
       
        
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

    PERFORM gpInsertUpdate_Object_Price(ioId           := 0,                    -- ���� ������� < ���� >
                                        ioStartDate    := zc_dateEnd(),         -- 
                                        inPrice        := NULL::TFloat,         -- ����
                                        inMCSValue     := MAX(Sold)::TFloat,    -- ����������� �������� �����
                                        inMCSPeriod    := inPeriod::TFloat,     --
                                        inMCSDay       := inDay::TFloat,        --
                                        inPercentMarkup:= Object_Price.PercentMarkup, -- % �������
                                        inGoodsId      := tmp_ResultSet.GoodsId,-- �����
                                        inUnitId       := inUnitId,             -- �������������
                                        inMCSIsClose   := NULL::Boolean,        -- ��� ������
                                        inMCSNotRecalc := NULL::Boolean,        -- ��� �� ���������������
                                        inFix          := Object_Price.Fix,     -- ������������� ����
                                        inisTop        := Object_Price.isTop,   -- ��� �������
                                        inSession      := inSession)
    FROM 
        tmp_ResultSet
        INNER JOIN tmpPrice AS Object_Price
                            ON Object_Price.GoodsId = tmp_ResultSet.GoodsId
                           AND Object_Price.UnitId = inUnitId 
    GROUP BY
        tmp_ResultSet.GoodsId,
        Object_Price.MCSValue,
        Object_Price.isTop,
        Object_Price.PercentMarkup,
        Object_Price.Fix
    HAVING  COALESCE(MAX(Sold),0)::TFloat <> COALESCE(Object_Price.MCSValue,0);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRecalcMCS(Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  
 24.02.17         *
 04.07.16         * add PercentMarkup
 29.08.15                                                         *
 */

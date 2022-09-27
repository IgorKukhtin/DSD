-- Function: gpReport_Object_Price_MCS_Year (TVarChar)

DROP FUNCTION IF EXISTS gpReport_Object_Price_MCS_Year(Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Object_Price_MCS_Year(
    IN inUnitId      Integer,       -- подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat, MCSValueYear TFloat, MCSValueMax TFloat
             , MCSValueProc TFloat, UnitId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MCSDateChange TDateTime
             , isErased boolean
             , isClose boolean, isFirst boolean , isSecond boolean
             , isTop boolean
             , Remains TFloat
             , MCSValueNew TFloat
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
    vbStartDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbStartDate:= DATE_TRUNC ('DAY', CURRENT_DATE);

    RETURN QUERY
      WITH      
    -- данные из прай листа
      tmpPrice AS (SELECT Object_Price.Id                           AS Id
                        , Price_Goods.ChildObjectId                 AS GoodsId
                        , ROUND(Price_Value.ValueData,2)   ::TFloat AS Price
                        , COALESCE (MCS_Value.ValueData,0) ::TFloat AS MCSValue
                        , MCS_datechange.valuedata                  AS MCSDateChange
                        , ObjectLink_Price_Unit.ChildObjectId       AS UnitId
                   FROM Object AS Object_Price
                      INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                  ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                 AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                 AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                      LEFT JOIN ObjectLink        AS Price_Goods
                             ON Price_Goods.ObjectId = Object_Price.Id
                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                      LEFT JOIN ObjectFloat AS Price_Value
                                  ON Price_Value.ObjectId = Object_Price.Id
                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                      LEFT JOIN ObjectFloat       AS MCS_Value
                                  ON MCS_Value.ObjectId = Object_Price.Id
                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                      LEFT JOIN ObjectDate        AS MCS_DateChange
                                  ON MCS_DateChange.ObjectId = Object_Price.Id
                                 AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                   WHERE Object_Price.DescId = zc_Object_Price()
                  )
    , tmpObjectHistory_Year AS (SELECT tmpPrice.Id
                                     , ObjectHistoryFloat_Price_MCSValue.ValueData              AS MCSValue
                                FROM tmpPrice
                                     
                                     INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = tmpPrice.Id
                                                             AND ObjectHistory.DescId = zc_ObjectHistory_Price()
                                                             AND ObjectHistory.StartDate <= CURRENT_DATE - INTERVAL '1 YEAR'
                                                             AND ObjectHistory.EndDate > CURRENT_DATE - INTERVAL '1 YEAR'

                                     LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price_MCSValue
                                                                  ON ObjectHistoryFloat_Price_MCSValue.ObjectHistoryId = ObjectHistory.Id
                                                                 AND ObjectHistoryFloat_Price_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()
                                                                 
                                     -- получаем значения Количество дней для анализа НТЗ из истории значений на дату    
                                     LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                                                  ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory.Id
                                                                 AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                                                                 
                                WHERE COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)  < 45                                    
                            )
    , tmpObjectHistory_Max AS (SELECT tmpPrice.Id
                                    , MAX(ObjectHistoryFloat_Price_MCSValue.ValueData)::TFloat    AS MCSValue
                               FROM tmpPrice
                                     
                                    INNER JOIN ObjectHistory ON ObjectHistory.ObjectId = tmpPrice.Id
                                                            AND ObjectHistory.DescId = zc_ObjectHistory_Price()
                                                            AND ObjectHistory.EndDate > CURRENT_DATE - INTERVAL '1 YEAR'

                                    LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price_MCSValue
                                                                 ON ObjectHistoryFloat_Price_MCSValue.ObjectHistoryId = ObjectHistory.Id
                                                                AND ObjectHistoryFloat_Price_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()

                                     -- получаем значения Количество дней для анализа НТЗ из истории значений на дату    
                                     LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                                                  ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory.Id
                                                                 AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()

                              WHERE COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)  < 45
                              GROUP BY tmpPrice.Id      
                              )
    , tmpContainerCount AS (SELECT Container.ObjectId              AS GoodsId
                                 , Sum(Container.Amount)::TFloat   AS Remains
                            FROM Container
                            WHERE Container.DescId = zc_Container_count()
                              AND Container.WhereObjectId = inUnitId
                              AND Container.Amount <> 0
                            GROUP BY Container.ObjectId
                            )      
                          
    SELECT tmpPrice.Id
         , COALESCE (tmpPrice.Price,0)    :: TFloat AS Price
         , COALESCE (tmpPrice.MCSValue,0) :: TFloat AS MCSValue
         
         , tmpObjectHistory_Year.MCSValue           AS MCSValueYear
         , tmpObjectHistory_Max.MCSValue            AS MCSValueMax
         
         , CASE WHEN COALESCE(tmpObjectHistory_Year.MCSValue, 0) = 0 
                THEN NULL
                ELSE COALESCE (tmpPrice.MCSValue,0) / tmpObjectHistory_Year.MCSValue END::TFloat AS MCSValueProc
               
         , tmpPrice.UnitId               
         , tmpPrice.GoodsId
         , Object_Goods_Main.ObjectCode             AS GoodsCode
         , Object_Goods_Main.Name                   AS GoodsName
         , tmpPrice.MCSDateChange                   AS MCSDateChange
         , Object_Goods_Retail.isErased             AS isErased 
         , Object_Goods_Main.isClose
         , Object_Goods_Retail.isFirst
         , Object_Goods_Retail.isSecond
         , Object_Goods_Retail.isTop
         , tmpContainerCount.Remains 
         , 0::TFloat                                AS MCSValueNew
    FROM tmpPrice
        
        JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpPrice.goodsid
        JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
            
        LEFT JOIN tmpContainerCount ON tmpContainerCount.goodsid = tmpPrice.goodsid
        
        LEFT JOIN tmpObjectHistory_Year ON tmpObjectHistory_Year.Id = tmpPrice.Id

        LEFT JOIN tmpObjectHistory_Max ON tmpObjectHistory_Max.Id = tmpPrice.Id
            
    WHERE COALESCE (tmpPrice.MCSValue, 0) > 0
       OR COALESCE (tmpObjectHistory_Year.MCSValue, 0) > 0
       OR COALESCE (tmpObjectHistory_Max.MCSValue, 0) > 0
    ORDER BY GoodsName;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 20.09.22                                                      *
*/

-- тест
--
select * from gpReport_Object_Price_MCS_Year(inUnitId := 183292 ,  inSession := '3');
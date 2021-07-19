-- Function: gpSelect_ObjectHistory_DiscountPeriodItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_DiscountPeriod (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_DiscountPeriod(
    IN inStartDate          TDateTime , -- Дата
    IN inEndDate            TDateTime , -- Дата
    IN inUnitId             Integer   , -- подразделение
    IN inBrandId            Integer   , -- торговая марка
    IN inPeriodId           Integer   , -- сезон
    IN inStartYear          Integer   , -- Год с ...
    IN inEndYear            Integer   , -- Год по ...
    IN inIsYear             Boolean   , -- ограничение Год ТМ (Да/Нет) (выбор партий)
    IN inIsValue            Boolean   , -- показать значение скидки (Да/Нет)
    IN inIsBrand            Boolean  ,  -- показать <торговая марка> (Да/Нет)
    IN inIsPeriodYear       Boolean  ,  -- показать <Год>  (Да/Нет)
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE  (  UnitId               Integer
                , UnitName             TVarChar
                , BrandName            TVarChar
                , PeriodName           TVarChar
                , PeriodYear           Integer
                , StartDate            TDateTime
                , EndDate              TDateTime
                , myCount              Integer
                , ValueDiscount        TFloat
                , ValueNextDiscount    TFloat
                , ValueDiscount_min    TFloat
                , ValueDiscount_max    TFloat
                , YEAR_Start           Integer
                , YEAR_End             Integer
               )
AS
$BODY$
BEGIN

    -- !!!замена!!!
    IF inIsYear = TRUE AND COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;

    -- Выбираем данные
     RETURN QUERY
       WITH tmpDiscount AS
                  (SELECT ObjectLink_Unit.ChildObjectId AS UnitId
                        , Object_PartionGoods.PeriodId  AS PeriodId
                        , CASE WHEN inIsValue      = TRUE THEN ObjectHistoryFloat_Value.ValueData     ELSE 0 END AS ValueDiscount
                        , CASE WHEN inIsValue      = TRUE THEN ObjectHistoryFloat_ValueNext.ValueData ELSE 0 END AS ValueNextDiscount
                        , CASE WHEN inIsBrand      = TRUE THEN Object_PartionGoods.BrandId        ELSE 0 END AS BrandId
                        , CASE WHEN inIsPeriodYear = TRUE THEN Object_PartionGoods.PeriodYear     ELSE 0 END AS PeriodYear
                        , COUNT (*) AS myCount
                        , MIN (ObjectHistory_DiscountPeriodItem.StartDate) AS StartDate
                        , MAX (ObjectHistory_DiscountPeriodItem.EndDate)   AS EndDate
                        , MIN (ObjectHistoryFloat_Value.ValueData)         AS ValueDiscount_min
                        , MAX (ObjectHistoryFloat_Value.ValueData)         AS ValueDiscount_max

                        , CASE WHEN Object_Period.ObjectCode = 1 THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                               WHEN Object_Period.ObjectCode = 2
                                AND ObjectHistory_DiscountPeriodItem.StartDate BETWEEN DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate)
                                                                                   AND DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate) + INTERVAL '9 MONTH'
                                    THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate) - 1
                               WHEN Object_Period.ObjectCode = 2
                                    THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                               ELSE 0
                          END AS YEAR_Start
                        , CASE WHEN Object_Period.ObjectCode = 1 THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                               WHEN Object_Period.ObjectCode = 2
                                AND ObjectHistory_DiscountPeriodItem.StartDate BETWEEN DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate)
                                                                                   AND DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate) + INTERVAL '9 MONTH'
                                    THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                               WHEN Object_Period.ObjectCode = 2
                                    THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate) + 1
                               ELSE 0
                          END AS YEAR_End

                   FROM ObjectLink AS ObjectLink_Unit
                        LEFT JOIN ObjectLink AS ObjectLink_Goods
                                             ON ObjectLink_Goods.ObjectId = ObjectLink_Unit.ObjectId
                                            AND ObjectLink_Goods.DescId   = zc_ObjectLink_DiscountPeriodItem_Goods()
                        LEFT JOIN Object_PartionGoods     ON Object_PartionGoods.GoodsId = ObjectLink_Goods.ChildObjectId
                        LEFT JOIN Object AS Object_Period ON Object_Period.Id            = Object_PartionGoods.PeriodId

                        INNER JOIN ObjectHistory AS ObjectHistory_DiscountPeriodItem
                                                 ON ObjectHistory_DiscountPeriodItem.ObjectId = ObjectLink_Unit.ObjectId
                                                AND ObjectHistory_DiscountPeriodItem.DescId   = zc_ObjectHistory_DiscountPeriodItem()
                                                AND (ObjectHistory_DiscountPeriodItem.StartDate BETWEEN DATE_TRUNC ('YEAR', inStartDate)
                                                                                                    AND CASE WHEN Object_Period.ObjectCode = 1
                                                                                                                  THEN DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '9 MONTH'
                                                                                                             ELSE DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '18 MONTH'
                                                                                                        END
                                                  AND ObjectHistory_DiscountPeriodItem.EndDate  BETWEEN DATE_TRUNC ('YEAR', inStartDate)
                                                                                                    AND CASE WHEN Object_Period.ObjectCode = 1
                                                                                                                  THEN DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '9 MONTH'
                                                                                                             ELSE DATE_TRUNC ('YEAR', inStartDate) + INTERVAL '18 MONTH'
                                                                                                        END
                                                  -- OR ObjectHistory_DiscountPeriodItem.EndDate   BETWEEN inStartDate AND inEndDate
                                                  -- OR inStartDate   BETWEEN ObjectHistory_DiscountPeriodItem.StartDate AND ObjectHistory_DiscountPeriodItem.EndDate
                                                  -- OR inEndDate     BETWEEN ObjectHistory_DiscountPeriodItem.StartDate AND ObjectHistory_DiscountPeriodItem.EndDate
                                                    )
                        INNER JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                                      ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                     AND ObjectHistoryFloat_Value.DescId          = zc_ObjectHistoryFloat_DiscountPeriodItem_Value()
                                                     AND ObjectHistoryFloat_Value.ValueData       <> 0
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_ValueNext
                                                     ON ObjectHistoryFloat_ValueNext.ObjectHistoryId = ObjectHistory_DiscountPeriodItem.Id
                                                    AND ObjectHistoryFloat_ValueNext.DescId          = zc_ObjectHistoryFloat_DiscountPeriodItem_ValueNext()
                   WHERE ObjectLink_Unit.DescId        = zc_ObjectLink_DiscountPeriodItem_Unit()
                     AND (ObjectLink_Unit.ChildObjectId = inUnitId OR inUnitId = 0)
                     AND (Object_PartionGoods.BrandId    = inBrandId OR inBrandId = 0)
                     AND (Object_PartionGoods.PeriodId   = inPeriodId OR inPeriodId = 0)
                     AND ((Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear) OR inIsYear = FALSE)
                     AND (Object_PartionGoods.PeriodYear = EXTRACT (YEAR FROM inStartDate)   OR inIsYear = TRUE)
                   GROUP BY ObjectLink_Unit.ChildObjectId
                          , Object_PartionGoods.PeriodId
                          , CASE WHEN inIsValue      = TRUE THEN ObjectHistoryFloat_Value.ValueData     ELSE 0 END
                          , CASE WHEN inIsValue      = TRUE THEN ObjectHistoryFloat_ValueNext.ValueData ELSE 0 END
                          , CASE WHEN inIsBrand      = TRUE THEN Object_PartionGoods.BrandId        ELSE 0 END
                          , CASE WHEN inIsPeriodYear = TRUE THEN Object_PartionGoods.PeriodYear     ELSE 0 END
                          , CASE WHEN Object_Period.ObjectCode = 1 THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                                 WHEN Object_Period.ObjectCode = 2
                                  AND ObjectHistory_DiscountPeriodItem.StartDate BETWEEN DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate)
                                                                                     AND DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate) + INTERVAL '9 MONTH'
                                      THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate) - 1
                                 WHEN Object_Period.ObjectCode = 2
                                      THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                                 ELSE 0
                            END
                          , CASE WHEN Object_Period.ObjectCode = 1 THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                                 WHEN Object_Period.ObjectCode = 2
                                  AND ObjectHistory_DiscountPeriodItem.StartDate BETWEEN DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate)
                                                                                     AND DATE_TRUNC ('YEAR', ObjectHistory_DiscountPeriodItem.StartDate) + INTERVAL '9 MONTH'
                                      THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate)
                                 WHEN Object_Period.ObjectCode = 2
                                      THEN EXTRACT (YEAR FROM ObjectHistory_DiscountPeriodItem.StartDate) + 1
                                 ELSE 0
                            END
                   )
       -- Результат
       SELECT Object_Unit.Id                             AS UnitId
            , Object_Unit.ValueData                      AS UnitName
            , Object_Brand.ValueData                     AS BrandName
            , Object_Period.ValueData                    AS PeriodName
            , tmpDiscount.PeriodYear        :: Integer   AS PeriodYear
            , tmpDiscount.StartDate         :: TDateTime AS StartDate
            , tmpDiscount.EndDate           :: TDateTime AS EndDate
            , tmpDiscount.myCount           :: Integer   AS myCount
            , tmpDiscount.ValueDiscount     :: TFloat    AS ValueDiscount
            , tmpDiscount.ValueNextDiscount :: TFloat    AS ValueNextDiscount
            , tmpDiscount.ValueDiscount_min :: TFloat    AS ValueDiscount_min
            , tmpDiscount.ValueDiscount_max :: TFloat    AS ValueDiscount_max
            , tmpDiscount.YEAR_Start        :: Integer   AS YEAR_Start
            , tmpDiscount.YEAR_End          :: Integer   AS YEAR_End
       FROM tmpDiscount
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpDiscount.UnitId
            LEFT JOIN Object AS Object_Brand   ON Object_Brand.Id   = tmpDiscount.BrandId
            LEFT JOIN Object AS Object_Period  ON Object_Period.Id  = tmpDiscount.PeriodId
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_DiscountPeriod (inStartDate:= '01.07.2017', inEndDate:= '01.07.2017', inUnitId:= 1487, inBrandId:= 0, inPeriodId:= 0, inStartYear:= 0, inEndYear:= 2017, inIsYear:= FALSE, inIsValue:= FALSE, inIsBrand:= FALSE, inIsPeriodYear:= FALSE, inSession:= zfCalc_UserAdmin())

-- Function: gpSelect_KilledCodeRecovery()

DROP FUNCTION IF EXISTS gpSelect_KilledCodeRecovery (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_KilledCodeRecovery(
    IN inRangeOfDays      Integer  ,  -- Диапозон дней
    IN inPercePharmaciesd TFloat   ,  -- % аптек
    IN inSalesThreshold   TFloat   ,  -- Порог продаж
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
                UnitName TVarChar
              , GoodsCode Integer
              , GoodsName TVarChar
              , MCSIsCloseDateChange TDateTime
              , CountUnit Integer
              , CountSelling Integer
              , CountUnitAll Integer
              , GoodsCount Integer
  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
     WITH tmpGoods AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , Object_Unit.valuedata             AS UnitName
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , Object_Goods.objectcode           AS GoodsCode
                            , Object_Goods.valuedata            AS GoodsName
                            , MCS_Value.ValueData               AS MCSValue
                            , MCS_isClose.ValueData             AS isClose
                            , MCSIsClose_DateChange.valuedata   AS MCSIsCloseDateChange
                       FROM ObjectLink AS OL_Price_Unit

                            INNER JOIN ObjectBoolean AS MCS_isClose
                                                     ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                    AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                    AND MCS_isClose.ValueData = TRUE
                            LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                                 ON MCSIsClose_DateChange.ObjectId = OL_Price_Unit.ObjectId
                                                AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()

                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN Object AS Object_Unit
                                             ON Object_Unit.Id       = OL_Price_Unit.ChildObjectId
                            LEFT JOIN Object AS Object_Goods
                                             ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            AND Object_Goods.isErased = FALSE

                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = OL_Price_Unit.ChildObjectId
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Juridical_Retail.childobjectid = 4
                         AND Object_Unit.ValueData not ILIKE '%закры%'),
          tmpUnit AS (SELECT DISTINCT tmpGoods.UnitId FROM tmpGoods),
          tmpUnitCount AS (SELECT Count(*) as CountUnit FROM tmpUnit),
          tmpGoodsUnitCount AS (SELECT tmpGoods.GoodsId
                                     , COUNT(*)           AS CountUnit
                                FROM tmpGoods
                                GROUP BY tmpGoods.GoodsId
                                HAVING COUNT(*) <= FLOOR((SELECT COUNT(*) FROM tmpUnit) - (SELECT COUNT(*) FROM tmpUnit) * inPercePharmaciesd / 100)
                                ),
          tmpSelling AS (SELECT ACI.GoodsId                   AS GoodsId
                              , ACI.UnitId                    AS UnitId
                              , SUM(ACI.AmountCheck)          AS AmountCheck
                         FROM tmpGoodsUnitCount

                              INNER JOIN tmpUnit ON 1= 1

                              INNER JOIN AnalysisContainerItem AS ACI
                                                               ON ACI.GoodsId = tmpGoodsUnitCount.GoodsId
                                                              AND ACI.UnitId = tmpUnit.UnitId
                                                              AND ACI.OperDate >= CURRENT_DATE - ((inRangeOfDays + 1)::TVarChar||' DAY')::INTERVAL

                         GROUP BY ACI.GoodsId
                                , ACI.UnitId
                        ),
           tmpSellingCount AS (SELECT tmpSelling.GoodsId
                                    , COUNT(*)           AS CountSelling
                               FROM tmpSelling
                               WHERE tmpSelling.AmountCheck >= inSalesThreshold
                               GROUP BY tmpSelling.GoodsId
                               ),
           tmpDate AS (SELECT tmpGoods.UnitName
                            , tmpGoods.GoodsId
                            , tmpGoods.GoodsCode
                            , tmpGoods.GoodsName
                            , tmpGoods.MCSIsCloseDateChange
                            , tmpGoodsUnitCount.CountUnit::Integer
                            , tmpSellingCount.CountSelling::Integer
                       FROM tmpGoods

                            INNER JOIN tmpGoodsUnitCount ON tmpGoodsUnitCount.GoodsId = tmpGoods.GoodsId

                            INNER JOIN tmpSellingCount ON tmpSellingCount.GoodsId = tmpGoods.GoodsId
                                                      AND tmpSellingCount.CountSelling >= CEIL((SELECT COUNT(*) FROM tmpUnit) - (SELECT COUNT(*) FROM tmpUnit) * inPercePharmaciesd / 100)),
           tmpDataCount AS (SELECT Count(DISTINCT tmpDate.GoodsId) as GoodsCount FROM tmpDate)

    SELECT tmpDate.UnitName
         , tmpDate.GoodsCode
         , tmpDate.GoodsName
         , tmpDate.MCSIsCloseDateChange
         , tmpDate.CountUnit
         , tmpDate.CountSelling
         , tmpUnitCount.CountUnit::Integer
         , tmpDataCount.GoodsCount::Integer
    FROM tmpDate

         INNER JOIN tmpUnitCount ON 1 = 1

         INNER JOIN tmpDataCount ON 1 = 1

    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.04.21                                                       *
*/

-- тест

SELECT * FROM gpSelect_KilledCodeRecovery(200, 60, 1, '3')
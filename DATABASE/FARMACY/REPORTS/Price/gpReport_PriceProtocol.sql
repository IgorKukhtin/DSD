-- Function: gpReport_PriceProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_PriceProtocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceProtocol(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer , --
    IN inUserId             Integer , --
    IN inGoodsId            Integer   ,
    IN inSession            TVarChar  -- сессия пользователя
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , OperDate      TDateTime
             , Price         TFloat
             , Price_before  TFloat
             , PersentDiff   TFloat
             , IsInsert      Boolean

              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- Результат
   RETURN QUERY 
    WITH 
    tmpProtocol AS (SELECT ObjectProtocol.OperDate
                         , ObjectProtocol.UserId
                         , Price_Goods.ChildObjectId               AS GoodsId
                         , ObjectLink_Price_Unit.ObjectId          AS PriceId
                         , ObjectProtocol.isInsert
                         , CAST (REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение цены реализации"]/@FieldValue', ObjectProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') AS TFloat) AS Price
                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectProtocol ON ObjectProtocol.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                     AND (ObjectProtocol.OperDate >= inStartDate AND ObjectProtocol.OperDate < inEndDate + INTERVAL '1 DAY')
                                                     AND (ObjectProtocol.UserId = inUserId OR inUserId = 0)
                                                     AND ObjectProtocol.UserId <> 3

                            INNER JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                 AND (Price_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                    )

  , tmpCount AS (SELECT tmpProtocol.PriceId
                      , COUNT (DISTINCT tmpProtocol.Price)
                 FROM tmpProtocol
                 GROUP BY tmpProtocol.PriceId
                 HAVING  count(DISTINCT tmpProtocol.Price) > 1
                )

    -- Результат
    SELECT Object_User.Id                    AS UserId
         , Object_User.ObjectCode ::Integer  AS UserCode
         , Object_User.ValueData             AS UserName
         , Object_Goods.ObjectCode           AS GoodsCode
         , Object_Goods.ValueData            AS GoodsName
         , tmpProtocol.OperDate ::TDateTime
         , tmpProtocol.Price    ::TFloat
         , COALESCE (ObjectHistoryFloat_Price.ValueData, 0) :: TFloat AS Price_before
         , CASE WHEN COALESCE (ObjectHistoryFloat_Price.ValueData, 0) <> 0 THEN (COALESCE (ObjectHistoryFloat_Price.ValueData, 0) - COALESCE (tmpProtocol.Price,0) ::TFloat )*100 / COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END ::TFloat AS PersentDiff
         , tmpProtocol.isInsert ::Boolean


    FROM tmpProtocol
      INNER JOIN tmpCount ON tmpCount.PriceId = tmpProtocol.PriceId
      LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId 
      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpProtocol.GoodsId 

      -- получаем значения цены из истории значений на начало дня                                                          
      LEFT JOIN ObjectHistory AS ObjectHistory_Price
                              ON ObjectHistory_Price.ObjectId = tmpProtocol.PriceId
                             AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                             AND DATE_TRUNC ('DAY', tmpProtocol.OperDate) >= ObjectHistory_Price.StartDate AND DATE_TRUNC ('DAY', tmpProtocol.OperDate) < ObjectHistory_Price.EndDate
      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                   ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                  AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
    ORDER BY Object_Goods.ValueData
            ,tmpProtocol.OperDate
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.08.19         *
*/
-- тест
-- SELECT * FROM gpReport_PriceProtocol(inStartDate:= '01.06.2019':: TDateTime, inEndDate:= '01.09.2019':: TDateTime, inUnitId := 494882, inUserId := 4007336 , inGoodsId:= 0,inSession:='3':: TVarChar)
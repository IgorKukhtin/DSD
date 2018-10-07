DROP FUNCTION IF EXISTS gpGet_Object_PriceChange (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PriceChange(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , RetailId Integer, RetailCode Integer, RetailName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , DateChange tdatetime
             , PriceChange TFloat, FixValue TFloat, PercentMarkup TFloat
             , isErased boolean
             ) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PriceChange());

    IF COALESCE (inId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            CAST (0 as Integer)      AS Id

          , CAST (0 as Integer)      AS GoodsId
          , CAST (0 as Integer)      AS GoodsCode
          , CAST ('' as TVarChar)    AS GoodsName

          , CAST (0 as Integer)      AS RetailId
          , CAST (0 as Integer)      AS RetailCode
          , CAST ('' as TVarChar)    AS RetailName

          , CAST (0 as Integer)      AS UnitId
          , CAST (0 as Integer)      AS UnitCode
          , CAST ('' as TVarChar)    AS UnitName

          , CAST (Null as TDateTime) AS DateChange

          , CAST (0 as TFloat)       AS PriceChange
          , CAST (0 as TFloat)       AS FixValue
          , CAST (0 as TFloat)       AS PercentMarkup

          , CAST (NULL AS Boolean)   AS isErased;
    ELSE
        RETURN QUERY
        SELECT Object_PriceChange.Id                   AS Id

             , Object_Goods.Id                         AS GoodsId
             , Object_Goods.ObjectCode                 AS GoodsCode
             , Object_Goods.ValueData                  AS GoodsName

             , Object_Retail.Id                        AS RetailId
             , Object_Retail.ObjectCode                AS RetailCode
             , Object_Retail.ValueData                 AS RetailName

             , Object_Unit.Id                          AS UnitId
             , Object_Unit.ObjectCode                  AS UnitCode
             , Object_Unit.ValueData                   AS UnitName

             , ObjectDate_DateChange.valuedata         AS DateChange

             , ROUND(ObjectFloat_Value.ValueData,2)::TFloat  AS PriceChange
             , ObjectFloat_FixValue.ValueData                AS FixValue
             , ObjectFloat_PercentMarkup.ValueData           AS PercentMarkup
      
             , Object_Goods.isErased                   AS isErased
           FROM Object AS Object_PriceChange
               LEFT JOIN ObjectLink AS ObjectLink_Retail
                                    ON ObjectLink_Retail.ObjectId = Object_PriceChange.Id
                                   AND ObjectLink_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
               LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Unit
                                    ON ObjectLink_Unit.ObjectId = Object_PriceChange.Id
                                   AND ObjectLink_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Goods
                                    ON ObjectLink_Goods.ObjectId = Object_PriceChange.Id
                                   AND ObjectLink_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

               LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                     ON ObjectFloat_Value.ObjectId = Object_PriceChange.Id
                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_PriceChange_Value()
               LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                                     ON ObjectFloat_PercentMarkup.ObjectId = Object_PriceChange.Id
                                    AND ObjectFloat_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()
               LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                     ON ObjectFloat_FixValue.ObjectId = Object_PriceChange.Id
                                    AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()

               LEFT JOIN ObjectDate AS ObjectDate_DateChange
                                    ON ObjectDate_DateChange.ObjectId = Object_PriceChange.Id
                                   AND ObjectDate_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()

           WHERE Object_PriceChange.DescId = zc_Object_PriceChange() 
             AND Object_PriceChange.Id = inId;

    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.09.18         * add zc_ObjectLink_PriceChange_Unit
 16.08.18         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PriceChange (2, '2')

DROP FUNCTION IF EXISTS gpGet_Object_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Price(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , DateChange tdatetime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSNotRecalc Boolean
             , isErased boolean
             ) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Price());

    IF COALESCE (inId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            CAST (0 as Integer)      AS Id
          , CAST (0 as TFloat)       AS Price
          , CAST (0 as TFloat)       AS MCSValue

          , CAST (0 as Integer)      AS GoodsId
          , CAST (0 as Integer)      AS GoodsCode
          , CAST ('' as TVarChar)    AS GoodsName

          , CAST (0 as Integer)      AS UnitId
          , CAST (0 as Integer)      AS UnitCode
          , CAST ('' as TVarChar)    AS UnitName

          , CAST (Null as TDateTime) AS DateChange
          , CAST (Null as TDateTime) AS MCSDateChange

          , CAST (False as Boolean)  AS MCSIsClose
          , CAST (False as Boolean)  AS MCSNotRecalc
           
          , CAST (NULL AS Boolean)   AS isErased;
    ELSE
        RETURN QUERY
        SELECT
            Object_Price_View.Id
           ,Object_Price_View.Price
           ,Object_Price_View.MCSValue

           ,Object_Price_View.GoodsId
           ,Object_Price_View.GoodsCode
           ,Object_Price_View.GoodsName

           ,Object_Price_View.UnitId
           ,Object_Price_View.UnitCode
           ,Object_Price_View.UnitName

           ,object_price_view.DateChange
           ,object_price_view.MCSDateChange

           ,object_price_view.MCSIsClose
           ,object_price_view.MCSNotRecalc
           
           ,Object_Price_View.isErased

        FROM 
            Object_Price_View
        WHERE 
            Object_Price_View.Id = inId;

    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Price (Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
29.08.2015                                                       * + MCSIsClose, MCSNotRecalc
 31.07.15                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_Price (0, '')

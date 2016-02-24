-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForReprice(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForReprice(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitName TVarChar) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

    RETURN QUERY 
     
        SELECT Object_Unit.Id          AS Id  
             , Object_Unit.ValueData   AS Name
        FROM Object AS Object_Unit

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RepriceAuto 
                                ON ObjectBoolean_RepriceAuto.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RepriceAuto.DescId = zc_ObjectBoolean_Unit_RepriceAuto()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND COALESCE (ObjectBoolean_isLeaf.ValueData,False) = TRUE
          AND COALESCE (ObjectBoolean_RepriceAuto.ValueData,False) = TRUE

        ORDER BY Object_Unit.ValueData
       ;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitForReprice ('2')
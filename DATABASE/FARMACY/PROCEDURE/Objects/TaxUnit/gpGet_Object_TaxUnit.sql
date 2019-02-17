-- Function: gpGet_Object_TaxUnit()

DROP FUNCTION IF EXISTS gpGet_Object_TaxUnit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TaxUnit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitName TVarChar
             , Price TFloat, Value TFloat
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_TaxUnit());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
          
           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName 

           , CAST (NULL AS TFloat) AS Price
           , CAST (NULL AS TFloat) AS Value   
           ;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_TaxUnit.Id           AS Id
         
           , Object_Unit.Id              AS UnitId
           , Object_Unit.ValueData       AS UnitName 

           , ObjectFloat_Price.ValueData AS Price
           , ObjectFloat_Value.ValueData AS Value
           
       FROM Object AS Object_TaxUnit
           LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                 ON ObjectFloat_Price.ObjectId = Object_TaxUnit.Id
                                AND ObjectFloat_Price.DescId = zc_ObjectFloat_TaxUnit_Price()
           LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                 ON ObjectFloat_Value.ObjectId = Object_TaxUnit.Id
                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_TaxUnit_Value()

           LEFT JOIN ObjectLink AS ObjectLink_TaxUnit_Unit
                                ON ObjectLink_TaxUnit_Unit.ObjectId = Object_TaxUnit.Id
                               AND ObjectLink_TaxUnit_Unit.DescId = zc_ObjectLink_TaxUnit_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_TaxUnit_Unit.ChildObjectId
                                  
      WHERE Object_TaxUnit.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.19         *

*/

-- тест
-- SELECT * FROM gpGet_Object_TaxUnit(0,'2')
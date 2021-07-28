-- Function: gpSelect_Object_DiffKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiffKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiffKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isClose Boolean
             , isLessYear Boolean
             , isFormOrder Boolean
             , isFindLeftovers Boolean
             , isErased boolean
             , MaxOrderAmount TFloat
             , MaxOrderAmountSecond TFloat
             , DaysForSale Integer) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT Object_DiffKind.Id                                   AS Id
          , Object_DiffKind.ObjectCode                           AS Code
          , Object_DiffKind.ValueData                            AS Name
          , COALESCE(ObjectBoolean_DiffKind_Close.ValueData, False)               AS isClose
          , COALESCE(ObjectBoolean_DiffKind_LessYear.ValueData, False)            AS isLessYear
          , COALESCE(ObjectBoolean_DiffKind_FormOrder.ValueData, False)           AS isFormOrder            
          , COALESCE(ObjectBoolean_DiffKind_FindLeftovers.ValueData, False)       AS isFindLeftovers           
          , Object_DiffKind.isErased                             AS isErased
          , ObjectFloat_DiffKind_MaxOrderAmount.ValueData        AS MaxOrderAmount
          , ObjectFloat_DiffKind_MaxOrderAmountSecond.ValueData  AS MaxOrderAmount
          , ObjectFloat_DiffKind_DaysForSale.ValueData::Integer  AS DaysForSale
     FROM Object AS Object_DiffKind
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                  ON ObjectBoolean_DiffKind_Close.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()   
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_LessYear
                                  ON ObjectBoolean_DiffKind_LessYear.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_LessYear.DescId = zc_ObjectBoolean_DiffKind_LessYear()   
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_FormOrder
                                  ON ObjectBoolean_DiffKind_FormOrder.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_FormOrder.DescId = zc_ObjectBoolean_DiffKind_FormOrder()   
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_FindLeftovers
                                  ON ObjectBoolean_DiffKind_FindLeftovers.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_FindLeftovers.DescId = zc_ObjectBoolean_DiffKind_FindLeftovers()   
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmount
                                ON ObjectFloat_DiffKind_MaxOrderAmount.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_MaxOrderAmount.DescId = zc_ObjectFloat_MaxOrderAmount() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmountSecond
                                ON ObjectFloat_DiffKind_MaxOrderAmountSecond.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_MaxOrderAmountSecond.DescId = zc_ObjectFloat_MaxOrderAmountSecond() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_DaysForSale
                                ON ObjectFloat_DiffKind_DaysForSale.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_DaysForSale.DescId = zc_ObjectFloat_DiffKind_DaysForSale() 
     WHERE Object_DiffKind.DescId = zc_Object_DiffKind();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.12.19                                                       * 
 05.06.19                                                       * 
 11.12.18         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_DiffKind('2')
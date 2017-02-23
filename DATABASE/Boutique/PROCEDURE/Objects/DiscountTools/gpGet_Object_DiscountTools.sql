-- Function: gpGet_Object_DiscountTools()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountTools(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountTools(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartSumm TFloat, EndSumm TFloat, DiscountTax TFloat, DiscountId Integer, DiscountName TVarChar) 
  AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Discount());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST (0 as TFloat)     AS StartSumm
           , CAST (0 as TFloat)     AS EndSumm
           , CAST (0 as TFloat)     AS DiscountTax
           , CAST (0 as Integer)    AS DiscountId
           , CAST ('' as TVarChar)  AS DiscountName

       FROM Object
       WHERE Object.DescId = zc_Object_DiscountTools();
   ELSE
       RETURN QUERY
       SELECT
             Object.Id                              AS Id
           , OS_DiscountTools_StartSumm.ValueData   AS StartSumm
           , OS_DiscountTools_EndSumm.ValueData     AS EndSumm
           , OS_DiscountTools_DiscountTax.ValueData AS DiscountTax
           , Object_Discount.ID                     AS DiscountId
           , Object_Discount.ValueData              AS DiscountName 
       FROM Object
        LEFT JOIN ObjectFloat AS OS_DiscountTools_StartSumm
                 ON OS_DiscountTools_StartSumm.ObjectId = Object.Id
                AND OS_DiscountTools_StartSumm.DescId = zc_ObjectFloat_DiscountTools_StartSumm()
        LEFT JOIN ObjectFloat AS OS_DiscountTools_EndSumm
                 ON OS_DiscountTools_EndSumm.ObjectId = Object.Id
                AND OS_DiscountTools_EndSumm.DescId = zc_ObjectFloat_DiscountTools_EndSumm()
        LEFT JOIN ObjectFloat AS OS_DiscountTools_DiscountTax
                 ON OS_DiscountTools_DiscountTax.ObjectId = Object.Id
                AND OS_DiscountTools_DiscountTax.DescId = zc_ObjectFloat_DiscountTools_DiscountTax()
        LEFT JOIN ObjectLink AS ObjectLink_DiscountTools_Discount ON ObjectLink_DiscountTools_Discount.ObjectId = Object.Id
                AND ObjectLink_DiscountTools_Discount.DescId = zc_ObjectLink_DiscountTools_Discount()
        LEFT JOIN Object AS Object_Discount ON Object_Discount.Id = ObjectLink_DiscountTools_Discount.ChildObjectId
       WHERE Object.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
23.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Discount (1,'2')

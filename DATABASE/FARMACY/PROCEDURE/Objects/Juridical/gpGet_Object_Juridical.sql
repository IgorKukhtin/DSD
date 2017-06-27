-- Function: gpGet_Object_Juridical()

DROP FUNCTION IF EXISTS gpGet_Object_Juridical(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               RetailId Integer, RetailName TVarChar,
               isCorporate boolean,
               Percent TFloat, 
               PayOrder TFloat,
               OrderSumm TFloat, OrderSummComment TVarChar,
               OrderTime TVarChar,
               isLoadBarcode Boolean,
               isErased boolean) AS
$BODY$
BEGIN 

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Juridical());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Juridical()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS RetailId
           , CAST ('' as TVarChar) AS RetailName 

           , CAST (False AS Boolean) AS isCorporate 
           , 0::TFloat               AS Percent    
           , NULL::TFloat            AS PayOrder
       
           , CAST (0 as TFloat)      AS OrderSumm
           , CAST ('' as TVarChar)   AS OrderSummComment
           , CAST ('' as TVarChar)   AS OrderTime

           , FALSE                   AS isLoadBarcode  

           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Juridical.Id           AS Id
           , Object_Juridical.ObjectCode   AS Code
           , Object_Juridical.ValueData    AS Name
         
           , Object_Retail.Id         AS RetailId
           , Object_Retail.ValueData  AS RetailName 

           , ObjectBoolean_isCorporate.ValueData AS isCorporate
           , ObjectFloat_Percent.ValueData       AS Percent
           , ObjectFloat_PayOrder.ValueData      AS PayOrder

           , COALESCE (ObjectFloat_OrderSumm.ValueData, 0)  ::TFloat   AS OrderSumm
           , COALESCE (ObjectString_OrderSumm.ValueData,'') ::TVarChar AS OrderSummComment
           , COALESCE (ObjectString_OrderTime.ValueData,'') ::TVarChar AS OrderTime

           , COALESCE (ObjectBoolean_LoadBarcode.ValueData, FALSE) AS isLoadBarcode 

           , Object_Juridical.isErased           AS isErased
           
       FROM Object AS Object_Juridical

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

           LEFT JOIN ObjectFloat AS ObjectFloat_PayOrder
                                 ON ObjectFloat_PayOrder.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_PayOrder.DescId = zc_ObjectFloat_Juridical_PayOrder()

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate 
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

           LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm
                                 ON ObjectFloat_OrderSumm.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_OrderSumm.DescId = zc_ObjectFloat_Juridical_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderSumm
                                  ON ObjectString_OrderSumm.ObjectId = Object_Juridical.Id
                                 AND ObjectString_OrderSumm.DescId = zc_ObjectString_Juridical_OrderSumm()
           LEFT JOIN ObjectString AS ObjectString_OrderTime
                                  ON ObjectString_OrderTime.ObjectId = Object_Juridical.Id
                                 AND ObjectString_OrderTime.DescId = zc_ObjectString_Juridical_OrderTime()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_LoadBarcode 
                                   ON ObjectBoolean_LoadBarcode.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_LoadBarcode.DescId = zc_ObjectBoolean_Juridical_LoadBarcode()
      WHERE Object_Juridical.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Juridical (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Ярошенко Р.Ф.
 27.06.17                                                                       * isLoadBarcode
 14.01.17         * 
 02.12.15                                                         * PayOrder               
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Juridical(0, '2')

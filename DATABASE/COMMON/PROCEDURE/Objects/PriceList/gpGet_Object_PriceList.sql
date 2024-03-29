-- Function: gpGet_Object_PriceList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PriceList(
    IN inId          Integer,       -- ключ объекта <Прайс лист> 
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
               , PriceWithVAT Boolean, isUser Boolean
               , VATPercent TFloat
               , CurrencyId Integer, CurrencyName TVarChar
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)         AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)       AS Name
           , CAST (FALSE AS Boolean)     AS PriceWithVAT
           , FALSE            :: Boolean AS isUser
           , CAST (20 AS TFloat)         AS VATPercent
           , Object_Currency.Id          AS CurrencyId
           , Object_Currency.ValueData   AS CurrencyName
       FROM Object
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = zc_Enum_Currency_Basis()
       WHERE Object.DescId = zc_Object_PriceList()
       GROUP BY Object_Currency.Id
              , Object_Currency.ValueData
      ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PriceList.Id                  AS Id
           , Object_PriceList.ObjectCode          AS Code
           , Object_PriceList.ValueData           AS Name
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , COALESCE (ObjectBoolean_User.ValueData, FALSE) :: Boolean AS isUser
           , ObjectFloat_VATPercent.ValueData     AS VATPercent
           , Object_Currency.Id                   AS CurrencyId
           , Object_Currency.ValueData            AS CurrencyName
       FROM Object AS Object_PriceList
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_User
                                    ON ObjectBoolean_User.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_User.DescId = zc_ObjectBoolean_PriceList_User()

            LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                  ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                 AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
            LEFT JOIN ObjectLink AS ObjectLink_Currency
                                 ON ObjectLink_Currency.ObjectId = Object_PriceList.Id
                                AND ObjectLink_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Currency.ChildObjectId
       WHERE Object_PriceList.Id = inId;

   END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PriceList (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.11.14                                        * add Currency...
 07.09.13                                        * add PriceWithVAT and VATPercent
 14.06.13          *
*/

-- тест
-- SELECT * FROM gpGet_Object_PriceList (0, '2')

-- Function: lfGet_Object_PriceList (Integer)

DROP FUNCTION IF EXISTS lfGet_Object_PriceList (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_PriceList(
    IN inId          Integer        -- ключ объекта <Прайс лист> 
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, PriceWithVAT Boolean, VATPercent TFloat, CurrencyId Integer, CurrencyName TVarChar, isErased Boolean) AS
$BODY$
BEGIN

     RETURN QUERY 
       SELECT 
             Object_PriceList.Id                  AS Id
           , Object_PriceList.ObjectCode          AS Code
           , Object_PriceList.ValueData           AS Name
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , ObjectFloat_VATPercent.ValueData     AS VATPercent
           , Object_Currency.Id                   AS CurrencyId
           , Object_Currency.ValueData            AS CurrencyName
           , Object_PriceList.isErased            AS isErased
       FROM Object AS Object_PriceList
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
            LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                  ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                 AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
            LEFT JOIN ObjectLink AS ObjectLink_Currency
                                 ON ObjectLink_Currency.ObjectId = Object_PriceList.Id
                                AND ObjectLink_Currency.DescId = zc_ObjectLink_PriceList_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Currency.ChildObjectId
       WHERE Object_PriceList.Id = inId;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Object_PriceList (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.11.14                                        * add Currency...
 07.09.13                                        * add PriceWithVAT and VATPercent
*/

-- тест
-- SELECT * FROM lfGet_Object_PriceList (1)

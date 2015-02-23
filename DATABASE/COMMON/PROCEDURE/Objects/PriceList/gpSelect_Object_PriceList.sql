-- Function: gpSelect_Object_PriceList (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PriceList (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceList(
    IN inShowAll        Boolean,   
    IN inSession        TVarChar         -- ������ ������������
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, PriceWithVAT Boolean, VATPercent TFloat, CurrencyId Integer, CurrencyName TVarChar, isErased Boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)
     
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
            JOIN tmpIsErased on tmpIsErased.isErased= Object_PriceList.isErased
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
       WHERE Object_PriceList.DescId = zc_Object_PriceList();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_PriceList (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.02.15         * add inShowAll
 16.11.14                                        * add Currency...
 07.09.13                                        * add PriceWithVAT and VATPercent
*/

-- ����
-- SELECT * FROM gpSelect_Object_PriceList ( false , '5')

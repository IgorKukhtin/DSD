-- Function: gpSelect_Object_PriceList (TVarChar)

-- DROP FUNCTION gpSelect_Object_PriceList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceList(
    IN inSession        TVarChar         -- ������ ������������
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, PriceWithVAT Boolean, VATPercent TFloat, isErased Boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

     RETURN QUERY 
       SELECT 
             Object_PriceList.Id
           , Object_PriceList.ObjectCode AS Code
           , Object_PriceList.ValueData AS Name
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , ObjectFloat_VATPercent.ValueData  AS VATPercent
           , Object_PriceList.isErased
       FROM Object AS Object_PriceList
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                    ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                   AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
            LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                  ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                 AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
       WHERE Object_PriceList.DescId = zc_Object_PriceList();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PriceList (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.09.13                                        * add PriceWithVAT and VATPercent
 00.06.13          

*/

-- ����
-- SELECT * FROM gpSelect_Object_PriceList ('2')
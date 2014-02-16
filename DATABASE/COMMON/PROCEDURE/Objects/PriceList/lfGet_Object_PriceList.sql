-- Function: lfGet_Object_PriceList (Integer)

-- DROP FUNCTION lfGet_Object_PriceList (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_PriceList(
    IN inId          Integer        -- ���� ������� <����� ����> 
)
  RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, PriceWithVAT Boolean, VATPercent TFloat, isErased Boolean) AS
$BODY$
BEGIN

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
       WHERE Object_PriceList.Id = inId;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_Object_PriceList (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.09.13                                        * add PriceWithVAT and VATPercent
*/

-- ����
-- SELECT * FROM lfGet_Object_PriceList (1)

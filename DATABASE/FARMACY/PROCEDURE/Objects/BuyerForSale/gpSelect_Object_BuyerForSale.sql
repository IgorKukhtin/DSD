-- Function: gpSelect_Object_BuyerForSale()

DROP FUNCTION IF EXISTS gpSelect_Object_BuyerForSale(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BuyerForSale(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_BuyerForSale.Id                        AS Id 
        , Object_BuyerForSale.ObjectCode                AS Code
        , Object_BuyerForSale.ValueData                 AS Name
        , Object_BuyerForSale.isErased                  AS isErased
   FROM Object AS Object_BuyerForSale
   WHERE Object_BuyerForSale.DescId = zc_Object_BuyerForSale();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_BuyerForSale(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.10.20                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_BuyerForSale('3')
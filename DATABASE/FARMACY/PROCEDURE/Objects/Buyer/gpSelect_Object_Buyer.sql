-- Function: gpSelect_Object_Buyer()

DROP FUNCTION IF EXISTS gpSelect_Object_Buyer(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Buyer(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Phone TVarChar
             , Name TVarChar 
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_Buyer.Id                      AS Id 
        , Object_Buyer.ObjectCode              AS Code
        , Object_Buyer.ValueData               AS Phone
        , ObjectString_Buyer_Name.ValueData    AS Name
        , Object_Buyer.isErased                AS isErased
   FROM Object AS Object_Buyer
        LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                               ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id 
                              AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()
   WHERE Object_Buyer.DescId = zc_Object_Buyer();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Buyer(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Buyer('3')
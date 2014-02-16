-- Function: gpSelect_Object_Freight()

DROP FUNCTION IF EXISTS gpSelect_Object_Freight(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Freight(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Freight());

     RETURN QUERY 
       SELECT 
             Object_Freight.Id          AS Id
           , Object_Freight.ObjectCode  AS Code
           , Object_Freight.ValueData   AS Name
           
           , Object_Freight.isErased AS isErased
           
       FROM Object AS Object_Freight
       WHERE Object_Freight.DescId = zc_Object_Freight();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Freight(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.09.13          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Freight('2')
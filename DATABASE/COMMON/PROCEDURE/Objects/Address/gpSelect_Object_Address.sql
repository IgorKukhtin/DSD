-- Function: gpSelect_Object_Address()

DROP FUNCTION IF EXISTS gpSelect_Object_Address (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Address(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReturnType());

   RETURN QUERY 
       SELECT 
             Object.Id            AS Id
           , Object.ObjectCode    AS Code
           , Object.ValueData     AS NAME
           , Object.isErased      AS isErased
       FROM Object
   WHERE Object.DescId = zc_Object_Address();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Address (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������ �.�.
 28.05.18        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Address('3')
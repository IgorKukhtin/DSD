-- Function: gpSelect_Object_ReturnType()

DROP FUNCTION IF EXISTS gpSelect_Object_ReturnType (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReturnType(
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
   WHERE Object.DescId = zc_Object_ReturnType();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReturnType (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.01.15                         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReturnType('2')
-- Function: gpSelect_Object_OrderKind()

DROP FUNCTION IF EXISTS gpSelect_Object_OrderKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_OrderKind());

   RETURN QUERY 
       SELECT 
             Object.Id            AS Id
           , Object.ObjectCode    AS Code
           , Object.ValueData     AS NAME
           , Object.isErased      AS isErased
       FROM Object
   WHERE Object.DescId = zc_Object_OrderKind();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_OrderKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.12.14                         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_OrderKind('2')
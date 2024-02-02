-- Function: gpSelect_Object_FileTypeKind()

DROP FUNCTION IF EXISTS gpSelect_Object_FileTypeKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_FileTypeKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_FileTypeKind());

   RETURN QUERY 
       SELECT 
             Object_FileTypeKind.Id           AS Id
           , Object_FileTypeKind.ObjectCode   AS Code
           , Object_FileTypeKind.ValueData    AS Name
         
           , Object_FileTypeKind.isErased     AS isErased
           
       FROM Object AS Object_FileTypeKind

       WHERE Object_FileTypeKind.DescId = zc_Object_FileTypeKind();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_FileTypeKind(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.07.14         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_FileTypeKind ('2')
-- Function: gpGet_Object_EmailKind()

DROP FUNCTION IF EXISTS gpGet_Object_EmailKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_EmailKind(
    IN inId          Integer,       -- ���� ������� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_EmailKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_EmailKind()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (False AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id            AS Id
           , Object.ObjectCode    AS Code
           , Object.ValueData     AS NAME
           , Object.isErased      AS isErased
       FROM Object
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_EmailKind(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.03.16         *
*/

-- ����
-- SELECT * FROM gpGet_Object_EmailKind (0, '2')
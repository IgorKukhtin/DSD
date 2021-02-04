-- Function: gpGet_Object_PaidKind (Integer, TVarChar)

-- DROP FUNCTION gpGet_Object_PaidKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PaidKind(
    IN inId             Integer,       -- ���� ������� <���� ���� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_PaidKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_PaidKind();
   ELSE
       RETURN QUERY 
       SELECT
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
       FROM Object 
       WHERE Object.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PaidKind (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.13          *

*/

-- ����
-- SELECT * FROM gpGet_Object_PaidKind (2, '')

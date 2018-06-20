-- Function: gpGet_Object_ReplMovement()

DROP FUNCTION IF EXISTS gpGet_Object_ReplMovement(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReplMovement(
    IN inId          Integer,       -- ���� ������� <�������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT CAST (0 as Integer)    AS Id
            , lfGet_ObjectCode(0, zc_Object_ReplMovement()) AS Code
            , CAST ('' as TVarChar)  AS Name
            , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_ReplMovement.Id         AS Id
            , Object_ReplMovement.ObjectCode AS Code
            , Object_ReplMovement.ValueData  AS Name
            , Object_ReplMovement.isErased   AS isErased
       FROM Object AS Object_ReplMovement
       WHERE Object_ReplMovement.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.06.18         *

*/

-- ����
-- SELECT * FROM gpGet_Object_ReplMovement (0, '2')
-- Function: gpGet_Object_UserByGroup()

DROP FUNCTION IF EXISTS gpGet_Object_UserByGroup(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_UserByGroup(
    IN inId          Integer,       -- �����
    IN inSession     TVarChar       -- ������ ������������ 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_UserByGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_UserByGroup()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       ;
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
  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.04.22         *
*/

-- ����
-- SELECT * FROM gpSelect_UserByGroup('2')
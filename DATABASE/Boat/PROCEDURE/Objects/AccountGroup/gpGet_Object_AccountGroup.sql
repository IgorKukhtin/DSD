-- Function: gpGet_Object_AccountGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_AccountGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_AccountGroup(
    IN inId             Integer,       -- ���� ������� <������ �������������� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_AccountGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_AccountGroup())   AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
       FROM Object AS Object_AccountGroup
       WHERE Object_AccountGroup.DescId = zc_Object_AccountGroup();
   ELSE
       RETURN QUERY 
       SELECT
             Object_AccountGroup.Id         AS Id
           , Object_AccountGroup.ObjectCode AS Code
           , Object_AccountGroup.ValueData  AS Name
           , Object_AccountGroup.isErased   AS isErased
       FROM Object AS Object_AccountGroup
       WHERE Object_AccountGroup.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.03.21         *

*/

-- ����
-- SELECT * FROM gpGet_Object_AccountGroup (2, '')

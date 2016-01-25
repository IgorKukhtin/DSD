-- Function: gpGet_Object_PersonalGroup (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_PersonalGroup (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PersonalGroup(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PersonalGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PersonalGroup()) AS Code  
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PersonalGroup.Id          AS Id
           , Object_PersonalGroup.ObjectCode  AS Code
           , Object_PersonalGroup.ValueData   AS Name
           
           , Object_PersonalGroup.isErased AS isErased
           
       FROM Object AS Object_PersonalGroup
       WHERE Object_PersonalGroup.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PersonalGroup(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.16         *

*/

-- ����
-- SELECT * FROM gpGet_Object_PersonalGroup (2, '')

-- Function: gpGet_Object_JuridicalGroup()

--DROP FUNCTION gpGet_Object_JuridicalGroup();

CREATE OR REPLACE FUNCTION gpGet_Object_JuridicalGroup(
    IN inId          Integer,       -- �����
    IN inSession     TVarChar       -- ������ ������������ 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer, ParentName TVarChar) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalGroup());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_JuridicalGroup()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased
           , CAST (0 as Integer)    AS ParentId
           , CAST ('' as TVarChar)  AS ParentName;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
           , JuridicalGroup.Id AS ParentId
           , JuridicalGroup.ValueData AS ParentName
       FROM Object
  LEFT JOIN ObjectLink 
         ON ObjectLink.ObjectId = Object.Id
        AND ObjectLink.DescId = zc_ObjectLink_JuridicalGroup_Parent()
  LEFT JOIN Object AS JuridicalGroup
         ON JuridicalGroup.Id = ObjectLink.ChildObjectId
       WHERE Object.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_JuridicalGroup(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.12.13                                        *Cyr1251
 13.06.13          *
*/

-- ����
-- SELECT * FROM gpSelect_JuridicalGroup('2')
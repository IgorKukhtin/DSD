-- Function: gpGet_Object_Language (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Language (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Language(
    IN inId          Integer,       -- ���� ������� <����������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Language());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_Language()) AS Code
           , CAST ('' as TVarChar)   AS NAME
           , CAST (FALSE AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Language.Id          AS Id
           , Object_Language.ObjectCode  AS Code
           , Object_Language.ValueData   AS Name
           , Object_Language.isErased    AS isErased
       FROM Object AS Object_Language
       WHERE Object_Language.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.09.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Language (2, '')

-- Function: gpGet_Object_ImportGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_ImportGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ImportGroup(
    IN inId          Integer,       -- ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Name TVarChar)
AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST ('' as TVarChar)  AS Name
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ImportGroup.Id         AS Id
           , Object_ImportGroup.ValueData  AS Name
       FROM Object AS Object_ImportGroup
       WHERE Object_ImportGroup.Id = inId;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.07.19         *
*/

-- ����
-- SELECT * FROM gpSelect_ImportGroup('2')
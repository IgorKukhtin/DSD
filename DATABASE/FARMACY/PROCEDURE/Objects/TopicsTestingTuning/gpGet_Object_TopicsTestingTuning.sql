-- Function: gpGet_Object_TopicsTestingTuning()

DROP FUNCTION IF EXISTS gpGet_Object_TopicsTestingTuning(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TopicsTestingTuning(
    IN inId          Integer,       -- ���� ������� <������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_TopicsTestingTuning()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_TopicsTestingTuning.Id                       AS Id
           , Object_TopicsTestingTuning.ObjectCode               AS Code
           , Object_TopicsTestingTuning.ValueData                AS Name
           , Object_TopicsTestingTuning.isErased                 AS isErased

       FROM Object AS Object_TopicsTestingTuning

       WHERE Object_TopicsTestingTuning.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.07.21                                                       *


*/

-- ����
-- SELECT * FROM gpGet_Object_TopicsTestingTuning (1, '3')
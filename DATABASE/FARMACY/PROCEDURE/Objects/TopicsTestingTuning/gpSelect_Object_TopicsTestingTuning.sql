-- Function: gpSelect_Object_TopicsTestingTuning()

DROP FUNCTION IF EXISTS gpSelect_Object_TopicsTestingTuning(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TopicsTestingTuning(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TopicsTestingTuning()());

   RETURN QUERY
   SELECT
          Object_TopicsTestingTuning.Id         AS Id
        , Object_TopicsTestingTuning.ObjectCode AS Code
        , Object_TopicsTestingTuning.ValueData  AS Name

        , Object_TopicsTestingTuning.isErased   AS isErased
   FROM Object AS Object_TopicsTestingTuning
   WHERE Object_TopicsTestingTuning.DescId = zc_Object_TopicsTestingTuning();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.07.21                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_TopicsTestingTuning('3')
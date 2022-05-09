-- Function: gpGet_Object_Competitor (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Competitor (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Competitor(
    IN inId          Integer,        -- ID ����������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Competitor());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Competitor()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_Competitor.Id                     AS Id
            , Object_Competitor.ObjectCode             AS Code
            , Object_Competitor.ValueData              AS Name
            , Object_Competitor.isErased               AS isErased
       FROM Object AS Object_Competitor
 
       WHERE Object_Competitor.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.05.22                                                       *
*/

-- ����
-- SELECT * FROM gpGet_Object_Competitor(0, '3')
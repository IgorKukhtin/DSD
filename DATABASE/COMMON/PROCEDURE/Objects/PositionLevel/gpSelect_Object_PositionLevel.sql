-- Function: gpSelect_Object_PositionLevel (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PositionLevel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PositionLevel(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_PositionLevel());

   RETURN QUERY 
       SELECT
             Object_PositionLevel.Id         AS Id
           , Object_PositionLevel.ObjectCode AS Code
           , Object_PositionLevel.ValueData  AS Name
                      
           , Object_PositionLevel.isErased   AS isErased
           
       FROM Object AS Object_PositionLevel
       WHERE Object_PositionLevel.DescId = zc_Object_PositionLevel();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PositionLevel (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.10.13          *

*/

-- ����
-- SELECT * FROM gpSelect_Object_PositionLevel('2')

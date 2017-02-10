-- Function: gpSelect_Object_RouteSorting (TVarChar)

-- DROP FUNCTION gpSelect_Object_RouteSorting (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteSorting(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_RouteSorting());

   RETURN QUERY 
   SELECT
     Object.Id
   , Object.ObjectCode AS Code
   , Object.ValueData AS Name
   , Object.isErased
   FROM Object
   WHERE Object.DescId = zc_Object_RouteSorting()

      UNION ALL
       SELECT 
             0 AS Id
           , NULL :: Integer AS Code
           , '�������' :: TVarChar AS Name
           , FALSE AS isErased
    ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RouteSorting (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.13          *

*/

-- ����
-- SELECT * FROM gpSelect_Object_RouteSorting('2')

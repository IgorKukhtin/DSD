-- Function: gpGet_Object_RouteSorting (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_RouteSorting (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RouteSorting(
    IN inId             Integer,       -- ���� ������� <���������� ���������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Code Integer, Name TVarChar) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_RouteSorting());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             lfGet_ObjectCode(0, zc_Object_RouteSorting()) AS Code
           , CAST ('' as TVarChar)  AS Name;
   ELSE
       RETURN QUERY 
       SELECT
             Object.ObjectCode AS Code
           , Object.ValueData  AS Name
       FROM Object 
       WHERE Object.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_RouteSorting (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.09.13                        *
 04.06.13          *

*/

-- ����
-- SELECT * FROM gpGet_Object_RouteSorting (2, '')

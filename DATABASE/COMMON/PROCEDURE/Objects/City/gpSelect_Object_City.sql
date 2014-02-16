-- Function: gpSelect_Object_City()

DROP FUNCTION IF EXISTS gpSelect_Object_City(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_City(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_City()());

   RETURN QUERY
   SELECT
     Object.Id         AS Id
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_City();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_City(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
 14.01.14 Dima
*/

-- ����
-- SELECT * FROM gpSelect_Object_City('2')
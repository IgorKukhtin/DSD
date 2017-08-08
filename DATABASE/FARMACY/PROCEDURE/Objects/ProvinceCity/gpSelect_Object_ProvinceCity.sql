-- Function: gpSelect_Object_ProvinceCity()

DROP FUNCTION IF EXISTS gpSelect_Object_ProvinceCity(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProvinceCity(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProvinceCity()());

   RETURN QUERY
   SELECT
          Object_ProvinceCity.Id         AS Id
        , Object_ProvinceCity.ObjectCode AS Code
        , Object_ProvinceCity.ValueData  AS Name

        , Object_ProvinceCity.isErased   AS isErased
   FROM Object AS Object_ProvinceCity
   WHERE Object_ProvinceCity.DescId = zc_Object_ProvinceCity();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 08.08.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ProvinceCity('2')
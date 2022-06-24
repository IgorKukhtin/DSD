-- Function: gpSelect_Object_MakerCountrySP_1303(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MakerCountrySP_1303(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MakerCountrySP_1303(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MakerCountrySP_1303());

   RETURN QUERY 
     SELECT Object_MakerCountrySP_1303.Id                 AS Id
          , Object_MakerCountrySP_1303.ObjectCode         AS Code
          , Object_MakerCountrySP_1303.ValueData          AS Name
          , Object_MakerCountrySP_1303.isErased           AS isErased
     FROM OBJECT AS Object_MakerCountrySP_1303
     WHERE Object_MakerCountrySP_1303.DescId = zc_Object_MakerCountrySP_1303();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MakerCountrySP_1303(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.06.22                                                       *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_MakerCountrySP_1303('2')
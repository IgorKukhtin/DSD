-- Function: gpSelect_Object_StreetKind()

DROP FUNCTION IF EXISTS gpSelect_Object_StreetKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StreetKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ShortName TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StreetKind());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS NAME
   , ShortName.ValueData  AS ShortName
   , Object.isErased   AS isErased
   FROM Object
        LEFT JOIN ObjectString AS ShortName
                               ON ShortName.ObjectId = Object.Id 
                              AND ShortName.DescId = zc_ObjectString_StreetKind_ShortName()
   WHERE Object.DescId = zc_Object_StreetKind();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_StreetKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.14         * add ShortName
 31.05.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_StreetKind('2')
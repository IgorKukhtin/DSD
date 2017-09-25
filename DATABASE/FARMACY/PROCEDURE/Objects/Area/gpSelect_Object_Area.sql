-- Function: gpSelect_Object_Area()

DROP FUNCTION IF EXISTS gpSelect_Object_Area(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Area(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Email TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_Area.Id                     AS Id 
        , Object_Area.ObjectCode             AS Code
        , Object_Area.ValueData              AS Name
        , ObjectString_Area_Email.ValueData  AS Email
        , Object_Area.isErased               AS isErased
   FROM Object AS Object_Area
        LEFT JOIN ObjectString AS ObjectString_Area_Email
                               ON ObjectString_Area_Email.ObjectId = Object_Area.Id 
                              AND ObjectString_Area_Email.DescId = zc_ObjectString_Area_Email()
   WHERE Object_Area.DescId = zc_Object_Area();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Area(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.17         *
 14.11.13         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Area('2')
-- Function: gpSelect_Object_NameBefore()

DROP FUNCTION IF EXISTS gpSelect_Object_NameBefore (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_NameBefore(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_NameBefore());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_NameBefore();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.07.16         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_NameBefore (zfCalc_UserAdmin())

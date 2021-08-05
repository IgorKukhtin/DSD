-- Function: gpSelect_Object_MemberSkill()

DROP FUNCTION IF EXISTS gpSelect_Object_MemberSkill(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberSkill(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MemberSkill()());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_MemberSkill();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.08.21         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_MemberSkill('2')
-- Function: gpSelect_Object_AccountGroup (TVarChar)

-- DROP FUNCTION gpSelect_Object_AccountGroup (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AccountGroup(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_AccountGroup());

   RETURN QUERY 
   SELECT
         Object_AccountGroup.Id         AS Id 
       , Object_AccountGroup.ObjectCode AS Code
       , Object_AccountGroup.ValueData  AS Name
       , Object_AccountGroup.isErased   AS isErased
   FROM Object AS Object_AccountGroup
   WHERE Object_AccountGroup.DescId = zc_Object_AccountGroup();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AccountGroup (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.13          * zc_Enum_Process_Select_Object_AccountGroup()
 17.06.13          *

*/

-- ����
-- SELECT * FROM gpSelect_Object_AccountGroup('2')

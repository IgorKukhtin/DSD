-- Function: gpSelect_Object_InfoMoneyGroup (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyGroup (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyGroup(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoneyGroup());

   RETURN QUERY 
   SELECT 
         Object_InfoMoneyGroup.Id         AS Id 
       , Object_InfoMoneyGroup.ObjectCode AS Code
       , Object_InfoMoneyGroup.ValueData  AS Name
       , Object_InfoMoneyGroup.isErased   AS isErased
   FROM Object AS Object_InfoMoneyGroup
   WHERE Object_InfoMoneyGroup.DescId = zc_Object_InfoMoneyGroup();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoneyGroup (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.13          *                             
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoneyGroup (zfCalc_UserAdmin()) ORDER BY Code

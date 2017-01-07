-- Function: gpSelect_Object_ConditionsKeep(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ConditionsKeep(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ConditionsKeep(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ConditionsKeep());

   RETURN QUERY 
     SELECT Object_ConditionsKeep.Id                 AS Id
          , Object_ConditionsKeep.ObjectCode         AS Code
          , Object_ConditionsKeep.ValueData          AS Name
          , Object_ConditionsKeep.isErased           AS isErased
     FROM Object AS Object_ConditionsKeep
     WHERE Object_ConditionsKeep.DescId = zc_Object_ConditionsKeep();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.01.17         *  

*/

-- ����
-- SELECT * FROM gpSelect_Object_ConditionsKeep('2')
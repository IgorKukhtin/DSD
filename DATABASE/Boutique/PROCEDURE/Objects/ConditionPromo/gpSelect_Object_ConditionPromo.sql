-- Function: gpSelect_Object_ConditionPromo(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ConditionPromo(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ConditionPromo(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT
       Object.Id                    AS Id
     , Object.ObjectCode            AS Code
     , Object.ValueData             AS Name
     , Object.isErased
     FROM Object
     WHERE Object.DescId = zc_Object_ConditionPromo();
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ConditionPromo (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 31.10.15                                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ConditionPromo('2')
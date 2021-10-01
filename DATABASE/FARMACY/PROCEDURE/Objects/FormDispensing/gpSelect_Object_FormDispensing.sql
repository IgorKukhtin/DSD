-- Function: gpSelect_Object_FormDispensing(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_FormDispensing(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_FormDispensing(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_FormDispensing());

   RETURN QUERY 
     SELECT Object_FormDispensing.Id                 AS Id
          , Object_FormDispensing.ObjectCode         AS Code
          , Object_FormDispensing.ValueData          AS Name
          , Object_FormDispensing.isErased           AS isErased
     FROM OBJECT AS Object_FormDispensing
     WHERE Object_FormDispensing.DescId = zc_Object_FormDispensing();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_FormDispensing(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.09.21                                                       *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_FormDispensing('2')
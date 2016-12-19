-- Function: gpSelect_Object_IntenalSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_IntenalSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_IntenalSP(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_IntenalSP());

   RETURN QUERY 
     SELECT Object_IntenalSP.Id                 AS Id
          , Object_IntenalSP.ObjectCode         AS Code
          , Object_IntenalSP.ValueData          AS Name
          , Object_IntenalSP.isErased           AS isErased
     FROM OBJECT AS Object_IntenalSP
     WHERE Object_IntenalSP.DescId = zc_Object_IntenalSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_IntenalSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.12.16         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_IntenalSP('2')
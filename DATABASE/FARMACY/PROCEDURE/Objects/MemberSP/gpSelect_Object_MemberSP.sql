-- Function: gpSelect_Object_MemberSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberSP(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberSP());

   RETURN QUERY 
     SELECT Object_MemberSP.Id                 AS Id
          , Object_MemberSP.ObjectCode         AS Code
          , Object_MemberSP.ValueData          AS Name
          , Object_MemberSP.isErased           AS isErased
     FROM OBJECT AS Object_MemberSP
     WHERE Object_MemberSP.DescId = zc_Object_MemberSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MemberSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.02.17         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_MemberSP('2')
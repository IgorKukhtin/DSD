-- Function: gpSelect_Object_GroupMemberSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GroupMemberSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GroupMemberSP(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GroupMemberSP());

   RETURN QUERY 
     SELECT Object_GroupMemberSP.Id                 AS Id
          , Object_GroupMemberSP.ObjectCode         AS Code
          , Object_GroupMemberSP.ValueData          AS Name
          , Object_GroupMemberSP.isErased           AS isErased
     FROM Object AS Object_GroupMemberSP
     WHERE Object_GroupMemberSP.DescId = zc_Object_GroupMemberSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GroupMemberSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.17         *              

*/

-- ����
-- SELECT * FROM gpSelect_Object_GroupMemberSP('2')
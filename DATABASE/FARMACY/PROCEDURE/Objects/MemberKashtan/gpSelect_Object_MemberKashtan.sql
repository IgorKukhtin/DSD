-- Function: gpSelect_Object_MemberKashtan(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberKashtan(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberKashtan(
    IN inSession            TVarChar       -- ������ ������������
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
     WHERE Object_MemberSP.DescId = zc_Object_MemberKashtan()
       AND Object_MemberSP.isErased = False;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.03.21                                                       *

*/

-- ����
-- 
SELECT * FROM gpSelect_Object_MemberKashtan('3')
-- Function: gpGet_Object_Member_GLNDialog (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Member_GLNDialog (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member_GLNDialog(
    IN inId          Integer,        -- ���������� ���� 
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GLN TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       SELECT Object_Member.Id
            , Object_Member.ObjectCode AS Code
            , Object_Member.ValueData  AS Name
            , ObjectString_GLN.ValueData :: TVarChar AS GLN
       FROM Object AS Object_Member
         LEFT JOIN ObjectString AS ObjectString_GLN
                                ON ObjectString_GLN.ObjectId = Object_Member.Id
                               AND ObjectString_GLN.DescId IN (zc_ObjectString_Member_GLN(), zc_ObjectString_MemberExternal_GLN()) 
       WHERE Object_Member.Id = inId;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.17         *
*/

-- ����
-- select * from gpGet_Object_Member_GLNDialog(inId := 8486 ,  inSession := '9457');
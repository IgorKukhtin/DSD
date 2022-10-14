-- Function: gpGet_Object_User_Language()

DROP FUNCTION IF EXISTS gpGet_Object_User_Language (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User_Language(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Language TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT 
          Object_User.Id
        , Object_User.ObjectCode
        , Object_User.ValueData
        , COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language

   FROM Object AS Object_User
                 
        LEFT JOIN ObjectString AS ObjectString_Language
               ON ObjectString_Language.ObjectId = Object_User.Id
              AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
   WHERE Object_User.Id = vbUserId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_User_Language (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.09.22                                                       *
*/

-- ����
-- 
select * from gpGet_Object_User_Language(inSession := '3');
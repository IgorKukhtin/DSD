-- Function: gpGet_Scale_User()

DROP FUNCTION IF EXISTS gpGet_Scale_User (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_User(
    IN inSession     TVarChar      -- ������ ������������
)
RETURNS TABLE (UserId    Integer
             , UserCode  Integer
             , UserName  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
       SELECT Object_User.Id         AS UserId
            , Object_User.ObjectCode AS UserCode
            , Object_User.ValueData  AS UserName
       FROM Object AS Object_User
       WHERE Id = vbUserId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_User (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.01.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_User (zfCalc_UserAdmin())

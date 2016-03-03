-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, Directory TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���������
   RETURN QUERY 
     SELECT 'pop.ua.fm'       :: TVarChar AS Host
          , '110'             :: TVarChar AS Port
          , ''                :: TVarChar AS Mail
          , 'Ashtu777@ua.fm'  :: TVarChar AS UserName
          , 'qsxqsxw1'        :: TVarChar AS PasswordValue
          , '\inbox'          :: TVarChar AS Directory
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.16                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ImportSettings_Email (zfCalc_UserAdmin()) order by 3

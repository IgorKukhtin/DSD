-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, DirectoryMail TVarChar
             , Id               Integer
             , Code             Integer
             , Name             TVarChar
             , JuridicalId      Integer
             , JuridicalCode    Integer
             , JuridicalName    TVarChar
             , ContractId       Integer
             , ContractName     TVarChar
             , DirectoryImport  TVarChar
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
          , '\inbox'          :: TVarChar AS DirectoryMail

          , gpSelect.Id
          , gpSelect.Code
          , gpSelect.Name
          , gpSelect.JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , gpSelect.JuridicalName
          , gpSelect.ContractId
          , gpSelect.ContractName
          , gpSelect.Directory AS DirectoryImport
     FROM gpSelect_Object_ImportSettings (inSession:= inSession) AS gpSelect
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = gpSelect.JuridicalId
     WHERE gpSelect.isErased = FALSE
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

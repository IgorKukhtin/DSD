-- Function: gpSelect_Object_ExportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, TDateTime, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, Integer, TDateTime, TVarChar, TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, Integer, TDateTime, Text, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExportSettings_Email(
    IN inObjectId         Integer,       -- ���� �������
    IN inContactPersonId  Integer,       -- ���� �������
    IN inByDate           TDateTime,     -- 
    IN inByMail           Text,          -- 
    IN inByFileName       TBlob,         -- 
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (EmailId          Integer
             , EmailName        TVarChar
             , EmailKindId      Integer
             , EmailKindName    TVarChar
             , Host TVarChar, Port TVarChar
             , UserName TVarChar, PasswordValue TVarChar
             , MailFrom TVarChar, MailTo TVarChar
             , Subject TVarChar, Body TBlob
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbIsUkrNet Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   vbIsUkrNet:= EXISTS (select 1 from Object WHERE Id = vbUserId AND ObjectCode < 0);


   -- ���������
   RETURN QUERY 
     WITH tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.EmailKindId = zc_Enum_EmailKind_OutOrder() AND tmp.JuridicalId = 0)
        , tmpFind AS (SELECT * FROM gpSelect_Object_ImportSettings_Email ('zc_Enum_EmailKind_IncomeMMO', inSession:= inSession) AS tmp
                      WHERE tmp.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                        AND tmp.Id          = inObjectId
                        AND STRPOS (LOWER (inByMail), LOWER (tmp.Mail)) > 0
                     )
     SELECT 
            gpGet_Host.EmailId
          , gpGet_Host.EmailName
          , gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindName

          , case when vbIsUkrNet = TRUE THEN 'smtp.ukr.net'          ELSE gpGet_Host.Value     END :: TVarChar AS Host
          , case when vbIsUkrNet = TRUE THEN '465'                   ELSE gpGet_Port.Value     END :: TVarChar AS Port
          , case when vbIsUkrNet = TRUE THEN 'zakaz_neboley@ukr.net' ELSE gpGet_User.Value     END :: TVarChar AS UserName
          , case when vbIsUkrNet = TRUE THEN 'neboley2000'           ELSE gpGet_Password.Value END :: TVarChar AS PasswordValue
          , case when vbIsUkrNet = TRUE THEN 'zakaz_neboley@ukr.net' ELSE gpGet_Mail.Value     END :: TVarChar AS MailFrom
          
          , CASE WHEN tmp.Num = 1 THEN 'ashtu777@ua.fm' WHEN tmp.Num = 2 THEN COALESCE (ObjectString_ErrorTo.ValueData, 'pravda_6@i.ua') ELSE 'price@neboley.dp.ua' END :: TVarChar AS MailTo

          , CASE WHEN gpSelect.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                      THEN '������ ���� - �������� ������ ��� ' || COALESCE (Object_ContactPerson.ValueData, '') || ' - ' || TO_CHAR (CURRENT_TIMESTAMP, 'dd.mm.yyyy hh:mm:ss')
                 ELSE '������ ���� - �������� ������ ���������� ' || '(' || COALESCE (Object_Juridical.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object_Juridical.ValueData, '') || ' - ' || TO_CHAR (CURRENT_TIMESTAMP, 'dd.mm.yyyy hh:mm:ss')
            END :: TVarChar AS Subject
          , CASE WHEN inByFileName = '-1'
                     THEN '������ ���������� ������ � ����� ���������� "' || COALESCE (inByFileName, '') || '".'
                 WHEN inByFileName = '0'
                     THEN '������ �������� "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" � ������������ ������ "' || COALESCE (inByMail, '') || '".'
                       || CASE WHEN gpSelect.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                                    THEN '�� �������� ����� *.mmo ��� �������� �������.���������� ������� ������ � ������ ������.'
                               ELSE '�� �������� ����� *.xls ��� �������� ������.���������� ������� ������ � ������ ������.'
                          END
                 WHEN inByFileName = '4'
                     THEN '������ �������� "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" � ������������ ������ "' || COALESCE (inByMail, '') || '". �������� ������ ���� ����� *.xls ��� ��������.���������� ������� ������ � ��������� ����� � ������ ������.'
                 WHEN inByFileName = '2'
                     THEN '� ����� �� ������� "' || COALESCE (inByMail, '') || '" ������� ������ ���� ����� *.xls ��� �������� ������.���������� ������� ������.'
                 ELSE '������ �������� "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" � ������������ ������ "' || COALESCE (inByMail, '') || '". �������� �������� "' || COALESCE (inByFileName, '') || '".'
             END :: TBlob AS Body

     FROM tmpEmail AS gpGet_Host
          LEFT JOIN (SELECT 1 AS Num UNION ALL SELECT 2 AS Num /*UNION ALL SELECT 3 AS Num*/) AS tmp ON 1 = 1
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()

          LEFT JOIN gpSelect_Object_ImportSettings (inSession:= inSession) AS gpSelect ON gpSelect.Id = inObjectId
          LEFT JOIN tmpFind ON tmpFind.Id = inObjectId
          LEFT JOIN ObjectString AS ObjectString_ErrorTo
                                 ON ObjectString_ErrorTo.ObjectId = COALESCE (tmpFind.EmailId, gpSelect.EmailId)
                                AND ObjectString_ErrorTo.DescId = zc_ObjectString_Email_ErrorTo()
                                AND ObjectString_ErrorTo.ValueData <> ''

          LEFT JOIN Object AS Object_Juridical     ON Object_Juridical.Id     = gpSelect.JuridicalId
          LEFT JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = inContactPersonId

     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.03.16                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 2367578, inContactPersonId:= 2324911, inByDate:= CURRENT_TIMESTAMP, inByMail:= 'info-fk.dp@framco.com.ua', inByFileName:= '', inSession:= zfCalc_UserAdmin()) order by 3
-- SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 2367552, inContactPersonId:= 2324488, inByDate:= CURRENT_TIMESTAMP, inByMail:= 'info-fk.dp@framco.com.ua', inByFileName:= '', inSession:= zfCalc_UserAdmin()) order by 3
-- SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 2357054, inContactPersonId:= 2325575, inByDate:= CURRENT_TIMESTAMP, inByMail:= 'info-fk.dp@framco.com.ua', inByFileName:= '', inSession:= zfCalc_UserAdmin()) order by 3

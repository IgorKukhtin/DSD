-- Function: gpSelect_Object_ExportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ExportSettings_Email (Integer, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExportSettings_Email(
    IN inObjectId         Integer,       -- ���� �������
    IN inByDate           TDateTime,     -- 
    IN inByMail           TVarChar,      -- 
    IN inByFileName       TVarChar,      -- 
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Host TVarChar, Port TVarChar
             , UserName TVarChar, PasswordValue TVarChar
             , MailFrom TVarChar, MailTo TVarChar
             , Subject TVarChar, Body TBlob
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_...());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���������
   RETURN QUERY 
     WITH tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= zc_Enum_EmailKind_OutOrder(), inSession:= inSession))
     SELECT 
            gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Mail.Value      AS MailFrom
          , CASE WHEN tmp.Num = 1 THEN 'ashtu777@ua.fm' WHEN tmp.Num = 2 THEN 'pravda_6@i.ua' ELSE 'price@neboley.dp.ua' END :: TVarChar AS MailTo

          , ('������ ���� - �������� ������ ���������� ' || '(' || COALESCE (Object_Juridical.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object_Juridical.ValueData, '') || ' - ' || TO_CHAR (CURRENT_TIMESTAMP, 'dd.mm.yyyy hh:mm:ss') ) :: TVarChar AS Subject
          , CASE WHEN inByFileName = '-1'
                     THEN '������ ���������� ������ � ����� ���������� "' || COALESCE (inByFileName, '') || '".'
                 WHEN inByFileName = '0'
                     THEN '������ �������� "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" � ������������ ������ "' || COALESCE (inByMail, '') || '". �� �������� ����� *.xls ��� �������� ������.���������� ������� ������ � ������ ������.'
                 WHEN inByFileName = '4'
                     THEN '������ �������� "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" � ������������ ������ "' || COALESCE (inByMail, '') || '". �������� ������ ���� ����� *.xls ��� ��������.���������� ������� ������ � ��������� ����� � ������ ������.'
                 WHEN inByFileName = '2'
                     THEN '� ����� �� ������� "' || COALESCE (inByMail, '') || '" ������� ������ ���� ����� *.xls ��� �������� ������.���������� ������� ������.'
                 ELSE '������ �������� "' || COALESCE (TO_CHAR (inByDate, 'dd.mm.yyyy hh:mm:ss'), '') || '" � ������������ ������ "' || COALESCE (inByMail, '') || '". �������� �������� "' || COALESCE (inByFileName, '') || '".'
             END :: TBlob AS Body

     FROM tmpEmail AS gpGet_Host
          LEFT JOIN (SELECT 1 AS Num UNION ALL SELECT 2 AS Num UNION ALL SELECT 3 AS Num) AS tmp ON 1 = 1
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()

          LEFT JOIN gpSelect_Object_ImportSettings (inSession:= inSession) AS gpSelect
                                                                           ON gpSelect.Id = inObjectId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = gpSelect.JuridicalId
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
-- SELECT * FROM gpSelect_Object_ExportSettings_Email (inObjectId:= 228283, inByDate:= CURRENT_TIMESTAMP, inByMail:= '', inByFileName:= '', inSession:= zfCalc_UserAdmin()) order by 3

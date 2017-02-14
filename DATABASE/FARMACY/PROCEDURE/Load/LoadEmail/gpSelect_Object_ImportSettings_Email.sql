-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inEmailKindDesc    TVarChar ,      --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (EmailId          Integer
             , EmailName        TVarChar
             , EmailKindId      Integer
             , EmailKindName    TVarChar
             , Id               Integer
             , Code             Integer
             , Name             TVarChar
             , JuridicalId      Integer
             , JuridicalCode    Integer
             , JuridicalName    TVarChar
             , JuridicalMail    TVarChar
             , ContactPersonId  Integer
             , ContactPersonName TVarChar
             , ContractId       Integer
             , ContractName     TVarChar
             , DirectoryImport  TVarChar

             , StartTime        TDateTime -- ����� ������ �������� ��������
             , EndTime          TDateTime -- ����� ��������� �������� ��������
             , onTime           Integer   -- � ����� �������������� ��������� ����� � �������� �������, ���

             , zc_Enum_EmailKind_InPrice    Integer
             , zc_Enum_EmailKind_IncomeMMO  Integer
             , Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, DirectoryMail TVarChar

             , isMultiLoad      Boolean   -- ����� ��� ��������� �����
             , isBeginMove      Boolean   -- !!!�����������!!! ���������� ����� � ���������� ���� � "������" ������ (� ���� �������� ����������� ������)
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
     WITH tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.Value <> '' AND tmp.EmailKindId IN (zc_Enum_EmailKind_InPrice(), zc_Enum_EmailKind_IncomeMMO()))
        , tmp_ImportSettings AS (SELECT *
                                 FROM gpSelect_Object_ImportSettings (inSession:= inSession) AS tmp
                                 WHERE tmp.isErased    = FALSE
                                   AND tmp.Directory   <> ''
                                   -- AND tmp.EmailKindId IN (zc_Enum_EmailKind_InPrice(), zc_Enum_EmailKind_IncomeMMO())
                                   AND tmp.EmailKindId = CASE WHEN LOWER (inEmailKindDesc) = LOWER ('zc_Enum_EmailKind_InPrice') THEN zc_Enum_EmailKind_InPrice() WHEN LOWER (inEmailKindDesc) = LOWER ('zc_Enum_EmailKind_IncomeMMO') THEN zc_Enum_EmailKind_IncomeMMO() END
                                )
        , tmp_IncomeMMO AS (SELECT tmp.Id
                                 , tmp.EmailKindId
                                 , tmp.EmailId
                                 , Object_ContactPerson.Id            AS ContactPersonId
                                 , Object_ContactPerson.ValueData     AS ContactPersonName
                                 , ObjectString_Mail.ValueData        AS ContactPersonMail
                            FROM (SELECT MIN (tmp.Id) AS Id, tmp.EmailId, tmp.EmailKindId
                                  FROM tmp_ImportSettings AS tmp
                                  WHERE tmp.EmailKindId     = zc_Enum_EmailKind_IncomeMMO()
                                    AND tmp.ContactPersonId IS NULL
                                  -- LIMIT 1
                                  GROUP BY tmp.EmailId, tmp.EmailKindId
                                 ) AS tmp
                                 INNER JOIN ObjectLink AS ObjectLink_ContactPerson_Email
                                                       ON ObjectLink_ContactPerson_Email.ChildObjectId = tmp.EmailId
                                                      AND ObjectLink_ContactPerson_Email.DescId        = zc_ObjectLink_ContactPerson_Email()
                                 /*INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                       ON ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                                      AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = zc_Enum_ContactPersonKind_IncomeMMO()*/
                                 INNER JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = ObjectLink_ContactPerson_Email.ObjectId
                                 INNER JOIN ObjectString AS ObjectString_Mail
                                                         ON ObjectString_Mail.ObjectId  = Object_ContactPerson.Id
                                                        AND ObjectString_Mail.DescId    = zc_ObjectString_ContactPerson_Mail()
                                                        AND ObjectString_Mail.ValueData <> ''

                            WHERE Object_ContactPerson.Id NOT IN (SELECT tmp.ContactPersonId
                                                                  FROM tmp_ImportSettings AS tmp
                                                                  WHERE tmp.EmailKindId     = zc_Enum_EmailKind_IncomeMMO()
                                                                    AND tmp.ContactPersonId IS NOT NULL
                                                                 )
                           )
     SELECT 
            gpGet_Host.EmailId
          , gpGet_Host.EmailName
          , gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindName

          , gpSelect.Id
          , gpSelect.Code
          , gpSelect.Name
          , gpSelect.JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , gpSelect.JuridicalName

          , gpSelect.ContactPersonMail AS JuridicalMail
          , gpSelect.ContactPersonId   AS ContactPersonId
          , gpSelect.ContactPersonName AS ContactPersonName

          , gpSelect.ContractId
          , gpSelect.ContractName
          , gpSelect.Directory AS DirectoryImport

          -- , ObjectDate_StartTime.ValueData        AS StartTime -- ����� ������ �������� ��������
          , CURRENT_DATE :: TDateTime             AS StartTime -- ����� ������ �������� ��������
          , ObjectDate_EndTime.ValueData          AS EndTime   -- ����� ��������� �������� ��������
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN /*5*/ ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- � ����� �������������� ��������� ����� � �������� �������, ���

          , zc_Enum_EmailKind_InPrice()   AS zc_Enum_EmailKind_InPrice
          , zc_Enum_EmailKind_IncomeMMO() AS zc_Enum_EmailKind_IncomeMMO

          , gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_Mail.Value      AS Mail
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Directory.Value AS DirectoryMail

/*            'imap.mail.ru'           :: TVarChar AS Host
          , '993'                    :: TVarChar AS Port -- 143
--            'pop.mail.ru'            :: TVarChar AS Host
--          , '995'                    :: TVarChar AS Port
          , ''                       :: TVarChar AS Mail

          , 'price-neboley@mail.ru'  :: TVarChar AS UserName
          , 'admin2014'              :: TVarChar AS PasswordValue
          , '..\������\inbox'        :: TVarChar AS DirectoryMail
*/

          , gpSelect.isMultiLoad
          , TRUE AS isBeginMove -- !!!�����������!!! ���������� ����� � ���������� ���� � "������" ������ (� ���� �������� ����������� ������)

     FROM tmpEmail AS gpGet_Host
          INNER JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailId      = gpGet_Host.EmailId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          INNER JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailId      = gpGet_Host.EmailId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          INNER JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailId      = gpGet_Host.EmailId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          INNER JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailId  = gpGet_Host.EmailId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          INNER JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailId = gpGet_Host.EmailId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

          INNER JOIN tmp_ImportSettings AS gpSelect
                                        -- ON gpSelect.EmailId           = gpGet_Host.EmailId
                                        ON gpSelect.EmailKindId       = gpGet_Host.EmailKindId
                                       AND gpSelect.ContactPersonMail <> ''

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = gpSelect.JuridicalId
          LEFT JOIN ObjectDate AS ObjectDate_StartTime 
                               ON ObjectDate_StartTime.ObjectId = gpSelect.Id
                              AND ObjectDate_StartTime.DescId = zc_ObjectDate_ImportSettings_StartTime()
          LEFT JOIN ObjectDate AS ObjectDate_EndTime 
                               ON ObjectDate_EndTime.ObjectId = gpSelect.Id
                              AND ObjectDate_EndTime.DescId = zc_ObjectDate_ImportSettings_EndTime()
          LEFT JOIN ObjectFloat AS ObjectFloat_Time
                                ON ObjectFloat_Time.ObjectId = gpSelect.Id
                               AND ObjectFloat_Time.DescId = zc_ObjectFloat_ImportSettings_Time()
     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
       -- AND ((gpSelect.Id  = 2357054 AND gpGet_Host.EmailId <> 2567237) OR inSession <> '3') -- ������ ��� ������ + ������ � �

   UNION ALL
     SELECT 
            gpGet_Host.EmailId
          , gpGet_Host.EmailName
          , gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindName

          , gpSelect.Id
          , gpSelect.Code
          , gpSelect.Name
          , gpSelect.JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , gpSelect.JuridicalName

          , COALESCE (gpSelect_two.ContactPersonMail, gpSelect.ContactPersonMail) :: TVarChar AS JuridicalMail
          , COALESCE (gpSelect_two.ContactPersonId,   gpSelect.ContactPersonId)   :: Integer  AS ContactPersonId
          , COALESCE (gpSelect_two.ContactPersonName, gpSelect.ContactPersonName) :: TVarChar AS ContactPersonName

          , gpSelect.ContractId
          , gpSelect.ContractName
          , gpSelect.Directory AS DirectoryImport

          -- , ObjectDate_StartTime.ValueData        AS StartTime -- ����� ������ �������� ��������
          , CURRENT_DATE :: TDateTime             AS StartTime -- ����� ������ �������� ��������
          , ObjectDate_EndTime.ValueData          AS EndTime   -- ����� ��������� �������� ��������
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN /*5*/ ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- � ����� �������������� ��������� ����� � �������� �������, ���

          , zc_Enum_EmailKind_InPrice()   AS zc_Enum_EmailKind_InPrice
          , zc_Enum_EmailKind_IncomeMMO() AS zc_Enum_EmailKind_IncomeMMO

          , gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_Mail.Value      AS Mail
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Directory.Value AS DirectoryMail

          , gpSelect.isMultiLoad
          , TRUE AS isBeginMove -- !!!�����������!!! ���������� ����� � ���������� ���� � "������" ������ (� ���� �������� ����������� ������)

     FROM tmpEmail AS gpGet_Host
          INNER JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailId      = gpGet_Host.EmailId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          INNER JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailId      = gpGet_Host.EmailId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          INNER JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailId      = gpGet_Host.EmailId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          INNER JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailId  = gpGet_Host.EmailId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          INNER JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailId = gpGet_Host.EmailId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

          LEFT JOIN tmp_IncomeMMO AS gpSelect_two -- ON gpSelect_two.EmailId     = gpGet_Host.EmailId
                                                  ON gpSelect_two.EmailKindId = gpGet_Host.EmailKindId
          INNER JOIN tmp_ImportSettings AS gpSelect ON gpSelect.Id = gpSelect_two.Id

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = gpSelect.JuridicalId
          LEFT JOIN ObjectDate AS ObjectDate_StartTime 
                               ON ObjectDate_StartTime.ObjectId = gpSelect.Id
                              AND ObjectDate_StartTime.DescId = zc_ObjectDate_ImportSettings_StartTime()
          LEFT JOIN ObjectDate AS ObjectDate_EndTime 
                               ON ObjectDate_EndTime.ObjectId = gpSelect.Id
                              AND ObjectDate_EndTime.DescId = zc_ObjectDate_ImportSettings_EndTime()
          LEFT JOIN ObjectFloat AS ObjectFloat_Time
                                ON ObjectFloat_Time.ObjectId = gpSelect.Id
                               AND ObjectFloat_Time.DescId = zc_ObjectFloat_ImportSettings_Time()
     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
     -- AND (gpSelect.Id  = 2357054 OR inSession <> '3') -- ������ ��� ������ + ������ � �
     -- ORDER BY gpGet_Host.EmailId, gpGet_Host.EmailKindId, gpSelect.Name, COALESCE (gpSelect_two.ContactPersonName, gpSelect.ContactPersonName)
     ORDER BY 1, 5, 11
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
-- SELECT * FROM gpSelect_Object_ImportSettings_Email ('zc_Enum_EmailKind_InPrice', zfCalc_UserAdmin()) AS tmp order by 3
-- SELECT * FROM gpSelect_Object_ImportSettings_Email ('zc_Enum_EmailKind_IncomeMMO', zfCalc_UserAdmin()) AS tmp order by 3

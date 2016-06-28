-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (EmailKindId                  Integer
             , EmailKindname                TVarChar
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

             , StartTime        TDateTime -- Время начала активной проверки
             , EndTime          TDateTime -- Время окончания активной проверки
             , onTime           Integer   -- с какой периодичностью проверять почту в активном периоде, мин

             , zc_Enum_EmailKind_InPrice    Integer
             , zc_Enum_EmailKind_IncomeMMO  Integer
             , Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, DirectoryMail TVarChar

             , isBeginMove      Boolean   -- !!!захардкодил!!! переносить прайс в актуальные цены и "другие" данные (а сама загрузка выполняется всегда)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);


   -- Результат
   RETURN QUERY 
     WITH tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= 0, inSession:= inSession) AS tmp WHERE tmp.EmailKindId IN (zc_Enum_EmailKind_InPrice(), zc_Enum_EmailKind_IncomeMMO()))
        , tmp_IncomeMMO AS (SELECT tmp.Id
                                 , tmp.EmailKindId
                                 , Object_ContactPerson.Id            AS ContactPersonId
                                 , Object_ContactPerson.ValueData     AS ContactPersonName
                                 , ObjectString_Mail.ValueData        AS ContactPersonMail
                            FROM (SELECT tmp.*
                                  FROM gpSelect_Object_ImportSettings (inSession:= inSession) AS tmp
                                  WHERE tmp.isErased = FALSE
                                    AND tmp.Directory <> ''
                                    AND tmp.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                                    AND tmp.ContactPersonId IS NULL
                                  LIMIT 1
                                 ) AS tmp
                                 INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                       ON ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                                      AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = zc_Enum_ContactPersonKind_IncomeMMO()
                                 INNER JOIN Object AS Object_ContactPerson ON Object_ContactPerson.Id = ObjectLink_ContactPerson_ContactPersonKind.ObjectId
                                 INNER JOIN ObjectString AS ObjectString_Mail
                                                         ON ObjectString_Mail.ObjectId  = Object_ContactPerson.Id
                                                        AND ObjectString_Mail.DescId    = zc_ObjectString_ContactPerson_Mail()
                                                        AND ObjectString_Mail.ValueData <> ''

                            WHERE Object_ContactPerson.Id NOT IN (SELECT tmp.ContactPersonId
                                                                  FROM gpSelect_Object_ImportSettings (inSession:= inSession) AS tmp
                                                                  WHERE tmp.isErased = FALSE
                                                                    AND tmp.Directory <> ''
                                                                    AND tmp.EmailKindId = zc_Enum_EmailKind_IncomeMMO()
                                                                    AND tmp.ContactPersonId IS NOT NULL
                                                                 )
                           )
     SELECT 
            gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindname

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

          -- , ObjectDate_StartTime.ValueData        AS StartTime -- Время начала активной проверки
          , CURRENT_DATE :: TDateTime             AS StartTime -- Время начала активной проверки
          , ObjectDate_EndTime.ValueData          AS EndTime   -- Время окончания активной проверки
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN /*5*/ ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- с какой периодичностью проверять почту в активном периоде, мин

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
          , '..\Прайсы\inbox'        :: TVarChar AS DirectoryMail
*/

          , TRUE AS isBeginMove -- !!!захардкодил!!! переносить прайс в актуальные цены и "другие" данные (а сама загрузка выполняется всегда)

     FROM tmpEmail AS gpGet_Host
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailKindId  = gpGet_Host.EmailKindId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          LEFT JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailKindId = gpGet_Host.EmailKindId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

          LEFT JOIN tmp_IncomeMMO AS gpSelect_two ON gpSelect_two.EmailKindId = gpGet_Host.EmailKindId AND 1=0
          INNER JOIN gpSelect_Object_ImportSettings (inSession:= inSession) AS gpSelect
                                                                            ON gpSelect.EmailKindId = gpGet_Host.EmailKindId
                                                                           AND ((gpSelect.isErased = FALSE
                                                                             AND gpSelect.ContactPersonMail <> ''
                                                                             AND gpSelect.Directory <> ''
                                                                                )
                                                                             --OR (gpSelect.Id = gpSelect_two.Id)
                                                                               )

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
UNION ALL
     SELECT 
            gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindname

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

          -- , ObjectDate_StartTime.ValueData        AS StartTime -- Время начала активной проверки
          , CURRENT_DATE :: TDateTime             AS StartTime -- Время начала активной проверки
          , ObjectDate_EndTime.ValueData          AS EndTime   -- Время окончания активной проверки
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN /*5*/ ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- с какой периодичностью проверять почту в активном периоде, мин

          , zc_Enum_EmailKind_InPrice()   AS zc_Enum_EmailKind_InPrice
          , zc_Enum_EmailKind_IncomeMMO() AS zc_Enum_EmailKind_IncomeMMO

          , gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_Mail.Value      AS Mail
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Directory.Value AS DirectoryMail

          , TRUE AS isBeginMove -- !!!захардкодил!!! переносить прайс в актуальные цены и "другие" данные (а сама загрузка выполняется всегда)

     FROM tmpEmail AS gpGet_Host
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailKindId      = gpGet_Host.EmailKindId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailKindId  = gpGet_Host.EmailKindId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          LEFT JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailKindId = gpGet_Host.EmailKindId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

          LEFT JOIN tmp_IncomeMMO AS gpSelect_two ON gpSelect_two.EmailKindId = gpGet_Host.EmailKindId
          INNER JOIN gpSelect_Object_ImportSettings (inSession:= inSession) AS gpSelect ON gpSelect.Id = gpSelect_two.Id

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



     -- ORDER BY gpGet_Host.EmailKindId, gpSelect.Name, COALESCE (gpSelect_two.ContactPersonName, gpSelect.ContactPersonName)
     ORDER BY 1, 5, 11
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ImportSettings_Email (zfCalc_UserAdmin()) AS tmp WHERE EmailKindId = zc_Enum_EmailKind_IncomeMMO() order by 3

-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inEmailKindDesc    TVarChar ,      --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (AreaId           Integer
             , AreaName         TVarChar
             , AreaId_load      Integer
             , AreaName_load    TVarChar
             , EmailId          Integer
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

             , StartTime        TDateTime -- Время начала активной проверки
             , EndTime          TDateTime -- Время окончания активной проверки
             , onTime           Integer   -- с какой периодичностью проверять почту в активном периоде, мин

             , zc_Enum_EmailKind_InPrice    Integer
             , zc_Enum_EmailKind_IncomeMMO  Integer
             , zc_Area_Basis                Integer

             , Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, DirectoryMail TVarChar

             , isMultiLoad      Boolean   -- Много раз загружать прайс
             , isBeginMove      Boolean   -- !!!захардкодил!!! переносить прайс в актуальные цены и "другие" данные (а сама загрузка выполняется всегда)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Member());
   vbUserId:= lpGetUserBySession (inSession);



   -- !!!
   -- !!!что б не делать еще один шедулер - ВОССТАНОВЛЕНИЕ цен и НТЗ - здесь!!!
   IF  (EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) IN (0, 1, 2)
    AND EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) BETWEEN 1 AND 15
       )
    OR (EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) IN (6, 7, 8, 9, 10)
    AND EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) BETWEEN 41 AND 55
       )
   THEN
       PERFORM lpUpdate_Object_Price_restore();
   END IF;
   -- !!!


   -- Результат
   RETURN QUERY
     WITH tmpEmail AS (SELECT tmp.*
                            , COALESCE (ObjectLink_Area.ChildObjectId, zc_Area_Basis())  AS AreaId
                       FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp
                            LEFT JOIN ObjectLink AS ObjectLink_Area
                                                 ON ObjectLink_Area.ObjectId = tmp.EmailId
                                                AND ObjectLink_Area.DescId = zc_ObjectLink_Email_Area()
                       WHERE tmp.Value <> '' AND tmp.EmailKindId IN (zc_Enum_EmailKind_InPrice(), zc_Enum_EmailKind_IncomeMMO())
                      )
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
       -- ЮрЛица по ВСЕМ установленным Регионам
     , tmpJuridicalArea AS (SELECT ObjectLink_JuridicalArea_Juridical.ChildObjectId AS JuridicalId
                                 , ObjectLink_JuridicalArea_Area.ChildObjectId      AS AreaId
                            FROM Object AS Object_JuridicalArea
                                  INNER JOIN ObjectLink AS ObjectLink_JuridicalArea_Juridical
                                                        ON ObjectLink_JuridicalArea_Juridical.ObjectId = Object_JuridicalArea.Id
                                                       AND ObjectLink_JuridicalArea_Juridical.DescId = zc_ObjectLink_JuridicalArea_Juridical()

                                  LEFT JOIN ObjectLink AS ObjectLink_JuridicalArea_Area
                                                       ON ObjectLink_JuridicalArea_Area.ObjectId = Object_JuridicalArea.Id
                                                      AND ObjectLink_JuridicalArea_Area.DescId = zc_ObjectLink_JuridicalArea_Area()

                            WHERE Object_JuridicalArea.DescId = zc_Object_JuridicalArea()
                              AND Object_JuridicalArea.isErased = FALSE
                            )
        -- Контактные лица по другим Регионам - здесь нужен будет EMail (если он есть) для JuridicalId
      , tmpContactPerson AS (SELECT Object_ContactPerson.Id                       AS ContactPersonId
                                  , Object_ContactPerson.ObjectCode               AS ContactPersonCode
                                  , Object_ContactPerson.ValueData                AS ContactPersonName
                                  , ObjectLink_ContactPerson_Object.ChildObjectId AS JuridicalId
                                  , ObjectLink_Email_Area.ChildObjectId           AS AreaId
                                  , ObjectString_Mail.ValueData                   AS ContactPersonMail
                              FROM Object AS Object_ContactPerson
                                   INNER JOIN ObjectLink AS ObjectLink_ContactPerson_Object
                                                         ON ObjectLink_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                        AND ObjectLink_ContactPerson_Object.DescId   = zc_ObjectLink_ContactPerson_Object()
                                   LEFT JOIN ObjectString AS ObjectString_Mail
                                                          ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id
                                                         AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                   INNER JOIN ObjectLink AS ObjectLink_ContactPerson_Email
                                                         ON ObjectLink_ContactPerson_Email.ObjectId = Object_ContactPerson.Id
                                                        AND ObjectLink_ContactPerson_Email.DescId = zc_ObjectLink_ContactPerson_Email()
                                   INNER JOIN ObjectLink AS ObjectLink_Email_Area
                                                         ON ObjectLink_Email_Area.ObjectId      = ObjectLink_ContactPerson_Email.ChildObjectId
                                                        AND ObjectLink_Email_Area.DescId        = zc_ObjectLink_Email_Area()
                                                        AND ObjectLink_Email_Area.ChildObjectId <> zc_Area_Basis() -- Значит по другим Регионам
                              WHERE Object_ContactPerson.DescId   = zc_Object_ContactPerson()
                                AND Object_ContactPerson.isErased = FALSE
                            )
            -- Данные по ЮрЛицам по другим Регионам
          , tmp_DataArea AS (SELECT tmpJuridicalArea.JuridicalId
                                  , tmpJuridicalArea.AreaId
                                  , tmpContactPerson.ContactPersonId
                                  , tmpContactPerson.ContactPersonCode
                                  , tmpContactPerson.ContactPersonName
                                  , tmpContactPerson.ContactPersonMail
                              FROM tmpJuridicalArea
                                   LEFT JOIN tmpContactPerson ON tmpContactPerson.JuridicalId = tmpJuridicalArea.JuridicalId
                                                             AND tmpContactPerson.AreaId      = tmpJuridicalArea.AreaId

                              WHERE tmpJuridicalArea.AreaId <> zc_Area_Basis() -- Значит по другим Регионам
                            )
     -- Результат
     -- Регион - zc_Area_Basis - Днепр
     SELECT
            Object_Area.Id             AS AreaId        -- !!!только для Прайса!!!
          , Object_Area.ValueData      AS AreaName      -- !!!только для Прайса!!!
          , Object_Area_load.Id        AS AreaId_load   -- Не всегда загрузка будет в регион Днепр
          , Object_Area_load.ValueData AS AreaName_load -- иногда загрузка будет в "без Региона"

          , gpGet_Host.EmailId
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
          , (gpSelect.Directory || CASE WHEN Object_Area.ValueData <> '' THEN Object_Area.ValueData || '\' ELSE '' END) :: TVarChar AS DirectoryImport

          -- , ObjectDate_StartTime.ValueData        AS StartTime -- Время начала активной проверки
          , CURRENT_DATE :: TDateTime             AS StartTime -- Время начала активной проверки
          , ObjectDate_EndTime.ValueData          AS EndTime   -- Время окончания активной проверки
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN /*5*/ ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- с какой периодичностью проверять почту в активном периоде, мин

          , zc_Enum_EmailKind_InPrice()   AS zc_Enum_EmailKind_InPrice
          , zc_Enum_EmailKind_IncomeMMO() AS zc_Enum_EmailKind_IncomeMMO
          , zc_Area_Basis()               AS zc_Area_Basis

          , gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_Mail.Value      AS Mail
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Directory.Value AS DirectoryMail
/*
          , 'imap.ukr.net'    :: TVarChar AS Host
          , '993'             :: TVarChar AS Port
          , 'Ashtu@ukr.net'   :: TVarChar AS Mail
          , 'Ashtu@ukr.net'   :: TVarChar AS UserName
          , 'qazqazw1'        :: TVarChar AS PasswordValue
          -- , '\inbox'          :: TVarChar AS DirectoryMail
          , gpGet_Directory.Value AS DirectoryMail
*/
/*            'imap.mail.ru'           :: TVarChar AS Host
          , '993'                    :: TVarChar AS Port -- 143
--            'pop.mail.ru'            :: TVarChar AS Host
--          , '995'                    :: TVarChar AS Port
          , ''                       :: TVarChar AS Mail

          , 'price-neboley@mail.ru'  :: TVarChar AS UserName
          , 'admin2014'              :: TVarChar AS PasswordValue
          , '..\Прайсы\inbox'        :: TVarChar AS DirectoryMail
*/

          , gpSelect.isMultiLoad
          , TRUE AS isBeginMove -- !!!захардкодил!!! переносить прайс в актуальные цены и "другие" данные (а сама загрузка выполняется всегда)

     FROM tmpEmail AS gpGet_Host
          INNER JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailId      = gpGet_Host.EmailId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          INNER JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailId      = gpGet_Host.EmailId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          INNER JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailId      = gpGet_Host.EmailId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          INNER JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailId  = gpGet_Host.EmailId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          INNER JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailId = gpGet_Host.EmailId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

          INNER JOIN tmp_ImportSettings AS gpSelect
                                        ON gpSelect.EmailKindId       = gpGet_Host.EmailKindId
                                       AND gpSelect.ContactPersonMail <> ''
                                       AND (gpSelect.EmailId          = gpGet_Host.EmailId
                                         OR gpSelect.EmailKindId      = zc_Enum_EmailKind_IncomeMMO()
                                           )

          -- ВАЖНО - здесь Определяем - надо лиЮрлицу проставлять регион
          LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = gpSelect.JuridicalId
                                    AND tmpJuridicalArea.AreaId      = gpGet_Host.AreaId
                                    AND gpSelect.EmailKindId         = zc_Enum_EmailKind_InPrice()  -- !!!только для Прайса!!!
          LEFT JOIN Object AS Object_Area_load ON Object_Area_load.Id = tmpJuridicalArea.AreaId

          LEFT JOIN Object AS Object_Area ON Object_Area.Id       = gpGet_Host.AreaId
                                         AND gpSelect.EmailKindId = zc_Enum_EmailKind_InPrice() -- !!!только для Прайса!!!

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
       AND gpGet_Host.AreaId       = zc_Area_Basis()
       -- AND ((gpSelect.Id  = 2357054 AND gpGet_Host.EmailId <> 2567237) OR inSession <> '3') -- Приход ММО Оптима + Шапиро И А

    UNION ALL
     -- Другой Регион
     SELECT
            Object_Area.Id        AS AreaId
          , Object_Area.ValueData AS AreaName
          , Object_Area.Id        AS AreaId_load   -- Здесь другой регион
          , Object_Area.ValueData AS AreaName_load -- поэтому в него и загружаем
          , gpGet_Host.EmailId
          , gpGet_Host.EmailName
          , gpGet_Host.EmailKindId
          , gpGet_Host.EmailKindName

          , gpSelect.Id
          , gpSelect.Code
          , gpSelect.Name
          , gpSelect.JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , gpSelect.JuridicalName

            -- подставили другой адрес поставщика
          , CASE WHEN tmp_DataArea.ContactPersonMail <> '' THEN tmp_DataArea.ContactPersonMail ELSE gpSelect.ContactPersonMail END :: TVarChar AS JuridicalMail
          , COALESCE (tmp_DataArea.ContactPersonId, gpSelect.ContactPersonId)     AS ContactPersonId
          , COALESCE (tmp_DataArea.ContactPersonName, gpSelect.ContactPersonName) AS ContactPersonName

          , gpSelect.ContractId
          , gpSelect.ContractName
          , (gpSelect.Directory || CASE WHEN Object_Area.ValueData <> '' THEN Object_Area.ValueData || '\' ELSE '' END) :: TVarChar AS DirectoryImport

          -- , ObjectDate_StartTime.ValueData        AS StartTime -- Время начала активной проверки
          , CURRENT_DATE :: TDateTime             AS StartTime -- Время начала активной проверки
          , ObjectDate_EndTime.ValueData          AS EndTime   -- Время окончания активной проверки
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN /*5*/ ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- с какой периодичностью проверять почту в активном периоде, мин

          , zc_Enum_EmailKind_InPrice()   AS zc_Enum_EmailKind_InPrice
          , zc_Enum_EmailKind_IncomeMMO() AS zc_Enum_EmailKind_IncomeMMO
          , zc_Area_Basis()               AS zc_Area_Basis

          , gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_Mail.Value      AS Mail
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Directory.Value AS DirectoryMail

          , gpSelect.isMultiLoad
          , TRUE AS isBeginMove -- !!!захардкодил!!! переносить прайс в актуальные цены и "другие" данные (а сама загрузка выполняется всегда)

     FROM tmpEmail AS gpGet_Host
          INNER JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailId      = gpGet_Host.EmailId AND gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          INNER JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailId      = gpGet_Host.EmailId AND gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          INNER JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailId      = gpGet_Host.EmailId AND gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          INNER JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailId  = gpGet_Host.EmailId AND gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
          INNER JOIN tmpEmail AS gpGet_Directory ON gpGet_Directory.EmailId = gpGet_Host.EmailId AND gpGet_Directory.EmailToolsId = zc_Enum_EmailTools_Directory()

          INNER JOIN tmp_ImportSettings AS gpSelect
                                        ON gpSelect.EmailKindId       = gpGet_Host.EmailKindId
                                       AND gpSelect.ContactPersonMail <> ''

          -- ограничили + подставили (Контактн лицо) для Другого региона
          INNER JOIN tmp_DataArea ON tmp_DataArea.JuridicalId = gpSelect.JuridicalId
                                 AND tmp_DataArea.AreaId      = gpGet_Host.AreaId

          LEFT JOIN Object AS Object_Area ON Object_Area.Id = gpGet_Host.AreaId
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
       AND gpGet_Host.AreaId       <> zc_Area_Basis()

   UNION ALL
     -- MMO
     SELECT
            0  :: Integer  AS AreaId
          , '' :: TVarChar AS AreaName
          , 0  :: Integer  AS AreaId_load
          , '' :: TVarChar AS AreaName_load
          , gpGet_Host.EmailId
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

          -- , ObjectDate_StartTime.ValueData        AS StartTime -- Время начала активной проверки
          , CURRENT_DATE :: TDateTime             AS StartTime -- Время начала активной проверки
          , ObjectDate_EndTime.ValueData          AS EndTime   -- Время окончания активной проверки
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN /*5*/ ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- с какой периодичностью проверять почту в активном периоде, мин

          , zc_Enum_EmailKind_InPrice()   AS zc_Enum_EmailKind_InPrice
          , zc_Enum_EmailKind_IncomeMMO() AS zc_Enum_EmailKind_IncomeMMO
          , zc_Area_Basis()               AS zc_Area_Basis

          , gpGet_Host.Value      AS Host
          , gpGet_Port.Value      AS Port
          , gpGet_Mail.Value      AS Mail
          , gpGet_User.Value      AS UserName
          , gpGet_Password.Value  AS PasswordValue
          , gpGet_Directory.Value AS DirectoryMail

          , gpSelect.isMultiLoad
          , TRUE AS isBeginMove -- !!!захардкодил!!! переносить прайс в актуальные цены и "другие" данные (а сама загрузка выполняется всегда)

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
     -- AND (gpSelect.Id  = 2357054 OR inSession <> '3') -- Приход ММО Оптима + Шапиро И А
     -- ORDER BY gpGet_Host.EmailId, gpGet_Host.EmailKindId, gpSelect.Name, COALESCE (gpSelect_two.ContactPersonName, gpSelect.ContactPersonName)
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
-- SELECT * FROM gpSelect_Object_ImportSettings_Email ('zc_Enum_EmailKind_InPrice', zfCalc_UserAdmin()) AS tmp order by JuridicalName, 7
-- SELECT * FROM gpSelect_Object_ImportSettings_Email ('zc_Enum_EmailKind_IncomeMMO', zfCalc_UserAdmin()) AS tmp order by 7

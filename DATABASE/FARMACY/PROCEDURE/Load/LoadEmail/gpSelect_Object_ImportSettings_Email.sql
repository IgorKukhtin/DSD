-- Function: gpSelect_Object_ImportSettings_Email (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ImportSettings_Email (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ImportSettings_Email(
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Host TVarChar, Port TVarChar, Mail TVarChar
             , UserName TVarChar, PasswordValue TVarChar, DirectoryMail TVarChar
             , Id               Integer
             , Code             Integer
             , Name             TVarChar
             , JuridicalId      Integer
             , JuridicalCode    Integer
             , JuridicalName    TVarChar
             , JuridicalMail    TVarChar
             , ContractId       Integer
             , ContractName     TVarChar
             , DirectoryImport  TVarChar

             , StartTime        TDateTime -- Время начала активной проверки
             , EndTime          TDateTime -- Время окончания активной проверки
             , onTime           Integer   -- с какой периодичностью проверять почту в активном периоде, мин
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
     SELECT 'pop.mail.ru'            :: TVarChar AS Host
          , '110'                    :: TVarChar AS Port
          , ''                       :: TVarChar AS Mail
          , 'price-neboley@mail.ru'  :: TVarChar AS UserName
          , 'admin2014'              :: TVarChar AS PasswordValue
          , '..\Прайсы\inbox'               :: TVarChar AS DirectoryMail

          , gpSelect.Id
          , gpSelect.Code
          , gpSelect.Name
          , gpSelect.JuridicalId
          , Object_Juridical.ObjectCode AS JuridicalCode
          , gpSelect.JuridicalName
          , gpSelect.ContactPersonMail AS JuridicalMail
          , gpSelect.ContractId
          , gpSelect.ContractName
          , gpSelect.Directory AS DirectoryImport

          , ObjectDate_StartTime.ValueData        AS StartTime -- Время начала активной проверки
          , ObjectDate_EndTime.ValueData          AS EndTime   -- Время окончания активной проверки
          , CASE WHEN ObjectFloat_Time.ValueData >= 1 THEN ObjectFloat_Time.ValueData ELSE 5 END :: Integer AS onTime    -- с какой периодичностью проверять почту в активном периоде, мин

     FROM gpSelect_Object_ImportSettings (inSession:= inSession) AS gpSelect
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
     WHERE gpSelect.isErased = FALSE
       -- AND gpSelect.ContactPersonMail <> ''
       AND gpSelect.Directory <> ''
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
-- SELECT * FROM gpSelect_Object_ImportSettings_Email (zfCalc_UserAdmin()) order by 3

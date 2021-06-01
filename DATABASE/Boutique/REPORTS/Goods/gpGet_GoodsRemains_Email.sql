-- Function: gpGet_Movement_Email_Send()

DROP FUNCTION IF EXISTS gpGet_GoodsRemains_Email (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsRemains_Email(
    IN inFileName             TVarChar  ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port TVarChar, UserName TVarChar, Password TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;

   DECLARE vbPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
     /*SELECT inFileName               :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , '24447183@ukr.net'          :: TVarChar AS AddressFrom
          , 'ashtu@ua.fm'            :: TVarChar AS AddressTo
          , 'smtp.ukr.net'           :: TVarChar AS Host
          , '465'                     :: TVarChar AS Port
          , '24447183@ukr.net'          :: TVarChar AS UserName
          , 'vas6ok'               :: TVarChar AS Password
*/

     SELECT inFileName                    :: TVarChar AS Subject
          , inFileName                    :: TBlob    AS Body
          , 'podium_dnepr@ukr.net'        :: TVarChar AS AddressFrom
          , CASE WHEN 1=0 AND inSession = zfCalc_UserAdmin() THEN 'ashtu@ua.fm'  ELSE 'Grigorashd@i.ua;ashtu@ua.fm' END :: TVarChar AS AddressTo
--        , 'ashtu@ua.fm'                 :: TVarChar AS AddressTo
          , 'smtp.ukr.net'                :: TVarChar AS Host
          , '465'                         :: TVarChar AS Port
          , 'podium_dnepr@ukr.net'        :: TVarChar AS UserName
        --, '12podium12'                  :: TVarChar AS Password
          , 'rMm5A9kfYjwnOfWu'            :: TVarChar AS Password

/*     SELECT inFileName               :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , 'ashtu@ukr.net'          :: TVarChar AS AddressFrom
          , 'ashtu@ua.fm'            :: TVarChar AS AddressTo
          , 'smtp.ukr.net'           :: TVarChar AS Host
          , '465'                    :: TVarChar AS Port
          , 'ashtu@ukr.net'          :: TVarChar AS UserName
          , 'cwhcKndOhbOtgND9'       :: TVarChar AS Password*/
  /*   SELECT inFileName               :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , 'ashtu@ua.fm'          :: TVarChar AS AddressFrom
          , 'ashtu@ua.fm'            :: TVarChar AS AddressTo
          , 'smtp.ua.fm'           :: TVarChar AS Host
          , '465'                    :: TVarChar AS Port
          , 'ashtu@ua.fm'          :: TVarChar AS UserName
          , 'aaa'               :: TVarChar AS Password*/
         ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.02.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_GoodsRemains_Email (inFileName:= ('Podium_' || CURRENT_TIMESTAMP), inSession:= zfCalc_UserAdmin())

-- Function: gpGet_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpGet_Object_EmailSettings(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_EmailSettings(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_EmailSettings(
    IN inEmailKindId   Integer   ,
    IN inOrderNumber   TVarChar  ,
   OUT outHttps_order  TVarChar  ,
   OUT outHttps_pdf    TVarChar  ,
   OUT outHttps_png    TVarChar  ,
   OUT outTokenValue   TVarChar  ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_EmailSettings());

-- old
-- https://agilis-jettenders.com/wp-admin/admin-ajax.php?action=catalog_csv3&order=
-- https://agilis-jettenders.com/constructor-pdf/agilis-configuration-
-- https://agilis-jettenders.com/constructor-images/order-constructor-

-- new
-- https://agilis-jettenders.com/wp-json/agilis/v1/order/json/?id=
-- https://agilis-jettenders.com/wp-json/agilis/v1/order/pdf/?id=
-- https://agilis-jettenders.com/wp-json/agilis/v1/order/png/?id=


    WITH tmpEmailSettings AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= CASE WHEN inOrderNumber <> '' THEN zc_Enum_EmailKind_HTTP_OrderClient() ELSE inEmailKindId END, inSession:= inSession)
                             )
       --
       SELECT tmpEmailSettings_Host.Value                    :: TVarChar AS Https_order
              -- new
            , (tmpEmailSettings_Port.Value || inOrderNumber) :: TVarChar AS Https_pdf
            , (tmpEmailSettings_Mail.Value || inOrderNumber) :: TVarChar AS Https_png
              -- old
            --, (tmpEmailSettings_Port.Value || inOrderNumber || '.pdf') :: TVarChar AS Https_pdf
            --, (tmpEmailSettings_Mail.Value || inOrderNumber || '.png') :: TVarChar AS Https_png
              --
            , CASE WHEN tmpEmailSettings_User.Value <> ''     THEN tmpEmailSettings_User.Value
                   WHEN tmpEmailSettings_Password.Value <> '' THEN tmpEmailSettings_Password.Value
                   ELSE ''
              END :: TVarChar AS TokenValue
              INTO outHttps_order
                 , outHttps_pdf
                 , outHttps_png
                 , outTokenValue
       FROM (SELECT 1) AS tmp
            -- order
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_Host     ON tmpEmailSettings_Host.EmailToolsId     = zc_Enum_EmailTools_Host()
            -- pdf
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_Port     ON tmpEmailSettings_Port.EmailToolsId     = zc_Enum_EmailTools_Port()
            -- png
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_Mail     ON tmpEmailSettings_Mail.EmailToolsId     = zc_Enum_EmailTools_Mail()
            -- Token
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_User     ON tmpEmailSettings_User.EmailToolsId     = zc_Enum_EmailTools_User()
            -- or Token
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_Password ON tmpEmailSettings_Password.EmailToolsId = zc_Enum_EmailTools_Password()
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.06.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_EmailSettings (inEmailKindId:= 0, inOrderNumber:= '12345', inSession:= '5')

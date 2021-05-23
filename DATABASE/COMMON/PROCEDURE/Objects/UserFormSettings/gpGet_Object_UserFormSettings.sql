-- Function: gpGet_Object_UserFormSettings()

--DROP FUNCTION gpGet_Object_UserFormSettings();

CREATE OR REPLACE FUNCTION gpGet_Object_UserFormSettings(
    IN inFormName    TVarChar,      -- Форма
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TBlob
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbData   TBlob;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   SELECT
         ObjectBLOB_UserFormSettings_Data.ValueData
         INTO vbData
   FROM Object AS Object_UserFormSettings
        JOIN ObjectBLOB AS ObjectBLOB_UserFormSettings_Data
                        ON ObjectBLOB_UserFormSettings_Data.ObjectId = Object_UserFormSettings.Id
                       AND ObjectBLOB_UserFormSettings_Data.DescId   = zc_ObjectBlob_UserFormSettings_Data()
        JOIN ObjectLink AS ObjectLink_UserFormSettings_User
                        ON ObjectLink_UserFormSettings_User.ObjectId      = Object_UserFormSettings.Id
                       AND ObjectLink_UserFormSettings_User.DescId        = zc_ObjectLink_UserFormSettings_User()
                       AND ObjectLink_UserFormSettings_User.ChildObjectId = vbUserId
  WHERE Object_UserFormSettings.ValueData = inFormName
    AND Object_UserFormSettings.DescId    = zc_Object_UserFormSettings();

   RETURN vbData;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.21                                        *
*/

-- тест
-- SELECT gpGet_Object_UserFormSettings ('Плановая Прибыль (Факт)', '81245')

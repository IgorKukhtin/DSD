-- Function: gpInsertUpdate_Object_UserFormSettings()

-- DROP FUNCTION gpInsertUpdate_Object_UserFormSettings();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserFormSettings(
  IN inFormName             TVarChar,    -- Имя формы
  IN inUserFormSettingsData TBLOB   ,    -- Данные формы пользователя
  IN inSession              TVarChar     -- текущий пользователь
)
  RETURNS Integer
AS
$BODY$
DECLARE 
  vbId Integer;
  vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_Forms());
   vbUserId:= lpGetUserBySession (inSession);
               
   --
   vbId:= (SELECT Object_UserFormSettings.Id
           FROM Object AS Object_UserFormSettings
                JOIN ObjectLink AS ObjectLink_UserFormSettings_User 
                                ON ObjectLink_UserFormSettings_User.DescId        = zc_ObjectLink_UserFormSettings_User() 
                               AND ObjectLink_UserFormSettings_User.ChildObjectId = vbUserId
                               AND ObjectLink_UserFormSettings_User.ObjectId      = Object_UserFormSettings.Id
           WHERE Object_UserFormSettings.DescId    = zc_Object_UserFormSettings() 
             AND Object_UserFormSettings.ValueData = inFormName
          );

   --
   IF COALESCE (vbId, 0) = 0
   THEN
      --
      LOCK TABLE Object IN SHARE UPDATE EXCLUSIVE MODE;
      LOCK TABLE ObjectLink IN SHARE UPDATE EXCLUSIVE MODE;
      --
      vbId := lpInsertUpdate_Object (vbId, zc_Object_UserFormSettings(), 0, inFormName);

      --
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserFormSettings_User(), vbId, vbUserId);

   END IF;


   --
   LOCK TABLE ObjectBLOB IN SHARE UPDATE EXCLUSIVE MODE;
   --
   PERFORM lpInsertUpdate_ObjectBLOB (zc_ObjectBlob_UserFormSettings_Data(), vbId, inUserFormSettingsData);
   
   RETURN 0;
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

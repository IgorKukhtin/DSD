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
   --UserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_Forms());
   vbUserId := to_number(inSession, '00000000000');   
               
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
      --
      vbId := lpInsertUpdate_Object (vbId, zc_Object_UserFormSettings(), 0, inFormName);
      --
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserFormSettings_User(), vbId, vbUserId);
      -- Ведение протокола
      PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);

   END IF;


   --
   --
   PERFORM lpInsertUpdate_ObjectBLOB (zc_ObjectBlob_UserFormSettings_Data(), vbId, inUserFormSettingsData);
   
   RETURN 0;
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

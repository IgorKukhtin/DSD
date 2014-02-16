-- Function: gpInsertUpdate_Object_UserFormSettings()

-- DROP FUNCTION gpInsertUpdate_Object_UserFormSettings();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserFormSettings(
IN inFormName             TVarChar,    /* Имя формы */
IN inUserFormSettingsData TBLOB   ,    /* Данные формы пользователя*/
IN inSession              TVarChar     /* текущий пользователь */
)
  RETURNS integer AS
$BODY$
DECLARE 
  Id integer;
  UserId Integer;
BEGIN
   --UserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_Forms());
   UserId := to_number(inSession, '00000000000');   
               
   SELECT Object_UserFormSettings.Id INTO Id 
    FROM Object AS Object_UserFormSettings
    JOIN ObjectLink AS ObjectLink_UserFormSettings_User 
      ON ObjectLink_UserFormSettings_User.DescId = zc_ObjectLink_UserFormSettings_User() 
     AND ObjectLink_UserFormSettings_User.ChildObjectId = UserId
     AND ObjectLink_UserFormSettings_User.ObjectId = Object_UserFormSettings.Id
   WHERE Object_UserFormSettings.DescId = zc_Object_UserFormSettings() 
     AND Object_UserFormSettings.ValueData = inFormName;

   IF COALESCE(Id, 0) = 0 THEN
      Id := lpInsertUpdate_Object(Id, zc_Object_UserFormSettings(), 0, inFormName);
   END IF;

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_UserFormSettings_User(), Id, UserId);

   PERFORM lpInsertUpdate_ObjectBLOB(zc_ObjectBlob_UserFormSettings_Data(), Id, inUserFormSettingsData);
   
   RETURN 0;
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            
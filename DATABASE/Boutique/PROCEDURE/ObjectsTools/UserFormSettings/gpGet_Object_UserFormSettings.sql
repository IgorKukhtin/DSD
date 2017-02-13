-- Function: gpGet_Object_UserFormSettings()

--DROP FUNCTION gpGet_Object_UserFormSettings();

CREATE OR REPLACE FUNCTION gpGet_Object_UserFormSettings(
IN inFormName    TVarChar,       /* Форма */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TBlob AS
$BODY$
DECLARE
  Data TBlob;
  UserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   UserId := to_number(inSession, '00000000000');   


   SELECT 
       ObjectBLOB_UserFormSettings_Data.ValueData INTO Data
   FROM Object AS Object_UserFormSettings
   JOIN ObjectBLOB AS ObjectBLOB_UserFormSettings_Data
     ON ObjectBLOB_UserFormSettings_Data.DescId = zc_ObjectBlob_UserFormSettings_Data() 
    AND ObjectBLOB_UserFormSettings_Data.ObjectId = Object_UserFormSettings.Id
   JOIN ObjectLink AS ObjectLink_UserFormSettings_User 
     ON ObjectLink_UserFormSettings_User.DescId = zc_ObjectLink_UserFormSettings_User() 
    AND ObjectLink_UserFormSettings_User.ChildObjectId = UserId
    AND ObjectLink_UserFormSettings_User.ObjectId = Object_UserFormSettings.Id
  WHERE Object_UserFormSettings.ValueData = inFormName AND Object_UserFormSettings.DescId = zc_Object_UserFormSettings();
    
   RETURN DATA; 
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpGet_Object_UserFormSettings(TVarChar, TVarChar)
  OWNER TO postgres;

-- SELECT length(gpGet_Object_Form) FROM gpGet_Object_UserFormSettings('Form1', '2')
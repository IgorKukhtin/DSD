-- Function: gpSelect_Cash_UserSettings()

DROP FUNCTION IF EXISTS gpSelect_Cash_UserSettings (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_UserSettings(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name TVarChar
             , Pass TVarChar
             , MainForm TBlob
             , DataModulForm TBlob
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
    vbUserId:= lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- поиск <Торговой сети>
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey ::Integer;


    RETURN QUERY
    WITH FS AS (SELECT
                        ObjectLink_UserFormSettings_User.ChildObjectId      AS UserID
                      , ObjectBLOB_UserFormSettings_Data.ValueData          AS MainForm
                FROM Object AS Object_UserFormSettings
                     JOIN ObjectBLOB AS ObjectBLOB_UserFormSettings_Data
                                     ON ObjectBLOB_UserFormSettings_Data.DescId = zc_ObjectBlob_UserFormSettings_Data()
                                    AND ObjectBLOB_UserFormSettings_Data.ObjectId = Object_UserFormSettings.Id
                     JOIN ObjectLink AS ObjectLink_UserFormSettings_User
                                     ON ObjectLink_UserFormSettings_User.DescId = zc_ObjectLink_UserFormSettings_User()
                                    AND ObjectLink_UserFormSettings_User.ObjectId = Object_UserFormSettings.Id
                      WHERE Object_UserFormSettings.ValueData = 'TMainCashForm2' AND Object_UserFormSettings.DescId = zc_Object_UserFormSettings()),

         FD AS (SELECT
                        ObjectLink_UserFormSettings_User.ChildObjectId      AS UserID
                      , ObjectBLOB_UserFormSettings_Data.ValueData          AS MainForm
                FROM Object AS Object_UserFormSettings
                     JOIN ObjectBLOB AS ObjectBLOB_UserFormSettings_Data
                                     ON ObjectBLOB_UserFormSettings_Data.DescId = zc_ObjectBlob_UserFormSettings_Data()
                                    AND ObjectBLOB_UserFormSettings_Data.ObjectId = Object_UserFormSettings.Id
                     JOIN ObjectLink AS ObjectLink_UserFormSettings_User
                                     ON ObjectLink_UserFormSettings_User.DescId = zc_ObjectLink_UserFormSettings_User()
                                    AND ObjectLink_UserFormSettings_User.ObjectId = Object_UserFormSettings.Id
                      WHERE Object_UserFormSettings.ValueData = 'TdmMain' AND Object_UserFormSettings.DescId = zc_Object_UserFormSettings()),

         RR AS (SELECT Object_User.ID  AS RoleID
                FROM DefaultValue
                     INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                     INNER JOIN Object AS Object_User
                                       ON Object_User.Id = UserKeyId
                                      AND Object_User.DescId = zc_Object_Role()
                    LEFT JOIN Object ON Object.Id = zfConvert_StringToNumber (DefaultValue.DefaultValue)
                WHERE DefaultKeys.id = 1
                  AND Object.ID = vbObjectId),

         UR AS (SELECT  DISTINCT ObjectLink_UserRole_User.ChildObjectId AS UserID
                FROM RR AS UserRole_Role

                     INNER JOIN ObjectLink AS ObjectLink_UserRole_Role
                                           ON ObjectLink_UserRole_Role.ChildObjectId = UserRole_Role.RoleID
                                          AND ObjectLink_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()

                     INNER JOIN ObjectLink AS ObjectLink_UserRole_User
                                           ON ObjectLink_UserRole_User.ObjectId = ObjectLink_UserRole_Role.ObjectId
                                          AND ObjectLink_UserRole_User.DescId = zc_ObjectLink_UserRole_User())

    SELECT Object_User.Id
         , Object_User.ObjectCode
         , Object_User.ValueData

         , encode(ObjectString_User_Password.ValueData::bytea, 'base64')::TVarChar

         , UserFormSettings.MainForm
         , UserDMSettings.MainForm

    FROM UR

         INNER JOIN  Object AS Object_User
                            ON Object_User.ID = UR.UserID
                           AND Object_User.DescId = zc_Object_User()

         INNER JOIN ObjectString AS ObjectString_User_Password
                                ON ObjectString_User_Password.ObjectId = Object_User.Id
                               AND ObjectString_User_Password.DescId = zc_ObjectString_User_Password()
                               AND COALESCE (ObjectString_User_Password.ValueData, '') <> ''
                               
         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                ON ObjectLink_User_Member.ObjectId = Object_User.Id
               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                               

         LEFT JOIN FS AS UserFormSettings ON UserFormSettings.UserID = Object_User.Id

         LEFT JOIN FD AS UserDMSettings ON UserDMSettings.UserID = Object_User.Id

    WHERE Object_User.isErased = FALSE
      AND COALESCE(Object_Member.isErased, FALSE) = FALSE;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 01.05.19                                                      *
*/

-- тест

-- 
SELECT * FROM gpSelect_Cash_UserSettings (inSession:= '3')

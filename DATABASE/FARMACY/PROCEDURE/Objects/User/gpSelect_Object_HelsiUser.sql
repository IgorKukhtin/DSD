-- Function: gpSelect_Object_HelsiUser (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_HelsiUser (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_HelsiUser(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , PositionName TVarChar
             , UnitId Integer, UnitName TVarChar
             , UserName TVarChar
             , UserPassword TVarChar
             , KeyPassword TVarChar
             , PasswordEHels TVarChar
             , KeyExpireDate TDateTime
             , isUserKeyDate boolean
             , Color_calc Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Send());
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 11041603))
   THEN
     RAISE EXCEPTION 'Доступно только системному администратору';
   END IF;

   -- Результат
   RETURN QUERY 
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       ),
        tmpMedicalProgramSPUnit AS (SELECT DISTINCT ObjectLink_Unit.ChildObjectId                     AS UnitId 
                                    FROM Object AS Object_MedicalProgramSPLink
                                         INNER JOIN ObjectLink AS ObjectLink_Unit
                                                               ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                              AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                     WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                       AND Object_MedicalProgramSPLink.isErased = False),
        tmpUserKeyUnit AS (SELECT DISTINCT ObjectLink_User_Unit.ChildObjectId AS UnitId
                           FROM Object AS Object_User


                                 LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                                        ON ObjectLink_User_Unit.ObjectId = Object_User.Id
                                       AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Helsi_Unit()

                                 LEFT JOIN ObjectDate AS ObjectDate_User_KeyExpireDate
                                        ON ObjectDate_User_KeyExpireDate.DescId = zc_ObjectDate_User_KeyExpireDate() 
                                       AND ObjectDate_User_KeyExpireDate.ObjectId = Object_User.Id

                                 LEFT JOIN ObjectString AS ObjectString_KeyPassword 
                                        ON ObjectString_KeyPassword.DescId = zc_ObjectString_User_Helsi_KeyPassword() 
                                       AND ObjectString_KeyPassword.ObjectId = Object_User.Id

                                 LEFT JOIN ObjectBlob AS ObjectBlob_Key
                                        ON ObjectBlob_Key.DescId = zc_ObjectBlob_User_Helsi_Key() 
                                       AND ObjectBlob_Key.ObjectId = Object_User.Id

                           WHERE Object_User.DescId = zc_Object_User()
                             AND ObjectDate_User_KeyExpireDate.ValueData >= CURRENT_DATE 
                             AND COALESCE(ObjectBlob_Key.ValueData, '') <> '' 
                             AND COALESCE(ObjectString_KeyPassword.ValueData, '') <> '')
                         
   SELECT 
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_User.ValueData                      AS Name
       , Object_User.isErased                       AS isErased
       , Object_Member.Id                           AS MemberId
       , Object_Member.ValueData                    AS MemberName
                                                    
       , Object_Position.ValueData                  AS PositionName

       , Object_Unit.Id AS UnitId
       , Object_Unit.ValueData AS UnitName

       , ObjectString_UserName.ValueData
       , ObjectString_UserPassword.ValueData
       , ObjectString_KeyPassword.ValueData
       , ObjectString_PasswordEHels.ValueData
       
       , ObjectDate_User_KeyExpireDate.ValueData
       
       , CASE WHEN COALESCE(tmpMedicalProgramSPUnit.UnitId, 0) <> 0 AND 
                   COALESCE(tmpUserKeyUnit.UnitId, 0) = 0
              THEN True ELSE False END                                                    AS isUserKeyDate     

       , CASE WHEN Object_Unit.ValueData ILIKE '%Зачинена%' OR Object_Unit.ValueData ILIKE '%ЗАКРЫТА%' 
              THEN zfCalc_Color (255, 165, 0)
              WHEN COALESCE(ObjectBlob_Key.ValueData, '') <> '' AND 
                   COALESCE(ObjectString_KeyPassword.ValueData, '') <> '' AND
                   COALESCE(ObjectDate_User_KeyExpireDate.ValueData, CURRENT_DATE + INTERVAL '1 DAY') < CURRENT_DATE
              THEN zc_Color_Yelow() 
              ELSE zc_Color_White() END AS Color_calc     
       
   FROM Object AS Object_User

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                ON ObjectLink_User_Unit.ObjectId = Object_User.Id
               AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Helsi_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_UserName 
                ON ObjectString_UserName.DescId = zc_ObjectString_User_Helsi_UserName() 
               AND ObjectString_UserName.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_UserPassword
                ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Helsi_UserPassword() 
               AND ObjectString_UserPassword.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_KeyPassword 
                ON ObjectString_KeyPassword.DescId = zc_ObjectString_User_Helsi_KeyPassword() 
               AND ObjectString_KeyPassword.ObjectId = Object_User.Id
              
         LEFT JOIN ObjectString AS ObjectString_PasswordEHels 
                ON ObjectString_PasswordEHels.DescId = zc_ObjectString_User_Helsi_PasswordEHels() 
               AND ObjectString_PasswordEHels.ObjectId = Object_User.Id

         LEFT JOIN ObjectDate AS ObjectDate_User_KeyExpireDate
                ON ObjectDate_User_KeyExpireDate.DescId = zc_ObjectDate_User_KeyExpireDate() 
               AND ObjectDate_User_KeyExpireDate.ObjectId = Object_User.Id

         LEFT JOIN ObjectBlob AS ObjectBlob_Key
                ON ObjectBlob_Key.DescId = zc_ObjectBlob_User_Helsi_Key() 
               AND ObjectBlob_Key.ObjectId = Object_User.Id

         LEFT JOIN tmpMedicalProgramSPUnit ON tmpMedicalProgramSPUnit.UnitId = ObjectLink_User_Unit.ChildObjectId
         
         LEFT JOIN tmpUserKeyUnit ON tmpUserKeyUnit.UnitId = ObjectLink_User_Unit.ChildObjectId

   WHERE Object_User.DescId = zc_Object_User()
     AND COALESCE(ObjectString_UserName.ValueData, '') <> '';
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_HelsiUser (TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 25.02.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_HelsiUser ('3')
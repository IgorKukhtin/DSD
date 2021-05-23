-- Function: gpUpdate_Object_User_PhoneAuthent()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_PhoneAuthent (TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User_PhoneAuthent(
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
   vbUserId:= lpGetUserBySession (inSession);


   --выбираем тел из zc_Object_MobileEmployee
   
  PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_PhoneAuthent(), tmpMobileEmployee.UserId, tmpMobileEmployee.Phone)
        , lpInsert_ObjectProtocol (tmpMobileEmployee.UserId, vbUserId)  -- Cохранили протокол
  FROM 
       (SELECT ObjectLink_User_Member.ObjectId AS UserId
             , Object_MobileEmployee.ValueDAta AS Phone
        FROM Object AS Object_MobileEmployee
             LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Personal
                                  ON ObjectLink_MobileEmployee_Personal.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectLink_MobileEmployee_Personal.DescId = zc_ObjectLink_MobileEmployee_Personal()
               
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                  ON ObjectLink_Personal_Member.ObjectId = ObjectLink_MobileEmployee_Personal.ChildObjectId
                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                  
             INNER JOIN ObjectLink AS ObjectLink_User_Member
                                  ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          
        WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
          AND Object_MobileEmployee.isErased = false
          AND COALESCE (Object_MobileEmployee.ValueDAta,'') <> ''
        ) AS tmpMobileEmployee;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.21         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_User_PhoneAuthent ('2')
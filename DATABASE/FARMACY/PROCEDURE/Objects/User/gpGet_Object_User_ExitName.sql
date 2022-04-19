-- Function: gpGet_Object_User_ExitName()

DROP FUNCTION IF EXISTS gpGet_Object_User_ExitName (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User_ExitName(
    IN inName        TVarChar,      -- 
    IN inLogin       TVarChar,      --  
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Name TVarChar
             , Login TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbLogin TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 1633980))
   THEN
     RAISE EXCEPTION 'Создание нового пользователя вам запрещено.';
   END IF;
   
   vbLogin := inLogin;
   
   inName := TRIM(inName);     
   WHILE POSITION ('  ' in inName) > 0 LOOP
     inName := REPLACE (inName, '  ', ' ');
   END LOOP;

   
   IF COALESCE (vbLogin, '') = ''
   THEN
     IF SPLIT_PART (inName, ' ', 1) <> '' 
     THEN 
       vbLogin := SPLIT_PART (inName, ' ', 1);
     END IF;
     IF SPLIT_PART (inName, ' ', 2) <> '' 
     THEN 
       vbLogin := vbLogin||' '||SPLIT_PART (inName, ' ', 2);
     END IF;
   END IF;
   
   RETURN QUERY 
   SELECT inName, vbLogin;

  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_User_NewUser (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.04.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpGet_Object_User_ExitName (' Петров  Иван  Иванович', '', '3')
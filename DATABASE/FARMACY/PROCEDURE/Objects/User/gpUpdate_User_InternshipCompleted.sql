-- Function: gpUpdate_User_InternshipCompleted()

DROP FUNCTION IF EXISTS gpUpdate_User_InternshipCompleted (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_InternshipCompleted(
    IN inUserId                    Integer   ,    -- Сотрудник
    IN inIsInternshipCompleted     Boolean   ,    -- Стажировка проведена
    IN inSession                   TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inisInternshipCompleted, FALSE) <>
      COALESCE((SELECT ObjectBoolean.ValueData 
                FROM ObjectBoolean 
                WHERE ObjectBoolean.ObjectId = inUserId 
                  AND ObjectBoolean.DescId = zc_ObjectBoolean_User_InternshipCompleted()), FALSE)
   THEN

     IF inIsInternshipCompleted = False AND 
        NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
       RAISE EXCEPTION 'Изменение <Стажировка проведена>. Разрешено только системному администратору';
     END IF;     

       -- свойство <Стажировка проведена>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_InternshipCompleted(), inUserId, inIsInternshipCompleted);

     IF inIsInternshipCompleted = TRUE
     THEN
       -- свойство <Дата подтверждения стажировки>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_InternshipCompleted(), inUserId, CURRENT_DATE);
     END IF;     

     -- Ведение протокола
     PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);
     
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.22                                                       *
*/
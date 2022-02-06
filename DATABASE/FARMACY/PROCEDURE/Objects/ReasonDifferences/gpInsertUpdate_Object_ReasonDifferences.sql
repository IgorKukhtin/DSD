-- Function: gpInsertUpdate_Object_ReasonDifferences()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReasonDifferences(Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReasonDifferences(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Причина разногласия>
 INOUT ioCode                    Integer   ,    -- Код объекта <Причина разногласия>
    IN inName                    TVarChar  ,    -- Название объекта <Причина разногласия>
    IN inisDeficit               Boolean   ,    -- Недостача
    IN inisSurplus           Boolean   ,    -- Некондиция
    IN inSession                 TVarChar       -- Сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReasonDifferences());
   vbUserId:= inSession;

   -- проверка - проведенные/удаленные документы Изменять нельзя
   IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
      RAISE EXCEPTION 'Ошибка.Изменять <Причины разногласия> вам запрещено.';
   END IF;


   -- Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_ReasonDifferences());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReasonDifferences(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReasonDifferences(), ioCode);

   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReasonDifferences(), ioCode, inName, NULL);

   -- сохранили св-во < Недостача>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReasonDifferences_Deficit(), ioId, inisDeficit);
   -- сохранили св-во < Некондиция>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReasonDifferences_Surplus(), ioId, inisSurplus);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReasonDifferences(Integer, Integer, TVarChar, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 27.06.14                                                          * 
 
*/
-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isReplaceSte2ListDif(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isReplaceSte2ListDif(
    IN inId                       Integer   ,    -- ключ объекта <Подразделение>
    IN inisReplaceSte2ListDif     Boolean   ,    -- Заменит текст шага 2 при добавлении в листы отказов
   OUT outisReplaceSte2ListDif    Boolean   ,
    IN inSession                  TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- проверка - проведенные/удаленные документы Изменять нельзя
   IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION 'Ошибка. Изменение признака <Заменит текст шага 2 при добавлении в листы отказов> разрешено только администратору.';
   END IF;

   -- определили признак
   outisReplaceSte2ListDif:= NOT inisReplaceSte2ListDif;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ReplaceSte2ListDif(), inId, outisReplaceSte2ListDif);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.10.22                                                       *
*/
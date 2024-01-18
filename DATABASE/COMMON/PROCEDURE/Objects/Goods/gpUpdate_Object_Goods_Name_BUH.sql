-- Function: gpUpdateObject_Goods_Name_BUH()

--DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Name_BUH (Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Goods_Name_BUH (Integer, TVarChar, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Goods_Name_BUH(
    IN inId                Integer   , -- Ключ объекта <товар>
    IN inName_BUH          TVarChar  , -- 
    IN inDate_BUH          TDateTime , -- Дата до которой действует Название товара(бухг.)
    IN inisNameOrig        Boolean   , -- Показывать реальное назв.
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Goods_Name_BUH());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка прав пользователя на вызов процедуры
     IF 1=0 AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Goods_Name_BUH())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет Прав на изменение <Название бухгалтерское>.';
     END IF;

     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент справочника не выбран.';
         --RETURN;
     END IF;

     -- сохранили свойство <Название БУХГ>
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_BUH(), inId, inName_BUH);
     -- сохранили свойство <Дата до которой действует Название товара(бухг.)>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_BUH(), inId, CASE WHEN 1=0 AND inDate_BUH = CURRENT_DATE THEN NULL ELSE inDate_BUH END);

     -- сохранили свойство
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_NameOrig(), inId, inisNameOrig);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.12.21         *
 09.09.21         *
*/


-- тест
-- SELECT * FROM gpUpdateObject_Goods_UKTZED (ioId:= 275079, inUKTZED:= '456/45', inSession:= '2')

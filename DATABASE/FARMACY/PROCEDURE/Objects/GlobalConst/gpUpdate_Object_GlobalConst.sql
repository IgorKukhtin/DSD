-- Function: gpUpdate_Object_GlobalConst()

DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst(
    IN inId                       Integer,   -- ключ объекта  
    IN inSiteDiscount             TFloat,    -- 
    IN inisSiteDiscount           Boolean,   -- 
    IN inSession                  TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_GlobalConst_SiteDiscount(), inId, inisSiteDiscount);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GlobalConst_SiteDiscount(), inId, inSiteDiscount);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.19         *
*/

-- тест
-- 
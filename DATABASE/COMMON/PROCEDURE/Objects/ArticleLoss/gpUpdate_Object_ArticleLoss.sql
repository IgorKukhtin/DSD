-- Function: gpUpdate_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ArticleLoss (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ArticleLoss(
    IN inId                       Integer   ,     -- ключ объекта <Статьи списания>  
    IN inBusinessId               Integer   ,     -- Бизнес
    IN inBranchId                 Integer   ,     -- Филиал
    IN inComment                  TVarChar  ,     -- Примечание 
    IN inSession                  TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ArticleLoss());


   -- сохранили связь с <Бизнес>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Business(), inId, inBusinessId);
   -- сохранили связь с <Филиал>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Branch(), inId, inBranchId);
   -- сохранили cсвойство с <ПРимечание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ArticleLoss_Comment(), inId, inComment);
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 16.11.20         * inBranchId
 27.07.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_ArticleLoss(inId:=null, inBusinessId:=0, inComment:= '', inSession:='2')

-- Function: gpInsertUpdate_Object_ModelServiceItemMaster(Integer,  TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemMaster(Integer,  TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemMaster(Integer,  TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelServiceItemMaster(
 INOUT ioId                  Integer   , -- ключ объекта < Главные элементы Модели начисления>
    IN inMovementDescId      TFloat    , -- Код документа
    IN inRatio               TFloat    , -- Коэффициент для выбора данных
    IN inComment             TVarChar  , -- Примечание
    IN inModelServiceId      Integer   , -- Модели начисления
    IN inFromId              Integer   , -- Подразделения(От кого)
    IN inToId                Integer   , -- Подразделения(Кому)
    IN inSelectKindId        Integer   , -- Тип выбора данных
    IN inDocumentKindId      Integer   , -- Тип выбора данных
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ModelServiceItemMaster());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_ModelService())
      AND vbUserId <> 5
   THEN
        RAISE EXCEPTION 'Ошибка.%Нет прав корректировать = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_ModelServiceItemMaster())
                       ;
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ModelServiceItemMaster(), 0, '');

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ModelServiceItemMaster_MovementDesc(), ioId, inMovementDescId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ModelServiceItemMaster_Ratio(), ioId, inRatio);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ModelServiceItemMaster_Comment(), ioId, inComment);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_ModelService(), ioId, inModelServiceId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_From(), ioId, inFromId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_To(), ioId, inToId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_SelectKind(), ioId, inSelectKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_DocumentKind(), ioId, inDocumentKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.16         * DocumentKind
 21.11.13                                        * inMovementDesc -> inMovementDescId
 19.10.13         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ModelServiceItemMaster (0,  198, 2, 1000, 1, 5, 6, '2')

-- Function: gpInsertUpdate_Object_ProductPhoto(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProductPhoto(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProductPhoto(
 INOUT ioId                        Integer   , -- ключ объекта
    IN inPhotoName                 TVarChar  , --
    IN inProductId                 Integer   , --
    IN inProductPhotoData          TBlob     , -- Файл
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

    -- проверка
   IF COALESCE (inProductId, 0) = 0
   THEN
       --RAISE EXCEPTION 'Ошибка! Договор не установлен!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Лодка не установлена.'       :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_ProductPhoto' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;


   -- если пусто
   IF COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inPhotoName), '') = '' 
   THEN
       -- попробуем найти
       ioId:= (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.ChildObjectId = inProductId AND OL.DescId = zc_ObjectLink_ProductPhoto_Product());
       --
     --inPhotoName:= 'https://agilis-jettenders.com/constructor-images/order-constructor-4754.png';
       inPhotoName:= 'order-constructor-'
                  || COALESCE ((SELECT Movement.InvNumber FROM MovementLinkObject AS MLO JOIN Movement ON Movement.Id = MLO.MovementId WHERE MLO.ObjectId = inProductId AND MLO.DescId = zc_MovementLinkObject_Product()
                               ), '???')
                  || '.png'
                    ;

   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProductPhoto(), 0, inPhotoName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ProductPhoto_Data(), ioId, inProductPhotoData);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProductPhoto_Product(), ioId, inProductId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProductPhoto (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')


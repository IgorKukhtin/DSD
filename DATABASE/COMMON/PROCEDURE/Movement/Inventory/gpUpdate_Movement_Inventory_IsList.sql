-- Function: gpUpdate_Movement_Inventory_IsList()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Inventory_IsList (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Inventory_IsList(
    IN inId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
 INOUT ioIsGoodsGroupIn      Boolean   , -- Только выбр. группа
 INOUT ioIsGoodsGroupExc     Boolean   , -- Кроме выбр. группы
 INOUT ioIsList              Boolean   , -- по всем товарам накладной
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
     
     --переопределяем, т.к. при нажатии кнопки нужно установить обратное значение 
     ioIsList := NOT ioIsList;

     -- замена
     IF ioIsList = TRUE
     THEN
         ioIsGoodsGroupIn := FALSE;
         ioIsGoodsGroupExc:= FALSE;
     END IF;


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupIn(), inId, ioIsGoodsGroupIn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupExc(), inId, ioIsGoodsGroupExc);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_List(), inId, ioIsList);


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, false);
     
     -- проверка
     IF vbUserId = 9457
     THEN
        -- RAISE EXCEPTION 'Тест.Ok. <%>, <%>, <%>', ioIsGoodsGroupIn, ioIsGoodsGroupExc, ioIsList;
     END IF;

     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.07.26         *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Inventory_IsList (inId:= 34731820, ioIsGoodsGroupIn:= FALSE, ioIsGoodsGroupExc:= FALSE, inSession:= '9457')


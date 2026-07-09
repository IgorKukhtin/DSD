-- Function: gpUpdate_Movement_Inventory_isGoodsGroupExc()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Inventory_isGoodsGroupExc (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Inventory_isGoodsGroupExc(
    IN inId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
 INOUT ioIsGoodsGroupIn      Boolean   , -- Только выбр. группа
 INOUT ioIsGoodsGroupExc     Boolean   , -- Кроме выбр. группы
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbisGoodsGroupExc  Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());

     --переопределяем, т.к. при нажатии кнопки нужно установить обратное значение 
     ioIsGoodsGroupExc := NOT ioIsGoodsGroupExc;

     -- получаем прошлые значения Только выбр. группа / Кроме выбр. группы (для того чтобы одновременно не были выбранны обе галки)
     SELECT COALESCE (MovementBoolean_GoodsGroupExc.ValueData, FALSE) :: Boolean AS isGoodsGroupExc
          INTO vbisGoodsGroupExc
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupExc
                                    ON MovementBoolean_GoodsGroupExc.MovementId = Movement.Id
                                   AND MovementBoolean_GoodsGroupExc.DescId = zc_MovementBoolean_GoodsGroupExc()
     WHERE Movement.Id = inId;
     
     --
     IF ioIsGoodsGroupExc <> vbisGoodsGroupExc AND ioIsGoodsGroupIn = TRUE
     THEN
          ioIsGoodsGroupIn := NOT ioIsGoodsGroupExc;
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupIn(), inId, ioIsGoodsGroupIn);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_GoodsGroupExc(), inId, ioIsGoodsGroupExc);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, false);


     -- проверка
     IF vbUserId = 9457
     THEN
        -- RAISE EXCEPTION 'Тест.Ok. <%>, <%>', ioIsGoodsGroupIn, ioIsGoodsGroupExc;
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
-- SELECT * FROM gpUpdate_Movement_Inventory_isGoodsGroupIn (inId:= 34731820, ioIsGoodsGroupIn:= FALSE, ioIsGoodsGroupExc:= FALSE, inSession:= '9457')


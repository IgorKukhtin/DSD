-- Function: gpUpdate_MI_WeighingPartner_report()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_report (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_report(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inCountTare1          TFloat    , -- Количество поддон-вид1
    IN inCountTare2          TFloat    , -- Количество поддон-вид2
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbBoxId    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_WeighingPartner_report());

     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Строка документа не определена.';
     END IF;

     --проверка
     IF COALESCE (inCountTare1,0) <> 0 AND COALESCE (inCountTare2,0) <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Должно быть выбрано одно их значений <Поддон-вид1> или <Поддон-вид2>.';
     END IF;


     -- Находим
     IF inCountTare1 > 0
     THEN
          -- Находим Поддон-1
          vbBoxId := (SELECT OF.ObjectId
                      FROM ObjectFloat AS OF
                      WHERE OF.DescId = zc_ObjectFloat_Box_NPP()
                        AND OF.ValueData = 1
                     );

         -- Проверка
         IF COALESCE (vbBoxId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.<Поддон-вид1> с № п/п = <1> не найден.';
         END IF;

         -- сохранили свойство <Количество Поддон-вид1>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, inCountTare1);
         -- сохранили связь с <Поддон-вид1>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, vbBoxId);


     ELSEIF inCountTare2 > 0
     THEN
          -- Находим Поддон-2
          vbBoxId := (SELECT OF.ObjectId
                      FROM ObjectFloat AS OF
                      WHERE OF.DescId = zc_ObjectFloat_Box_NPP()
                        AND OF.ValueData = 2
                     );
         -- Проверка
         IF COALESCE (vbBoxId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.<Поддон-вид2> с № п/п = <2> не найден.';
         END IF;

         -- сохранили свойство <Количество Поддон-вид2>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, inCountTare2);
        -- сохранили связь с <Поддон-вид2>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, vbBoxId);

     -- Обнулили
     ELSE
         -- сохранили свойство <Количество Поддон>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, 0);
        -- сохранили связь с <Поддон>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, NULL);

     END IF;



     --
     IF vbUserId = 9457 THEN RAISE EXCEPTION 'OK.'; END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.25         *
*/

-- тест
-- select * from gpUpdate_MI_WeighingPartner_report(inId := 317381166 , inCountTare1 := 0 , inCountTare2 := 1 ,  inSession := '9457');
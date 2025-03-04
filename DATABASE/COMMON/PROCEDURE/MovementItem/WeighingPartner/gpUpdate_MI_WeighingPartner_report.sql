-- Function: gpUpdate_MI_WeighingPartner_report()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_report (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_report(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inCountTare1          TFloat    , -- Количество ящ. вида1
    IN inCountTare2          TFloat    , -- Количество ящ. вида2
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
           vbCountTare1_old TFloat;
           vbCountTare2_old TFloat;
           vbBoxId1    Integer;
           vbBoxId2    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_WeighingPartner_report());
     --vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Строка документа не определена.';
     END IF;
     
     vbCountTare1_old := (SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.DescId = zc_MIFloat_CountTare1() AND MF.MovementItemId = inId);
     vbCountTare2_old := (SELECT MF.ValueData FROM MovementItemFloat AS MF WHERE MF.DescId = zc_MIFloat_CountTare2() AND MF.MovementItemId = inId);

     --проверка
    IF COALESCE (inCountTare1,0) <> 0 AND COALESCE (inCountTare2,0) <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Должно быть выбрано одно их значений <Кол. ящ. вида1> или <Кол. ящ. вида2>.';
     END IF;

     /*IF (COALESCE (inCountTare1,0) <> COALESCE (vbCountTare1_old)) AND (COALESCE (inCountTare2,0) <> COALESCE (vbCountTare2_old))
    AND COALESCE (inCountTare1,0) <> 0 AND COALESCE (inCountTare2,0) <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Запрещено изменять два значения.';
     END IF; 
     */
     
     --Находим тару
     IF COALESCE (inCountTare1,0) <> COALESCE (vbCountTare1_old,0)
     THEN
         vbBoxId1 := (SELECT OF.ObjectId 
                      FROM ObjectFloat AS OF
                      WHERE OF.DescId = zc_ObjectFloat_Box_NPP()
                        AND OF.ValueData = 1);

         IF COALESCE (vbBoxId1,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Тара с номером <1> не найдена.';
         END IF;

         -- сохранили свойство <Количество ящ. вида1>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, inCountTare1);
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, CASE WHEN COALESCE (inCountTare1,0) <> 0 THEN vbBoxId1 ELSE NULL END::Integer);
     END IF;

     IF COALESCE (inCountTare2,0) <> COALESCE (vbCountTare2_old,0)
     THEN
         vbBoxId2 := (SELECT OF.ObjectId 
                      FROM ObjectFloat AS OF
                      WHERE OF.DescId = zc_ObjectFloat_Box_NPP()
                        AND OF.ValueData = 2);
         IF COALESCE (vbBoxId2,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Тара с номером <2> не найдена.';
         END IF;
         
        -- сохранили свойство <Количество ящ. вида2>
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), inId, inCountTare2);
        -- сохранили связь с <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box2(), inId, CASE WHEN COALESCE (inCountTare2,0) <> 0 THEN vbBoxId2 ELSE NULL END::Integer);
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
--              select * from gpUpdate_MI_WeighingPartner_report(inId := 317381166 , inCountTare1 := 0 , inCountTare2 := 1 ,  inSession := '9457');
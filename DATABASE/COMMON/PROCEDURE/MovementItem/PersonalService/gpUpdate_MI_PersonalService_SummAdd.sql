-- Function: gpUpdate_MI_PersonalService_SummAdd()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_SummAdd  (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_SummAdd(
    IN inId                  Integer   , -- 
    IN inSummAdd             TFloat    ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer; 
           vbSummAdd TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
   vbUserId:= lpGetUserBySession (inSession);


   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не найдена Ведомость начисления.';
   END IF;

   SELECT COALESCE (MIFloat_SummAdd.ValueData,0) AS SummAdd
 INTO vbSummAdd
   FROM MovementItemFloat AS MIFloat_SummAdd
   WHERE MIFloat_SummAdd.MovementItemId = inId
     AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd();

   -- проверка
   IF COALESCE (vbSummAdd, 0) <> 0 AND COALESCE (vbSummAdd, 0) <> COALESCE (inSummAdd, 0)
   THEN
       RAISE EXCEPTION 'Ошибка.Сумма Премии отличается от сохраненной.';
   END IF; 
   
   --если суммы совпадают просто выход
   IF COALESCE (vbSummAdd, 0) <> 0 AND COALESCE (vbSummAdd, 0) = COALESCE (inSummAdd, 0)
   THEN
       RETURN;
   END IF;
 
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd(), inId, inSummAdd);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.04.24         *
*/

-- тест
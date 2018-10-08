-- Function: gpInsertUpdate_MovementItem_KPU()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_KPU (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_KPU(
 INOUT ioId                    Integer    , -- Ключ объекта <Докумен>
   OUT outKPU                  Integer    , -- КПУ
    IN inMarkRatio             Integer    , -- Коеффициент выполнение плана по маркетингу
    IN inAverageCheckRatio     Integer    , -- Коеффициент за средний чек
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
  vbUserId := inSession;

  IF (COALESCE (ioId, 0) = 0) OR NOT EXISTS(SELECT ID FROM MovementItem WHERE MovementItem.ID = ioId)
  THEN
    RAISE EXCEPTION 'Ошибка. Номер содержимого документа должен быть заполнен или содержимое не найдено.';
  END IF;

  if (inMarkRatio > 1) OR (inMarkRatio < -1)
  THEN
    RAISE EXCEPTION 'Ошибка. Значение коэффициента должно быть в пределах от -1 до 1.';
  END IF;

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MarkRatio(), ioId, inMarkRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AverageCheckRatio(), ioId, inAverageCheckRatio);

  PERFORM lpUpdate_MovementItem_KPU (ioId);

  SELECT
    Amount
  INTO
    outKPU
  FROM MovementItem
  WHERE MovementItem.ID = ioId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.10.18         *
*/
-- Function: lpUnConduct_MovementItem_Income (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpUnConduct_MovementItem_Income (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUnConduct_MovementItem_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementItemId    Integer  , -- строка документа
    IN inUserId            Integer    -- Пользователь
)
  RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate TDateTime;
  DECLARE vbDescId Integer;
  DECLARE vbAccessKeyId Integer;
  DECLARE vbStatusId_old Integer;
BEGIN

  -- !!!Проверка что б второй раз не провели накладную и проводки не задвоились!!!
  IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
  THEN
      RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
  END IF;

  IF NOT EXISTS(SELECT ValueData FROM MovementItemBoolean WHERE DescId = zc_MIBoolean_Conduct()
                                                        AND MovementItemId = inMovementItemId
                                                        AND ValueData = TRUE)
  THEN
      RAISE EXCEPTION 'Ошибка.Строка документа не проведена.';
  END IF;

  -- Удаляем все проводки
  PERFORM lpDelete_MovementItemContainerOne (inMovementId, inMovementItemId);

  -- ФИНИШ - Обязательно меняем статус строки документа
  PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Conduct(), inMovementItemId, FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpUnComplete_Movement (Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 24.06.18         *
*/


-- тест
-- SELECT * FROM lpUnConduct_MovementItem_Income (inMovementId:= 103, inMovementItemId := 0, inSession:= zfCalc_UserAdmin())

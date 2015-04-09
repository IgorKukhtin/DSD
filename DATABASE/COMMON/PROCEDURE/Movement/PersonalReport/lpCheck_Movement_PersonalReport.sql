-- Function: lpCheck_Movement_PersonalReport (Integer)

DROP FUNCTION IF EXISTS lpCheck_Movement_PersonalReport (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_PersonalReport(
    IN inMovementId  Integer  , -- ключ объекта <Документ>
    IN inComment     TVarChar , -- 
    IN inUserId      Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN

          -- проверка
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Cash())
             OR EXISTS (SELECT 1 WHERE -1 * inMovementId = zc_Object_Cash())
          THEN
              RAISE EXCEPTION 'Ошибка.Документ может быть % только через <Касса, приход/расход>.', inComment;
          END IF;
          -- проверка
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_BankAccount())
             OR EXISTS (SELECT 1 WHERE -1 * inMovementId = zc_Object_BankAccount())
          THEN
              RAISE EXCEPTION 'Ошибка.Документ может быть % только через <Расчетный счет, приход/расход>.', inComment;
          END IF;
          -- проверка
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_PersonalSendCash())
             OR EXISTS (SELECT 1 WHERE -1 * inMovementId = zc_Object_Member())
          THEN
              RAISE EXCEPTION 'Ошибка.Документ может быть % только через <Движение денег с подотчета на подотчет>.', inComment;
          END IF;
          -- проверка
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_PersonalAccount())
          THEN
              RAISE EXCEPTION 'Ошибка.Документ может быть % только через <Расчеты подотчета с юр.лицом>.', inComment;
          END IF;
          -- проверка
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income())
          THEN
              RAISE EXCEPTION 'Ошибка.Документ может быть % только через <Приход (Заправка авто)>.', inComment;
          END IF;
          -- проверка
          IF NOT EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_PersonalReport())
             AND inMovementId > 0
          THEN
              RAISE EXCEPTION 'Ошибка.Документ может быть % только через <не определен>.', inComment;
          END IF;
          -- проверка
          IF inMovementId < 0
             AND -1 * inMovementId <> zc_Object_Juridical()
             AND -1 * inMovementId <> zc_Object_Partner()
          THEN
              RAISE EXCEPTION 'Ошибка.Документ для <%> не может быть %.', (SELECT ItemName FROM ObjectDesc WHERE Id = -1 * inMovementId), inComment;
          END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheck_Movement_PersonalReport (Integer, TVarChar, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.04.15                                        *
*/

-- тест
-- SELECT * FROM lpCheck_Movement_PersonalReport (inMovementId:= 55, inComment:= '', inUserId:= zfCalc_UserAdmin() :: Integer)

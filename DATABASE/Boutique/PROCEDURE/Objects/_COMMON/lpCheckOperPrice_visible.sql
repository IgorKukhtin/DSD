-- Function: lpCheckOperPrice_visible (Integer)

DROP FUNCTION IF EXISTS lpCheckOperPrice_visible (Integer);

CREATE OR REPLACE FUNCTION lpCheckOperPrice_visible (
    IN inUserId    Integer   -- Пользователь
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- Получили для Пользователя - к какому Подразделению он привязан
     IF lpGetUnit_byUser (inUserId) > 0 AND inUserId <> 1234551 -- Рогожан Е.
     THEN
         -- Нельзя показывать цену ВХ.
         RETURN FALSE;
     ELSE
         -- Можно показывать цену ВХ.
         RETURN TRUE;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.18                                        *
*/

-- тест
-- SELECT * FROM lpCheckOperPrice_visible (inUserId:= zfCalc_UserAdmin() :: Integer)

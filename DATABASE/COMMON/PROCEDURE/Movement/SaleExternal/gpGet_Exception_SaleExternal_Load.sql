-- Function: gpGet_Exception_SaleExternal_Load()

DROP FUNCTION IF EXISTS gpGet_Exception_SaleExternal_Load (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Exception_SaleExternal_Load(
    IN inRetailId              Integer   , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
 
     -- проверка
     IF COALESCE (inRetailId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Торговая сеть не выбрана';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
03.11.20          *
*/

-- тест
--
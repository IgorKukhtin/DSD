-- Function: lpUpdate_Container_CountPartionDate 

-- Поцедура для исправления остатка по споковой партии
DROP FUNCTION IF EXISTS lpUpdate_Container_CountPartionDate (Integer, TFloat);

CREATE OR REPLACE FUNCTION lpUpdate_Container_CountPartionDate(
    IN inContainerPDId    Integer  , -- контейнер
    IN inDelta            TFloat     -- Количество
)
RETURNS Void AS
$BODY$
BEGIN

  update Container SET Amount = Amount + inDelta
  where  Container.DescId = zc_Container_CountPartionDate()
    and  Container.Id = inContainerPDId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.04.21                                                       *

*/

-- тест
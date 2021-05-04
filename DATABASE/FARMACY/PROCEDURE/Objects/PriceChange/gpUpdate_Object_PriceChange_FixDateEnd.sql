-- Function: gpUpdate_Object_PriceChange_FixDateEnd (TVarChar)
DROP FUNCTION IF EXISTS gpUpdate_Object_PriceChange_FixDateEnd(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PriceChange_FixDateEnd(
    IN inId          Integer,       -- ID
    IN inFixEndDate  TDateTime,     -- Дата окончания действия скидки
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
DECLARE
    vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF COALESCE(inId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка.Запись не сохранена.';
    END IF;

    -- сохранили св-во <Дата окончания действия скидки>
    PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceChange_FixEndDate(), inId, inFixEndDate);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 30.04.21                                                      *
*/

-- тест
-- select * from gpUpdate_Object_PriceChange_FixDateEnd(,  inSession := '3');
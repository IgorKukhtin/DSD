-- Function: gpGet_Movement_ExistsPretension()

DROP FUNCTION IF EXISTS gpGet_Movement_ExistsPretension (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ExistsPretension(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Pretension());
   vbUserId := inSession;

   IF COALESCE (inMovementId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Претензия не создана нет данных.';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ExistsPretension (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/

-- тест
-- 
select * from gpGet_Movement_ExistsPretension(inMovementId := 0 ,  inSession := '3');


-- Function: gpGet_Movement_RepriceChange_TotalSum()

DROP FUNCTION IF EXISTS gpGet_Movement_RepriceChange_TotalSum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_RepriceChange_TotalSum(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (TotalSumm TFloat)
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_RepriceChange());

    SELECT Movement_RepriceChange.TotalSum
    FROM Movement_RepriceChange_View AS Movement_RepriceChange
    WHERE Movement_RepriceChange.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.18         *
*/

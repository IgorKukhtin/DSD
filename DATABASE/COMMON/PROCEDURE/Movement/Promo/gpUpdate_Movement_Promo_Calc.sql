-- Function: gpUpdate_Movement_Promo_Calc()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Calc(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbUnitId    Integer;
   DECLARE vbStatusId  Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Promo_Data());

    -- параметры из документа <Акции>
    SELECT Movement_Promo_View.StatusId
         , Movement_Promo_View.StartSale
         , Movement_Promo_View.EndSale
         , COALESCE (Movement_Promo_View.UnitId, 0)
      INTO vbStatusId, vbStartDate, vbEndDate, vbUnitId
    FROM Movement_Promo_View
    WHERE Movement_Promo_View.Id = inMovementId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 09.08.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Promo_Calc (inMovementId:= 2641111, inSession:= zfCalc_UserAdmin())
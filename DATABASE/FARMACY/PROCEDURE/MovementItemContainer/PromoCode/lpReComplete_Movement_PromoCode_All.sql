-- Function: lpReComplete_Movement_PromoCode_All (Integer)

DROP FUNCTION IF EXISTS lpReComplete_Movement_PromoCode_All (Integer, Integer);

CREATE OR REPLACE FUNCTION lpReComplete_Movement_PromoCode_All(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN

    
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 14.12.17         * 
*/
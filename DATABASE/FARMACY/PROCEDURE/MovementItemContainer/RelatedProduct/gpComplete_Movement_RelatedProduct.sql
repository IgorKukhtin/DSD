-- Function: gpComplete_Movement_RelatedProduct()

DROP FUNCTION IF EXISTS gpComplete_Movement_RelatedProduct (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_RelatedProduct(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  
BEGIN
    vbUserId:= inSession;

    -- собственно проводки
    PERFORM lpComplete_Movement_RelatedProduct(inMovementId, -- ключ Документа
                                          vbUserId);    -- Пользователь  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.10.20                                                       *
 */
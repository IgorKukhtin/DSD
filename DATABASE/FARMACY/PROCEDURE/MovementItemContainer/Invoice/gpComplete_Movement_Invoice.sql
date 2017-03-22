-- Function: gpComplete_Movement_Invoice()

DROP FUNCTION IF EXISTS gpComplete_Movement_Invoice  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Invoice(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbAmount    TFloat;
  DECLARE vbSaldo     TFloat;
  DECLARE vbUnitId    Integer;
  DECLARE vbOperDate  TDateTime;
  
BEGIN
    vbUserId:= inSession;
 
    -- собственно проводки
    PERFORM lpComplete_Movement_Invoice(inMovementId, -- ключ Документа
                                     vbUserId);    -- Пользователь  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 13.10.15                                                         *
 */
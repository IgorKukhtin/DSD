-- Function: gpUpdate_Movement_Promo_Correction()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Correction (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Correction (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Correction(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inPromoStateKindId      Integer   , 
    IN inComment               TVarChar  , 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.20         
*/

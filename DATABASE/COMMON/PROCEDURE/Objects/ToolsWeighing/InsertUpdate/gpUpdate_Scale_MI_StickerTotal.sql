-- Function: gpUpdate_Scale_MI_StickerTotal()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_StickerTotal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_StickerTotal(
    IN inMovementItemId  Integer      ,
    IN inBranchCode      Integer      , --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId               Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
   
     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), inMovementItemId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.07.25                                        *
*/

-- тест
-- SELECT *, AmountTotal - WeightTare_add  FROM gpUpdate_Scale_MI_StickerTotal (331192570, zfCalc_UserAdmin())

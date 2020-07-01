-- Function: gpUpdate_Movement_Promo_TaxPromo()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_TaxPromo(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_TaxPromo(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inisTaxPromo             Boolean   ,
   OUT outisTaxPromo            Boolean   ,
   OUT outisTaxPromo_Condition  Boolean   ,
    IN inSession                TVarChar     -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());


     -- проверка - если есть подписи, корректировать нельзя
     PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                        , inIsComplete:= FALSE
                                        , inIsUpdate  := TRUE
                                        , inUserId    := vbUserId
                                         );

     -- определили признак
     inisTaxPromo:= NOT inisTaxPromo;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, inisTaxPromo);
     
     outisTaxPromo := inisTaxPromo;
     outisTaxPromo_Condition := NOT inisTaxPromo;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.20         *
*/

-- тест
--
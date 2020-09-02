-- Function: gpUpdate_MI_Message_PromoStateKind()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Correction (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Correction (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Checked (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Checked (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Message_PromoStateKind (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Message_PromoStateKind(
 INOUT ioId                  Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPromoStateKindId    Integer   , -- Состояние
    IN inComment             TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo());

     -- добавили состояние
     ioId:= gpInsertUpdate_MI_Message_PromoStateKind (ioId                  := ioId
                                                    , inMovementId          := inMovementId
                                                    , inPromoStateKindId    := inPromoStateKindId
                                                    , inIsQuickly           := TRUE
                                                    , inComment             := inComment
                                                    , inSession             := inSession
                                                     );

     --
     -- RAISE EXCEPTION 'Ошибка.OK';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 27.06.20                                       *
*/

-- тест
--
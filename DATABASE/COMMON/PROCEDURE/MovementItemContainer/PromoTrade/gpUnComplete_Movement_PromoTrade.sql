-- Function: gpUnComplete_Movement_PromoTrade (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_PromoTrade(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_PromoTrade());


     -- Если последний = Подписан
     IF (SELECT MI.ObjectId
         FROM MovementItem AS MI
              JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
         WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message() AND MI.isErased = FALSE
         ORDER BY MI.Id DESC
         LIMIT 1
        ) IN (zc_Enum_PromoTradeStateKind_Complete_1()
            , zc_Enum_PromoTradeStateKind_Complete_2()
            , zc_Enum_PromoTradeStateKind_Complete_3()
            , zc_Enum_PromoTradeStateKind_Complete_4()
            , zc_Enum_PromoTradeStateKind_Complete_5()
            , zc_Enum_PromoTradeStateKind_Complete_6()
            , zc_Enum_PromoTradeStateKind_Complete_7()
             )
     THEN
         RAISE EXCEPTION 'Ошибка.Документ в процессе согласования.%Изменения возможны для <%>', CHR (13), lfGet_Object_ValueData_sh (zc_Enum_PromoTradeStateKind_Return());
     END IF;


     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);


     -- Если последний = Вернули для исправлений
     IF zc_Enum_PromoTradeStateKind_Return() = (SELECT MI.ObjectId
                                                FROM MovementItem AS MI
                                                     JOIN Object ON Object.Id = MI.ObjectId AND Object.DescId = zc_Object_PromoTradeStateKind()
                                                WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Message() AND MI.isErased = FALSE
                                                ORDER BY MI.Id DESC
                                                LIMIT 1
                                               )
     THEN
         -- сохранили <В работе Автор документа>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoTradeStateKind(), inMovementId, zc_Enum_PromoTradeStateKind_Start());
         -- сохранили <В работе Автор документа>
         PERFORM gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := 0
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := zc_Enum_PromoTradeStateKind_Start()
                                                              , inIsQuickly             := FALSE
                                                              , inComment               := ''
                                                              , inSession               := inSession
                                                               );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.20         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_PromoTrade (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())

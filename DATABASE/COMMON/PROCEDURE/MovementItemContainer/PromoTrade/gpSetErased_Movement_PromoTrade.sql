-- Function: gpSetErased_Movement_PromoTrade (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PromoTrade(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_PromoTrade());

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

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.20         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_PromoTrade (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())

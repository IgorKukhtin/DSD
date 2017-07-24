-- Function: gpSetErased_Movement_GoodsAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_GoodsAccount());
    vbUserId:= lpGetUserBySession (inSession);

    -- убираем ссылки на этот док в продажах
    /*PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), MLM_Child.MovementId, Null)
    FROM MovementLinkMovement AS MLM_Child
    WHERE MLM_Child.descId = zc_MovementLinkMovement_Child()
      AND MLM_Child.MovementChildId = inMovementId;*/
    
    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- пересчитали "итоговые" суммы по элементам продажи / возврата
    PERFORM CASE WHEN Movement_Partion.DescId = zc_Movement_Sale()     THEN lpUpdate_MI_Sale_Total(MI_Partion.Id)
                 WHEN Movement_Partion.DescId = zc_Movement_ReturnIn() THEN lpUpdate_MI_ReturnIn_Total(MI_Partion.Id)
            END
    FROM MovementItem
         INNER JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                           ON MILinkObject_PartionMI.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
         LEFT JOIN Object       AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
         LEFT JOIN MovementItem AS MI_Partion       ON MI_Partion.Id       = Object_PartionMI.ObjectCode
         LEFT JOIN Movement     AS Movement_Partion ON Movement_Partion.Id = MI_Partion.MovementId
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;

    -- пересчитали "итоговые" суммы по элементам продажи для Партия возврата
    PERFORM lpUpdate_MI_Sale_Total(Object_PartionMI_level2.ObjectCode)
    FROM MovementItem
         -- получаем сразу партию Возврата
         INNER JOIN MovementItemLinkObject AS MILO_PartionMI_level1
                                           ON MILO_PartionMI_level1.MovementItemId = MovementItem.Id
                                          AND MILO_PartionMI_level1.DescId = zc_MILinkObject_PartionMI()
         LEFT JOIN Object AS Object_PartionMI_level1 ON Object_PartionMI_level1.Id = MILO_PartionMI_level1.ObjectId
         -- получаем партию Продажи если в предыдущем была партия Возврата
         INNER JOIN MovementItemLinkObject AS MILO_PartionMI_level2
                                           ON MILO_PartionMI_level2.MovementItemId = Object_PartionMI_level1.ObjectCode
                                          AND MILO_PartionMI_level2.DescId         = zc_MILinkObject_PartionMI()
         LEFT JOIN Object AS Object_PartionMI_level2 ON Object_PartionMI_level2.Id = MILO_PartionMI_level2.ObjectId

    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 23.07.17         *
 18.05.17         *
*/

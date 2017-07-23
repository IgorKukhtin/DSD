-- Function: gpComplete_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpComplete_Movement_GoodsAccount  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
 
    -- собственно проводки
    PERFORM lpComplete_Movement_GoodsAccount(inMovementId, -- ключ Документа
                                       vbUserId);    -- Пользователь  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());
    
    -- пересчитали "итоговые" суммы по элементам продажи / возврата
    PERFORM CASE WHEN Movement_Partion.DescId = zc_Movement_Sale() THEN lpUpdate_MI_Sale_Total(MI_Partion.Id)
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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 23.07.17         *
 18.05.17         *
 */

DROP FUNCTION IF EXISTS lpUpdate_Movement_Transport_PartnerCount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Transport_PartnerCount(
    IN inMovementId_trasport          Integer,      -- ключ<>
    IN inUserId                       Integer       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbPartnerCount TFloat;
   DECLARE vbPartnerCount_no TFloat;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Car());


   vbPartnerCount := (SELECT COUNT (DISTINCT MovementLinkObject_To.ObjectId)
                       FROM  MovementLinkMovement AS MovementLinkMovement_Transport

                            INNER JOIN Movement AS Movement_Reestr
                                                ON Movement_Reestr.Id       = MovementLinkMovement_Transport.MovementId
                                               AND Movement_Reestr.DescId   = zc_Movement_Reestr()
                                               AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()  --IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())   --zc_Enum_Status_Erased()
                            -- строки реестра
                            INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement_Transport.MovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                            -- связь с накладными
                            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                    ON MovementFloat_MovementItemId.ValueData = MovementItem.Id
                                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                            -- накладная
                            INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id       = MovementFloat_MovementItemId.MovementId
                                                                AND Movement_Sale.StatusId = zc_Enum_Status_Complete()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = MovementFloat_MovementItemId.MovementId
                                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_to()

                       WHERE MovementLinkMovement_Transport.MovementChildId = inMovementId_trasport --19665046
                         AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                       );

 vbPartnerCount_no := (SELECT COUNT (DISTINCT MovementLinkObject_To.ObjectId)
                       FROM  MovementLinkMovement AS MovementLinkMovement_Transport

                            INNER JOIN Movement AS Movement_Reestr
                                                ON Movement_Reestr.Id       = MovementLinkMovement_Transport.MovementId
                                               AND Movement_Reestr.DescId   = zc_Movement_Reestr()
                                               AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()  --IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())   --zc_Enum_Status_Erased()
                            -- строки реестра
                            INNER JOIN MovementItem ON MovementItem.MovementId = MovementLinkMovement_Transport.MovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                            -- связь с накладными
                            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                    ON MovementFloat_MovementItemId.ValueData = MovementItem.Id
                                                   AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                            -- накладная
                            INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id       = MovementFloat_MovementItemId.MovementId
                                                                AND Movement_Sale.StatusId = zc_Enum_Status_Complete()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = MovementFloat_MovementItemId.MovementId
                                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_to()

             -- маршрут в заявке
             LEFT JOIN MovementLinkMovement AS MLM_Order
                                            ON MLM_Order.MovementId = Movement_Sale.Id
                                           AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                          ON MovementLinkObject_Route.MovementId = MLM_Order.MovementChildId
                                         AND MovementLinkObject_Route.DescId     = zc_MovementLinkObject_Route()
             INNER JOIN ObjectBoolean AS OB_NotPayForWeight
                                      ON OB_NotPayForWeight.ObjectId  = MovementLinkObject_Route.ObjectId
                                     AND OB_NotPayForWeight.DescId    = zc_ObjectBoolean_Route_NotPayForWeight()
                                     AND OB_NotPayForWeight.ValueData = TRUE

                       WHERE MovementLinkMovement_Transport.MovementChildId = inMovementId_trasport
                         AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                       );
   --
   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PartnerCount(), inMovementId_trasport, vbPartnerCount);
   --
   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PartnerCount_no(), inMovementId_trasport, vbPartnerCount_no);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.21         *
*/

-- тест
-- SELECT * FROM  lpUpdate_Movement_Transport_PartnerCount (19684175 ,5)

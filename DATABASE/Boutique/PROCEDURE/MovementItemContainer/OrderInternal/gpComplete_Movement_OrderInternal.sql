-- Function: gpComplete_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderInternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderInternal(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId_check Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderInternal());

     -- Проверка - других быть не должно
     vbMovementId_check:= (SELECT Movement.Id
                           FROM (SELECT Movement.Id                     AS MovementId
                                      , Movement.DescId                 AS DescId
                                      , Movement.OperDate               AS OperDate
                                      , COALESCE (MLO_From.ObjectId, 0) AS FromId
                                      , COALESCE (MLO_To.ObjectId, 0)   AS ToId
                                 FROM Movement
                                      LEFT JOIN MovementLinkObject AS MLO_From
                                                                   ON MLO_From.MovementId = Movement.Id
                                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN MovementLinkObject AS MLO_To
                                                                   ON MLO_To.MovementId = Movement.Id
                                                                  AND MLO_To.DescId = zc_MovementLinkObject_To()
                                 WHERE Movement.Id = inMovementId
                                   AND Movement.DescId = zc_Movement_OrderInternal()
                                 ) tmpMovement
                                INNER JOIN Movement ON Movement.OperDate = tmpMovement.OperDate
                                                   AND Movement.DescId   = tmpMovement.DescId
                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                LEFT JOIN MovementLinkObject AS MLO_From
                                                             ON MLO_From.MovementId = Movement.Id
                                                            AND MLO_From.DescId = zc_MovementLinkObject_From()
                                LEFT JOIN MovementLinkObject AS MLO_To
                                                             ON MLO_To.MovementId = Movement.Id
                                                            AND MLO_To.DescId = zc_MovementLinkObject_To()
                           WHERE COALESCE (MLO_From.ObjectId, 0) = tmpMovement.FromId
                             AND COALESCE (MLO_To.ObjectId, 0)   = tmpMovement.ToId
                             AND Movement.Id <> tmpMovement.MovementId
                           LIMIT 1
                          );
     IF vbMovementId_check <> 0 AND vbUserId <> 5 -- Админу временно
     THEN
         RAISE EXCEPTION 'Ошибка.%Найдена другая <Заявка> № <%> за <%> от <%>%.%Дублирование запрещено.', CHR (13)
                                                                                                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_check)
                                                                                                        , DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_check))
                                                                                                        , lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_check AND MLO.DescId = zc_MovementLinkObject_From()))
                                                                                                        , COALESCE (' на <' || lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = vbMovementId_check AND MLO.DescId = zc_MovementLinkObject_To())) || '>', '')
                                                                                                        , CHR (13)
                                                                                                       ;
     END IF;


     -- ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_OrderInternal()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.06.15                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_OrderInternal (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')

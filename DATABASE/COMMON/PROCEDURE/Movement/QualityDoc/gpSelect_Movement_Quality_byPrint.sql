-- Function: gpSelect_Movement_Quality_byPrint()

DROP FUNCTION IF EXISTS gpSelect_Movement_Quality_byPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Quality_byPrint(
    IN inMovementId         Integer  , -- ключ Документа
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId_Sale Integer
             --, MovementId Integer
              ) AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbToId Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметр из документа
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     --
     vbToId := (SELECT MovementLinkObject_To.ObjectId AS ToId
                FROM MovementLinkMovement AS MovementLinkMovement_Child
                     LEFT JOIN Movement AS Movement_Sale
                                        ON Movement_Sale.Id = MovementLinkMovement_Child.MovementChildId
                                       AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                WHERE MovementLinkMovement_Child.MovementId = inMovementId 
                  AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                );

     -- Результат
     RETURN QUERY

     SELECT DISTINCT Movement_Sale.Id AS MovementId_Sale
         --, Movement.Id      AS MovementId
     FROM Movement
         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                        ON MovementLinkMovement_Child.MovementId = Movement.Id 
                                       AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
         INNER JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_Child.MovementChildId
                                             AND Movement_Sale.StatusId = zc_Enum_Status_Complete()

         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                      AND MovementLinkObject_To.ObjectId = vbToId

     WHERE Movement.DescId = zc_Movement_QualityDoc()
       AND Movement.OperDate = vbOperDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.21         *
*/

-- тест
-- select * from gpSelect_Movement_Quality_byPrint (19818100 , '5')
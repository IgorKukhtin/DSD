-- Function: gpSelect_Movement_OrderInternal_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= inSession;

OPEN Cursor1 FOR

        SELECT 
            Movement_OrderInternal.Id
          , Movement_OrderInternal.InvNumber
          , Movement_OrderInternal.OperDate             AS OperDate

          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_OrderInternal 
   
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_OrderInternal.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_OrderInternal.Id = inMovementId
          AND Movement_OrderInternal.DescId = zc_Movement_OrderInternal();

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
      SELECT
            MovementItem.*
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.isErased   = false;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.22         *
*/
-- тест
--select * from gpSelect_Movement_OrderInternal_Print(inMovementId := 3897397 ,  inSession := '3');

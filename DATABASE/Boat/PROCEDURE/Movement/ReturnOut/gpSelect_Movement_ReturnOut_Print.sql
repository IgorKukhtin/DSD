-- Function: gpSelect_Movement_ReturnOut_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnOut_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnOut_Print(
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
            Movement_ReturnOut.Id
          , Movement_ReturnOut.InvNumber
          , Movement_ReturnOut.OperDate               AS OperDate
          , MovementDate_OperDatePartner.ValueData    AS OperDatePartner

          , MovementBoolean_PriceWithVAT.ValueData    AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          , MovementFloat_ChangePercent.ValueData     AS ChangePercent

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_ReturnOut 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_ReturnOut.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_ReturnOut.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()       

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_ReturnOut.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
    
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement_ReturnOut.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
    
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_ReturnOut.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
    
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_ReturnOut.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_ReturnOut.Id = inMovementId
          AND Movement_ReturnOut.DescId = zc_Movement_ReturnOut();

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
 19.02.21         *
*/
-- тест
--select * from gpSelect_Movement_ReturnOut_Print(inMovementId := 3897397 ,  inSession := '3');

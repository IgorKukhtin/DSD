-- Function: gpSelect_Movement_OrderClient_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient_Print(
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
            Movement_OrderClient.Id
          , Movement_OrderClient.InvNumber
          , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
          , Movement_OrderClient.OperDate             AS OperDate

          , MovementBoolean_PriceWithVAT.ValueData    AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          , MovementFloat_DiscountTax.ValueData       AS DiscountTax

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_OrderClient 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_OrderClient.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
    
            LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                    ON MovementFloat_DiscountTax.MovementId = Movement_OrderClient.Id
                                   AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
    
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_OrderClient.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
    
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_OrderClient.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient();

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
 15.02.21         *
*/
-- тест
--select * from gpSelect_Movement_OrderClient_Print(inMovementId := 3897397 ,  inSession := '3');  -- FETCH ALL "<unnamed portal 1>";

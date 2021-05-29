-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_Movement_Income (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Income (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_Income_seq') AS TVarChar) AS InvNumber
             , CAST ('' AS TVarChar)     AS InvNumberPartner
             , inOperDate   ::TDateTime   AS OperDate     --CURRENT_DATE
             , NULL ::TDateTime          AS OperDatePartner 
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , CAST (False as Boolean)   AS PriceWithVAT
             , CAST (0 as TFloat)        AS VATPercent
             , CAST (0 as TFloat)        AS DiscountTax
             , 0                         AS FromId
             , CAST ('' AS TVarChar)     AS FromName
             , 0                         AS ToId
             , CAST ('' AS TVarChar)     AS ToName
             , 0                         AS PaidKindId
             , CAST ('' AS TVarChar)     AS PaidKindName
             , CAST ('' AS TVarChar)     AS Comment
             , 0                         AS MovementId_Invoice
             , CAST ('' as TVarChar)     AS InvNumber_Invoice
             , CAST ('' as TVarChar)     AS Comment_Invoice

             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY

        SELECT 
            Movement_Income.Id
          , Movement_Income.InvNumber
          , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
          , Movement_Income.OperDate                  AS OperDate
          , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
          , Object_Status.ObjectCode                  AS StatusCode
          , Object_Status.ValueData                   AS StatusName

          , MovementBoolean_PriceWithVAT.ValueData    AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          , MovementFloat_DiscountTax.ValueData       AS DiscountTax

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , Object_PaidKind.Id                        AS PaidKindId      
          , Object_PaidKind.ValueData                 AS PaidKindName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
          , Movement_Invoice.Id                       AS MovementId_Invoice
          , zfCalc_InvNumber_isErased ('', Movement_Invoice.InvNumber, Movement_Invoice.OperDate, Movement_Invoice.StatusId) AS InvNumber_Invoice
          , MovementString_Comment_Invoice.ValueData  AS Comment_Invoice

          , Object_Insert.Id                     AS InsertId
          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate
        FROM Movement AS Movement_Income 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId 

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Income.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Income.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()       

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_Income.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
    
            LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                    ON MovementFloat_DiscountTax.MovementId = Movement_Income.Id
                                   AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
    
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
    
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_Income.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Invoice
                                           ON MovementLinkMovement_Invoice.MovementId = Movement_Income.Id
                                          AND MovementLinkMovement_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MovementLinkMovement_Invoice.MovementChildId

            LEFT JOIN MovementString AS MovementString_Comment_Invoice
                                     ON MovementString_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MovementString_Comment_Invoice.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Income.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_Income.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        WHERE Movement_Income.Id = inMovementId
          AND Movement_Income.DescId = zc_Movement_Income()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Income (inMovementId:= 1, inOperDate:= '02.02.2021', inSession:= zfCalc_UserAdmin())

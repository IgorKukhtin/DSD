-- Function: gpGet_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternalPromo (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderInternalPromo(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , StartSale TDateTime
             , Amount TFloat
             , RetailId Integer
             , RetailName TVarChar
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderInternalPromo());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                                                AS Id
          , CAST (NEXTVAL ('movement_OrderInternalPromo_seq') AS TVarChar) AS InvNumber
          , inOperDate		                             AS OperDate
          , Object_Status.Code               	             AS StatusCode
          , Object_Status.Name            	             AS StatusName
          , DATE_TRUNC ('MONTH', inOperDate) :: TDateTime   AS StartSale
          , 0::TFloat                                        AS Amount
          , NULL::Integer                                    AS RetailId
          , NULL::TVarChar                                   AS RetailName
          , NULL::TVarChar                                   AS Comment
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
  
   ELSE
 
  RETURN QUERY
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , MovementDate_StartSale.ValueData                               AS StartSale
          , COALESCE(MovementFloat_Amount.ValueData,0)::TFloat             AS Amount
          , MovementLinkObject_Retail.ObjectId                             AS RetailId
          , Object_Retail.ValueData                                        AS RetailName
          , MovementString_Comment.ValueData                               AS Comment
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_Amount
                                ON MovementFloat_Amount.MovementId =  Movement.Id
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
        
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

     WHERE Movement.Id =  inMovementId;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.19         *
*/

--тест 
--select * from gpGet_Movement_OrderInternalPromo(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_OrderInternalPromo(inMovementId := 1923638 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');
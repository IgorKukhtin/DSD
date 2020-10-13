-- Function: gpGet_Movement_RelatedProduct()

DROP FUNCTION IF EXISTS gpGet_Movement_RelatedProduct (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_RelatedProduct(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , StatusCode    Integer
             , StatusName    TVarChar
             , RetailId      Integer
             , RetailName    TVarChar
             , PriceMin      TFloat
             , Comment       TVarChar
             , Message       TBlob
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Promo());
    vbUserId := inSession;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0                           AS Id
          , CAST (NEXTVAL ('movement_RelatedProduct_seq') AS TVarChar) AS InvNumber
          , inOperDate		            AS OperDate
          , Object_Status.Code          AS StatusCode
          , Object_Status.Name          AS StatusName
          , NULL  ::Integer             AS RetailId
          , NULL  ::TVarChar            AS RetailName
          , 0     ::TFloat              AS PriceMin
          , NULL  ::TVarChar            AS Comment
          , Null::TBlob                 AS Message
        FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
  
   ELSE
 
  RETURN QUERY
     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , Object_Retail.Id                                               AS RetailId
          , Object_Retail.ValueData                                        AS RetailName
          , MovementFloat_PriceMin.ValueData                               AS PriceMin
          , MovementString_Comment.ValueData                               AS Comment
          , MovementBlob_Message.ValueData                                 AS Message
     FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_PriceMin
                                ON MovementFloat_PriceMin.MovementId = Movement.Id
                               AND MovementFloat_PriceMin.DescId = zc_MovementFloat_PriceMin()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()
                              
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

        LEFT JOIN MovementBlob AS MovementBlob_Message
                               ON MovementBlob_Message.MovementId = Movement.Id
                              AND MovementBlob_Message.DescId = zc_MovementBlob_Message()

        
     WHERE Movement.Id =  inMovementId;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.10.20                                                       *
*/

--тест 
--select * from gpGet_Movement_RelatedProduct(inMovementId := 0 , inOperDate := ('13.03.2016')::TDateTime ,  inSession := '3');
--select * from gpGet_Movement_RelatedProduct(inMovementId := 16406918 , inOperDate := ('24.04.2016')::TDateTime ,  inSession := '3');
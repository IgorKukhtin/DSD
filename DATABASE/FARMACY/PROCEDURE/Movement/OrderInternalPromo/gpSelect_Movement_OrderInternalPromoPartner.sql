-- Function: gpSelect_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPromoPartner (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPromoPartner(
    IN inMovementId     Integer , --
    IN inIsErased       Boolean ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer
             , JuridicalCode Integer
             , JuridicalName TVarChar
             , Comment TVarChar
             , CorrPrice TFloat
             , IsReport  Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

     SELECT Movement.Id                              AS Id
          , MovementLinkObject_Juridical.ObjectId    AS JuridicalId
          , Object_Juridical.ObjectCode              AS JuridicalCode
          , Object_Juridical.ValueData               AS JuridicalName
          , MovementString_Comment.ValueData         AS Comment
          , MovementFloat_CorrPrice.ValueData       AS CorrPrice
          , CASE WHEN Movement.StatusId = zc_Enum_Status_Erased() THEN FALSE ELSE TRUE END AS IsReport
     FROM Movement 
        --INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
        
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementFloat AS MovementFloat_CorrPrice
                                ON MovementFloat_CorrPrice.MovementId = Movement.Id
                               AND MovementFloat_CorrPrice.DescId = zc_MovementFloat_CorrOther()

     WHERE Movement.DescId = zc_Movement_OrderInternalPromoPartner()
       AND Movement.ParentId = inMovementId
     ORDER BY Object_Juridical.ValueData;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.02.21                                                       *
 15.10.17         *
*/
--select * from gpSelect_Movement_OrderInternalPromoPartner(inMovementId := 0 , inIsErased:= true, inSession := '3');

select * from gpSelect_Movement_OrderInternalPromoPartner(inMovementId := 21065554 , inIsErased := 'False' ,  inSession := '3');
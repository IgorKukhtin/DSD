-- Function: gpGet_TaxParam()

DROP FUNCTION IF EXISTS gpGet_TaxParam (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_TaxParam(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , DateRegistered TDateTime
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PartnerId Integer, PartnerName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Tax());
     vbUserId := lpGetUserBySession (inSession);
     

     RETURN QUERY
       SELECT
             Movement.Id					AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , COALESCE (MovementDate_DateRegistered.ValueData,CAST (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) AS TDateTime)) AS DateRegistered
           , MovementString_InvNumberPartner.ValueData          AS InvNumberPartner
           , Object_From.Id                    			AS FromId
           , Object_From.ValueData             			AS FromName--
           , Object_To.Id                      			AS ToId
           , Object_To.ValueData               			AS ToName
           , Object_Partner.Id                     		AS PartnerId
           , Object_Partner.ValueData              		AS PartnerName
      
       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId = Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

       WHERE Movement.Id = inMovementId 
         AND Movement.DescId = zc_Movement_Tax()
         AND COALESCE (inMovementId, 0) <> 0
      UNION
       SELECT 0	              AS Id
           , '' ::TVarChar    AS InvNumber
           , CAST (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) AS TDateTime) AS OperDate
           , CAST (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP) AS TDateTime) AS DateRegistered
           , '' ::TVarChar    AS InvNumberPartner
           , 0                AS FromId
           , '' ::TVarChar    AS FromName--
           , 0                AS ToId
           , '' ::TVarChar    AS ToName
           , 0                AS PartnerId
           , '' ::TVarChar    AS PartnerName 
       WHERE COALESCE (inMovementId, 0) = 0
      ;
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.04.18         *
 02.03.18         *
*/

-- тест
-- SELECT * FROM gpGet_TaxParam (inMovementId:= 0, inSession:= '2')

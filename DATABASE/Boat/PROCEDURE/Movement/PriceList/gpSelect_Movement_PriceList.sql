-- Function: gpSelect_Movement_SendChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_PriceList (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_PriceList(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_PriceList AS ( SELECT Movement_PriceList.Id
                                       , Movement_PriceList.InvNumber
                                       , Movement_PriceList.OperDate             AS OperDate
                                       , Movement_PriceList.StatusId             AS StatusId
                                       , MovementLinkObject_Partner.ObjectId   AS PartnerId
                                  FROM tmpStatus
                                       INNER JOIN Movement AS Movement_PriceList
                                                           ON Movement_PriceList.StatusId = tmpStatus.StatusId
                                                          AND Movement_PriceList.OperDate BETWEEN inStartDate AND inEndDate
                                                          AND Movement_PriceList.DescId = zc_Movement_PriceList()
     
                                       LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                    ON MovementLinkObject_Partner.MovementId = Movement_PriceList.Id
                                                                   AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                 )

        SELECT Movement_PriceList.Id
             , zfConvert_StringToNumber (Movement_PriceList.InvNumber) AS InvNumber
             , ('№ ' || Movement_PriceList.InvNumber || ' от ' || zfConvert_DateToString (Movement_PriceList.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement_PriceList.OperDate
             , Object_Status.ObjectCode              AS StatusCode
             , Object_Status.ValueData               AS StatusName

             , Object_Partner.Id                     AS PartnerId
             , Object_Partner.ObjectCode             AS PartnerCode
             , Object_Partner.ValueData              AS PartnerName

             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM Movement_PriceList

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PriceList.StatusId
        LEFT JOIN Object AS Object_Partner   ON Object_Partner.Id   = Movement_PriceList.PartnerId

         LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_PriceList.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_PriceList.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_PriceList.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_PriceList.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_PriceList.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
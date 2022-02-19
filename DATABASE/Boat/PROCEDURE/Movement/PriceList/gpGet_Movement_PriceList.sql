-- Function: gpGet_Movement_PriceList()

DROP FUNCTION IF EXISTS gpGet_Movement_PriceList (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PriceList(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PriceList());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                               AS Id
             , CAST (NEXTVAL ('movement_PriceList_seq') AS TVarChar) AS InvNumber
             , inOperDate   ::TDateTime        AS OperDate     --CURRENT_DATE
             , Object_Status.Code              AS StatusCode
             , Object_Status.Name              AS StatusName
             , 0                               AS PartnerId
             , CAST ('' AS TVarChar)           AS PartnerName
             , CAST ('' AS TVarChar)           AS Comment
             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY

        SELECT
            Movement_PriceList.Id
          , Movement_PriceList.InvNumber
          , Movement_PriceList.OperDate    AS OperDate
          , Object_Status.ObjectCode       AS StatusCode
          , Object_Status.ValueData        AS StatusName

          , Object_Partner.Id              AS PartnerId
          , Object_Partner.ValueData       AS PartnerName

          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

          , Object_Insert.Id               AS InsertId
          , Object_Insert.ValueData        AS InsertName
          , MovementDate_Insert.ValueData  AS InsertDate

        FROM Movement AS Movement_PriceList
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PriceList.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement_PriceList.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

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

        WHERE Movement_PriceList.Id = inMovementId
          AND Movement_PriceList.DescId = zc_Movement_PriceList()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.22         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PriceList (inMovementId:= 0, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')

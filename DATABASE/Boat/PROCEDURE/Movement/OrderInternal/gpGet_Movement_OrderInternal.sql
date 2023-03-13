-- Function: gpGet_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderInternal(
    IN inMovementId             Integer,   -- ключ Документа
    IN inMovementId_OrderClient Integer,   -- заказ клиента
    IN inOperDate               TDateTime, -- 
    IN inSession                TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar
             , MovementId_OrderClient Integer, InvNumber_all TVarChar, ProductName TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_OrderInternal_seq') AS TVarChar) AS InvNumber
             , inOperDate   ::TDateTime   AS OperDate     --CURRENT_DATE
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , CAST ('' AS TVarChar)     AS Comment

             , 0              :: Integer AS MovementId_OrderClient
             , CAST ('' AS TVarChar)     AS InvNumber_all
             , CAST ('' AS TVarChar)     AS ProductName

             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
          ;

     ELSE

     RETURN QUERY
     WITH tmpMovement_OrderClient AS (SELECT Movement_OrderClient.Id              AS MovementId
                                           , Movement_OrderClient.InvNumber       AS InvNumber
                                           , Movement_OrderClient.OperDate        AS OperDate
                                           , Movement_OrderClient.StatusId        AS StatusId
                                           , MovementLinkObject_From.ObjectId     AS FromId
                                           , MovementLinkObject_Product.ObjectId  AS ProductId
                                      FROM Movement AS Movement_OrderClient
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                                        ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                                       AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()
                                      WHERE Movement_OrderClient.Id = inMovementId_OrderClient
                                     )
        SELECT
            Movement_OrderInternal.Id
          , Movement_OrderInternal.InvNumber
          , Movement_OrderInternal.OperDate              AS OperDate
          , Object_Status.ObjectCode                     AS StatusCode
          , Object_Status.ValueData                      AS StatusName
          , MovementString_Comment.ValueData :: TVarChar AS Comment

          , inMovementId_OrderClient                     AS MovementId_OrderClient
          , (zfCalc_InvNumber_isErased ('', tmpMovement_OrderClient.InvNumber, tmpMovement_OrderClient.OperDate, tmpMovement_OrderClient.StatusId) || ' / ' || Object_From.ValueData) :: TVarChar  AS InvNumber_all
          , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName

          , Object_Insert.Id                     AS InsertId
          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate

        FROM Movement AS Movement_OrderInternal
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderInternal.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_OrderInternal.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_OrderInternal.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_OrderInternal.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN tmpMovement_OrderClient  ON tmpMovement_OrderClient.MovementId = inMovementId_OrderClient
            LEFT JOIN Object AS Object_Product ON Object_Product.Id = tmpMovement_OrderClient.ProductId
            LEFT JOIN Object AS Object_From    ON Object_From.Id    = tmpMovement_OrderClient.FromId

        WHERE Movement_OrderInternal.Id = inMovementId
          AND Movement_OrderInternal.DescId = zc_Movement_OrderInternal()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.22         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderInternal (inMovementId:= 0, inMovementId_OrderClient:= 0, inOperDate := '02.02.2021'::TDateTime, inSession:= '9818')

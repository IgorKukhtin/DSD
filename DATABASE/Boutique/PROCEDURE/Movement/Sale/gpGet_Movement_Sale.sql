-- Function: gpGet_Movement_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , LastDate TDateTime, TotalLastSumm TFloat, TotalSummPay TFloat, TotalDebt TFloat
             , DiscountTax TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , HappyDate TDateTime, CityName TVarChar, Address TVarChar, PhoneMobile TVarChar, Phone TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- определять магазин по принадлежности пользователя к сотруднику
     vbUnitId:= lpGetUnitBySession (inSession);

     IF inOperDate < '01.01.2017' THEN inOperDate := CURRENT_DATE; END IF;
     -- пытаемся найти последний непроведенный документ
     IF COALESCE (inMovementId, 0) = 0
     THEN
         inMovementId:= (SELECT tmp.Id
                         FROM (SELECT Movement.Id
                                    , ROW_NUMBER() OVER (ORDER BY Movement.Operdate desc, Movement.Id desc) AS Ord
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                           AND MovementLinkObject_From.ObjectId = vbUnitId
                               WHERE Movement.DescId   = zc_Movement_Sale()
                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                               ) AS tmp
                         WHERE tmp.Ord = 1);
     END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             --, CAST (NEXTVAL ('Movement_Sale_seq') AS TVarChar) AS InvNumber
             , CAST (lfGet_InvNumber (0, zc_Movement_Sale()) AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , CAST (NULL AS TDateTime)         AS LastDate
             , CAST (0 as TFloat)               AS TotalLastSumm
             , CAST (0 as TFloat)               AS TotalSummPay
             , CAST (0 as TFloat)               AS TotalDebt
             , CAST (0 as TFloat)               AS DiscountTax

             , Object_Unit.Id                                   AS FromId
             , COALESCE (Object_Unit.ValueData, '') :: TVarChar AS FromName
             , 0                                AS ToId
             , CAST ('' as TVarChar)            AS ToName

             , CAST (NULL AS TDateTime)         AS HappyDate
             , CAST ('' as TVarChar)            AS CityName
             , CAST ('' as TVarChar)            AS Address
             , CAST ('' as TVarChar)            AS PhoneMobile
             , CAST ('' as TVarChar)            AS Phone
             , CAST ('' as TVarChar)            AS Comment

             , COALESCE(Object_Insert.ValueData,'')  ::TVarChar AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime    AS InsertDate

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId;
     ELSE
       RETURN QUERY
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode               AS StatusCode
             , Object_Status.ValueData                AS StatusName

             , ObjectDate_LastDate.ValueData           AS LastDate
             , (COALESCE (ObjectFloat_TotalSumm.ValueData, 0) - COALESCE (ObjectFloat_TotalSummDiscount.ValueData, 0)) :: TFloat AS TotalLastSumm
             , COALESCE (ObjectFloat_TotalSummPay.ValueData, 0) :: TFloat AS TotalSummPay
             , (COALESCE (ObjectFloat_TotalSumm.ValueData, 0) - COALESCE (ObjectFloat_TotalSummDiscount.ValueData, 0) - COALESCE (ObjectFloat_TotalSummPay.ValueData, 0)) :: TFloat AS TotalDebt
             , ObjectFloat_DiscountTax.ValueData      AS DiscountTax

             , Object_From.Id                         AS FromId
             , Object_From.ValueData                  AS FromName
             , Object_To.Id                           AS ToId
             , Object_To.ValueData                    AS ToName

             , ObjectDate_HappyDate.ValueData         AS HappyDate
             , Object_City.ValueData                  AS CityName
             , ObjectString_Address.ValueData         AS Address
             , ObjectString_PhoneMobile.ValueData     AS PhoneMobile
             , ObjectString_Phone.ValueData           AS Phone

             , MovementString_Comment.ValueData       AS Comment

             , Object_Insert.ValueData                AS InsertName
             , COALESCE (MovementDate_Insert.ValueData, CURRENT_TIMESTAMP)  :: TDateTime AS InsertDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Client_City
                                 ON ObjectLink_Client_City.ObjectId = Object_To.Id
                                AND ObjectLink_Client_City.DescId = zc_ObjectLink_Client_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Client_City.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                  ON ObjectFloat_DiscountTax.ObjectId = Object_To.Id
                                 AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummPay
                                  ON ObjectFloat_TotalSummPay.ObjectId = Object_To.Id
                                 AND ObjectFloat_TotalSummPay.DescId = zc_ObjectFloat_Client_TotalSummPay()
            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                  ON ObjectFloat_TotalSumm.ObjectId = Object_To.Id
                                 AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_Client_TotalSumm()
            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummDiscount
                                  ON ObjectFloat_TotalSummDiscount.ObjectId = Object_To.Id
                                 AND ObjectFloat_TotalSummDiscount.DescId = zc_ObjectFloat_Client_TotalSummDiscount()

            LEFT JOIN ObjectDate AS ObjectDate_LastDate
                                 ON ObjectDate_LastDate.ObjectId = Object_To.Id
                                AND ObjectDate_LastDate.DescId = zc_ObjectDate_Client_LastDate()

            LEFT JOIN ObjectString AS ObjectString_Address
                                   ON ObjectString_Address.ObjectId = Object_To.Id
                                  AND ObjectString_Address.DescId = zc_ObjectString_Client_Address()

            LEFT JOIN ObjectDate AS ObjectDate_HappyDate
                                 ON ObjectDate_HappyDate.ObjectId = Object_To.Id
                                AND ObjectDate_HappyDate.DescId = zc_ObjectDate_Client_HappyDate()

            LEFT JOIN ObjectString AS ObjectString_PhoneMobile
                                   ON ObjectString_PhoneMobile.ObjectId = Object_To.Id
                                  AND ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()

            LEFT JOIN ObjectString AS ObjectString_Phone
                                   ON ObjectString_Phone.ObjectId = Object_To.Id
                                  AND ObjectString_Phone.DescId = zc_ObjectString_Client_Phone()

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Sale();
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.17         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Sale (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())

-- Function: gpGet_Movement_BankSecondNum()

DROP FUNCTION IF EXISTS gpGet_Movement_BankSecondNum (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_BankSecondNum(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , BankSecond_num TFloat
             , BankSecondTwo_num TFloat
             , BankSecondDiff_num TFloat
             , BankSecondId_num Integer, BankSecondName_num TVarChar
             , BankSecondTwoId_num Integer, BankSecondTwoName_num TVarChar
             , BankSecondDiffId_num Integer, BankSecondDiffName_num TVarChar
             , Comment TVarChar
             , InsertDate TDateTime, InsertName TVarChar
             , UpdateDate TDateTime, UpdateName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_BankSecondNum());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_BankSecondNum_seq') AS TVarChar) AS InvNumber
             , inOperDate                                 AS OperDate
             , Object_Status.Code                         AS StatusCode
             , Object_Status.Name                         AS StatusName

             , CAST (0 as TFloat)                         AS BankSecond_num
             , CAST (0 as TFloat)                         AS BankSecondTwo_num
             , CAST (0 as TFloat)                         AS BankSecondDiff_num
             , 0                                          AS BankSecondId_num
             , CAST ('' as TVarChar)                      AS BankSecondName_num
             , 0                                          AS BankSecondTwoId_num
             , CAST ('' as TVarChar)                      AS BankSecondTwoName_num
             , 0                                          AS BankSecondDiffId_num
             , CAST ('' as TVarChar)                      AS BankSecondDiffName_num

             , CAST ('' as TVarChar) 	                  AS Comment

             , CURRENT_TIMESTAMP ::TDateTime              AS InsertDate
             , COALESCE(Object_Insert.ValueData,'')  ::TVarChar AS InsertName 
             , NULL              ::TDateTime              AS UpdateDate
             , ''                ::TVarChar               AS UpdateName

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = zc_Enum_Currency_Basis()
          ;

     ELSE

     RETURN QUERY

       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName

           , MovementFloat_BankSecond_num.ValueData      ::TFloat AS BankSecond_num
           , MovementFloat_BankSecondTwo_num.ValueData   ::TFloat AS BankSecondTwo_num
           , MovementFloat_BankSecondDiff_num.ValueData  ::TFloat AS BankSecondDiff_num

           , Object_BankSecond_num.Id                   AS BankSecondId_num
           , Object_BankSecond_num.ValueData            AS BankSecondName_num
           , Object_BankSecondTwo_num.Id                AS BankSecondTwoId_num
           , Object_BankSecondTwo_num.ValueData         AS BankSecondTwoName_num
           , Object_BankSecondDiff_num.Id               AS BankSecondDiffId_num
           , Object_BankSecondDiff_num.ValueData        AS BankSecondDiffName_num

           , MovementString_Comment.ValueData       AS Comment

           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName         
           , MovementDate_Update.ValueData          AS UpdateDate
           , Object_Update.ValueData                AS UpdateName
       FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecond_num
                                    ON MovementFloat_BankSecond_num.MovementId =  Movement.Id
                                   AND MovementFloat_BankSecond_num.DescId = zc_MovementFloat_BankSecond_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondTwo_num
                                    ON MovementFloat_BankSecondTwo_num.MovementId =  Movement.Id
                                   AND MovementFloat_BankSecondTwo_num.DescId = zc_MovementFloat_BankSecondTwo_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondDiff_num
                                    ON MovementFloat_BankSecondDiff_num.MovementId =  Movement.Id
                                   AND MovementFloat_BankSecondDiff_num.DescId = zc_MovementFloat_BankSecondDiff_num()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecond_num
                                         ON MovementLinkObject_BankSecond_num.MovementId = Movement.Id
                                        AND MovementLinkObject_BankSecond_num.DescId = zc_MovementLinkObject_BankSecond_num()
            LEFT JOIN Object AS Object_BankSecond_num ON Object_BankSecond_num.Id = MovementLinkObject_BankSecond_num.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecondTwo_num
                                         ON MovementLinkObject_BankSecondTwo_num.MovementId = Movement.Id
                                        AND MovementLinkObject_BankSecondTwo_num.DescId = zc_MovementLinkObject_BankSecondTwo_num()
            LEFT JOIN Object AS Object_BankSecondTwo_num ON Object_BankSecondTwo_num.Id = MovementLinkObject_BankSecondTwo_num.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_BankSecondDiff_num
                                         ON MovementLinkObject_BankSecondDiff_num.MovementId = Movement.Id
                                        AND MovementLinkObject_BankSecondDiff_num.DescId = zc_MovementLinkObject_BankSecondDiff_num()
            LEFT JOIN Object AS Object_BankSecondDiff_num ON Object_BankSecondDiff_num.Id = MovementLinkObject_BankSecondDiff_num.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_BankSecondNum();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.24         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_BankSecondNum (inMovementId:= 40874, inOperDate:= CURRENT_DATE, inSession := zfCalc_UserAdmin());

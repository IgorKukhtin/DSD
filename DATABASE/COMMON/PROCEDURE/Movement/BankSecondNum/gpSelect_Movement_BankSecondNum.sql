-- Function: gpSelect_Movement_BankSecondNum()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankSecondNum (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankSecondNum(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_PersonalService Integer, InvNumber_PersonalService TVarChar, ServiceDate TDateTime
             , BankSecond_num TFloat
             , BankSecondTwo_num TFloat
             , BankSecondDiff_num TFloat
             , BankSecondId_num Integer, BankSecondName_num TVarChar
             , BankSecondTwoId_num Integer, BankSecondTwoName_num TVarChar
             , BankSecondDiffId_num Integer, BankSecondDiffName_num TVarChar
             , BankName_Num TVarChar
             , Comment TVarChar
             , InsertDate TDateTime, InsertName TVarChar
             , UpdateDate TDateTime, UpdateName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankSecondNum());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
      
         , tmpPersonalService AS (SELECT Movement_PersonalService.Id AS MovementId_PersonalService
                                     --, (COALESCE (Object_PersonalServiceList.ValueData, '') || ' № ' || Movement_PersonalService.InvNumber || ' от ' || zfConvert_DateToString (Movement_PersonalService.OperDate)) :: TVarChar  AS InvNumber_PersonalService 
                                       , (COALESCE (Object_PersonalServiceList.ValueData, '') || ' за ' || zfCalc_MonthName (MovementDate_ServiceDate.ValueData) || ' № ' || Movement_PersonalService.InvNumber) :: TVarChar  AS InvNumber_PersonalService
                                       , MovementDate_ServiceDate.ValueData  AS ServiceDate
                                  FROM MovementDate AS MovementDate_ServiceDate 
                                       INNER JOIN Movement AS Movement_PersonalService
                                                           ON Movement_PersonalService.Id = MovementDate_ServiceDate.MovementId
                                                          AND Movement_PersonalService.DescId = zc_Movement_PersonalService()
                                       LEFT JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                                    ON MLO_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                                   AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                       LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MLO_PersonalServiceList.ObjectId
                                  WHERE MovementDate_ServiceDate.ValueData BETWEEN inStartDate AND inEndDate
                                    AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                                  )
         , tmpBankSecondNum AS (SELECT MLM_BankSecond_num.* 
                                FROM MovementLinkMovement AS MLM_BankSecond_num
                                WHERE MLM_BankSecond_num.MovementId IN (SELECT DISTINCT tmpPersonalService.MovementId_PersonalService FROM tmpPersonalService)
                                  AND MLM_BankSecond_num.DescId = zc_MovementLinkMovement_BankSecondNum() 
                                )
 
         , tmpMovement AS (SELECT Movement.*
                           FROM tmpStatus
                                JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                             AND Movement.DescId = zc_Movement_BankSecondNum()
                                             AND Movement.StatusId = tmpStatus.StatusId
                           )

       ----------
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName

           , tmpPersonalService.MovementId_PersonalService                AS MovementId_PersonalService
           , tmpPersonalService.InvNumber_PersonalService    :: TVarChar  AS InvNumber_PersonalService
           , COALESCE (tmpPersonalService.ServiceDate, NULL) :: TDateTime AS ServiceDate

           , MovementFloat_BankSecond_num.ValueData      ::TFloat AS BankSecond_num
           , MovementFloat_BankSecondTwo_num.ValueData   ::TFloat AS BankSecondTwo_num
           , MovementFloat_BankSecondDiff_num.ValueData  ::TFloat AS BankSecondDiff_num

           , Object_BankSecond_num.Id                   AS BankSecondId_num
           , Object_BankSecond_num.ValueData            AS BankSecondName_num
           , Object_BankSecondTwo_num.Id                AS BankSecondTwoId_num
           , Object_BankSecondTwo_num.ValueData         AS BankSecondTwoName_num
           , Object_BankSecondDiff_num.Id               AS BankSecondDiffId_num
           , Object_BankSecondDiff_num.ValueData        AS BankSecondDiffName_num
           
           , ('1.'||CASE WHEN COALESCE (MovementFloat_BankSecond_num.ValueData,0) = 1     THEN COALESCE (Object_BankSecond_num.ValueData,'Восток')
                         WHEN COALESCE (MovementFloat_BankSecondTwo_num.ValueData,0) = 1  THEN COALESCE (Object_BankSecondTwo_num.ValueData,'ОТП')
                         WHEN COALESCE (MovementFloat_BankSecondDiff_num.ValueData,0) = 1 THEN COALESCE (Object_BankSecondDiff_num.ValueData,'Личный')
                    END
                         
          || ' 2.'||CASE WHEN COALESCE (MovementFloat_BankSecond_num.ValueData,0) = 2     THEN COALESCE (Object_BankSecond_num.ValueData,'Восток')
                         WHEN COALESCE (MovementFloat_BankSecondTwo_num.ValueData,0) = 2  THEN COALESCE (Object_BankSecondTwo_num.ValueData,'ОТП')
                         WHEN COALESCE (MovementFloat_BankSecondDiff_num.ValueData,0) = 2 THEN COALESCE (Object_BankSecondDiff_num.ValueData,'Личный')
                    END
          || ' 3.'||CASE WHEN COALESCE (MovementFloat_BankSecond_num.ValueData,0) = 3     THEN COALESCE (Object_BankSecond_num.ValueData,'Восток')
                         WHEN COALESCE (MovementFloat_BankSecondTwo_num.ValueData,0) = 3  THEN COALESCE (Object_BankSecondTwo_num.ValueData,'ОТП')
                         WHEN COALESCE (MovementFloat_BankSecondDiff_num.ValueData,0) = 3 THEN COALESCE (Object_BankSecondDiff_num.ValueData,'Личный')
                    END ) ::TVarChar AS BankName_Num

           , MovementString_Comment.ValueData       AS Comment

           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName         
           , MovementDate_Update.ValueData          AS UpdateDate
           , Object_Update.ValueData                AS UpdateName
       FROM tmpPersonalService
       
            INNER JOIN MovementLinkMovement AS MLM_BankSecond_num
                                            ON MLM_BankSecond_num.MovementId = tmpPersonalService.MovementId_PersonalService   --- = Movement.Id
                                           AND MLM_BankSecond_num.DescId = zc_MovementLinkMovement_BankSecondNum() 
           
            LEFT JOIN Movement ON Movement.Id = MLM_BankSecond_num.MovementChildId
            LEFT JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId

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

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_BankSecondNum (inStartDate:= '01.02.2024', inEndDate:= '31.03.2024', inIsErased := FALSE, inJuridicalBasisId:= 0, inSession:= '2')

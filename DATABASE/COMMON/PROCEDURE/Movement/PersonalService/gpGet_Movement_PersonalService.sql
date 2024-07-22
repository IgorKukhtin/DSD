-- Function: gpGet_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalService (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalService(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , TotalSummCardRecalc TFloat 
             , PriceNalog TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , isAuto Boolean, isDetail Boolean
             , isMail Boolean
             , strSign          TVarChar    -- ФИО пользователей. - есть эл. подпись
             , strSignNo        TVarChar    -- ФИО пользователей. - ожидается эл. подпись
             , MemberId         Integer     --
             , MemberName       TVarChar    -- ФИО (пользователь) - ведомость начисления 
             , InfoMoneyId Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MovementId_BankSecondNum Integer, InvNumber_BankSecondNum TVarChar
             , AuditColumnName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalService());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = -1
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не выбран.' ;
     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_PersonalService_seq') AS TVarChar) AS InvNumber
--           , inOperDate                AS OperDate
             , CURRENT_DATE :: TDateTime AS OperDate
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName

             , DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '1 MONTH') :: TDateTime  AS ServiceDate
             , 0            :: TFloat    AS TotalSummCardRecalc  
             , 0            :: TFloat    AS PriceNalog
             , CAST ('' AS TVarChar)     AS Comment
             , 0                     	 AS PersonalServiceListId
             , CAST ('' AS TVarChar) 	 AS PersonalServiceListName

             , 0                     	 AS JuridicalId
             , CAST ('' AS TVarChar) 	 AS JuridicalName
             , False                     AS isAuto
             , False                     AS isDetail
             , False         :: Boolean  AS isMail
             , NULL::TVarChar            AS strSign
             , NULL::TVarChar            AS strSignNo
             , 0                         AS MemberId
             , NULL::TVarChar            AS MemberName

             , 0                     	 AS InfoMoneyId
             , CAST ('' AS TVarChar) 	 AS InfoMoneyName
             , CAST ('' AS TVarChar) 	 AS InfoMoneyName_all
             , 0                         AS MovementId_BankSecondNum
             , '' ::TVarChar             AS InvNumber_BankSecondNum
             , '' ::TVarChar             AS AuditColumnName
          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , COALESCE (MovementDate_ServiceDate.ValueData, DATE_TRUNC ('MONTH', Movement.OperDate)) :: TDateTime AS ServiceDate
           , MovementFloat_TotalSummCardRecalc.ValueData  AS TotalSummCardRecalc 
           , MovementFloat_PriceNalog.ValueData                   :: TFloat AS PriceNalog
           , MovementString_Comment.ValueData     AS Comment
           , Object_PersonalServiceList.Id        AS PersonalServiceListId
           , Object_PersonalServiceList.ValueData AS PersonalServiceListName
           , Object_Juridical.Id                  AS JuridicalId
           , Object_Juridical.ValueData           AS JuridicalName
           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto
           , COALESCE(MovementBoolean_Detail.ValueData, False) :: Boolean  AS isDetail
           , COALESCE(MovementBoolean_Mail.ValueData, False)   :: Boolean  AS isMail
           , tmpSign.strSign
           , tmpSign.strSignNo
           , Object_Member.Id                     AS MemberId
           , Object_Member.ValueData              AS MemberName   

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all

           , Movement_BankSecondNum.Id            AS MovementId_BankSecondNum
           , zfCalc_PartionMovementName (Movement_BankSecondNum.DescId
                                       , MovementDesc_BankSecondNum.ItemName
                                       , '(' 
                                      || (MovementFloat_BankSecond_num.ValueData     :: Integer) :: TVarChar
                             || ' + ' || (MovementFloat_BankSecondTwo_num.ValueData  :: Integer) :: TVarChar
                             || ' + ' || (MovementFloat_BankSecondDiff_num.ValueData :: Integer) :: TVarChar
                                      || ')'
                                      || ' № ' || Movement_BankSecondNum.InvNumber
                                       , Movement_BankSecondNum.OperDate) ::TVarChar AS InvNumber_BankSecondNum

           , CASE WHEN Object_PersonalServiceList.Id  IN (293428, 301885) THEN 'Допл. за ревизию' ELSE 'Возмещ. налоги грн' END :: TVarChar AS AuditColumnName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            LEFT JOIN MovementBoolean AS MovementBoolean_Detail
                                      ON MovementBoolean_Detail.MovementId = Movement.Id
                                     AND MovementBoolean_Detail.DescId = zc_MovementBoolean_Detail()
            LEFT JOIN MovementBoolean AS MovementBoolean_Mail
                                      ON MovementBoolean_Mail.MovementId = Movement.Id
                                     AND MovementBoolean_Mail.DescId = zc_MovementBoolean_Mail()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCardRecalc
                                    ON MovementFloat_TotalSummCardRecalc.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCardRecalc.DescId = zc_MovementFloat_TotalSummCardRecalc()

            LEFT JOIN MovementFloat AS MovementFloat_PriceNalog
                                    ON MovementFloat_PriceNalog.MovementId = Movement.Id
                                   AND MovementFloat_PriceNalog.DescId = zc_MovementFloat_PriceNalog()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN lpSelect_MI_Sign (inMovementId:= Movement.Id) AS tmpSign ON tmpSign.Id = Movement.Id   -- эл.подписи  --

            LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                 ON ObjectLink_PersonalServiceList_Member.ObjectId = Object_PersonalServiceList.Id
                                AND ObjectLink_PersonalServiceList_Member.DescId = zc_ObjectLink_PersonalServiceList_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_PersonalServiceList_Member.ChildObjectId

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101()

            LEFT JOIN MovementLinkMovement AS MLM_BankSecond_num
                                           ON MLM_BankSecond_num.MovementId = Movement.Id
                                          AND MLM_BankSecond_num.DescId = zc_MovementLinkMovement_BankSecondNum() 
            LEFT JOIN Movement AS Movement_BankSecondNum ON Movement_BankSecondNum.Id = MLM_BankSecond_num.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_BankSecondNum ON MovementDesc_BankSecondNum.Id = Movement_BankSecondNum.DescId

            LEFT JOIN MovementFloat AS MovementFloat_BankSecond_num
                                    ON MovementFloat_BankSecond_num.MovementId =  Movement_BankSecondNum.Id
                                   AND MovementFloat_BankSecond_num.DescId = zc_MovementFloat_BankSecond_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondTwo_num
                                    ON MovementFloat_BankSecondTwo_num.MovementId =  Movement_BankSecondNum.Id
                                   AND MovementFloat_BankSecondTwo_num.DescId = zc_MovementFloat_BankSecondTwo_num()

            LEFT JOIN MovementFloat AS MovementFloat_BankSecondDiff_num
                                    ON MovementFloat_BankSecondDiff_num.MovementId =  Movement_BankSecondNum.Id
                                   AND MovementFloat_BankSecondDiff_num.DescId = zc_MovementFloat_BankSecondDiff_num()

       WHERE Movement.Id =  inMovementId;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpGet_Movement_PersonalService (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 
 22.07.24         *
 12.03.24         *
 05.07.23         *
 16.11.21         *
 28.04.21         *
 20.09.18         *
 21.06.16         *
 01.10.14         * add Juridical
 11.09.14         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalService (inMovementId:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin())

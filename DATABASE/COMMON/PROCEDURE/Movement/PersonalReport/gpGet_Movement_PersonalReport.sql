-- Function: gpGet_Movement_PersonalReport()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalReport (Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_PersonalReport (Integer, Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalReport(
    IN inMovementId        Integer   , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inMemberId          Integer   ,
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , AmountIn TFloat, AmountOut TFloat
             , Comment TVarChar
             , MemberId Integer, MemberName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , CarId Integer, CarName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalReport());
     vbUserId := lpGetUserBySession (inSession);


     --новый
     IF (COALESCE (inMovementId, 0) = 0) AND (COALESCE (inMovementId_Value, 0) = 0)
     THEN
          -- проверка
          IF COALESCE (inMemberId, 0) = 0
          THEN 
              RAISE EXCEPTION 'Ошибка. Не установлено значение <Подотчет (ФИО)>.';
          END IF;

     RETURN QUERY
     WITH tmpPersonal AS (SELECT ObjectLink_Personal_Unit.ChildObjectId     AS UnitId
                               , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId
                                                    -- сортировкой определяется приоритет для выбора, т.к. выбираем с Ord = 1
                                                    ORDER BY CASE WHEN Object_Personal.isErased = FALSE THEN 0 ELSE 1 END
                                                           , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN 0 ELSE 1 END
                                                           , CASE WHEN ObjectBoolean_Main.ValueData = TRUE THEN 0 ELSE 1 END
                                                           , ObjectLink_Personal_Member.ObjectId
                                                   ) AS Ord
                          FROM ObjectLink AS ObjectLink_Personal_Member
                               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_Personal_Member.ObjectId
                               LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                                    ON ObjectDate_DateOut.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
                               LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                    ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                   AND ObjectLink_Personal_Unit.DescId   = zc_ObjectLink_Personal_Unit()
                              
                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = ObjectLink_Personal_Member.ObjectId
                                                      AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_Personal_Main()
                          WHERE ObjectLink_Personal_Member.ChildObjectId = inMemberId
                            AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                         )
       SELECT
             0                                  AS Id
           , CAST (NEXTVAL ('movement_personalreport_seq') AS TVarChar) AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime) AS OperDate
           , inOperDate                         AS OperDate


           , 0::TFloat                          AS AmountIn
           , 0::TFloat                          AS AmountOut

           , ''::TVarChar                       AS Comment
           , Object_Member.Id                   AS MemberId
           , Object_Member.ValueData            AS MemberName
           , 0                                  AS InfoMoneyId
           , CAST ('' as TVarChar)              AS InfoMoneyName

           , 0                                  AS ContractId
           , ''::TVarChar                       AS ContractInvNumber

           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , 0                                  AS MoneyPlaceId
           , CAST ('' as TVarChar)              AS MoneyPlaceName
           , 0                                  AS CarId
           , CAST ('' as TVarChar)              AS CarName

           , 0                                  AS MovementId_Invoice
           , CAST ('' AS TVarChar)              AS InvNumber_Invoice
       FROM Object AS Object_Member
            LEFT JOIN tmpPersonal ON tmpPersonal.ord = 1
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId 
       WHERE Object_Member.Id = inMemberId
       ;
   END IF;

   -- новый по маске
   IF (COALESCE (inMovementId, 0) = 0) AND (COALESCE (inMovementId_Value, 0) <> 0)
   THEN
   RETURN QUERY
       SELECT
             inMovementId                       AS Id
           , CAST (NEXTVAL ('movement_personalreport_seq') AS TVarChar) AS InvNumber
           , inOperDate                         AS OperDate

           , 0 :: TFloat                        AS AmountIn
           , 0 :: TFloat                        AS AmountOut

           , MIString_Comment.ValueData         AS Comment

           , Object_Member.Id                   AS MemberId
           , Object_Member.ValueData            AS MemberName
           , View_InfoMoney.InfoMoneyId         AS InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all   AS InfoMoneyName
           , View_Contract_InvNumber.ContractId AS ContractId
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_MoneyPlace.Id               AS MoneyPlaceId
           , Object_MoneyPlace.ValueData        AS MoneyPlaceName
           , Object_Car.Id                      AS CarId
           --, (COALESCE (Object_CarModel.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarName
           , (COALESCE (Object_CarModel.ValueData, '') || COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarName

           , Movement_Invoice.Id                AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE(MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = zc_Enum_Status_UnComplete()

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
           
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = CASE WHEN Movement.DescId = zc_Movement_PersonalReport() THEN MILinkObject_MoneyPlace.ObjectId END

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = CASE WHEN Movement.DescId = zc_Movement_PersonalReport() THEN MovementItem.ObjectId WHEN Movement.DescId = zc_Movement_Cash() THEN MILinkObject_MoneyPlace.ObjectId END

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId
            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId =  Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
            
       WHERE Movement.Id =  inMovementId_Value;

   END IF;

   -- существующий
   IF (COALESCE (inMovementId, 0) <> 0)
   THEN

          -- проверка
          PERFORM lpCheck_Movement_PersonalReport (inMovementId:= inMovementId, inComment:= 'изменен', inUserId:= vbUserId);


   RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate

           , CASE
                  WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END :: TFloat                      AS AmountIn
           , CASE
                  WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END :: TFloat                      AS AmountOut

           , MIString_Comment.ValueData         AS Comment

           , Object_Member.Id                   AS MemberId
           , Object_Member.ValueData            AS MemberName
           , View_InfoMoney.InfoMoneyId         AS InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all   AS InfoMoneyName
           , View_Contract_InvNumber.ContractId AS ContractId
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_MoneyPlace.Id               AS MoneyPlaceId
           , Object_MoneyPlace.ValueData        AS MoneyPlaceName
           , Object_Car.Id                      AS CarId
           , (COALESCE (Object_CarModel.ValueData, '') || COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, '')) :: TVarChar AS CarName

           , Movement_Invoice.Id                AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE(MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

       FROM Movement

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId
            LEFT JOIN ObjectLink AS Car_CarModel ON Car_CarModel.ObjectId = Object_Car.Id
                                                AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId =  Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

       WHERE Movement.Id =  inMovementId;

   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_PersonalReport (Integer, Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.05.15         * add contract
 09.04.15                                        * all
 16.09.14                                                        *
 15.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalReport (inMovementId:= 1, inMovementId_Value:=0,  inMemberId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin());

-- Function: gpSelect_Movement_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalService (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalService(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inServiceDate   TDateTime , --
    IN inisServiceDate Boolean , --
    IN inUnitId        Integer   , 
    IN inPaidKindId    Integer   , 
    IN inProcess       TVarChar  ,
    IN inIsErased      Boolean   ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate TDateTime
             , Amount TFloat
             , PersonalId Integer, PersonalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , Comment TVarChar
             , INN TVarChar
              )
AS
$BODY$
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyName TVarChar;
   DECLARE vbInfoMoneyName_all TVarChar;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalService());
     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);
     
   -- определяется Дефолт
   SELECT View_InfoMoney.InfoMoneyId, View_InfoMoney.InfoMoneyName, View_InfoMoney.InfoMoneyName_all
          INTO vbInfoMoneyId, vbInfoMoneyName, vbInfoMoneyName_all
   FROM Object_InfoMoney_View AS View_InfoMoney
   WHERE View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101(); -- 60101 Заработная плата + Заработная плата


     RETURN QUERY 
SELECT 
             PersonalData.Id
           , PersonalData.InvNumber
           , PersonalData.OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
           , COALESCE (PersonalData.ServiceDate, inServiceDate) AS ServiceDate 
           , PersonalData.Amount
           , Object_Personal.Id                  AS PersonalId
           , Object_Personal.ValueData           AS PersonalName
           , COALESCE (Object_PaidKind.Id, Object_PaidKindInf.Id)   AS PaidKindName
           , COALESCE (Object_PaidKind.ValueData, Object_PaidKindInf.ValueData) AS PaidKindName
           , COALESCE (Object_InfoMoney_View.InfoMoneyId, vbInfoMoneyId) AS InfoMoneyId      
           , COALESCE (Object_InfoMoney_View.InfoMoneyName_all, vbInfoMoneyName_all) AS InfoMoneyName
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , Object_Position.Id                   AS PositionId
           , Object_Position.ValueData            AS PositionName
           , PersonalData.Comment
           , ObjectString_Member_INN.ValueData    AS INN

FROM 
 (SELECT     Personal_Movement.Id
           , Personal_Movement.InvNumber
           , Personal_Movement.OperDate
           , Personal_Movement.StatusId
           , Personal_Movement.ServiceDate
           , Personal_Movement.Amount 
           , Personal_Movement.Comment
           , Personal_Movement.InfoMoneyId
           , Personal_Movement.PaidKindId          
           , COALESCE(Personal_Movement.PersonalId, Object_Personal_View.PersonalId) AS PersonalId     
           , COALESCE(Personal_Movement.PositionId, Object_Personal_View.PositionId) AS PositionId
           , COALESCE(Personal_Movement.UnitId, Object_Personal_View.UnitId)         AS UnitId
           
 FROM (
 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusId
           , MIDate_ServiceDate.ValueData    AS ServiceDate           
           , MovementItem.Amount 
           , MovementItem.ObjectId           AS PersonalId
           , MILinkObject_PaidKind.ObjectId  AS PaidKindId   
           , MILinkObject_Position.ObjectId  AS PositionId
           , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
           , MILinkObject_Unit.ObjectId      AS UnitId 
           , MIString_Comment.ValueData      AS Comment
 
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                   ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                  AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                  
            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                            AND MILinkObject_PaidKind.ObjectId = inPaidKindId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                                        
       WHERE Movement.DescId = zc_Movement_PersonalService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (MILinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
         AND (MILinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
         AND (CASE WHEN inisServiceDate = True THEN MIDate_ServiceDate.ValueData = inServiceDate else 0 = 0 END)
          ) AS Personal_Movement 
           FULL JOIN 
            (SELECT * FROM Object_Personal_View
              WHERE /*((Object_Personal_View.Official = TRUE AND inPaidKindId = zc_Enum_PaidKind_FirstForm())
                       OR (inPaidKindId <> zc_Enum_PaidKind_FirstForm()))
                   AND */(Object_Personal_View.UnitId = inUnitId OR COALESCE (inUnitId, 0) = 0)
         ) AS Object_Personal_View

       ON Object_Personal_View.Personalid = Personal_Movement.PersonalId
                              AND Object_Personal_View.UnitId = Personal_Movement.UnitId 
                              AND Object_Personal_View.PositionId = Personal_Movement.PositionId ) AS PersonalData

             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = PersonalData.PersonalId
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = PersonalData.StatusId
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = PersonalData.InfoMoneyId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = PersonalData.PositionId
             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = PersonalData.PaidKindId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = PersonalData.UnitId
             LEFT JOIN Object AS Object_PaidKindInf ON Object_PaidKindInf.Id = inPaidKindId
             
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                  ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id  
                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

             LEFT JOIN ObjectString AS ObjectString_Member_INN
                                    ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                   AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
             
             
       ;  

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PersonalService (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.14         * add inServiceDate, inUnitId
 21.05.14                         *
 27.02.14                         *
 12.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalService (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')

--select * from gpSelect_Movement_PersonalService(inStartDate := ('04.09.2014')::TDateTime , inEndDate := ('30.09.2014')::TDateTime , inServiceDate := ('09.09.2014')::TDateTime , inUnitId := 0 , inPaidKindId := 0 , InProcess := '' , inIsErased := 'False' ,  inSession := '5');
--select * from gpSelect_Movement_PersonalService(inStartDate := ('04.09.2014')::TDateTime , inEndDate := ('30.09.2014')::TDateTime  , inServiceDate := ('01.01.2014')::TDateTime , inisServiceDate := 'true', inUnitId := 0 , inPaidKindId := 0, InProcess := 'zc_Enum_Process_PersonalService_BN()' , inIsErased := 'true' ,  inSession := '5');
--select * from gpSelect_Movement_PersonalService(inStartDate := ('01.01.2014')::TDateTime , inEndDate := ('30.09.2014')::TDateTime  , inServiceDate := ('01.09.2014')::TDateTime , inisServiceDate := 'true', inUnitId := 0 , inPaidKindId := 0, InProcess := 'zc_Enum_Process_PersonalService_BN()' , inIsErased := 'False' ,  inSession := '5');

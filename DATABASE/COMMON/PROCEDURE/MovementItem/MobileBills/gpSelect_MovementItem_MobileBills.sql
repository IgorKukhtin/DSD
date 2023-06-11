-- Function: gpSelect_MovementItem_MobileBills()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileBills (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileBills(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MobileEmployeeId Integer, MobileEmployeeCode Integer, MobileEmployeeName TVarChar, MobileEmployeeComment TVarChar
             , Amount TFloat
             , Amount_ProfitLoss TFloat
             , CurrMonthly TFloat, CurrNavigator TFloat, PrevNavigator TFloat
             , MobileLimit TFloat, PrevLimit TFloat, DutyLimit TFloat, Overlimit TFloat
             , PrevMonthly TFloat
             , RegionId Integer, RegionName  TVarChar
             , EmployeeId Integer, EmployeeName TVarChar, ItemName TVarChar, isDateOut Boolean, BranchName TVarChar, UnitName TVarChar, PositionName TVarChar
             , PrevEmployeeId Integer, PrevEmployeeName TVarChar, UnitName_prev TVarChar, PositionName_prev TVarChar
             , MobileTariffId Integer, MobileTariffName TVarChar
             , PrevMobileTariffId Integer, PrevMobileTariffName TVarChar
             , isPrev Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbPrevEmployeeId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_MobileBills());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат 
     RETURN QUERY
     
     SELECT
             MovementItem.Id                    AS Id
           , Object_MobileEmployee.Id           AS MobileEmployeeId
           , Object_MobileEmployee.ObjectCode   AS MobileEmployeeCode
           , Object_MobileEmployee.ValueData    AS MobileEmployeeName
           , LEFT (ObjectString_Comment.ValueData, 125) :: TVarChar AS MobileEmployeeComment

           , MovementItem.Amount                AS Amount
           , (CASE WHEN ObjectDesc.Id = zc_Object_Founder() OR ObjectLink_Unit_Contract.ChildObjectId > 0 THEN 0 ELSE COALESCE (MovementItem.Amount, 0) - COALESCE (MIFloat_Overlimit.ValueData, 0) END) :: TFloat AS Amount_ProfitLoss

           , MIFloat_CurrMonthly.ValueData      AS CurrMonthly
           , MIFloat_CurrNavigator.ValueData    AS CurrNavigator

           , MIFloat_PrevNavigator.ValueData    AS PrevNavigator
           , MIFloat_Limit.ValueData            AS MobileLimit
           , MIFloat_PrevLimit.ValueData        AS PrevLimit
           , MIFloat_DutyLimit.ValueData        AS DutyLimit
           , MIFloat_Overlimit.ValueData        AS Overlimit
           , MIFloat_PrevMonthly.ValueData      AS PrevMonthly


           , Object_Region.Id                   AS RegionId
           , Object_Region.ValueData            AS RegionName
           , Object_Employee.Id                 AS EmployeeId
           , Object_Employee.ValueData          AS EmployeeName
           , ObjectDesc.ItemName
           , CASE WHEN COALESCE (ObjectDate_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN FALSE ELSE TRUE END :: Boolean AS isDateOut
           , Object_Branch.ValueData            AS BranchName
           , Object_Unit.ValueData              AS UnitName
           , Object_Position.ValueData          AS PositionName

           , Object_Employee_prev.Id            AS PrevEmployeeId
           , Object_Employee_prev.ValueData     AS PrevEmployeeName
           , Object_Unit_prev.ValueData         AS UnitName_prev
           , Object_Position_prev.ValueData     AS PositionName_prev
           , Object_MobileTariff.Id             AS MobileTariffId
           , Object_MobileTariff.ValueData      AS MobileTariffName
           , Object_PrevMobileTariff.Id         AS PrevMobileTariffId
           , Object_PrevMobileTariff.ValueData  AS PrevMobileTariffName

           , COALESCE (MILinkObject_Employee_prev.ObjectId, 0) <> COALESCE (MILinkObject_Employee_prev.ObjectId, 0) AS isPrev
          
           , MovementItem.isErased              AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_MobileEmployee ON Object_MobileEmployee.Id = MovementItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_MobileEmployee.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_MobileEmployee_Comment()

            LEFT JOIN MovementItemFloat AS MIFloat_CurrMonthly
                                        ON MIFloat_CurrMonthly.MovementItemId = MovementItem.Id
                                       AND MIFloat_CurrMonthly.DescId = zc_MIFloat_CurrMonthly()

            LEFT JOIN MovementItemFloat AS MIFloat_CurrNavigator
                                        ON MIFloat_CurrNavigator.MovementItemId = MovementItem.Id
                                       AND MIFloat_CurrNavigator.DescId = zc_MIFloat_CurrNavigator()

            LEFT JOIN MovementItemFloat AS MIFloat_PrevNavigator
                                        ON MIFloat_PrevNavigator.MovementItemId = MovementItem.Id
                                       AND MIFloat_PrevNavigator.DescId = zc_MIFloat_PrevNavigator()

            LEFT JOIN MovementItemFloat AS MIFloat_Limit
                                        ON MIFloat_Limit.MovementItemId = MovementItem.Id
                                       AND MIFloat_Limit.DescId = zc_MIFloat_Limit()

            LEFT JOIN MovementItemFloat AS MIFloat_PrevLimit
                                        ON MIFloat_PrevLimit.MovementItemId = MovementItem.Id
                                       AND MIFloat_PrevLimit.DescId = zc_MIFloat_PrevLimit()

            LEFT JOIN MovementItemFloat AS MIFloat_DutyLimit
                                        ON MIFloat_DutyLimit.MovementItemId = MovementItem.Id
                                       AND MIFloat_DutyLimit.DescId = zc_MIFloat_DutyLimit()

            LEFT JOIN MovementItemFloat AS MIFloat_Overlimit
                                        ON MIFloat_Overlimit.MovementItemId = MovementItem.Id
                                       AND MIFloat_Overlimit.DescId = zc_MIFloat_Overlimit()

            LEFT JOIN MovementItemFloat AS MIFloat_PrevMonthly
                                        ON MIFloat_PrevMonthly.MovementItemId = MovementItem.Id
                                       AND MIFloat_PrevMonthly.DescId = zc_MIFloat_PrevMonthly()

            -- Сотрудник/Подразделение/Учредитель
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Employee
                                             ON MILinkObject_Employee.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Employee.DescId = zc_MILinkObject_Employee()
            LEFT JOIN Object AS Object_Employee ON Object_Employee.Id = MILinkObject_Employee.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Employee.DescId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Employee_prev
                                             ON MILinkObject_Employee_prev.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Employee_prev.DescId = zc_MILinkObject_PrevEmployee()
            LEFT JOIN Object AS Object_Employee_prev ON Object_Employee_prev.Id = MILinkObject_Employee_prev.ObjectId

            LEFT JOIN ObjectDate AS ObjectDate_DateOut
                                 ON ObjectDate_DateOut.ObjectId = Object_Employee.Id
                                AND ObjectDate_DateOut.DescId   = zc_ObjectDate_Personal_Out()          
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                 ON ObjectLink_Personal_Position.ObjectId = Object_Employee.Id
                                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

            -- нашли Физ лицо
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member ON ObjectLink_Personal_Member.ObjectId = MILinkObject_Employee.ObjectId
                                                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
            -- если у Физ лица установлено - На кого "переносятся" затраты в "Налоги с ЗП" или в "Мобильная связь"
            LEFT JOIN ObjectLink AS ObjectLink_Member_ObjectTo ON ObjectLink_Member_ObjectTo.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                                              AND ObjectLink_Member_ObjectTo.DescId = zc_ObjectLink_Member_ObjectTo()
            LEFT JOIN Object AS Object_ObjectTo ON Object_ObjectTo.Id = ObjectLink_Member_ObjectTo.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = COALESCE (Object_ObjectTo.Id, MILinkObject_Employee.ObjectId)
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract ON ObjectLink_Unit_Contract.ObjectId = CASE -- если На кого "переносятся" затраты = Подразделение
                                                                                                         WHEN Object_ObjectTo.DescId = zc_Object_Unit()
                                                                                                              THEN Object_ObjectTo.Id
                                                                                                         -- если нашли Сотрудника или Телефон привязан к подразделению
                                                                                                         WHEN ObjectLink_Personal_Unit.ChildObjectId > 0 OR Object_Employee.DescId = zc_Object_Unit()
                                                                                                              THEN COALESCE (ObjectLink_Personal_Unit.ChildObjectId, Object_Employee.Id)
                                                                                                         -- иначе захардкодим - Подразделение "Административный"
                                                                                                         ELSE 8383
                                                                                                    END
                                                             AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()


            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id   = ObjectLink_Unit_Branch.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Position_prev
                                 ON ObjectLink_Personal_Position_prev.ObjectId = Object_Employee_prev.Id
                                AND ObjectLink_Personal_Position_prev.DescId = zc_ObjectLink_Personal_Position()
            LEFT JOIN Object AS Object_Position_prev ON Object_Position_prev.Id = ObjectLink_Personal_Position_prev.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit_prev
                                 ON ObjectLink_Personal_Unit_prev.ObjectId = Object_Employee_prev.Id
                                AND ObjectLink_Personal_Unit_prev.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_Unit_prev ON Object_Unit_prev.Id = ObjectLink_Personal_Unit_prev.ChildObjectId


            LEFT JOIN MovementItemLinkObject AS MILinkObject_MobileTariff
                                             ON MILinkObject_MobileTariff.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MobileTariff.DescId = zc_MILinkObject_MobileTariff()
            LEFT JOIN Object AS Object_MobileTariff ON Object_MobileTariff.Id = MILinkObject_MobileTariff.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PrevMobileTariff
                                             ON MILinkObject_PrevMobileTariff.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PrevMobileTariff.DescId = zc_MILinkObject_PrevMobileTariff()
            LEFT JOIN Object AS Object_PrevMobileTariff ON Object_PrevMobileTariff.Id = MILinkObject_PrevMobileTariff.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Region
                                 ON ObjectLink_MobileEmployee_Region.ObjectId = Object_MobileEmployee.Id 
                                AND ObjectLink_MobileEmployee_Region.DescId = zc_ObjectLink_MobileEmployee_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_MobileEmployee_Region.ChildObjectId
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.09.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_MobileBills (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_MobileBills (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')

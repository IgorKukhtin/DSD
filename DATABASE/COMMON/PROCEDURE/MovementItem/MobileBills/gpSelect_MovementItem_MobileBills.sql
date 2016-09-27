-- Function: gpSelect_MovementItem_MobileBills()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileBills (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileBills (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileBills(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , PrevMobileTariffDate TDateTime
             , Amount TFloat, Count TFloat, CurrNavigator TFloat
             , PrevMobileTariff TVarChar, RegionId Integer, RegionName  TVarChar
             , EmployeeId Integer, EmployeeName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , PrevEmployeeId Integer, PrevEmployeeName TVarChar
             , MobileTariffId Integer, MobileTariffName TVarChar
             , PrevMobileTariffId Integer, PrevMobileTariffName TVarChar, PrevMobileTariffOperDate TDateTime
             , Price TFloat, MobileTariffName_Partion TVarChar
             , AmountRemains TFloat
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


     -- определяется
     vbPrevEmployeeId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From());
     IF vbPrevEmployeeId IN (SELECT lfSelect_Object_PrevEmployee_byGroup.PrevEmployeeId FROM lfSelect_Object_PrevEmployee_byGroup (8433) AS lfSelect_Object_PrevEmployee_byGroup) -- Производство
     THEN vbPrevEmployeeId:= NULL;
     END IF;


     -- Результат 
     RETURN QUERY
     
     SELECT
             MovementItem.Id                             AS Id
           , Object_MobileEmployee.Id                    AS MobileEmployeeId
           , Object_MobileEmployee.ObjectCode            AS MobileEmployeeCode
           , Object_MobileEmployee.ValueData             AS MobileEmployeeName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                AS Amount
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
           , Object_PrevEmployee.Id             AS PrevEmployeeId
           , Object_PrevEmployee.ValueData      AS PrevEmployeeName
           , Object_MobileTariff.Id             AS MobileTariffId
           , Object_MobileTariff.ValueData      AS MobileTariffName
           , Object_PrevMobileTariff.Id         AS PrevMobileTariffId
           , Object_PrevMobileTariff.ValueData  AS PrevMobileTariffName
          
           , MovementItem.isErased              AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_MobileEmployee ON Object_MobileEmployee.Id = MovementItem.ObjectId

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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Region
                                             ON MILinkObject_Region.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Region.DescId = zc_MILinkObject_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = MILinkObject_Region.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Employee
                                             ON MILinkObject_Employee.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Employee.DescId = zc_MILinkObject_Employee()
            LEFT JOIN Object AS Object_Employee ON Object_Employee.Id = MILinkObject_Employee.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PrevEmployee
                                             ON MILinkObject_PrevEmployee.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PrevEmployee.DescId = zc_MILinkObject_PrevEmployee()
            LEFT JOIN Object AS Object_PrevEmployee ON Object_PrevEmployee.Id = MILinkObject_PrevEmployee.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MobileTariff
                                             ON MILinkObject_MobileTariff.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MobileTariff.DescId = zc_MILinkObject_MobileTariff()
            LEFT JOIN Object AS Object_MobileTariff ON Object_MobileTariff.Id = MILinkObject_MobileTariff.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PrevMobileTariff
                                             ON MILinkObject_PrevMobileTariff.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PrevMobileTariff.DescId = zc_MILinkObject_PrevMobileTariff()
            LEFT JOIN Object AS Object_PrevMobileTariff ON Object_PrevMobileTariff.Id = MILinkObject_PrevMobileTariff.ObjectId
    
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_MobileBills (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.09.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_MobileBills (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_MobileBills (inMovementId:= 25173, inIsErased:= TRUE, inSession:= '2')

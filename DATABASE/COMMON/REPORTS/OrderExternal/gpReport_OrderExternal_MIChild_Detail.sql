-- Function: Report_OrderExternal_MIChild_Detail()

DROP FUNCTION IF EXISTS Report_OrderExternal_MIChild_Detail (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS Report_OrderExternal_MIChild_Detail (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION Report_OrderExternal_MIChild_Detail(
    IN inOperDate                TDateTime , -- Дата документа
    IN inToId                    Integer   , -- Кому (в документе)
    IN inGoodsId                 Integer   , -- товар
    IN inGoodsKindId             Integer   , -- товар
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDate_CarInfo TDateTime
             , InvNumberPartner TVarChar, InvNumber_calc TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , RouteId Integer, RouteName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagId Integer, ContractTagName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , Remains_Weight TFloat
             , AmountWeight_child_one TFloat, AmountWeight_child_sec TFloat, AmountWeight_child TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat, TotalCountSecond TFloat
             , JuridicalId Integer, JuridicalName TVarChar
             , Comment TVarChar
             , DayOfWeekName          TVarChar
             , DayOfWeekName_Partner  TVarChar
             , DayOfWeekName_CarInfo  TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , MeasureName TVarChar
             , GoodsGroupNameFull TVarChar
              )
AS               
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inOperDate, inOperDate, NULL, NULL, NULL, vbUserId);


     RETURN QUERY
     WITH 
          --документы заказов резерв для выбранного товара
          tmpMov AS (SELECT Movement.*
                          , MovementLinkObject_To.ObjectId AS ToId 
                          , MI_Master.Id                   AS MI_Id
                          , MI_Master.ObjectId             AS GoodsId
                          , MI_Child.Id                    AS MI_Id_child
                          , MI_Child.ObjectId              AS GoodsId_child
                          , MI_Child.Amount                AS Amount_child

                     FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                      AND COALESCE (MovementLinkObject_To.ObjectId,0) = inToId 

                         INNER JOIN MovementItem AS MI_Master
                                                 ON MI_Master.MovementId = Movement.Id
                                                AND MI_Master.DescId     = zc_MI_Master()
                                                AND MI_Master.isErased   = FALSE 
                                                AND MI_Master.ObjectId = inGoodsId

                         INNER JOIN MovementItem AS MI_Child
                                                 ON MI_Child.MovementId = Movement.Id
                                                AND MI_Child.ParentId = MI_Master.Id
                                                AND MI_Child.DescId     = zc_MI_Child()
                                                AND MI_Child.isErased   = FALSE 

 
                     WHERE Movement.OperDate BETWEEN inOperDate AND inOperDate + INTERVAL '31 DAY'
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND Movement.DescId = zc_Movement_OrderExternal()
                     )

     , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                     FROM MovementItemLinkObject
                                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMov.MI_Id FROM tmpMov)
                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                    )

     , tmpMIFloat_Child AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMov.MI_Id_child FROM tmpMov)
                              AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                           )

     , tmpMovement AS (SELECT Movement.Id
                            , Movement.OperDate
                            , Movement.InvNumber
                            , Movement.StatusId
                            , Movement.ToId
                            , Movement.GoodsId
                            , MovementLinkObject_From.ObjectId           AS FromId
                            , MovementLinkObject_Route.ObjectId          AS RouteId
                            , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                                
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId

                            , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) = 0 THEN Movement.Amount_child * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS AmountWeight_child_one
                            , SUM (CASE WHEN COALESCE (MIFloat_MovementId.ValueData, 0) > 0 THEN Movement.Amount_child * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END ELSE 0 END) AS AmountWeight_child_sec
                            , SUM (Movement.Amount_child * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight_child

                       FROM tmpMov AS Movement
                           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                        ON MovementLinkObject_Route.MovementId = Movement.Id
                                                       AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                           LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = Movement.MI_Id
                                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN tmpMIFloat_Child AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = Movement.MI_Id_child
                                                     AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = Movement.GoodsId_child
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = Movement.GoodsId_child
                                                AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                       WHERE COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) = inGoodsKindId OR inGoodsKindId = 0
                       GROUP BY Movement.Id
                              , Movement.OperDate
                              , Movement.InvNumber
                              , Movement.StatusId
                              , Movement.ToId
                              , MovementLinkObject_From.ObjectId
                              , MovementLinkObject_Route.ObjectId
                              , ObjectLink_Juridical_Retail.ChildObjectId
                              , Movement.GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())
                      )

        , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                            , zc_MovementFloat_TotalCountSh()
                                                            , zc_MovementFloat_TotalCountKg()
                                                            , zc_MovementFloat_TotalCountSecond()

                                                            )
                              )

        , tmpMovementString AS (SELECT MovementString.*
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                              , zc_MovementString_Comment()
                                                              )
                              )

        , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                    FROM MovementLinkObject
                                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                      AND MovementLinkObject.DescId IN (zc_MovementLinkObject_PaidKind()
                                                                      , zc_MovementLinkObject_Contract()
                                                                       )
                                   )

        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                          , zc_MovementDate_CarInfo()
                                                            )
                            )

        , tmpContract_InvNumber_View AS (SELECT View_Contract_InvNumber.*
                                         FROM Object_Contract_InvNumber_View AS View_Contract_InvNumber
                                         WHERE View_Contract_InvNumber.ContractId IN (SELECT DISTINCT tmpMovementLinkObject.ObjectId FROM tmpMovementLinkObject WHERE tmpMovementLinkObject.DescId = zc_MovementLinkObject_Contract())
                                         )
        , tmpInfoMoney_View AS (SELECT View_InfoMoney.*
                                FROM Object_InfoMoney_View AS View_InfoMoney
                                WHERE View_InfoMoney.InfoMoneyId IN (SELECT DISTINCT tmpContract_InvNumber_View.InfoMoneyId FROM tmpContract_InvNumber_View)
                                )


     , tmpRemains AS (WITH
                      tmpContainer AS (SELECT Container.Id       AS ContainerId
                                            , CLO_Unit.ObjectId  AS ToId
                                            , Container.ObjectId AS GoodsId
                                            , Container.Amount
                                       FROM Container
                                            INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                           ON CLO_Unit.ContainerId = Container.Id
                                                                          AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                          AND CLO_Unit.ObjectId = inToId
                                            LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                          ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                                         AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                       WHERE Container.ObjectId = inGoodsId
                                         AND Container.DescId = zc_Container_Count()
                                         AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!! 
                                       )
                    , tmpCLO_GoodsKind AS (SELECT CLO_GoodsKind.*
                                           FROM ContainerLinkObject AS CLO_GoodsKind
                                           WHERE CLO_GoodsKind.ContainerId IN (SELECT DISTINCT tmpContainer.ContainerId FROM tmpContainer)
                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                           )
                     SELECT tmpContainer.ToId
                          , tmpContainer.GoodsId
                          , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Amount --на начало дня
                          , (tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS Amount_Weight
                          , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpContainer.Amount - SUM (COALESCE (MIContainer.Amount, 0)) ELSE 0 END ) AS Amount_Sh
                     FROM tmpContainer
                          LEFT JOIN tmpCLO_GoodsKind AS CLO_GoodsKind
                                                     ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                    AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                         AND MIContainer.OperDate >= inOperDate
                          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpContainer.GoodsId
                                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                ON ObjectFloat_Weight.ObjectId = tmpContainer.GoodsId
                                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     WHERE COALESCE (CLO_GoodsKind.ObjectId, zc_GoodsKind_Basis()) = inGoodsKindId OR inGoodsKindId = 0
                     GROUP BY tmpContainer.GoodsId
                            , COALESCE (CLO_GoodsKind.ObjectId, 0)
                            , tmpContainer.Amount
                            , tmpContainer.ToId
                            , ObjectFloat_Weight.ValueData
                            , ObjectLink_Goods_Measure.ChildObjectId
                     HAVING SUM (COALESCE (tmpContainer.Amount,0)) > 0
                     )

       SELECT 0 AS Id
             , '' ::TVarChar    AS InvNumber 
           , Null ::TDateTime   AS OperDate
           , 0                  AS StatusCode
           , '' ::TVarChar      AS StatusName
           , Null ::TDateTime   AS OperDatePartner
           , Null ::TDateTime   AS OperDate_CarInfo
           , '' ::TVarChar      AS InvNumberPartner
           , '' ::TVarChar      AS InvNumber_calc

           , 0                     AS FromId
           , '' ::TVarChar         AS FromName
           , Object_To.Id          AS ToId
           , Object_To.ValueData   AS ToName
           , 0                     AS RouteId
           , '' ::TVarChar         AS RouteName
           , 0                     AS RetailId
           , '' ::TVarChar         AS RetailName
           , 0                     AS PaidKindId
           , '' ::TVarChar         AS PaidKindName
           , 0                     AS ContractId
           , 0                     AS ContractCode
           , '' ::TVarChar         AS ContractName
           , 0                     AS ContractTagId
           , '' ::TVarChar         AS ContractTagName
           , '' ::TVarChar         AS InfoMoneyGroupName
           , '' ::TVarChar         AS InfoMoneyDestinationName
           , 0                     AS InfoMoneyCode
           , '' ::TVarChar         AS InfoMoneyName  
           
           , tmpRemains.Amount_Weight ::TFloat AS Remains_Weight

           , 0 :: TFloat AS AmountWeight_child_one
           , 0 :: TFloat AS AmountWeight_child_sec
           , 0 :: TFloat AS AmountWeight_child

            --итого по документу  информационно
           , 0 :: TFloat      AS TotalCountKg
           , 0 :: TFloat      AS TotalCountSh
           , 0 :: TFloat      AS TotalCount
           , 0 :: TFloat      AS TotalCountSecond

           , 0                AS JuridicalId
           , '' ::TVarChar    AS JuridicalName

           , '' ::TVarChar    AS Comment

           , '' ::TVarChar AS DayOfWeekName
           , '' ::TVarChar AS DayOfWeekName_Partner
           , '' ::TVarChar AS DayOfWeekName_CarInfo 

           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

       FROM tmpRemains
       LEFT JOIN Object AS Object_To ON Object_To.Id = inToId 

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpRemains.GoodsId
       LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpRemains.GoodsKindId  

       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                            ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
       LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                              ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                             AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()


     UNION
       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementDate_CarInfo.ValueData                 AS OperDate_CarInfo
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           , CASE WHEN MovementString_InvNumberPartner.ValueData <> '' THEN MovementString_InvNumberPartner.ValueData ELSE '***' || Movement.InvNumber END :: TVarChar AS InvNumber_calc

           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , Object_Route.Id                                AS RouteId
           , Object_Route.ValueData                         AS RouteName
           , Object_Retail.Id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagId          AS ContractTagId
           , View_Contract_InvNumber.ContractTagName        AS ContractTagName
           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

           , 0                               ::TFloat AS Remains_Weight
           , Movement.AmountWeight_child_one ::TFloat AS AmountWeight_child_one
           , Movement.AmountWeight_child_sec ::TFloat AS AmountWeight_child_sec
           , Movement.AmountWeight_child     ::TFloat AS AmountWeight_child    

            --итого по документу  информационно
           , MovementFloat_TotalCountKg.ValueData     ::TFloat AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData     ::TFloat AS TotalCountSh
           , MovementFloat_TotalCount.ValueData       ::TFloat AS TotalCount
           , MovementFloat_TotalCountSecond.ValueData ::TFloat AS TotalCountSecond

           , Object_Juridical.Id             AS JuridicalId
           , Object_Juridical.ValueData      AS JuridicalName

           , MovementString_Comment.ValueData       AS Comment

           , tmpWeekDay.DayOfWeekName         ::TVarChar AS DayOfWeekName
           , tmpWeekDay_Partner.DayOfWeekName ::TVarChar AS DayOfWeekName_Partner
           , tmpWeekDay_CarInfo.DayOfWeekName ::TVarChar AS DayOfWeekName_CarInfo

           , Object_Goods.Id                            AS GoodsId
           , Object_Goods.ObjectCode                    AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , Object_GoodsKind.ValueData                 AS GoodsKindName
           , Object_Measure.ValueData                   AS MeasureName
           , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Object AS Object_To ON Object_To.Id = Movement.ToId 
            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = Movement.RouteId
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = Movement.RetailId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Movement.GoodsKindId  

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
 
            LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                   ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                 
            LEFT JOIN tmpMovementDate AS MovementDate_CarInfo
                                      ON MovementDate_CarInfo.MovementId =  Movement.Id
                                     AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                            ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                           AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
                                            ON MovementLinkObject_Contract.MovementId = Movement.Id
                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN tmpContract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN tmpInfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId
 
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                       ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id                                            
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSecond
                                       ON MovementFloat_TotalCountSecond.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountSecond.DescId = zc_MovementFloat_TotalCountSecond()

            LEFT JOIN ObjectLink AS ObjectLink_From_Juridical
                                 ON ObjectLink_From_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_From_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_From_Juridical.ChildObjectId

            LEFT JOIN zfCalc_DayOfWeekName (Movement.OperDate) AS tmpWeekDay ON 1=1
            LEFT JOIN zfCalc_DayOfWeekName (MovementDate_OperDatePartner.ValueData) AS tmpWeekDay_Partner ON 1=1
            LEFT JOIN zfCalc_DayOfWeekName (MovementDate_CarInfo.ValueData) AS tmpWeekDay_CarInfo ON 1=1
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.07.22         *
*/

-- тест
-- SELECT * FROM Report_OrderExternal_MIChild_Detail(inOperDate := ('29.06.2022')::TDateTime , inToId := 8459 , inGoodsId := 2156 ,  inSession := '5');
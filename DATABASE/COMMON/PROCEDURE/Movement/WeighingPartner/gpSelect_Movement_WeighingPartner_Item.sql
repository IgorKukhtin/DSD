-- Function: gpSelect_Movement_WeighingPartner_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner_Item (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingPartner_Item(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar, OperDate_TransportGoods TDateTime
             , MovementId_Tax Integer, InvNumberPartner_Tax TVarChar, OperDate_Tax TDateTime
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , InvNumberOrder TVarChar
             , InvNumberTransport Integer
             , PriceWithVAT Boolean
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteSortingName TVarChar
             , PersonalCode1 Integer, PersonalName1 TVarChar
             , PersonalCode2 Integer, PersonalName2 TVarChar
             , PersonalCode3 Integer, PersonalName3 TVarChar
             , PersonalCode4 Integer, PersonalName4 TVarChar
             , PositionCode1 Integer, PositionName1 TVarChar
             , PositionCode2 Integer, PositionName2 TVarChar
             , PositionCode3 Integer, PositionName3 TVarChar
             , PositionCode4 Integer, PositionName4 TVarChar
             , UserName TVarChar

             , GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar
             , MIAmount TFloat,  AmountPartner TFloat
             , RealWeight TFloat,CountTare TFloat, WeightTare TFloat
             , HeadCount TFloat, BoxCount TFloat, BoxNumber TFloat
             , LevelNumber TFloat, ChangePercentAmount TFloat
             , Price TFloat, CountForPrice TFloat
             , PartionGoodsDate  TDateTime
             , InsertDate TDateTime, UpdateDate TDateTime
             , GoodsKindName TVarChar
             , MeasureName TVarChar, BoxName TVarChar
             , PriceListName TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     /*WITH tmpUserAdmin AS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND NOT EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT tmpUserAdmin.UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )*/
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , Movement_Parent.Id                AS MovementId_parent
             , Movement_Parent.OperDate          AS OperDate_parent
             , CASE WHEN Movement_Parent.StatusId = zc_Enum_Status_Complete() THEN Movement_Parent.InvNumber ELSE '' END :: TVarChar AS InvNumber_parent

             , Movement_TransportGoods.Id            AS MovementId_TransportGoods
             , Movement_TransportGoods.InvNumber     AS InvNumber_TransportGoods
             , Movement_TransportGoods.OperDate      AS OperDate_TransportGoods

             , Movement_Tax.Id                       AS MovementId_Tax
             , CASE WHEN Movement_Tax.StatusId = zc_Enum_Status_Complete() THEN MS_InvNumberPartner_Tax.ValueData ELSE '' END :: TVarChar AS InvNumberPartner_Tax
             , Movement_Tax.OperDate                 AS OperDate_Tax

             , MovementDate_StartWeighing.ValueData  AS StartWeighing  
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.ItemName                      AS MovementDescName
             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
             , MovementFloat_InvNumberTransport.ValueData :: Integer AS InvNumberTransport

             , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData             AS VATPercent
             , MovementFloat_ChangePercent.ValueData          AS ChangePercent
             , MovementFloat_TotalCount.ValueData             AS TotalCount
             , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
             , MovementFloat_TotalCountTare.ValueData         AS TotalCountTare
             , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
             , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
             , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
             , MovementFloat_TotalSumm.ValueData              AS TotalSumm

             , Object_From.ValueData              AS FromName
             , Object_To.ValueData                AS ToName

             , Object_PaidKind.ValueData          AS PaidKindName
             , View_Contract_InvNumber.InvNumber  AS ContractName
             , View_Contract_InvNumber.ContractTagName

             , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
             , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
             , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
             , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

             , Object_RouteSorting.ValueData      AS RouteSortingName

             , Object_Personal1.ObjectCode AS PersonalCode1, Object_Personal1.ValueData AS PersonalName1
             , Object_Personal2.ObjectCode AS PersonalCode2, Object_Personal2.ValueData AS PersonalName2
             , Object_Personal3.ObjectCode AS PersonalCode3, Object_Personal3.ValueData AS PersonalName3
             , Object_Personal4.ObjectCode AS PersonalCode4, Object_Personal4.ValueData AS PersonalName4

             , Object_Position1.ObjectCode AS PositionCode1, Object_Position1.ValueData AS PositionName1
             , Object_Position2.ObjectCode AS PositionCode2, Object_Position2.ValueData AS PositionName2
             , Object_Position3.ObjectCode AS PositionCode3, Object_Position3.ValueData AS PositionName3
             , Object_Position4.ObjectCode AS PositionCode4, Object_Position4.ValueData AS PositionName4

             , Object_User.ValueData              AS UserName


                  , Object_Goods.ObjectCode          AS GoodsCode
                  , Object_Goods.ValueData           AS GoodsName
                  , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

                  , MovementItem.Amount as MIAmount
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0)::TFloat AS AmountPartner

                  , COALESCE (MIFloat_RealWeight.ValueData, 0)   ::TFloat       AS RealWeight
                  , COALESCE (MIFloat_CountTare.ValueData, 0) ::TFloat          AS CountTare
                  , COALESCE (MIFloat_WeightTare.ValueData, 0)::TFloat          AS WeightTare

                  , COALESCE (MIFloat_HeadCount.ValueData, 0)::TFloat           AS HeadCount
                  , COALESCE (MIFloat_BoxCount.ValueData, 0)::TFloat            AS BoxCount
      
                  , COALESCE (MIFloat_BoxNumber.ValueData, 0)::TFloat  AS BoxNumber
                  , COALESCE (MIFloat_LevelNumber.ValueData, 0)::TFloat AS LevelNumber

                  , COALESCE (MIFloat_ChangePercentAmount.ValueData, 0)::TFloat AS ChangePercentAmount
                  , COALESCE (MIFloat_Price.ValueData, 0) ::TFloat		  AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) ::TFloat	  AS CountForPrice
           
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()):: TDateTime AS PartionGoodsDate

           
                  , COALESCE (MIDate_Insert.ValueData, zc_DateStart()):: TDateTime   AS InsertDate
                  , COALESCE (MIDate_Update.ValueData, zc_DateStart()):: TDateTime   AS UpdateDate
                  , Object_GoodsKind.ValueData      AS GoodsKindName
                  , Object_Measure.ValueData        AS MeasureName
                  , COALESCE (Object_Box.ValueData, '')::TVarChar              AS BoxName
                  , COALESCE (Object_PriceList.ValueData , '')::TVarChar       AS PriceListName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_WeighingPartner()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement_Parent.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                                  
            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData -- COALESCE (Movement_Parent.DescId, MovementFloat_MovementDesc.ValueData)

            LEFT JOIN MovementFloat AS MovementFloat_InvNumberTransport
                                    ON MovementFloat_InvNumberTransport.MovementId =  Movement.Id
                                   AND MovementFloat_InvNumberTransport.DescId = zc_MovementFloat_InvNumberTransport()
            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId =  Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal1
                                         ON MovementLinkObject_Personal1.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal1.DescId = zc_MovementLinkObject_PersonalComplete1()
            LEFT JOIN Object AS Object_Personal1 ON Object_Personal1.Id = MovementLinkObject_Personal1.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal2
                                         ON MovementLinkObject_Personal2.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal2.DescId = zc_MovementLinkObject_PersonalComplete2()
            LEFT JOIN Object AS Object_Personal2 ON Object_Personal2.Id = MovementLinkObject_Personal2.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal3
                                         ON MovementLinkObject_Personal3.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal3.DescId = zc_MovementLinkObject_PersonalComplete3()
            LEFT JOIN Object AS Object_Personal3 ON Object_Personal3.Id = MovementLinkObject_Personal3.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal4
                                         ON MovementLinkObject_Personal4.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal4.DescId = zc_MovementLinkObject_PersonalComplete4()
            LEFT JOIN Object AS Object_Personal4 ON Object_Personal4.Id = MovementLinkObject_Personal4.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position1
                                         ON MovementLinkObject_Position1.MovementId = Movement.Id
                                        AND MovementLinkObject_Position1.DescId = zc_MovementLinkObject_PositionComplete1()
            LEFT JOIN Object AS Object_Position1 ON Object_Position1.Id = MovementLinkObject_Position1.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position2
                                         ON MovementLinkObject_Position2.MovementId = Movement.Id
                                        AND MovementLinkObject_Position2.DescId = zc_MovementLinkObject_PositionComplete2()
            LEFT JOIN Object AS Object_Position2 ON Object_Position2.Id = MovementLinkObject_Position2.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position3
                                         ON MovementLinkObject_Position3.MovementId = Movement.Id
                                        AND MovementLinkObject_Position3.DescId = zc_MovementLinkObject_PositionComplete3()
            LEFT JOIN Object AS Object_Position3 ON Object_Position3.Id = MovementLinkObject_Position3.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position4
                                         ON MovementLinkObject_Position4.MovementId = Movement.Id
                                        AND MovementLinkObject_Position4.DescId = zc_MovementLinkObject_PositionComplete4()
            LEFT JOIN Object AS Object_Position4 ON Object_Position4.Id = MovementLinkObject_Position4.ObjectId


            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementId = Movement.ParentId
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_Tax ON MS_InvNumberPartner_Tax.MovementId = MovementLinkMovement_Tax.MovementChildId
                                                               AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()
            --- строки

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = False

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                             ON MIDate_Insert.MovementItemId = MovementItem.Id
                                            AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                             ON MIDate_Update.MovementItemId = MovementItem.Id
                                            AND MIDate_Update.DescId = zc_MIDate_Update()
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                                                 
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_RealWeight
                                              ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                             AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare
                                              ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare
                                              ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                             AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                              ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                              ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
            LEFT JOIN MovementItemFloat AS MIFloat_BoxNumber
                                              ON MIFloat_BoxNumber.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
            LEFT JOIN MovementItemFloat AS MIFloat_LevelNumber
                                              ON MIFloat_LevelNumber.MovementItemId = MovementItem.Id
                                             AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                             AND MIFloat_Price.ValueData <> 0 -- !!!временно!!!

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                   ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Box.DescId = zc_MILinkObject_Box()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PriceList
                                                   ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = MILinkObject_Box.ObjectId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MILinkObject_PriceList.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_WeighingPartner_Item (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.06.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_WeighingPartner_Item (inStartDate:= '01.05.2015', inEndDate:= '01.05.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
--select * from gpSelect_Movement_WeighingPartner_Item(inStartDate := ('01.06.2015')::TDateTime , inEndDate := ('01.06.2015')::TDateTime , inIsErased := 'False' ,  inSession := '5');
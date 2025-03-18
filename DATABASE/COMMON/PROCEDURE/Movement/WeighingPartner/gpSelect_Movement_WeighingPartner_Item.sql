-- Function: gpSelect_Movement_WeighingPartner_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner_Item (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingPartner_Item(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inJuridicalBasisId   Integer ,
    IN inIsErased           Boolean ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumberPartner TVarChar, OperDate TDateTime, OperDatePartner TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar, OperDate_TransportGoods TDateTime
             , MovementId_Tax Integer, InvNumberPartner_Tax TVarChar, OperDate_Tax TDateTime
             , StartWeighing TDateTime, EndWeighing TDateTime
             , MovementDescNumber Integer, MovementDescName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar, UnitName_PersonalGroup TVarChar
             , WeighingNumber TFloat
             , InvNumberOrder TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , isList Boolean
             , PriceWithVAT Boolean
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteSortingName TVarChar, RouteGroupName TVarChar, RouteName TVarChar
             , PersonalCode1 Integer, PersonalName1 TVarChar
             , PersonalCode2 Integer, PersonalName2 TVarChar
             , PersonalCode3 Integer, PersonalName3 TVarChar
             , PersonalCode4 Integer, PersonalName4 TVarChar
             , PersonalCode5 Integer, PersonalName5 TVarChar
             , PositionCode1 Integer, PositionName1 TVarChar
             , PositionCode2 Integer, PositionName2 TVarChar
             , PositionCode3 Integer, PositionName3 TVarChar
             , PositionCode4 Integer, PositionName4 TVarChar
             , PositionCode5 Integer, PositionName5 TVarChar
             , PersonalCode1_Stick Integer, PersonalName1_Stick TVarChar
             , PositionCode1_Stick Integer, PositionName1_Stick TVarChar
             , UserName TVarChar
             , Comment TVarChar
             , IP TVarChar
             , MovementId_ReturnIn Integer, InvNumber_ReturnInFull TVarChar
             , StartBegin_movement TDateTime, EndBegin_movement TDateTime, diffBegin_sec_movement TFloat -- для документа
             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat                            -- для строк
             , GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar
             , MIAmount TFloat,  AmountPartner TFloat
             , MIAmount_Weight TFloat, AmountPartner_Weight TFloat
             , RealWeight TFloat, RealWeight_Weight TFloat, CountTare TFloat, WeightTare TFloat
             , CountTare1   TFloat, CountTare2   TFloat, CountTare3   TFloat, CountTare4   TFloat, CountTare5   TFloat, CountTare6   TFloat
             , WeightTare1  TFloat, WeightTare2  TFloat, WeightTare3  TFloat, WeightTare4  TFloat, WeightTare5  TFloat, WeightTare6  TFloat
             , CountPack TFloat, WeightPack TFloat
             , HeadCount TFloat, BoxCount TFloat, BoxNumber TFloat
             , LevelNumber TFloat, ChangePercentAmount TFloat, ChangePercent_mi TFloat
             , Price TFloat, CountForPrice TFloat
             , PartionGoodsDate  TDateTime
             , InsertDate TDateTime, UpdateDate TDateTime
             , GoodsKindName TVarChar
             , MeasureName TVarChar, BoxName TVarChar
             , PriceListName TVarChar
             , isBarCode Boolean
             , MovementPromo TVarChar
             , isErased Boolean
             , Count_Doc  Integer
             , Count_Item Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
       WITH _tmpGoods AS -- (GoodsId Integer) ON COMMIT DROP;
             (SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
              WHERE inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
             UNION
              SELECT inGoodsId WHERE inGoodsId > 0
             UNION
              SELECT Object.Id FROM Object
              WHERE Object.DescId = zc_Object_Goods() AND (inStartDate + INTERVAL '3 DAY') >= inEndDate
                AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
             UNION
              SELECT Object.Id FROM Object
              WHERE Object.DescId = zc_Object_Goods() AND inIsErased = TRUE
                AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
             )
          , tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               INNER JOIN Movement ON Movement.DescId = zc_Movement_WeighingPartner()
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                  AND Movement.StatusId = tmpStatus.StatusId
                             --  INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                         )
        , tmpMI AS (SELECT *
                    FROM (SELECT MovementItem.*
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.MovementId ORDER BY MovementItem.Id) AS Ord
                               , COUNT(MovementItem.MovementId) OVER (PARTITION BY MovementItem.MovementId) AS Count
                          FROM MovementItem
                               INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                          WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND (MovementItem.isErased  = inIsErased
                             OR inGoodsGroupId <> 0
                             OR inGoodsId <> 0
                             OR (inStartDate + INTERVAL '3 DAY') >= inEndDate
                                )
                          ) AS tt
                    WHERE tt.Ord = 1
                    )


       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)        AS InvNumber
             , MovementString_InvNumberPartner.ValueData ::TVarChar AS InvNumberPartner
             , Movement.OperDate 
             , MovementDate_OperDatePartner.ValueData ::TDateTime AS OperDatePartner

             , CASE WHEN MovementBoolean_DocPartner.ValueData = FALSE AND zc_Movement_Income() = MovementFloat_MovementDesc.ValueData :: Integer
                    THEN 4
                    ELSE Object_Status.ObjectCode
               END :: Integer AS StatusCode

             , CASE WHEN MovementBoolean_DocPartner.ValueData = FALSE AND zc_Movement_Income() = MovementFloat_MovementDesc.ValueData :: Integer
                    THEN 'Не проведен'
                    ELSE Object_Status.ValueData
               END :: TVarChar AS StatusName

             , Movement_Parent.Id                AS MovementId_parent
             , Movement_Parent.OperDate          AS OperDate_parent

             , zfCalc_InvNumber_isErased_sh (Movement_Parent.InvNumber, Movement_Parent.StatusId) AS InvNumber_parent

             , Movement_TransportGoods.Id            AS MovementId_TransportGoods
             , Movement_TransportGoods.InvNumber     AS InvNumber_TransportGoods
             , Movement_TransportGoods.OperDate      AS OperDate_TransportGoods

             , Movement_Tax.Id                       AS MovementId_Tax
             , CASE WHEN Movement_Tax.StatusId = zc_Enum_Status_Complete() AND MS_InvNumberPartner_Tax.ValueData <> ''
                         THEN MS_InvNumberPartner_Tax.ValueData
                    WHEN Movement_Tax.StatusId = zc_Enum_Status_Complete()
                         THEN '_' || Movement_Tax.InvNumber
                    WHEN Movement_Tax.StatusId = zc_Enum_Status_UnComplete()
                         THEN '***' || Movement_Tax.InvNumber
                    WHEN Movement_Tax.StatusId = zc_Enum_Status_Erased()
                         THEN '*' || Movement_Tax.InvNumber
                    ELSE ''
               END :: TVarChar AS InvNumberPartner_Tax
             , Movement_Tax.OperDate                 AS OperDate_Tax

             , MovementDate_StartWeighing.ValueData  AS StartWeighing
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber
             , MovementDesc.ItemName                      AS MovementDescName

             , Object_SubjectDoc.Id                       AS SubjectDocId
             , Object_SubjectDoc.ValueData                AS SubjectDocName

             , Object_PersonalGroup.Id                    AS PersonalGroupId
             , Object_PersonalGroup.ValueData             AS PersonalGroupName
             , Object_Unit_PersonalGroup.ValueData        AS UnitName_PersonalGroup

             , MovementFloat_WeighingNumber.ValueData     AS WeighingNumber

             , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder

             , Movement_Transport.Id                     AS MovementId_Transport
             , Movement_Transport.InvNumber              AS InvNumber_Transport
             , Movement_Transport.OperDate               AS OperDate_Transport
             , Object_Car.ValueData                      AS CarName
             , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
             , COALESCE(Object_Member.ValueData, View_PersonalDriver.PersonalName) AS PersonalDriverName

             
             , COALESCE (MovementBoolean_List.ValueData,False) :: Boolean AS isList
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
             , Object_RouteGroup.ValueData        AS RouteGroupName
             , Object_Route.ValueData             AS RouteName

             , Object_Personal1.ObjectCode AS PersonalCode1, Object_Personal1.ValueData AS PersonalName1
             , Object_Personal2.ObjectCode AS PersonalCode2, Object_Personal2.ValueData AS PersonalName2
             , Object_Personal3.ObjectCode AS PersonalCode3, Object_Personal3.ValueData AS PersonalName3
             , Object_Personal4.ObjectCode AS PersonalCode4, Object_Personal4.ValueData AS PersonalName4
             , Object_Personal5.ObjectCode AS PersonalCode5, Object_Personal5.ValueData AS PersonalName5

             , Object_Position1.ObjectCode AS PositionCode1, Object_Position1.ValueData AS PositionName1
             , Object_Position2.ObjectCode AS PositionCode2, Object_Position2.ValueData AS PositionName2
             , Object_Position3.ObjectCode AS PositionCode3, Object_Position3.ValueData AS PositionName3
             , Object_Position4.ObjectCode AS PositionCode4, Object_Position4.ValueData AS PositionName4
             , Object_Position5.ObjectCode AS PositionCode5, Object_Position5.ValueData AS PositionName5

             , Object_Personal1_Stick.ObjectCode AS PersonalCode1_Stick, Object_Personal1_Stick.ValueData AS PersonalName1_Stick
             , Object_Position1_Stick.ObjectCode AS PositionCode1_Stick, Object_Position1_Stick.ValueData AS PositionName1_Stick

             , Object_User.ValueData              AS UserName
             , MovementString_Comment.ValueData   AS Comment
             , MovementString_IP.ValueData        AS IP
             
             , Movement_ReturnIn.Id                                                                                                AS MovementId_ReturnIn
             , zfCalc_InvNumber_isErased ('', Movement_ReturnIn.InvNumber, Movement_ReturnIn.OperDate, Movement_ReturnIn.StatusId) AS InvNumber_ReturnInFull

             , MovementDate_StartBegin.ValueData  AS StartBegin_movement
             , MovementDate_EndBegin.ValueData    AS EndBegin_movement
             , CASE WHEN tmpMI.Ord = 1 then EXTRACT (EPOCH FROM (COALESCE (MovementDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MovementDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) 
              else 0 END :: TFloat AS diffBegin_sec_movement

             , MIDate_StartBegin.ValueData  AS StartBegin
             , MIDate_EndBegin.ValueData    AS EndBegin
             , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec

             , Object_Goods.ObjectCode          AS GoodsCode
             , Object_Goods.ValueData           AS GoodsName
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

             , MovementItem.Amount AS MIAmount
             , COALESCE (MIFloat_AmountPartner.ValueData, 0)::TFloat AS AmountPartner
             , (MovementItem.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS MIAmount_Weight
             , (COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPartner_Weight

             , COALESCE (MIFloat_RealWeight.ValueData, 0)   ::TFloat       AS RealWeight
             , (COALESCE (MIFloat_RealWeight.ValueData, 0) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS RealWeight_Weight
             
             , COALESCE (MIFloat_CountTare.ValueData, 0)    ::TFloat       AS CountTare
             , (COALESCE (MIFloat_CountTare.ValueData, 0) * COALESCE (MIFloat_WeightTare.ValueData, 0)) ::TFloat    AS WeightTare

             , COALESCE (MIFloat_CountTare1.ValueData, 0)  ::TFloat  AS CountTare1
             , COALESCE (MIFloat_CountTare2.ValueData, 0)  ::TFloat  AS CountTare2
             , COALESCE (MIFloat_CountTare3.ValueData, 0)  ::TFloat  AS CountTare3
             , COALESCE (MIFloat_CountTare4.ValueData, 0)  ::TFloat  AS CountTare4
             , COALESCE (MIFloat_CountTare5.ValueData, 0)  ::TFloat  AS CountTare5
             , COALESCE (MIFloat_CountTare6.ValueData, 0)  ::TFloat  AS CountTare6
             , (COALESCE (MIFloat_CountTare1.ValueData, 0) * COALESCE (MIFloat_WeightTare1.ValueData, 0)) ::TFloat  AS WeightTare1
             , (COALESCE (MIFloat_CountTare2.ValueData, 0) * COALESCE (MIFloat_WeightTare2.ValueData, 0)) ::TFloat  AS WeightTare2
             , (COALESCE (MIFloat_CountTare3.ValueData, 0) * COALESCE (MIFloat_WeightTare3.ValueData, 0)) ::TFloat  AS WeightTare3
             , (COALESCE (MIFloat_CountTare4.ValueData, 0) * COALESCE (MIFloat_WeightTare4.ValueData, 0)) ::TFloat  AS WeightTare4
             , (COALESCE (MIFloat_CountTare5.ValueData, 0) * COALESCE (MIFloat_WeightTare5.ValueData, 0)) ::TFloat  AS WeightTare5
             , (COALESCE (MIFloat_CountTare6.ValueData, 0) * COALESCE (MIFloat_WeightTare6.ValueData, 0)) ::TFloat  AS WeightTare6
                  
             , CASE WHEN COALESCE (MIFloat_WeightPack.ValueData,0) > 0 THEN MIFloat_CountPack.ValueData ELSE 0 END ::TFloat AS CountPack
             , MIFloat_WeightPack.ValueData  ::TFloat AS WeightPack

             , MIFloat_HeadCount.ValueData                  AS HeadCount
             , MIFloat_BoxCount.ValueData                   AS BoxCount

             , MIFloat_BoxNumber.ValueData                  AS BoxNumber
             , MIFloat_LevelNumber.ValueData                AS LevelNumber

             , MIFloat_ChangePercentAmount.ValueData        AS ChangePercentAmount
             , MIFloat_ChangePercent.ValueData              AS ChangePercent_mi
             , MIFloat_Price.ValueData                      AS Price
             , MIFloat_CountForPrice.ValueData              AS CountForPrice

             , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()):: TDateTime AS PartionGoodsDate

             , COALESCE (MIDate_Insert.ValueData, zc_DateStart()):: TDateTime   AS InsertDate
             , COALESCE (MIDate_Update.ValueData, zc_DateStart()):: TDateTime   AS UpdateDate
             , Object_GoodsKind.ValueData      AS GoodsKindName
             , Object_Measure.ValueData        AS MeasureName
             , COALESCE (Object_Box.ValueData, '')::TVarChar              AS BoxName
             , COALESCE (Object_PriceList.ValueData , '')::TVarChar       AS PriceListName

             , COALESCE (MIBoolean_BarCode.ValueData, FALSE) :: Boolean AS isBarCode

             , zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale, CASE WHEN MovementFloat_MovementDesc.ValueData = zc_Movement_ReturnIn() THEN Movement_Promo_View.EndReturn ELSE Movement_Promo_View.EndSale END) AS MovementPromo

             , MovementItem.isErased
             
             , tmpMI.Ord   ::Integer AS Count_Doc
             , tmpMI.Count ::Integer AS Count_Item

       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId = zc_Movement_WeighingPartner()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId
            INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementBoolean AS MovementBoolean_DocPartner
                                      ON MovementBoolean_DocPartner.MovementId = Movement.Id
                                     AND MovementBoolean_DocPartner.DescId = zc_MovementBoolean_DocPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement_Parent.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId = Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId = Movement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementDesc ON MovementDesc.Id = MovementFloat_MovementDesc.ValueData :: Integer -- COALESCE (Movement_Parent.DescId, MovementFloat_MovementDesc.ValueData)

            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber
                                    ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                   AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId     = zc_MovementString_Comment()
            LEFT JOIN MovementString AS MovementString_IP
                                     ON MovementString_IP.MovementId = Movement.Id
                                    AND MovementString_IP.DescId     = zc_MovementString_IP()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal1_Stick
                                         ON MovementLinkObject_Personal1_Stick.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal1_Stick.DescId = zc_MovementLinkObject_PersonalStick1()
            LEFT JOIN Object AS Object_Personal1_Stick ON Object_Personal1_Stick.Id = MovementLinkObject_Personal1_Stick.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position1_Stick
                                         ON MovementLinkObject_Position1_Stick.MovementId = Movement.Id
                                        AND MovementLinkObject_Position1_Stick.DescId = zc_MovementLinkObject_PositionStick1()
            LEFT JOIN Object AS Object_Position1_Stick ON Object_Position1_Stick.Id = MovementLinkObject_Position1_Stick.ObjectId

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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal5
                                         ON MovementLinkObject_Personal5.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal5.DescId = zc_MovementLinkObject_PersonalComplete5()
            LEFT JOIN Object AS Object_Personal5 ON Object_Personal5.Id = MovementLinkObject_Personal5.ObjectId

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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Position5
                                         ON MovementLinkObject_Position5.MovementId = Movement.Id
                                        AND MovementLinkObject_Position5.DescId = zc_MovementLinkObject_PositionComplete5()
            LEFT JOIN Object AS Object_Position5 ON Object_Position5.Id = MovementLinkObject_Position5.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementId = Movement.ParentId
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_Tax ON MS_InvNumberPartner_Tax.MovementId = MovementLinkMovement_Tax.MovementChildId
                                                               AND MS_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            --LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
--
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ReturnIn
                                           ON MovementLinkMovement_ReturnIn.MovementId = Movement.Id
                                          AND MovementLinkMovement_ReturnIn.DescId = zc_MovementLinkMovement_ReturnIn()
            LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = MovementLinkMovement_ReturnIn.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
--
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementDate AS MovementDate_StartBegin
                                   ON MovementDate_StartBegin.MovementId = Movement.Id
                                  AND MovementDate_StartBegin.DescId = zc_MovementDate_StartBegin()
            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_PersonalGroup_Unit
                                 ON ObjectLink_PersonalGroup_Unit.ObjectId = Object_PersonalGroup.Id
                                AND ObjectLink_PersonalGroup_Unit.DescId = zc_ObjectLink_PersonalGroup_Unit()
            LEFT JOIN Object AS Object_Unit_PersonalGroup ON Object_Unit_PersonalGroup.Id = ObjectLink_PersonalGroup_Unit.ChildObjectId

            --- строки
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND (MovementItem.isErased   = inIsErased
                                    OR inGoodsGroupId <> 0
                                    OR inGoodsId <> 0
                                    OR (inStartDate + INTERVAL '3 DAY') >= inEndDate
                                      )

            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpGoods.GoodsId
      
            left Join tmpMI on tmpMI.Id = MovementItem.Id

            LEFT JOIN MovementItemDate AS MIDate_StartBegin
                                       ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
            LEFT JOIN MovementItemDate AS MIDate_EndBegin
                                       ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                      AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()

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
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                        ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                       AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
            LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = MIFloat_PromoMovement.ValueData :: Integer

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

            LEFT JOIN MovementItemFloat AS MIFloat_CountTare1
                                        ON MIFloat_CountTare1.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare1.DescId = zc_MIFloat_CountTare1()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare1
                                        ON MIFloat_WeightTare1.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare1.DescId = zc_MIFloat_WeightTare1()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare2
                                        ON MIFloat_CountTare2.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare2.DescId = zc_MIFloat_CountTare2()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare2
                                        ON MIFloat_WeightTare2.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare2.DescId = zc_MIFloat_WeightTare2()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare3
                                        ON MIFloat_CountTare3.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare3.DescId = zc_MIFloat_CountTare3()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare3
                                        ON MIFloat_WeightTare3.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare3.DescId = zc_MIFloat_WeightTare3()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare4
                                        ON MIFloat_CountTare4.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare4.DescId = zc_MIFloat_CountTare4()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare4
                                        ON MIFloat_WeightTare4.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare4.DescId = zc_MIFloat_WeightTare4()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare5
                                        ON MIFloat_CountTare5.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare5.DescId = zc_MIFloat_CountTare5()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare5
                                        ON MIFloat_WeightTare5.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare5.DescId = zc_MIFloat_WeightTare5()
            LEFT JOIN MovementItemFloat AS MIFloat_CountTare6
                                        ON MIFloat_CountTare6.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountTare6.DescId = zc_MIFloat_CountTare6()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTare6
                                        ON MIFloat_WeightTare6.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTare6.DescId = zc_MIFloat_WeightTare6()

            LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                        ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
            LEFT JOIN MovementItemFloat AS MIFloat_WeightPack
                                        ON MIFloat_WeightPack.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightPack.DescId = zc_MIFloat_WeightPack()

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

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = MILinkObject_Box.ObjectId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MILinkObject_PriceList.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                            ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                           AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                          ON MIBoolean_BarCode.MovementItemId =  MovementItem.Id
                                         AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_WeighingPartner_Item (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.03.25         * CountPack, WeightPack
 14.11.24         * InvNumberPartner
 08.11.23         *
 12.04.22         *
 06.09.21         *
 08.02.21         * Comment
 17.08.20         *
 04.11.19         *
 17.12.18         *
 15.03.17         * add zc_MovementLinkObject_Member
 05.10.16         * add inJuridicalBasisId
 04.10.16         * add AccessKey
 29.08.15         * add inGoodsGroupId, inGoodsId
 28.06.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_WeighingPartner_Item (inStartDate:= '01.08.2019', inEndDate:= '01.08.2019', inGoodsGroupId:= 0, inGoodsId:= 0, inJuridicalBasisId:= zc_Juridical_Basis(), inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())

--SELECT * FROM gpSelect_Movement_WeighingPartner_Item (inStartDate:= '05.11.2022', inEndDate:= '05.11.2022', inGoodsGroupId:= 0, inGoodsId:= 0, inJuridicalBasisId:= zc_Juridical_Basis(), inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())

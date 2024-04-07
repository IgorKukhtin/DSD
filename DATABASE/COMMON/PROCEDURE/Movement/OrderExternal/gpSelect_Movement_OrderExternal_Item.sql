-- Function: gpSelect_Movement_OrderExternal_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_Item (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal_Item(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDateMark TDateTime
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat, TotalCountSecond TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , StartBegin      TDateTime
             , EndBegin        TDateTime
             , diffBegin_sec   TFloat
             
             --
             , MovementItemId  Integer
             , GoodsId         Integer
             , GoodsCode       Integer
             , GoodsName       TVarChar
             , GoodsKindId     Integer
             , GoodsKindName   TVarChar
             , MeasureName     TVarChar
             , Amount          TFloat
             , Price           TFloat
             , CountForPrice   TFloat
             --, ChangePercent   TFloat
             , AmountSecond    TFloat
             , AmountSumm      TFloat
             , MI_StartBegin   TDateTime
             , MI_EndBegin     TDateTime
             , MI_diffBegin_sec TFloat
             , isErased        Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsUserOrder  Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- определяется уровень доступа
     vbIsUserOrder:= EXISTS (SELECT Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.AccessKeyId_UserOrder > 0);


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll() AND vbIsUserOrder = FALSE
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )
        , tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.UnitId
                               , lfSelect.PositionId
                               , lfSelect.BranchId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          WHERE lfSelect.Ord = 1
                         )
        , tmpMovement AS (SELECT Movement.*
                               , Object_From.Id        AS FromId
                               , Object_From.ValueData AS FromName
                          FROM (SELECT Movement.*
                                FROM tmpStatus
                                     JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  
                                                  AND Movement.DescId = zc_Movement_OrderExternal() 
                                                  AND Movement.StatusId = tmpStatus.StatusId
                                     JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                                ) AS Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                                          AND COALESCE (Object_From.DescId, 0) <> zc_Object_Unit()
                          )

        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                          , zc_MovementDate_OperDateMark()
                                                          , zc_MovementDate_StartBegin()
                                                          , zc_MovementDate_EndBegin())
                              )

        , tmpMovementString AS (SELECT MovementString.*
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_Comment()
                                                              , zc_MovementString_InvNumberPartner())
                                )

        , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                 FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementBoolean.DescId = zc_MovementBoolean_PriceWithVAT()
                                 )

        , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_ChangePercent()
                                                            , zc_MovementFloat_TotalCount()
                                                            , zc_MovementFloat_TotalCountKg()
                                                            , zc_MovementFloat_TotalCountSecond()
                                                            , zc_MovementFloat_TotalCountSh()
                                                            , zc_MovementFloat_TotalSumm()
                                                            , zc_MovementFloat_TotalSummMVAT()
                                                            , zc_MovementFloat_TotalSummPVAT()
                                                            , zc_MovementFloat_VATPercent()
                                                            )
                                )
        , tmpMLO AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_To()
                                                       , zc_MovementLinkObject_Insert()
                                                       , zc_MovementLinkObject_PaidKind()
                                                       , zc_MovementLinkObject_Partner())
                     )

        , tmpMI_G AS (SELECT MovementItem.*
                      FROM tmpMovement
                      --- строки
                           INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND (MovementItem.isErased   = inIsErased OR (inStartDate + INTERVAL '3 DAY') >= inEndDate)
                      )
        , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                       FROM MovementItemLinkObject
                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                         AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                       )

        , tmpMI_Float AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                            AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                           , zc_MIFloat_CountForPrice()
                                                           , zc_MIFloat_AmountSecond()
                                                           , zc_MIFloat_Summ())
                         )

        , tmpMI_Date AS (SELECT MovementItemDate.*
                         FROM MovementItemDate
                         WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                           AND MovementItemDate.DescId IN (zc_MIDate_StartBegin()
                                                         , zc_MIDate_EndBegin()
                                                          )
                         )

        , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                         , MovementItem.MovementId                       AS MovementId
                         , MovementItem.ObjectId                         AS GoodsId
                         , MovementItem.Amount                           AS Amount
                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                         , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                         , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                         , MIFloat_AmountSecond.ValueData                AS AmountSecond
                         , MIFloat_Summ.ValueData                        AS Summ
                         , MIDate_StartBegin.ValueData                   AS StartBegin
                         , MIDate_EndBegin.ValueData                     AS EndBegin
                         , EXTRACT (EPOCH FROM (COALESCE (MIDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MIDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec
                         , MovementItem.isErased
                    FROM tmpMI_G AS MovementItem
                         LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                         LEFT JOIN tmpMI_Float AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                         LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                         LEFT JOIN tmpMI_Float AS MIFloat_Summ
                                               ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                              AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                         LEFT JOIN tmpMI_Date AS MIDate_StartBegin
                                              ON MIDate_StartBegin.MovementItemId = MovementItem.Id
                                             AND MIDate_StartBegin.DescId         = zc_MIDate_StartBegin()
                         LEFT JOIN tmpMI_Date AS MIDate_EndBegin
                                              ON MIDate_EndBegin.MovementItemId = MovementItem.Id
                                             AND MIDate_EndBegin.DescId         = zc_MIDate_EndBegin()
                   )


       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementDate_OperDateMark.ValueData            AS OperDateMark
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
           , Movement.FromId                                AS FromId
           , Movement.FromName                              AS FromName
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , Object_Partner.id                              AS PartnerId
           , Object_Partner.ValueData                       AS PartnerName
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData             AS VATPercent
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
           , MovementFloat_TotalCount.ValueData             AS TotalCount
           , MovementFloat_TotalCountSecond.ValueData       AS TotalCountSecond
           , MovementString_Comment.ValueData               AS Comment
           , Object_User.ValueData                          AS InsertName

           , MovementDate_StartBegin.ValueData  AS StartBegin
           , MovementDate_EndBegin.ValueData    AS EndBegin
           , EXTRACT (EPOCH FROM (COALESCE (MovementDate_EndBegin.ValueData, zc_DateStart()) - COALESCE (MovementDate_StartBegin.ValueData, zc_DateStart())) :: INTERVAL) :: TFloat AS diffBegin_sec


           -- строки
           , MovementItem.MovementItemId
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , MovementItem.Amount        :: TFloat
           , MovementItem.Price         :: TFloat
           , MovementItem.CountForPrice :: TFloat
           , MovementItem.AmountSecond  :: TFloat
           , MovementItem.Summ          :: TFloat AS AmountSumm
           , MovementItem.StartBegin              AS MI_StartBegin 
           , MovementItem.EndBegin                AS MI_EndBegin
           , MovementItem.diffBegin_sec :: TFloat AS MI_diffBegin_sec
           , MovementItem.isErased
       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN tmpMovementDate AS MovementDate_OperDateMark
                                      ON MovementDate_OperDateMark.MovementId = Movement.Id
                                     AND MovementDate_OperDateMark.DescId = zc_MovementDate_OperDateMark()

            LEFT JOIN tmpMovementDate AS MovementDate_StartBegin
                                      ON MovementDate_StartBegin.MovementId = Movement.Id
                                     AND MovementDate_StartBegin.DescId = zc_MovementDate_StartBegin()
            LEFT JOIN tmpMovementDate AS MovementDate_EndBegin
                                      ON MovementDate_EndBegin.MovementId = Movement.Id
                                     AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMLO AS MovementLinkObject_To
                             ON MovementLinkObject_To.MovementId = Movement.Id
                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId = Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                       ON MovementFloat_VATPercent.MovementId = Movement.Id
                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                       ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                      AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                       ON MovementFloat_TotalCountSh.MovementId = Movement.Id
                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSecond
                                       ON MovementFloat_TotalCountSecond.MovementId = Movement.Id
                                      AND MovementFloat_TotalCountSecond.DescId = zc_MovementFloat_TotalCountSecond()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId = Movement.Id
                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId = Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMLO AS MovementLinkObject_Partner
                             ON MovementLinkObject_Partner.MovementId = Movement.Id
                            AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                             ON MovementLinkObject_Insert.MovementId = Movement.Id
                            AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId
 
            --- строки
            LEFT JOIN tmpMI AS MovementItem 
                            ON MovementItem.MovementId = Movement.Id
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.05.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderExternal_Item(instartdate := ('20.04.2016')::TDateTime, inenddate := ('22.04.2016')::TDateTime, inIsErased := 'False', inJuridicalBasisId := 9399 , inSession := '5');

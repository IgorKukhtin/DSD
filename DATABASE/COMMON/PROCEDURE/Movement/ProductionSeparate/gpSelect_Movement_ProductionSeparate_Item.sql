-- Function: gpSelect_Movement_ProductionSeparate_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate_Item (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate_Item(
    IN inStartDate         TDateTime,
    IN inEndDate           TDateTime,
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementItemId Integer
               , InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
               , TotalCount TFloat, TotalCountChild TFloat
               , TotalHeadCount TFloat, TotalHeadCountChild TFloat
               , PartionGoods TVarChar
               , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
               , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
               , GoodsKindId Integer, GoodsKindName TVarChar
               , StorageLineId_old Integer, StorageLineId Integer, StorageLineName TVarChar
               , Amount TFloat
               , isAuto Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Movement_ProductionSeparate());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


   RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )
        , tmpMovement AS (SELECT Movement.id
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ProductionSeparate() AND Movement.StatusId = tmpStatus.StatusId
             --                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                         )
        , tmpMI_Master AS (SELECT tmpMovement.Id                     AS MovementId
                                , MovementItem.Id                    AS MovementItemId
                                , MovementItem.ObjectId              AS GoodsId
                                , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
                                , MILinkObject_StorageLine.ObjectId  AS StorageLineId
                                , SUM (MovementItem.Amount)          AS Amount
                           FROM tmpMovement
                                LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                      
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                                 ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                           GROUP BY tmpMovement.Id 
                                  , MovementItem.Id
                                  , MovementItem.ObjectId
                                  , MILinkObject_GoodsKind.ObjectId
                                  , MILinkObject_StorageLine.ObjectId
                          )
                         
     SELECT
             Movement.Id                          AS Id
           , tmpMI_Master.MovementItemId          AS MovementItemId
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
  
           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalCountChild.ValueData     AS TotalCountChild
           , MovementFloat_TotalHeadCount.ValueData      AS TotalHeadCount
           , MovementFloat_TotalHeadCountChild.ValueData AS TotalHeadCountChild

           , MovementString_PartionGoods.ValueData       AS PartionGoods
  
           , Object_From.Id                       AS FromId
           , Object_From.ValueData                AS FromName
           , Object_To.Id                         AS ToId
           , Object_To.ValueData                  AS ToName
           
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , Object_GoodsKind.Id                  AS GoodsKindId
           , Object_GoodsKind.ValueData           AS GoodsKindName
           , Object_StorageLine.Id                AS StorageLineId_old
           , Object_StorageLine.Id                AS StorageLineId
           , Object_StorageLine.ValueData         AS StorageLineName
                                               
           , tmpMI_Master.Amount        :: TFloat AS Amount
           
           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto

     FROM tmpMovement

          LEFT JOIN Movement ON Movement.id = tmpMovement.id

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

          LEFT JOIN MovementFloat AS MovementFloat_TotalCountChild
                                  ON MovementFloat_TotalCountChild.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCountChild.DescId = zc_MovementFloat_TotalCountChild()

          LEFT JOIN MovementFloat AS MovementFloat_TotalHeadCount
                                  ON MovementFloat_TotalHeadCount.MovementId = Movement.Id
                                 AND MovementFloat_TotalHeadCount.DescId = zc_MovementFloat_TotalHeadCount()

          LEFT JOIN MovementFloat AS MovementFloat_TotalHeadCountChild
                                  ON MovementFloat_TotalHeadCountChild.MovementId = Movement.Id
                                 AND MovementFloat_TotalHeadCountChild.DescId = zc_MovementFloat_TotalHeadCountChild()

          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId = Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

          LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                    ON MovementBoolean_isAuto.MovementId = Movement.Id
                                   AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
          
          -- строки
          
          LEFT JOIN tmpMI_Master ON tmpMI_Master.MovementId = Movement.Id
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Master.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Master.GoodsKindId
          LEFT JOIN Object AS Object_StorageLine ON Object_StorageLine.Id = tmpMI_Master.StorageLineId
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.06.19         *
 26.06.18         * MovementItemId
 10.08.17         * add gpSelect_Movement_ProductionSeparate_Item
 05.10.16         * add inJuridicalBasisId
 03.06.14                                                        *
 28.05.14                                                        *
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionSeparate_Item (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession:= '2')

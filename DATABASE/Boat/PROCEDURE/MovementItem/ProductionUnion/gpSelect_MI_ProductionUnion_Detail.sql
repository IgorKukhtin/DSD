-- Function: gpSelect_MI_ProductionUnion_Detail()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Detail (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Detail (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion_Detail(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , ReceiptServiceId Integer, ReceiptServiceCode Integer, ReceiptServiceName TVarChar
             , Article_ReceiptService TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , Comment TVarChar
             , Amount TFloat
             , OperPrice TFloat
             , Hours TFloat
             , Hours_plan TFloat
             , Summ TFloat
             , isErased Boolean

             , GoodsId_master   Integer
             , GoodsCode_master Integer
             , GoodsName_master TVarChar
             , DescName_master  TVarChar
             , Amount_master    TFloat
             , Article_master   TVarChar
             , MovementId_OrderClient Integer
             , InvNumber_OrderClient  TVarChar
             , InvNumberFull_OrderClient TVarChar
             , OperDate_OrderClient      TDateTime
             , FromName_OrderClient      TVarChar
             , ProductName_OrderClient   TVarChar
             , CIN_OrderClient           TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpIsErased AS (SELECT FALSE AS isErased
                           UNION ALL
                          SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                         )
      -- ProductionUnion - Master
    , tmpMI_Master AS (SELECT MovementItem.Id              AS MovementItemId
                            , MovementItem.ObjectId        AS ObjectId
                            , MovementItem.Amount          AS Amount
                            , MIFloat_MovementId.ValueData AS MovementId_order
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                      )
     -- OrderInternal - Detail
   , tmpMI_OrderInternal AS (SELECT tmpMI_Master.MovementItemId                 AS ParentId
                                  , MovementItem.ObjectId                       AS ReceiptServiceId
                                  , MILinkObject_Personal.ObjectId              AS PersonalId
                                  , SUM (COALESCE (MIFloat_Hours.ValueData, 0)) AS Hours_plan
                             FROM tmpMI_Master
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                              ON MIFloat_MovementId.ValueData = tmpMI_Master.MovementId_order
                                                             AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                                  LEFT JOIN MovementItem AS MI_Master
                                                         ON MI_Master.Id       = MIFloat_MovementId.MovementItemId
                                                        AND MI_Master.DescId   = zc_MI_Master()
                                                        AND MI_Master.isErased = FALSE
                                  LEFT JOIN MovementItem ON MovementItem.ParentId = MI_Master.Id
                                                        AND MovementItem.DescId   = zc_MI_Detail()
                                                        AND MovementItem.isErased = FALSE
                                  INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                     AND Movement.DescId   = zc_Movement_OrderInternal()
                                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Personal
                                                                   ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Personal.DescId         = zc_MILinkObject_Personal()
                                  LEFT JOIN MovementItemFloat AS MIFloat_Hours
                                                              ON MIFloat_Hours.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Hours.DescId = zc_MIFloat_Hours()
                             GROUP BY tmpMI_Master.MovementItemId
                                    , MovementItem.ObjectId
                                    , MILinkObject_Personal.ObjectId
                            )
  -- ProductionUnion - Detail
, tmpMI_Detail_all AS (SELECT MovementItem.Id                AS MovementItemId
                            , MovementItem.ParentId          AS ParentId
                            , MovementItem.ObjectId          AS ReceiptServiceId
                            , MILinkObject_Personal.ObjectId AS PersonalId
                            , MovementItem.Amount            AS Amount
                            , MovementItem.isErased          AS isErased
                       FROM tmpIsErased
                            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Detail()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Personal
                                                             ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Personal.DescId         = zc_MILinkObject_Personal()
                      )
      -- union
    , tmpMI_Detail AS (SELECT tmpMI_Detail_all.MovementItemId                                                     AS MovementItemId
                            , COALESCE (tmpMI_Detail_all.ParentId,         tmpMI_OrderInternal.ParentId)          AS ParentId
                            , COALESCE (tmpMI_Detail_all.ReceiptServiceId, tmpMI_OrderInternal.ReceiptServiceId)  AS ReceiptServiceId
                            , COALESCE (tmpMI_Detail_all.PersonalId,       tmpMI_OrderInternal.PersonalId)        AS PersonalId
                            , tmpMI_Detail_all.Amount                                                             AS Amount
                            , tmpMI_OrderInternal.Hours_plan                                                      AS Hours_plan
                            , COALESCE (tmpMI_Detail_all.isErased, FALSE)                                         AS isErased
                       FROM tmpMI_Detail_all
                            FULL JOIN tmpMI_OrderInternal ON tmpMI_OrderInternal.ParentId         = tmpMI_Detail_all.ParentId
                                                         AND tmpMI_OrderInternal.ReceiptServiceId = tmpMI_Detail_all.ReceiptServiceId
                                                         AND tmpMI_OrderInternal.PersonalId       = tmpMI_Detail_all.PersonalId
                      )

        -- Результат
        SELECT tmpMI_Detail.MovementItemId       :: Integer AS Id
             , tmpMI_Detail.ParentId             :: Integer AS ParentId
             , tmpMI_Detail.ReceiptServiceId     :: Integer AS ReceiptServiceId
             , Object_ReceiptService.ObjectCode             AS ReceiptServiceCode
             , Object_ReceiptService.ValueData              AS ReceiptServiceName
             , ObjectString_Article.ValueData               AS Article_ReceiptService

             , tmpMI_Detail.PersonalId           :: Integer AS PersonalId
             , Object_Personal.ObjectCode                   AS PersonalCode
             , Object_Personal.ValueData                    AS PersonalName
             , MIString_Comment.ValueData                   AS Comment

             , tmpMI_Detail.Amount          ::TFloat AS Amount
             , MIFloat_OperPrice.ValueData  ::TFloat AS OperPrice
             , MIFloat_Hours.ValueData      ::TFloat AS Hours
             , tmpMI_Detail.Hours_plan      ::TFloat AS Hours_plan
             , MIFloat_Summ.ValueData       ::TFloat AS Summ

             , tmpMI_Detail.isErased :: Boolean

               --
             , Object_Goods.Id           AS GoodsId_master
             , Object_Goods.ObjectCode   AS GoodsCode_master
             , Object_Goods.ValueData    AS GoodsName_master
             , ObjectDesc.ItemName       AS DescName_master
             , MI_Master.Amount ::TFloat AS Amount_master
             , ObjectString_Article_master.ValueData AS Article_master
             , Movement_OrderClient.Id                                              AS MovementId_OrderClient
             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber):: TVarChar AS InvNumber_OrderClient
             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId)  AS InvNumberFull_OrderClient
             , Movement_OrderClient.OperDate                                        AS OperDate_OrderClient
             , Object_From.ValueData                                                AS FromName_OrderClient

             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)  AS ProductName_OrderClient
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN_OrderClient

        FROM tmpMI_Detail

             LEFT JOIN Object AS Object_ReceiptService ON Object_ReceiptService.Id = tmpMI_Detail.ReceiptServiceId
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = tmpMI_Detail.ReceiptServiceId
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpMI_Detail.PersonalId

             LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                         ON MIFloat_OperPrice.MovementItemId = tmpMI_Detail.MovementItemId
                                        AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
             LEFT JOIN MovementItemFloat AS MIFloat_Hours
                                         ON MIFloat_Hours.MovementItemId = tmpMI_Detail.MovementItemId
                                        AND MIFloat_Hours.DescId         = zc_MIFloat_Hours()
             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = tmpMI_Detail.MovementItemId
                                        AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()

             LEFT JOIN MovementItemString AS MIString_Comment
                                          ON MIString_Comment.MovementItemId = tmpMI_Detail.MovementItemId
                                         AND MIString_Comment.DescId         = zc_MIString_Comment()

             -- данные из мастера
             LEFT JOIN tmpMI_Master AS MI_Master ON MI_Master.MovementItemId = tmpMI_Detail.ParentId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.ObjectId
             LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId

             LEFT JOIN ObjectString AS ObjectString_Article_master
                                    ON ObjectString_Article_master.ObjectId = MI_Master.ObjectId
                                   AND ObjectString_Article_master.DescId = zc_ObjectString_Article()

             LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MI_Master.MovementId_order

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                         AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
             LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.23         *
*/

-- тест
-- SELECT * from gpSelect_MI_ProductionUnion_Detail (inMovementId:= 224, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());

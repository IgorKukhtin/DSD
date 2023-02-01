-- Function: gpSelect_Movement_ProductionUnion_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnion_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnion_Print(
    IN inMovementId  Integer  , -- ключ Документа
    IN inSession     TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    OPEN Cursor1 FOR

        SELECT 
            Movement.Id
          , zfFormat_BarCode (zc_BarCodePref_Movement(), inMovementId) AS BarCode_ProductionUnion
          , Movement.InvNumber
          , Movement.OperDate         AS OperDate

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
          , Object_Insert.ValueData                   AS InsertName
          , MovementDate_Insert.ValueData             AS InsertDate
        FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
        WHERE Movement.Id = inMovementId
          AND Movement.DescId = zc_Movement_ProductionUnion();

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
     WITH -- все MovementItem
          tmpMI_all AS (SELECT MovementItem.*
                        FROM Movement
                             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.isErased   = FALSE
                                                   AND MovementItem.DescId     IN (zc_MI_Master(), zc_MI_Child())
                        WHERE Movement.Id     = inMovementId
                          AND Movement.DescId = zc_Movement_ProductionUnion()
                       )

     , tmpMI_Master AS (SELECT ROW_NUMBER() OVER (PARTITION BY MIFloat_MovementId.ValueData
                                                  ORDER BY CASE WHEN ObjectString_Article.ValueData ILIKE '%ПФ' THEN 0 ELSE 1 END
                                                         , Object_Goods.ValueData
                                                 ) AS NPP_1
                               --
                             , tmpMI_all.Id                   AS MovementItemId
                             , tmpMI_all.ObjectId             AS GoodsId
                             , Object_Goods.ObjectCode        AS GoodsCode
                             , Object_Goods.ValueData         AS GoodsName
                             , ObjectDesc.ItemName            AS DescName
                             , ObjectString_Article.ValueData AS Article 
                             , Object_ProdColor.ValueData     AS ProdColorName
                             , Object_Measure.ValueData       AS MeasureName
                             , Object_ReceiptProdModel.ObjectCode AS ReceiptProdModelCode
                             , Object_ReceiptProdModel.ValueData  AS ReceiptProdModelName
                             , MIString_Comment.ValueData     AS Comment_mi

                               --
                             , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber):: TVarChar AS InvNumber_OrderClient
                             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
                             , Object_From.ValueData                      AS FromName
                             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
                             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN


                        FROM tmpMI_all
                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_all.ObjectId
                             LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId

                             LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                              ON MILO_ReceiptProdModel.MovementItemId = tmpMI_all.Id
                                                             AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                             LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = MILO_ReceiptProdModel.ObjectId

                             LEFT JOIN ObjectString AS ObjectString_Article
                                                    ON ObjectString_Article.ObjectId = tmpMI_all.ObjectId
                                                   AND ObjectString_Article.DescId = zc_ObjectString_Article()

                             LEFT JOIN MovementItemString AS MIString_Comment
                                                          ON MIString_Comment.MovementItemId = tmpMI_all.Id
                                                         AND MIString_Comment.DescId = zc_MIString_Comment()

                             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                         ON MIFloat_MovementId.MovementItemId = tmpMI_all.Id
                                                        AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                             -- Заказ клиента
                             LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer

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

                             LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                  ON ObjectLink_ProdColor.ObjectId = tmpMI_all.ObjectId
                                                 AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                             LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = ObjectLink_ProdColor.ChildObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                  ON ObjectLink_Goods_Measure.ObjectId = tmpMI_all.ObjectId
                                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                        WHERE tmpMI_all.DescId = zc_MI_Master()
                       )

     , tmpMI_Child AS (SELECT tmpMI_all.Id                    AS MovementItemId
                            , tmpMI_all.ParentId
                            , tmpMI_all.ObjectId              AS GoodsId
                            , Object_Goods.ObjectCode         AS GoodsCode
                            , Object_Goods.ValueData          AS GoodsName
                            , ObjectString_Article.ValueData  AS Article
                            , Object_ProdColor.Id             AS ProdColorId
                            , Object_ProdColor.ValueData      AS ProdColorName
                            , tmpMI_all.Amount                AS Amount
                       FROM tmpMI_all
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_all.ObjectId

                            LEFT JOIN ObjectString AS ObjectString_Article
                                                   ON ObjectString_Article.ObjectId = tmpMI_all.ObjectId
                                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                            LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                 ON ObjectLink_ProdColor.ObjectId = tmpMI_all.ObjectId
                                                AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = ObjectLink_ProdColor.ChildObjectId
                       WHERE tmpMI_all.DescId = zc_MI_Child()
                      )

     -- OrderInternal - Detail
   , tmpMI_OrderInternal AS (SELECT tmpMI_Master.MovementItemId                 AS ParentId
                                  , MovementItem.ObjectId                       AS ReceiptServiceId
                                  , MILinkObject_Personal.ObjectId              AS PersonalId
                                  , SUM (COALESCE (MIFloat_Hours.ValueData, 0)) AS Hours_plan
                             FROM tmpMI_Master
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                              ON MIFloat_MovementId.ValueData = tmpMI_Master.MovementId_OrderClient
                                                             AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                                  LEFT JOIN MovementItem AS MI_Master
                                                         ON MI_Master.Id       = MIFloat_MovementId.MovementItemId
                                                        AND MI_Master.DescId   = zc_MI_Master()
                                                        AND MI_Master.ObjectId = tmpMI_Master.GoodsId
                                                        AND MI_Master.isErased = FALSE
                                  LEFT JOIN MovementItem ON MovementItem.MovementId = MI_Master.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Detail()
                                                        AND MovementItem.ParentId   = MI_Master.Id
                                                        AND MovementItem.isErased   = FALSE
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
                           FROM MovementItem
                                INNER JOIN MovementItem AS MI_Master
                                                        ON MI_Master.MovementId = inMovementId
                                                       AND MI_Master.DescId     = zc_MI_Master()
                                                       AND MI_Master.Id         = MovementItem.ParentId
                                                       AND MI_Master.isErased   = FALSE
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Personal
                                                                 ON MILinkObject_Personal.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Personal.DescId         = zc_MILinkObject_Personal()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Detail()
                             AND MovementItem.isErased   = FALSE
                          )
      -- union
    , tmpMI_Detail AS (SELECT tmp.MovementItemId
                            , tmp.ParentId
                            , Object_ReceiptService.ObjectCode  AS ReceiptServiceCode
                            , Object_ReceiptService.ValueData   AS ReceiptServiceName
                            , Object_Personal.Id                AS PersonalId
                            , Object_Personal.ObjectCode        AS PersonalCode
                            , Object_Personal.ValueData         AS PersonalName
                            , MIString_Comment.ValueData        AS Comment
                            , tmp.Amount               ::TFloat AS Amount
                            , MIFloat_Hours.ValueData  ::TFloat AS Hours
                            , tmp.Hours_plan           ::TFloat AS Hours_plan
                       FROM (SELECT tmpMI_Detail_all.MovementItemId                                                     AS MovementItemId
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
                            ) AS tmp
                            LEFT JOIN Object AS Object_ReceiptService ON Object_ReceiptService.Id = tmp.ReceiptServiceId
                            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmp.PersonalId

                            LEFT JOIN MovementItemFloat AS MIFloat_Hours
                                                        ON MIFloat_Hours.MovementItemId = tmp.MovementItemId
                                                       AND MIFloat_Hours.DescId         = zc_MIFloat_Hours()
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = tmp.MovementItemId
                                                        AND MIString_Comment.DescId         = zc_MIString_Comment()
                      )


  , tmpMI_Detail_group AS (SELECT tmpMI_Detail.ParentId
                                , STRING_AGG (DISTINCT tmpMI_Detail.PersonalName, ';') AS PersonalName
                           FROM tmpMI_Detail
                           GROUP BY tmpMI_Detail.ParentId
                          )

    -- Результат
    SELECT
           tmpMI_Master.NPP_1 :: Integer AS NPP_1 
         , 1                  :: Integer AS NPP_2
         , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.InvNumber_OrderClient, tmpMI_Master.GoodsName
                              ORDER BY tmpMI_Child.GoodsName
                             ) :: Integer AS NPP_3
           -- мастер
         , zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Master.MovementItemId) AS BarCode_mi
         , tmpMI_Master.MovementItemId
         , tmpMI_Master.GoodsCode
         , tmpMI_Master.GoodsName
         , tmpMI_Master.Article
         , tmpMI_Master.ProdColorName
         , tmpMI_Master.MeasureName
         , tmpMI_Master.ReceiptProdModelName
         , tmpMI_Master.Comment_mi
           --
         , tmpMI_Master.InvNumber_OrderClient      :: Integer AS InvNumber_OrderClient
         , tmpMI_Master.InvNumberFull_OrderClient             AS InvNumberFull_OrderClient
         , tmpMI_Master.FromName
         , tmpMI_Master.ProductName
         , tmpMI_Master.CIN
         , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpMI_Master.MovementId_OrderClient) AS BarCode_OrderClient

         , tmpMI_Detail_group.PersonalName :: TVarChar AS PersonalName
           -- чайлд
         , tmpMI_Child.GoodsCode            AS GoodsCode_ch
         , tmpMI_Child.GoodsName            AS GoodsName_ch
         , tmpMI_Child.Article              AS Article_ch
         , tmpMI_Child.ProdColorName        AS ProdColorName_ch
         , ''  ::TVarChar                   AS ReceiptLevelName_ch
         , tmpMI_Child.ProdColorName        AS ProdColorPatternName_ch
         , tmpMI_Child.ProdColorId          AS ProdColorPatternId_ch
         , tmpMI_Child.Amount               AS Amount_ch
         , 0                       ::TFloat AS Amount_plan_ch

         , (SELECT COUNT(*) FROM tmpMI_Child WHERE tmpMI_Child.ParentId = tmpMI_Master.MovementItemId) ::Integer AS mi_child_count

    FROM tmpMI_Master
         LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.MovementItemId
         LEFT JOIN tmpMI_Detail_group ON tmpMI_Detail_group.ParentId = tmpMI_Master.MovementItemId

  UNION ALL
    SELECT
           tmpMI_Master.NPP_1 :: Integer AS NPP_1
         , 2                  :: Integer AS NPP_2
         , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.InvNumber_OrderClient, tmpMI_Master.GoodsName
                              ORDER BY tmpMI_Detail.ReceiptServiceCode
                                     , tmpMI_Detail.PersonalName
                             ) :: Integer AS NPP_3
           -- мастер
         , zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Master.MovementItemId) AS BarCode_mi
         , tmpMI_Master.MovementItemId
         , tmpMI_Master.GoodsCode
         , tmpMI_Master.GoodsName
         , tmpMI_Master.Article
         , tmpMI_Master.ProdColorName
         , tmpMI_Master.MeasureName
         , tmpMI_Master.ReceiptProdModelName
         , tmpMI_Master.Comment_mi
           --
         , tmpMI_Master.InvNumber_OrderClient      :: Integer AS InvNumber_OrderClient
         , tmpMI_Master.InvNumberFull_OrderClient             AS InvNumberFull_OrderClient
         , tmpMI_Master.FromName
         , tmpMI_Master.ProductName
         , tmpMI_Master.CIN
         , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpMI_Master.MovementId_OrderClient) AS BarCode_OrderClient

         , tmpMI_Detail_group.PersonalName :: TVarChar AS PersonalName

           -- работы
         , tmpMI_Detail.ReceiptServiceCode        AS GoodsCode_ch
         , tmpMI_Detail.ReceiptServiceName        AS GoodsName_ch
           -- Сотрудник
         , tmpMI_Detail.PersonalCode  :: TVarChar AS Article_ch
         , tmpMI_Detail.PersonalName  :: TVarChar AS ProdColorName_ch
         , ''  ::TVarChar                         AS ReceiptLevelName_ch 
         , '' :: TVarChar                         AS ProdColorPatternName_ch
         , 0  :: Integer                          AS ProdColorPatternId_ch

         , COALESCE (tmpMI_Detail.Hours, 0)      :: NUMERIC (16, 8)  AS Amount_ch
         , COALESCE (tmpMI_Detail.Hours_plan, 0) :: NUMERIC (16, 8)  AS Amount_plan_ch        
         , (SELECT COUNT(*) FROM tmpMI_Detail WHERE tmpMI_Detail.ParentId = tmpMI_Master.MovementItemId) ::Integer AS mi_child_count

    FROM tmpMI_Master
         LEFT JOIN tmpMI_Detail_group  ON tmpMI_Detail_group.ParentId  = tmpMI_Master.MovementItemId
         LEFT JOIN tmpMI_Detail        ON tmpMI_Detail.ParentId        = tmpMI_Master.MovementItemId
    ORDER BY 12
           , 1 , 2

   ;
   RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.01.23         *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_ProductionUnion_Print (inMovementId:= 3897397, inSession:= zfCalc_UserAdmin());

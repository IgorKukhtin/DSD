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
                        WHERE tmpMI_all.DescId = zc_MI_Master()
                       )

     , tmpMI_Child AS (SELECT tmpMI_all.Id                    AS MovementItemId
                            , tmpMI_all.ParentId
                            , tmpMI_all.ObjectId              AS GoodsId
                            , Object_Goods.ObjectCode         AS GoodsCode
                            , Object_Goods.ValueData          AS GoodsName
                            , ObjectString_Article.ValueData  AS Article
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
    -- Результат
    SELECT
           tmpMI_Master.NPP_1 :: Integer AS NPP_1
         , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.InvNumber_OrderClient, tmpMI_Master.GoodsName
                              ORDER BY tmpMI_Child.GoodsName
                             ) :: Integer AS NPP_2
           -- мастер
         , zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Master.MovementItemId) AS BarCode_mi
         , tmpMI_Master.MovementItemId
         , tmpMI_Master.GoodsCode
         , tmpMI_Master.GoodsName
         , tmpMI_Master.Article
         , tmpMI_Master.ProdColorName
         , tmpMI_Master.ReceiptProdModelName
         , tmpMI_Master.Comment_mi
           --
         , tmpMI_Master.InvNumber_OrderClient      :: Integer AS InvNumber_OrderClient
         , tmpMI_Master.InvNumberFull_OrderClient             AS InvNumberFull_OrderClient
         , tmpMI_Master.FromName
         , tmpMI_Master.ProductName
         , tmpMI_Master.CIN
         , zfFormat_BarCode (zc_BarCodePref_Movement(), tmpMI_Master.MovementId_OrderClient) AS BarCode_OrderClient
           -- чайлд
         , tmpMI_Child.GoodsCode            AS GoodsCode_ch
         , tmpMI_Child.GoodsName            AS GoodsName_ch
         , tmpMI_Child.Article              AS Article_ch
         , tmpMI_Child.ProdColorName        AS ProdColorName_ch
         , ''  ::TVarChar                   AS ReceiptLevelName_ch
         , tmpMI_Child.Amount               AS Amount_ch

         , (SELECT COUNT(*) FROM tmpMI_Child WHERE tmpMI_Child.ParentId = tmpMI_Master.MovementItemId) ::Integer AS mi_child_count

    FROM tmpMI_Master
         LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.MovementItemId
    ORDER BY tmpMI_Master.InvNumber_OrderClient :: Integer
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

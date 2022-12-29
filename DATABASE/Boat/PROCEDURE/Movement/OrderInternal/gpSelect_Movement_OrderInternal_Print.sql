-- Function: gpSelect_Movement_OrderInternal_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal_Print(
    IN inMovementId  Integer  , -- ключ Документа
    IN inSession     TVarChar   -- сессия пользователя
)
RETURNS TABLE (NPP_1 Integer, NPP_2 Integer
               --
             , InvNumber Integer
             , OperDate TDateTime
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , BarCode_OrderInternal TVarChar
               -- мастер
             , BarCode_mi                TVarChar
             , MovementItemId            Integer
             , GoodsCode                 Integer
             , GoodsName                 TVarChar
             , Article                   TVarChar
             , ProdColorName             TVarChar
             , Comment_mi                TVarChar
             , UnitName                  TVarChar
               --
             , InvNumber_OrderClient     Integer
             , InvNumberFull_OrderClient TVarChar
             , FromName                  TVarChar
             , ProductName               TVarChar
             , CIN                       TVarChar
             , BarCode_OrderClient       TVarChar
               -- чайлд
             , GoodsCode_ch             Integer
             , GoodsName_ch             TVarChar
             , Article_ch               TVarChar
             , ProdColorName_ch         TVarChar
               --
             , Amount_ch                NUMERIC (16, 8)
             , AmountReserv_ch          NUMERIC (16, 8)
             , AmountSend_ch            NUMERIC (16, 8)
               --
             , UnitName_ch              TVarChar
             , ReceiptLevelName_ch      TVarChar
             , ColorPatternName_ch      TVarChar
             , ProdColorPatternName_ch  TVarChar
             , ProdColorPatternId_ch    Integer

             , mi_child_count Integer
              )
AS
$BODY$
    DECLARE vbUserId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH -- все MovementItem
          tmpMI_all AS (SELECT MovementItem.*
                             , Movement.InvNumber
                             , Movement.OperDate
                             , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
                             , Object_Insert.ValueData              AS InsertName
                             , MovementDate_Insert.ValueData        AS InsertDate
                        FROM Movement
                             LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.isErased   = FALSE
                                                   AND MovementItem.DescId     IN (zc_MI_Master(), zc_MI_Child())
                             LEFT JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId = Movement.Id
                                                     AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                             LEFT JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
                             LEFT JOIN MovementLinkObject AS MLO_Insert
                                                          ON MLO_Insert.MovementId = Movement.Id
                                                         AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
                             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
                        WHERE Movement.Id     = inMovementId
                          AND Movement.DescId = zc_Movement_OrderInternal()
                       )

     , tmpMI_Master AS (SELECT ROW_NUMBER() OVER (PARTITION BY MIFloat_MovementId.ValueData
                                                  ORDER BY CASE WHEN ObjectString_Article.ValueData ILIKE '%ПФ' THEN 0 ELSE 1 END
                                                         , Object_Goods.ValueData
                                                 ) AS NPP_1
                             , tmpMI_all.MovementId
                             , tmpMI_all.InvNumber
                             , tmpMI_all.OperDate
                             , tmpMI_all.Comment
                             , tmpMI_all.InsertName
                             , tmpMI_all.InsertDate
                               --
                             , tmpMI_all.Id                   AS MovementItemId
                             , tmpMI_all.ObjectId             AS GoodsId
                             , Object_Goods.ObjectCode        AS GoodsCode
                             , Object_Goods.ValueData         AS GoodsName
                             , ObjectDesc.ItemName            AS DescName
                             , ObjectString_Article.ValueData AS Article
                             , Object_ProdColor.ValueData     AS ProdColorName
                             , MIString_Comment.ValueData     AS Comment_mi
                             , Object_Unit.ValueData          AS UnitName
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

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                              ON MILinkObject_Unit.MovementItemId = tmpMI_all.Id
                                                             AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                             LEFT JOIN ObjectString AS ObjectString_Article
                                                    ON ObjectString_Article.ObjectId = tmpMI_all.ObjectId
                                                   AND ObjectString_Article.DescId = zc_ObjectString_Article()
                             LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                  ON ObjectLink_ProdColor.ObjectId = tmpMI_all.ObjectId
                                                 AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                             LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = ObjectLink_ProdColor.ChildObjectId

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

                        WHERE tmpMI_all.DescId = zc_MI_Master()
                       )

     , tmpMI_Child AS (SELECT tmpMI_all.Id                    AS MovementItemId
                            , tmpMI_all.ParentId
                            , tmpMI_all.ObjectId              AS GoodsId
                            , Object_Goods.ObjectCode         AS GoodsCode
                            , Object_Goods.ValueData          AS GoodsName
                            , ObjectString_Article.ValueData  AS Article
                            , Object_ProdColor.ValueData      AS ProdColorName
                            , zfCalc_Value_ForCount (tmpMI_all.Amount, MIFloat_ForCount.ValueData)                AS Amount
                            , zfCalc_Value_ForCount (MIFloat_AmountReserv.ValueData, MIFloat_ForCount.ValueData)  AS AmountReserv
                            , zfCalc_Value_ForCount (MIFloat_AmountSend.ValueData, MIFloat_ForCount.ValueData)    AS AmountSend
                            , Object_Unit.ValueData                   AS UnitName
                            , Object_ReceiptLevel.ValueData           AS ReceiptLevelName
                            , Object_ColorPattern.ValueData           AS ColorPatternName
                            , Object_ProdColorPattern.Id              AS ProdColorPatternId
                            , Object_ProdColorPattern.ValueData       AS ProdColorPatternName
                       FROM tmpMI_all
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_all.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                             ON MILinkObject_Unit.MovementItemId = tmpMI_all.Id
                                                            AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                                             ON MILO_ReceiptLevel.MovementItemId = tmpMI_all.Id
                                                            AND MILO_ReceiptLevel.DescId = zc_MILinkObject_ReceiptLevel()
                            LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = MILO_ReceiptLevel.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                                             ON MILO_ColorPattern.MovementItemId = tmpMI_all.Id
                                                            AND MILO_ColorPattern.DescId = zc_MILinkObject_ColorPattern()
                            LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = MILO_ColorPattern.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                                             ON MILO_ProdColorPattern.MovementItemId = tmpMI_all.Id
                                                            AND MILO_ProdColorPattern.DescId = zc_MILinkObject_ProdColorPattern()
                            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = MILO_ProdColorPattern.ObjectId

                            LEFT JOIN ObjectString AS ObjectString_Article
                                                   ON ObjectString_Article.ObjectId = tmpMI_all.ObjectId
                                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                            LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                 ON ObjectLink_ProdColor.ObjectId = tmpMI_all.ObjectId
                                                AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = ObjectLink_ProdColor.ChildObjectId

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountReserv
                                                        ON MIFloat_AmountReserv.MovementItemId = tmpMI_all.Id
                                                       AND MIFloat_AmountReserv.DescId = zc_MIFloat_AmountReserv()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSend
                                                        ON MIFloat_AmountSend.MovementItemId = tmpMI_all.Id
                                                       AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend()
                            LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                        ON MIFloat_ForCount.MovementItemId = tmpMI_all.Id
                                                       AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                       WHERE tmpMI_all.DescId = zc_MI_Child()
                      )
    -- Результат
    SELECT
           tmpMI_Master.NPP_1 :: Integer AS NPP_1
         , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.InvNumber_OrderClient, tmpMI_Master.GoodsName
                              ORDER BY tmpMI_Child.ReceiptLevelName
                                     , CASE WHEN tmpMI_Child.ProdColorPatternId > 0
                                            THEN 0
                                            ELSE 1
                                       END
                                     , CASE WHEN tmpMI_Child.Article ILIKE '%ПФ'
                                            THEN 0
                                            ELSE 1
                                       END
                                     , tmpMI_Child.GoodsName
                             ) :: Integer AS NPP_2
           --
         , tmpMI_Master.InvNumber :: Integer AS InvNumber
         , tmpMI_Master.OperDate
         , tmpMI_Master.Comment
         , tmpMI_Master.InsertName
         , tmpMI_Master.InsertDate
         , zfFormat_BarCode (zc_BarCodePref_Movement(), inMovementId) AS BarCode_OrderInternal
           -- мастер
         , zfFormat_BarCode (zc_BarCodePref_MI(), tmpMI_Master.MovementItemId) AS BarCode_mi
         , tmpMI_Master.MovementItemId
         , tmpMI_Master.GoodsCode
         , tmpMI_Master.GoodsName
         , tmpMI_Master.Article
         , tmpMI_Master.ProdColorName
         , tmpMI_Master.Comment_mi
         , tmpMI_Master.UnitName
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

         , tmpMI_Child.Amount               AS Amount_ch
         , tmpMI_Child.AmountReserv         AS AmountReserv_ch
         , tmpMI_Child.AmountSend           AS AmountSend_ch

         , tmpMI_Child.UnitName             AS UnitName_ch
         , tmpMI_Child.ReceiptLevelName     AS ReceiptLevelName_ch
         , tmpMI_Child.ColorPatternName     AS ColorPatternName_ch
         , tmpMI_Child.ProdColorPatternName AS ProdColorPatternName_ch
         , tmpMI_Child.ProdColorPatternId   AS ProdColorPatternId_ch

         , (SELECT COUNT(*) FROM tmpMI_Child WHERE tmpMI_Child.ParentId = tmpMI_Master.MovementItemId) ::Integer AS mi_child_count

    FROM tmpMI_Master
         LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.MovementItemId
    ORDER BY tmpMI_Master.InvNumber_OrderClient :: Integer
           , 1 , 2
   ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.22         *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternal_Print (inMovementId:= 3897397, inSession:= zfCalc_UserAdmin());

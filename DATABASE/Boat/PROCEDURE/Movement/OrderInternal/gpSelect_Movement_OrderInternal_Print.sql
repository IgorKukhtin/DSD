-- Function: gpSelect_Movement_OrderInternal_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
    vbUserId:= inSession;

OPEN Cursor1 FOR

        SELECT 
            Movement_OrderInternal.Id
          , Movement_OrderInternal.InvNumber
          , Movement_OrderInternal.OperDate             AS OperDate

          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_OrderInternal 
   
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_OrderInternal.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
        WHERE Movement_OrderInternal.Id = inMovementId
          AND Movement_OrderInternal.DescId = zc_Movement_OrderInternal();

    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH
       --все MovementItem
       tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.isErased   = FALSE
                 )

     , tmpMI_Master AS (SELECT MovementItem.Id             AS Id
                             , MovementItem.ObjectId       AS GoodsId
                             , Object_Goods.ObjectCode     AS GoodsCode
                             , Object_Goods.ValueData      AS GoodsName
                             , ObjectDesc.ItemName         AS DescName 
                             , ObjectString_EAN.ValueData     AS EAN
                             , ObjectString_Article.ValueData AS Article
                             , MIString_Comment.ValueData  AS Comment
                             , Object_Unit.ValueData       AS UnitName
                             , zfConvert_StringToNumber (Movement_OrderClient.InvNumber):: TVarChar AS InvNumber_OrderClient 
                             , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumberFull_OrderClient
                             , Object_From.ValueData                      AS FromName 
                             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
                             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN
                        FROM tmpMI AS MovementItem
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                            ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
                           
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                       ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                           LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer

                           LEFT JOIN MovementItemString AS MIString_Comment
                                                        ON MIString_Comment.MovementItemId = MovementItem.Id
                                                       AND MIString_Comment.DescId = zc_MIString_Comment()

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

                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

                           LEFT JOIN ObjectString AS ObjectString_EAN
                                                  ON ObjectString_EAN.ObjectId = MovementItem.ObjectId
                                                 AND ObjectString_EAN.DescId = zc_ObjectString_EAN()
                        WHERE MovementItem.DescId = zc_MI_Master()
                       )

     , tmpMI_Child AS (SELECT MovementItem.Id                  AS Id
                            , MovementItem.ParentId
                            , MovementItem.ObjectId           AS GoodsId
                            , Object_Goods.ObjectCode         AS GoodsCode
                            , Object_Goods.ValueData          AS GoodsName
                            , ObjectString_Article.ValueData  AS Article
                            , MovementItem.Amount            ::TFloat AS Amount
                            , MIFloat_AmountReserv.ValueData ::TFloat AS AmountReserv
                            , MIFloat_AmountSend.ValueData   ::TFloat AS AmountSend
                            , Object_Unit.ValueData                AS UnitName
                            , Object_ReceiptLevel.ValueData        AS ReceiptLevelName
                            , Object_ColorPattern.ValueData        AS ColorPatternName
                            , Object_ProdColorPattern.ValueData    AS ProdColorPatternName
                       FROM tmpMI AS MovementItem
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit() 
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId                            

                            LEFT JOIN MovementItemLinkObject AS MILO_ReceiptLevel
                                                             ON MILO_ReceiptLevel.MovementItemId = MovementItem.Id
                                                            AND MILO_ReceiptLevel.DescId = zc_MILinkObject_ReceiptLevel()
                            LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = MILO_ReceiptLevel.ObjectId
                
                            LEFT JOIN MovementItemLinkObject AS MILO_ColorPattern
                                                             ON MILO_ColorPattern.MovementItemId = MovementItem.Id
                                                            AND MILO_ColorPattern.DescId = zc_MILinkObject_ColorPattern()
                            LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = MILO_ColorPattern.ObjectId
                
                            LEFT JOIN MovementItemLinkObject AS MILO_ProdColorPattern
                                                             ON MILO_ProdColorPattern.MovementItemId = MovementItem.Id
                                                            AND MILO_ProdColorPattern.DescId = zc_MILinkObject_ProdColorPattern()
                            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = MILO_ProdColorPattern.ObjectId
                            
                            LEFT JOIN ObjectString AS ObjectString_Article
                                                ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                               AND ObjectString_Article.DescId   = zc_ObjectString_Article()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountReserv
                                                        ON MIFloat_AmountReserv.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountReserv.DescId = zc_MIFloat_AmountReserv()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSend
                                                        ON MIFloat_AmountSend.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSend.DescId = zc_MIFloat_AmountSend()
                       WHERE MovementItem.DescId = zc_MI_Child()
                       )
  --    
    SELECT --из мастера
           tmpMI_Master.Id
         , tmpMI_Master.GoodsCode
         , tmpMI_Master.GoodsName
         , tmpMI_Master.DescName 
         , tmpMI_Master.EAN
         , tmpMI_Master.Article
         , tmpMI_Master.Comment
         , tmpMI_Master.UnitName
         , tmpMI_Master.InvNumber_OrderClient 
         , tmpMI_Master.InvNumberFull_OrderClient
         , tmpMI_Master.FromName 
         , tmpMI_Master.ProductName
         , tmpMI_Master.CIN
         -- из чайлд
         , tmpMI_Child.ParentId
         , tmpMI_Child.GoodsCode            AS GoodsCode_ch
         , tmpMI_Child.GoodsName            AS GoodsName_ch
         , tmpMI_Child.Article              AS Article_ch
         , tmpMI_Child.Amount               AS Amount_ch
         , tmpMI_Child.AmountReserv         AS AmountReserv_ch
         , tmpMI_Child.AmountSend           AS AmountSend_ch
         , tmpMI_Child.UnitName             AS UnitName_ch
         , tmpMI_Child.ReceiptLevelName     AS ReceiptLevelName_ch
         , tmpMI_Child.ColorPatternName     AS ColorPatternName_ch
         , tmpMI_Child.ProdColorPatternName AS ProdColorPatternName_ch  
         , COUNT (*) OVER (PARTITION BY tmpMI_Master.Id )  ::Integer AS CountOrd 
 
    FROM tmpMI_Master
         LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmpMI_Master.Id
    ;
     
         RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.22         *
*/
-- тест
-- select * from gpSelect_Movement_OrderInternal_Print(inMovementId := 3897397 ,  inSession := '3');

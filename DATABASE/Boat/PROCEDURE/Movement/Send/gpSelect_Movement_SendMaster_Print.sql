-- Function: gpSelect_Movement_SendMaster_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendMaster_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendMaster_Print(
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
            Movement_Send.Id
          , Movement_Send.InvNumber
          , Movement_Send.OperDate             AS OperDate

          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_Send 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_Send.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_Send.Id = inMovementId
          AND Movement_Send.DescId = zc_Movement_Send();

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
     WITH
     tmpMI AS (SELECT MovementItem.ObjectId                           AS GoodsId
                    , MovementItem.Amount
                    , MIFloat_AmountSecond.ValueData                  AS AmountSecond
                    , MIFloat_OperPrice.ValueData                     AS OperPrice
                    , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                    , zfCalc_SummIn (COALESCE (MovementItem.Amount, 0), MIFloat_OperPrice.ValueData, COALESCE (MIFloat_CountForPrice.ValueData, 1)) ::TFloat AS Summ
                    , MovementItem.Id
               FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                              ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                              ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
               )

     , tmpOrderClient AS (SELECT MovementItem.Id
                               , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                               , Movement_OrderClient.OperDate AS OperDate
                               , zfCalc_InvNumber_isErased (MovementDesc_OrderClient.ItemName, Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_order
                               , Object_Product.Id                          AS ProductId
                               , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
                               , Object_Brand.Id                            AS BrandId
                               , Object_Brand.ValueData                     AS BrandName
                               , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
                               , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
                               , Object_Engine.ValueData                    AS EngineName
                               , Object_Model.ValueData                     AS ModelName
                               , (Object_Model.ValueData ||' (' || Object_Brand.ValueData||')') ::TVarChar AS ModelName_full
                               , Object_From.ObjectCode                     AS FromCode
                               , Object_From.ValueData                      AS FromName
                               , ObjectLink_Product_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                               , SUM (MovementItem.Amount) AS Amount
                          FROM tmpMI AS MovementItem
                               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                               LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer
                               LEFT JOIN MovementDesc AS MovementDesc_OrderClient ON MovementDesc_OrderClient.Id = Movement_OrderClient.DescId
   
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                                            ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                                           AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                               LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId
   
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                               --
                               LEFT JOIN ObjectString AS ObjectString_CIN
                                                      ON ObjectString_CIN.ObjectId = Object_Product.Id
                                                     AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
                               LEFT JOIN ObjectString AS ObjectString_EngineNum
                                                      ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                                     AND ObjectString_EngineNum.DescId   = zc_ObjectString_Product_EngineNum()
                               LEFT JOIN ObjectLink AS ObjectLink_Engine
                                                    ON ObjectLink_Engine.ObjectId = Object_Product.Id
                                                   AND ObjectLink_Engine.DescId   = zc_ObjectLink_Product_Engine()
                               LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId
                               LEFT JOIN ObjectLink AS ObjectLink_Brand
                                                    ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                                   AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
                               LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
   
                               LEFT JOIN ObjectLink AS ObjectLink_Model
                                                    ON ObjectLink_Model.ObjectId = Object_Product.Id
                                                   AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
                               LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
   
                               LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                                                    ON ObjectLink_Product_ReceiptProdModel.ObjectId = Object_Product.Id
                                                   AND ObjectLink_Product_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
   
                          GROUP BY MovementItem.Id
                               , MIFloat_MovementId.ValueData
                               , zfCalc_InvNumber_isErased (MovementDesc_OrderClient.ItemName, Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId)
                               , Object_Product.Id
                               , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)
                               , Object_Brand.Id
                               , Object_Brand.ValueData
                               , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased)
                               , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased)
                               , Object_Engine.ValueData
                               , Object_From.ObjectCode
                               , Object_From.ValueData
                               , Object_Model.ValueData
                               , (Object_Model.ValueData ||' (' || Object_Brand.ValueData||')')
                               , Movement_OrderClient.OperDate
                               , ObjectLink_Product_ReceiptProdModel.ChildObjectId
                         )


       SELECT MovementItem.Id          
            , MovementItem.GoodsId      AS GoodsId
            , Object_Goods.ObjectCode   AS GoodsCode
            , Object_Goods.ValueData    AS GoodsName
            , Object_GoodsGroup.ValueData               AS GoodsGroupName
            , ObjectString_Article.ValueData            AS Article
            --, Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName
            , tmpOrderClient.MovementId_order
            , tmpOrderClient.OperDate
            , tmpOrderClient.InvNumber_order
            , tmpOrderClient.ProductId
            , tmpOrderClient.ProductName
            , tmpOrderClient.BrandName
            , tmpOrderClient.ModelName
            , tmpOrderClient.ModelName_full
            , tmpOrderClient.CIN
            , tmpOrderClient.EngineNum
            , tmpOrderClient.FromCode
            , tmpOrderClient.FromName
            
            , MovementItem.Amount           ::TFloat
            , MovementItem.AmountSecond     ::TFloat
            , tmpOrderClient.Amount            ::TFloat AS Amount_unit
            , MovementItem.CountForPrice    ::TFloat
            , MovementItem.OperPrice        ::TFloat
            , MovementItem.Summ             ::TFloat AS Summa

       FROM tmpMI AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
            LEFT JOIN tmpOrderClient ON tmpOrderClient.Id = MovementItem.Id

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = MovementItem.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            -- получаем ReceiptLevel
           /* LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                 ON ObjectLink_ReceiptProdModelChild_Object.ChildObjectId = MovementItem.GoodsId
                                AND ObjectLink_ReceiptProdModelChild_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
             ---берем не удаленные
            LEFT JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                             AND Object_ReceiptProdModelChild.IsErased = FALSE
            -- ReceiptProdModel по лодке
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                  ON ObjectLink_ReceiptProdModel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                 AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                 AND ObjectLink_ReceiptProdModel.ChildObjectId = tmpOrderClient.ReceiptProdModelId

            LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptLevel
                                 ON ObjectLink_ReceiptProdModelChild_ReceiptLevel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                AND ObjectLink_ReceiptProdModelChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
            LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptProdModelChild_ReceiptLevel.ChildObjectId
               */
       ORDER BY tmpOrderClient.OperDate
              , tmpOrderClient.InvNumber_order
            --  , Object_ReceiptLevel.ValueData
              , Object_GoodsGroup.ValueData
              , Object_Goods.ValueData
       
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
-- SELECT * FROM gpSelect_Movement_SendMaster_Print(inMovementId := 3897397 ,  inSession := '3'); -- FETCH ALL "<unnamed portal 1>";

-- Function: gpSelect_Movement_Send_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_Print(
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
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
               )

     , tmpMI_Child AS (SELECT MovementItem.ParentId
                            , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                            , Movement_OrderClient.OperDate AS OperDate
                            , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_order
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
                            , SUM (MovementItem.Amount) AS Amount
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                            LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData :: Integer

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
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Child()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ParentId
                            , MIFloat_MovementId.ValueData
                            , ('№ ' || Movement_OrderClient.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderClient.OperDate) :: TVarChar )
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
                      )

       SELECT MovementItem.Id          
            , MovementItem.GoodsId      AS GoodsId
            , Object_Goods.ObjectCode   AS GoodsCode
            , Object_Goods.ValueData    AS GoodsName
            , tmpMI_Child.MovementId_order
            , tmpMI_Child.OperDate
            , tmpMI_Child.InvNumber_order
            , tmpMI_Child.ProductId
            , tmpMI_Child.ProductName
            , tmpMI_Child.BrandName
            , tmpMI_Child.ModelName
            , tmpMI_Child.ModelName_full
            , tmpMI_Child.CIN
            , tmpMI_Child.EngineNum
            , tmpMI_Child.FromCode
            , tmpMI_Child.FromName
            
            , MovementItem.Amount           ::TFloat
            , tmpMI_Child.Amount            ::TFloat AS Amount_unit
            , MovementItem.CountForPrice    ::TFloat
            , MovementItem.OperPrice        ::TFloat
            , MovementItem.Summ             ::TFloat AS Summa

       FROM tmpMI AS MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
       ORDER BY tmpMI_Child.OperDate
              , tmpMI_Child.InvNumber_order
              , Object_Goods.ValueData
       
;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.09.21         *
*/
-- тест
--select * from gpSelect_Movement_Send_Print(inMovementId := 3897397 ,  inSession := '3');

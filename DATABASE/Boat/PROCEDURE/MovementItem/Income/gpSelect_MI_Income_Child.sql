-- Function: gpSelect_MI_Income_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_Income_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Income_Child(
    IN inMovementId       Integer      , -- ���� ���������
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Article TVarChar
             , Amount TFloat
             , MovementId_OrderClient  Integer, InvNumber_OrderClient_Full  TVarChar
             , MovementId_OrderPartner Integer, InvNumber_OrderPartner_Full TVarChar
             , ProductId Integer, ProductName TVarChar, BrandId Integer, BrandName TVarChar, CIN TVarChar, EngineNum TVarChar, EngineName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������

     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
        WITH tmpIsErased AS (SELECT FALSE AS isErased
                                        UNION ALL
                                       SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                                      )
             -- ������������ �������� ������
           , tmpMI AS (SELECT MovementItem.Id
                            , MovementItem.ParentId
                            , MovementItem.ObjectId   AS GoodsId
                            , MovementItem.Amount
                            , MIFloat_MovementId.ValueData :: Integer AS MovementId_order
                            , MovementItem.isErased
                       FROM tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                      )

       -- �������� - ����� ������� - zc_MI_Child
     , tmpMI_order AS (SELECT tmpMI.MovementId_order  AS MovementId_order
                            , MovementItem.ObjectId   AS GoodsId
                              -- ����� ����������
                            , MIFloat_MovementId.ValueData :: Integer AS MovementId_order_income

                       FROM (SELECT DISTINCT tmpMI.MovementId_order FROM tmpMI) AS tmpMI
                            JOIN MovementItem ON MovementItem.MovementId = tmpMI.MovementId_order
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = FALSE
                                             -- �������� �������
                                             AND MovementItem.ParentId   IS NULL
                            -- ValueData - MovementId ������ ����������
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                      )
        -- ���������
        SELECT MovementItem.Id
             , MovementItem.ParentId
             , MovementItem.GoodsId            AS GoodsId
             , Object_Goods.ObjectCode         AS GoodsCode
             , Object_Goods.ValueData          AS GoodsName
             , ObjectString_Article.ValueData  AS Article
             , MovementItem.Amount

             , Movement_OrderClient.Id         AS MovementId_OrderClient
             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient_Full

             , Movement_OrderPartner.Id        AS MovementId_OrderPartner
             , zfCalc_InvNumber_isErased ('', Movement_OrderPartner.InvNumber, Movement_OrderPartner.OperDate, Movement_OrderPartner.StatusId) AS InvNumber_OrderPartner_Full

             , Object_Product.Id                          AS ProductId
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
             , Object_Brand.Id                            AS BrandId
             , Object_Brand.ValueData                     AS BrandName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
             , zfCalc_ValueData_isErased (ObjectString_EngineNum.ValueData, Object_Product.isErased) AS EngineNum
             , Object_Engine.ValueData                    AS EngineName

             , MovementItem.isErased

        FROM tmpMI AS MovementItem
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

             LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MovementItem.MovementId_order
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                         AND MovementLinkObject_Product.DescId     = zc_MovementLinkObject_Product()
             LEFT JOIN Object AS Object_Product  ON Object_Product.Id  = MovementLinkObject_Product.ObjectId
             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId   = zc_ObjectString_Product_CIN()
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

             LEFT JOIN tmpMI_order ON tmpMI_order.GoodsId          = MovementItem.GoodsId
                                  AND tmpMI_order.MovementId_order = MovementItem.MovementId_order
             LEFT JOIN Movement AS Movement_OrderPartner ON Movement_OrderPartner.Id = tmpMI_order.MovementId_order_income

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.06.21         *
*/

-- ����
-- SELECT * from gpSelect_MI_Income_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());

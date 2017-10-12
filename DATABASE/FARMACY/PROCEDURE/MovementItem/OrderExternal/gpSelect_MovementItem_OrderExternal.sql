-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , CommonCode Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsId Integer, PartnerGoodsCode TVarChar
             , RetailName TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat, PartionGoodsDate TDateTime
             , Comment TVarChar, isErased Boolean
             , isSP Boolean
              )
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbPartnerId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;
     
     --��� ������� ����� ������ ��� �����
     vbPartnerId := (SELECT MovementLinkObject_From.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_From
                     WHERE MovementLinkObject_From.MovementId = inMovementId
                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    );
           
     RETURN QUERY
       SELECT
             tmpMI.Id            AS Id
           , COALESCE(Object_LinkGoods_View.GoodsCode, Object_LinkGoods_View.GoodsCodeInt::TVarChar) ::Integer AS CommonCode
           , COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)     AS GoodsId
           , COALESCE(tmpMI.GoodsCode, tmpGoods.GoodsCode) AS GoodsCode
           , COALESCE(tmpMI.GoodsName, tmpGoods.GoodsName) AS GoodsName
           , tmpMI.PartnerGoodsId       AS PartnerGoodsId 
           , tmpMI.PartnerGoodsCode     AS PartnerGoodsCode
           , Object_Retail.ValueData    AS RetailName
           , tmpMI.Amount               AS Amount
           , tmpMI.Price                AS Price
           , tmpMI.Summ::TFloat         AS Summ
           , tmpMI.PartionGoodsDate     AS PartionGoodsDate
           , tmpMI.Comment              AS Comment
           , FALSE                      AS isErased
           , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods() AND inShowAll = true AND 
                   Object_Goods.isErased = false ) AS tmpGoods

            FULL JOIN (SELECT 
                              MovementItem.Id 
                            , MovementItem.PartnerGoodsCode
                            , MovementItem.PartnerGoodsId
                            , MovementItem.GoodsCode
                            , MovementItem.GoodsName
                            , MovementItem.Amount
                            , MovementItem.Price
                            , MovementItem.Summ
                            , MovementItem.isErased
                            , MovementItem.GoodsId
                            , MovementItem.PartionGoodsDate
                            , MovementItem.Comment
                            
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem_OrderExternal_View AS MovementItem 
                                              ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                -- �������� ����
                LEFT JOIN  ObjectLink AS ObjectLink_Object 
                                      ON ObjectLink_Object.ObjectId = COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)
                                     AND ObjectLink_Object.DescId = zc_ObjectLink_Goods_Object()            
                LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId
                
                -- �������� GoodsMainId
                LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                      ON ObjectLink_Child.ChildObjectId = COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)
                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                      ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                     AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                         ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                        AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()  
                                        
                LEFT JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsmainId = ObjectLink_Main.ChildObjectId
                                               AND Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_Marion()
                                               AND vbPartnerId = 59612 -- �����
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.09.17         *
 06.04.17         * add isSp
 12.12.14                         *
 06.11.14                         *
 20.10.14                         *
 15.07.14                                                       *
 01.07.14                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')

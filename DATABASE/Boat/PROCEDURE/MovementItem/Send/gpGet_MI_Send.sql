-- Function: gpGet_MI_Send()

DROP FUNCTION IF EXISTS gpGet_MI_Send (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Send(
    IN inMovementId        Integer    , -- ���� ������� <��������>
    IN inGoodsId           Integer    , -- ������� ����� ������� ����� �� �����������
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id                 Integer
             , PartionId          Integer
             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , Article            TVarChar
             , PartNumber         TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupId       Integer
             , GoodsGroupName     TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , CountForPrice      TFloat
             , Price              TFloat
             , TotalCount         TFloat
             , Amount          TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbGoodsId   Integer;
   DECLARE vbPartNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

              -- ���������
         RETURN QUERY
         WITH
         tmpPartionGoods AS (SELECT Object_PartionGoods.*
                                  , ROW_NUMBER () OVER (ORDER BY Object_PartionGoods.OperDate DESC, Object_PartionGoods.MovementItemId DESC) AS ORD
                             FROM Object_PartionGoods
                                  LEFT JOIN MovementItemString AS MIString_PartNumber
                                                               ON MIString_PartNumber.MovementItemId = Object_PartionGoods.MovementItemId
                                                              AND MIString_PartNumber.DescId    = zc_MIString_PartNumber()
                             WHERE Object_PartionGoods.ObjectId = inGoodsId
                               AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (TRIM (inPartNumber),'')
                            )

           SELECT -1                               :: Integer AS Id
                , Object_PartionGoods.MovementItemId          AS PartionId
                , Object_Goods.Id                             AS GoodsId
                , Object_Goods.ObjectCode                     AS GoodsCode
                , Object_Goods.ValueData                      AS GoodsName
                , ObjectString_Article.ValueData              AS Article
                , COALESCE (TRIM(inPartNumber),'')    ::TVarChar AS PartNumber
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                , Object_GoodsGroup.Id                        AS GoodsGroupId
                , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                , Object_Partner.ObjectCode                   AS PartnerId
                , Object_Partner.ValueData                    AS PartnerName
                , 1  :: TFloat   AS CountForPrice
                , Object_PartionGoods.ekPrice                 AS Price
                , (COALESCE (inAmount,1) + COALESCE ((SELECT SUM (MI.Amount)
                                                      FROM MovementItem AS MI
                                                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                                        ON MIString_PartNumber.MovementItemId = MI.Id
                                                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                      WHERE MI.MovementId = inMovementId
                                                        AND MI.DescId = zc_MI_Master()
                                                        AND MI.ObjectId = inGoodsId
                                                        AND MI.isErased = FALSE
                                                        AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                                                        ), 0)
                  )                                 :: TFloat AS TotalCount
                , COALESCE (inAmount,1)             :: TFloat AS Amount
    
           FROM Object AS Object_Goods
     
                LEFT JOIN tmpPartionGoods AS Object_PartionGoods ON Object_PartionGoods.ObjectId = Object_Goods.Id AND Object_PartionGoods.Ord = 1
    
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                     ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
    
                LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = COALESCE (Object_PartionGoods.FromId, ObjectLink_Goods_Partner.ChildObjectId)
                LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_Goods_GoodsGroup.ChildObjectId)
    
                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
    
                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()
        
           WHERE Object_Goods.Id = inGoodsId
              AND inGoodsId <> 0
          UNION
           SELECT -1         :: Integer AS Id
                , 0                     AS PartionId
                , 0                     AS GoodsId
                , 0                     AS GoodsCode
                , '' ::TVarChar         AS GoodsName
                , '' ::TVarChar         AS Article
                , '' ::TVarChar         AS PartNumber
                , '' ::TVarChar         AS GoodsGroupNameFull
                , 0                     AS GoodsGroupId
                , '' ::TVarChar         AS GoodsGroupName
                , 0                     AS PartnerId
                , '' ::TVarChar         AS PartnerName
                , 1  :: TFloat          AS CountForPrice
                , 0  ::TFloat           AS Price
                , 1  ::TFloat           AS TotalCount
                , 1  :: TFloat          AS Amount
           WHERE inGoodsId = 0
          ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.04.22         *
*/

-- ����
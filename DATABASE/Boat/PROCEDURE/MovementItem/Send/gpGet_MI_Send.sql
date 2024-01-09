-- Function: gpGet_MI_Send()

DROP FUNCTION IF EXISTS gpGet_MI_Send (Integer, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Send (Integer, Integer, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Send (Integer, Integer, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Send(
    IN inMovementId        Integer    , -- ���� ������� <��������>  
    IN inMovementId_OrderClient Integer, --�������� �����
    IN inId                Integer    , --
    IN inGoodsId           Integer    , -- ������� ����� ������� ����� �� �����������
    IN inPartNumber        TVarChar   , --
    IN inAmount            TFloat     , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id                 Integer
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
             , Amount             TFloat
             , AmountRemainsFrom  TFloat  
             , MovementId_OrderClient Integer
             , InvNumberFull_OrderClient TVarChar 
             , PartionCellId Integer, PartionCellName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ������ ��� ��������
     SELECT Movement.OperDate, MLO_From.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From
                                       ON MLO_From.MovementId = inMovementId
                                      AND MLO_From.DescId     = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

       -- ���������
       RETURN QUERY
       WITH
       tmpRemains AS (SELECT Container.ObjectId                           AS GoodsId
                           , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                           , SUM (Container.Amount)                       AS Remains
                      FROM Container
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = Container.PartionId
                                                       AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                      WHERE Container.WhereObjectId = vbUnitId
                        AND Container.DescId        = zc_Container_Count()
                        AND Container.ObjectId      = inGoodsId
                        AND COALESCE (MIString_PartNumber.ValueData, '') = COALESCE (inPartNumber,'')
                      GROUP BY Container.ObjectId
                             , COALESCE (MIString_PartNumber.ValueData, '')
                     )

     , tmpMI AS (SELECT MI.ObjectId                                  AS GoodsId
                      , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                      , MIFloat_MovementId.ValueData      :: Integer AS MovementId_OrderClient
                      , MILO_PartionCell.ObjectId                    AS PartionCellId
                      , SUM (MI.Amount)                              AS Amount
                 FROM MovementItem AS MI
                      LEFT JOIN MovementItemString AS MIString_PartNumber
                                                   ON MIString_PartNumber.MovementItemId = MI.Id
                                                  AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                  ON MIFloat_MovementId.MovementItemId = MI.Id
                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 
                      LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                       ON MILO_PartionCell.MovementItemId = MI.Id
                                                      AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId     = zc_MI_Master()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'') 
                   AND COALESCE (MIFloat_MovementId.ValueData,0)::Integer = COALESCE (inMovementId_OrderClient,0)
                   AND (MI.Id = inId OR inId = 0)
                 GROUP BY MI.ObjectId
                        , COALESCE (MIString_PartNumber.ValueData, '')
                        , MIFloat_MovementId.ValueData      :: Integer 
                        , MILO_PartionCell.ObjectId 
                )

           SELECT CASE WHEN COALESCE (inId,0) <> 0 THEN inId ELSE -1 END  :: Integer AS Id
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
                , 1  :: TFloat                                AS CountForPrice
                , 0  :: TFloat                                AS Price
                , (/*COALESCE (inAmount,1) +*/ COALESCE (tmpMI.Amount, 0)) :: TFloat AS TotalCount
                , COALESCE (inAmount,1)             :: TFloat AS Amount

                , COALESCE (tmpRemains.Remains, 0)                         :: TFloat AS AmountRemainsFrom

              , Movement_OrderClient.Id                                   AS MovementId_OrderClient
              , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient

              , Object_PartionCell.Id         AS PartionCellId
              , Object_PartionCell.ValueData  AS PartionCellName  
           FROM Object AS Object_Goods
                LEFT JOIN tmpMI ON tmpMI.GoodsId    = Object_Goods.Id
                               AND tmpMI.PartNumber = COALESCE (inPartNumber,'')

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                     ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()

                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
    
                LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = ObjectLink_Goods_Partner.ChildObjectId
                LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = ObjectLink_Goods_GoodsGroup.ChildObjectId
    
                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
    
                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()

                LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = Object_Goods.Id
                                    AND tmpRemains.PartNumber = COALESCE (inPartNumber,'')

                LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmpMI.MovementId_OrderClient 

                LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmpMI.PartionCellId

           WHERE Object_Goods.Id = inGoodsId
              AND inGoodsId <> 0 
          UNION
           SELECT -1         :: Integer AS Id
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
                , 0  ::TFloat           AS AmountRemains
                , inMovementId_OrderClient AS MovementId_OrderClient
                , (SELECT zfCalc_InvNumber_isErased ('', Movement.InvNumber, Movement.OperDate, Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId_OrderClient)::TVarChar AS InvNumberFull_OrderClient                
                , 0    ::Integer        AS PartionCellId
                , NULL::TVarChar        AS PartionCellName
           WHERE inGoodsId = 0
          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.01.24         *
 31.05.23         * add inId
 12.05.22         *
 08.04.22         *
*/

-- ����

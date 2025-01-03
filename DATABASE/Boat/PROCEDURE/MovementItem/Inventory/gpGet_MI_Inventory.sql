-- Function: gpGet_MI_Inventory()

DROP FUNCTION IF EXISTS gpGet_MI_Inventory (Integer, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Inventory (Integer, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Inventory(
    IN inMovementId        Integer    , -- ���� ������� <��������>
    IN inGoodsId           Integer    , -- ������� ����� ������� ����� �� �����������
    IN inPartionCellId     Integer    , --
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
             , GoodsGroupId       Integer
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName     TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , PartionCellId      Integer
             , PartionCellName    TVarChar
             , Price              TFloat
             , OperCount          TFloat
             , TotalCount         TFloat
             , AmountRemains      TFloat
             , AmountDiff         TFloat
             , MovementId_OrderClient Integer
             , InvNumber_OrderClient  TVarChar
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
     SELECT Movement.OperDate, MLO_Unit.ObjectId
            INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = inMovementId
                                      AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
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
          , tmpMI AS (SELECT MI.ObjectId                                   AS GoodsId
                           , COALESCE (MIString_PartNumber.ValueData, '')  AS PartNumber
                           , MILO_PartionCell.ObjectId                     AS PartionCellId      --���������� ��� ���������� �� ����� ���������
                           , MAX (MIFloat_MovementId.ValueData) :: Integer AS MovementId_OrderClient
                           , SUM (MI.Amount)                               AS Amount
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
                      GROUP BY MI.ObjectId
                             , COALESCE (MIString_PartNumber.ValueData, '')
                             --, MIFloat_MovementId.ValueData :: Integer
                             , MILO_PartionCell.ObjectId
                     )
           SELECT -1                               :: Integer AS Id
                , Object_Goods.Id                             AS GoodsId
                , Object_Goods.ObjectCode                     AS GoodsCode
                , Object_Goods.ValueData                      AS GoodsName
                , ObjectString_Article.ValueData              AS Article
                , COALESCE (TRIM(inPartNumber),'') ::TVarChar AS PartNumber
                , Object_GoodsGroup.Id                        AS GoodsGroupId
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                , Object_Partner.Id                           AS PartnerId
                , Object_Partner.ValueData                    AS PartnerName
                , Object_PartionCell.Id                       AS PartionCellId
                , Object_PartionCell.ValueData                AS PartionCellName
                , (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList (vbOperDate, inGoodsId, vbUserId) AS lpGet) :: TFloat  AS Price

                , COALESCE (inAmount, 1)                                          :: TFloat AS OperCount
                , (/*COALESCE (inAmount,1) +*/ COALESCE (tmpMI.Amount, 0))        :: TFloat AS TotalCount
                , COALESCE (tmpRemains.Remains, 0)                                :: TFloat AS AmountRemains
                , (COALESCE (tmpMI.Amount, 0) - COALESCE (tmpRemains.Remains, 0)) :: TFloat AS AmountDiff

                , Movement_OrderClient.Id                                   AS MovementId_OrderClient
                , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient


           FROM Object AS Object_Goods
                LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = Object_Goods.Id
                                    AND tmpRemains.PartNumber = COALESCE (inPartNumber,'')
                LEFT JOIN tmpMI ON tmpMI.GoodsId    = Object_Goods.Id
                               AND tmpMI.PartNumber = COALESCE (inPartNumber,'')

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                     ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

                LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id    = ObjectLink_Goods_Partner.ChildObjectId
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()

                LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmpMI.MovementId_OrderClient

                LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = CASE WHEN COALESCE (tmpMI.PartionCellId,0) = 0 THEN inPartionCellId ELSE tmpMI.PartionCellId END

           WHERE Object_Goods.Id = inGoodsId
             AND inGoodsId <> 0

          UNION
           SELECT -1         :: Integer AS Id
                , 0                     AS GoodsId
                , 0                     AS GoodsCode
                , '' ::TVarChar         AS GoodsName
                , '' ::TVarChar         AS Article
                , '' ::TVarChar         AS PartNumber
                , 0                     AS GoodsGroupId
                , '' ::TVarChar         AS GoodsGroupNameFull
                , '' ::TVarChar         AS GoodsGroupName
                , 0                     AS PartnerId
                , '' ::TVarChar         AS PartnerName
                , inPartionCellId       AS PartionCellId
                , (SELECT Object.ValueData FROM Object WHERE Object.Id = inPartionCellId) ::TVarChar AS PartionCellName

                , 0  ::TFloat           AS Price

                , 1  ::TFloat           AS OperCount
                , 0  ::TFloat           AS TotalCount
                , 0  ::TFloat           AS AmountRemains
                , 0  ::TFloat           AS AmountDiff
                , 0                     AS MovementId_OrderClient
                , '' ::TVarChar         AS InvNumber_OrderClient

           WHERE inGoodsId = 0
          ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.01.24         *
 14.05.23         *
 08.04.22         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Inventory (inMovementId := 604 , inGoodsId := 16242 , inPartNumber := '' , inPartionCellId:= 0, inAmount := 1 ,  inSession := '5');

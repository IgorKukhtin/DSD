-- Function: gpReport_OrderReturnTare_SaleByTransport()

DROP FUNCTION IF EXISTS gpReport_OrderReturnTare_SaleByTransport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderReturnTare_SaleByTransport(
    IN inMovementId_Transport  Integer,   -- 
    IN inSession               TVarChar   -- ������ ������������
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, OperDatePartner TDateTime, InvNumber TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , GoodsId            Integer   -- �� ������
             , GoodsCode          Integer   -- ��� ������
             , GoodsName          TVarChar  -- �����
             , GoodsGroupName     TVarChar  -- ������������ ������ ������
             , GoodsGroupNameFull TVarChar
             , Amount             TFloat    -- 
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
        WITH
           --��������� ������ �� ������� �� ��������
           tmpReport AS (SELECT tmp.*
                         FROM lpReport_OrderReturnTare_SaleByTransport (inMovementId_Transport := inMovementId_Transport, inUserId := vbUserId) AS tmp
                         )
           --
           SELECT Movement.Id               AS MovementId
                , Movement.OperDate         AS OperDate
                , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                , Movement.InvNumber        AS InvNumber
                , Object_Partner.Id         AS PartnerId
                , Object_Partner.ObjectCode AS PartnerCode
                , Object_Partner.ValueData  AS PartnerName

                , Object_Goods.Id              AS GoodsId         --�� ������
                , Object_Goods.ObjectCode      AS GoodsCode       --��� ������
                , Object_Goods.ValueData       AS GoodsName       --�����
                , Object_GoodsGroup.ValueData  AS GoodsGroupName  --������������ ������ ������
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

                , tmpReport.Amount    ::TFloat AS Amount
           FROM tmpReport
                LEFT JOIN Movement ON Movement.Id = tmpReport.MovementId_Sale
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpReport.PartnerId

                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReport.GoodsId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.01.22         *
*/

-- ����
-- SELECT * FROM gpReport_OrderReturnTare_SaleByTransport (inMovementId_Transport := 21590051, inSession:='5'::TVarChar);

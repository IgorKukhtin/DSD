-- Function: lpGet_MovementItem_PriceList()

DROP FUNCTION IF EXISTS lpGet_MovementItem_PriceList (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_PriceList(
    IN inOperDate           TDateTime , -- ���� ��������
    IN inGoodsId            Integer   , --
    IN inUserId             Integer     --
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , MovementItemId Integer, GoodsId Integer
             , ValuePrice          TFloat --  ���� ��� ���
             , ValuePrice_parent   TFloat --  ���� ��� ��� (�������)
             , EmpfPrice           TFloat --  ��������������� ���� ��� ���
             , EmpfPrice_parent    TFloat --  ��������������� ���� ��� ��� (�������)
             , MinCount            TFloat --  ��� ���-�� �������
             , MinCountMult        TFloat --  ������������� ���-�� �������
             , MeasureMult         TFloat --  �����������
             , PartnerId   Integer
             , PartnerName TVarChar
              )
AS
$BODY$
BEGIN

       -- �������� ������
       RETURN QUERY
         WITH tmpData AS (SELECT Movement.Id            AS MovementId
                               , Movement.InvNumber     AS InvNumber
                               , Movement.OperDate      AS OperDate
                               , MovementItem.Id        AS MovementItemId
                               , MovementItem.ObjectId  AS GoodsId

                                 -- ���� ��� ���
                               , MovementItem.Amount            AS ValuePrice
                                 -- ���� ��� ��� (�������)
                               , MIF_PriceParent.ValueData      AS ValuePrice_parent
                                 -- ��������������� ���� ��� ���
                               , CASE WHEN MIF_MeasureMult.ValueData > 0 THEN CAST (MIF_EmpfPriceParent.ValueData / MIF_MeasureMult.ValueData AS NUMERIC (16, 2)) ELSE MIF_EmpfPriceParent.ValueData END  :: TFloat AS EmpfPrice
                                 -- ��������������� ���� ��� ��� (�������)
                               , MIF_EmpfPriceParent.ValueData  AS EmpfPrice_parent
                                 -- ��� ���-�� �������
                               , MIF_MinCount.ValueData         AS MinCount
                                 -- ������������� ���-�� �������
                               , MIF_MinCountMult.ValueData     AS MinCountMult
                                 -- �����������
                               , MIF_MeasureMult.ValueData      AS MeasureMult

                                 --
                               , MLO_Partner.ObjectId   AS PartnerId
                                 -- � �/�
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementLinkObject AS MLO_Partner
                                                             ON MLO_Partner.MovementId = Movement.Id
                                                            AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                               -- ���� ��� ���
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND (MovementItem.ObjectId  = inGoodsId OR COALESCE (inGoodsId, 0) = 0)
                               -- ���� ��� ��� (�������)
                               LEFT JOIN MovementItemFloat AS MIF_PriceParent
                                                           ON MIF_PriceParent.MovementItemId = MovementItem.Id
                                                          AND MIF_PriceParent.DescId         = zc_MIFloat_PriceParent()
                               -- ��������������� ���� ��� ��� (�������)
                               LEFT JOIN MovementItemFloat AS MIF_EmpfPriceParent
                                                           ON MIF_EmpfPriceParent.MovementItemId = MovementItem.Id
                                                          AND MIF_EmpfPriceParent.DescId         = zc_MIFloat_EmpfPriceParent()
                               -- ��� ���-�� �������
                               LEFT JOIN MovementItemFloat AS MIF_MinCount
                                                           ON MIF_MinCount.MovementItemId = MovementItem.Id
                                                          AND MIF_MinCount.DescId         = zc_MIFloat_MinCount()
                               -- ������������� ���-�� �������
                               LEFT JOIN MovementItemFloat AS MIF_MinCountMult
                                                           ON MIF_MinCountMult.MovementItemId = MovementItem.Id
                                                          AND MIF_MinCountMult.DescId         = zc_MIFloat_MinCountMult()
                               -- �����������
                               LEFT JOIN MovementItemFloat AS MIF_MeasureMult
                                                           ON MIF_MeasureMult.MovementItemId = MovementItem.Id
                                                          AND MIF_MeasureMult.DescId         = zc_MIFloat_MeasureMult()

                          WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '12 MONTH') AND inOperDate
                            AND Movement.DescId    = zc_Movement_PriceList()
                            AND Movement.StatusId  = zc_Enum_Status_Complete()
                         )
         -- ���������
         SELECT tmpData.MovementId
              , tmpData.InvNumber
              , tmpData.OperDate
              , tmpData.MovementItemId
              , tmpData.GoodsId
              , tmpData.ValuePrice
              , tmpData.ValuePrice_parent
              , tmpData.EmpfPrice
              , tmpData.EmpfPrice_parent
              , tmpData.MinCount
              , tmpData.MinCountMult
              , tmpData.MeasureMult
              , tmpData.PartnerId
              , Object_Partner.ValueData AS PartnerName
         FROM tmpData
              LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
         WHERE tmpData.Ord = 1
        ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.04.22                                        *
*/

-- ����
-- SELECT * FROM lpGet_MovementItem_PriceList (inOperDate:= CURRENT_TIMESTAMP, inGoodsId:= 1, inUserId:= 1)

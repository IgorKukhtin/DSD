-- ��� ����� �� ���� �� ���������� + ������� + �������������
-- Function: lpSelect_Movement_Promo_Data()

DROP FUNCTION IF EXISTS lpSelect_Movement_Promo_Data (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Movement_Promo_Data(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer     --
)
RETURNS TABLE (MovementId          Integer -- ��������
             , GoodsId             Integer
             , GoodsKindId         Integer
             , MovementPromo       TVarChar
             , TaxPromo            TFloat  
             , PriceWithOutVAT     TFloat  -- ���� �������� ��� ����� ���, � ������ ������, ���
             , PriceWithVAT        TFloat  -- ���� �������� � ������ ���, � ������ ������, ���
             , CountForPrice         TFloat
             , PriceWithOutVAT_orig  TFloat   -- ���� �������� ��� ����� ���, � ������ ������, ���
             , PriceWithVAT_orig     TFloat   -- ���� �������� � ������ ���, � ������ ������, ���
             , isChangePercent     Boolean -- ��������� % ������ �� ��������
              )
AS
$BODY$
BEGIN
     -- RAISE EXCEPTION '% % % %', inOperDate, inPartnerId, inContractId, inUnitId;

     -- ���������
     RETURN QUERY
        SELECT tmp.MovementId
             , tmp.GoodsId
             , tmp.GoodsKindId
             , tmp.MovementPromo
             , tmp.TaxPromo
             , tmp.PriceWithOutVAT
             , tmp.PriceWithVAT
             , tmp.CountForPrice
             , tmp.PriceWithOutVAT_orig
             , tmp.PriceWithVAT_orig
             , tmp.isChangePercent
        FROM lpSelect_Movement_Promo_Data_all (inOperDate     := inOperDate
                                             , inPartnerId    := inPartnerId
                                             , inContractId   := inContractId
                                             , inUnitId       := inUnitId
                                             , inIsReturn     := FALSE
                                              ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 21.08.16                                        *
*/

-- ����
-- SELECT * FROM lpSelect_Movement_Promo_Data (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= 0, inUnitId:= 0) AS tmp LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = GoodsId LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = GoodsKindId LEFT JOIN Movement ON Movement.Id = MovementId

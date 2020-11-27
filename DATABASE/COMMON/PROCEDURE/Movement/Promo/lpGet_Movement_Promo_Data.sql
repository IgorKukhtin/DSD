-- ��� ����� �� ���� �� ����� + ���������� + ������� + �������������
-- Function: lpGet_Movement_Promo_Data()

DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data (TDateTime, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpGet_Movement_Promo_Data (TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_Movement_Promo_Data(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer   , --
    IN inGoodsId      Integer   , --
    IN inGoodsKindId  Integer     --
)
RETURNS TABLE (MovementId          Integer -- ��������
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
     -- ���������
     RETURN QUERY
        SELECT tmp.MovementId
             , tmp.TaxPromo
             , tmp.PriceWithOutVAT
             , tmp.PriceWithVAT
             , tmp.CountForPrice
             , tmp.PriceWithOutVAT_orig
             , tmp.PriceWithVAT_orig
             , tmp.isChangePercent
        FROM lpGet_Movement_Promo_Data_all (inOperDate     := inOperDate
                                          , inPartnerId    := inPartnerId
                                          , inContractId   := inContractId
                                          , inUnitId       := inUnitId
                                          , inGoodsId      := inGoodsId
                                          , inGoodsKindId  := inGoodsKindId
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
-- SELECT * FROM lpGet_Movement_Promo_Data (inOperDate:= CURRENT_DATE, inPartnerId:= 324124, inContractId:= NULL, inUnitId:= 0, inGoodsId:= 2524, inGoodsKindId:= NULL) AS tmp LEFT JOIN Movement ON Movement.Id = MovementId

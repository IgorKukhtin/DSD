-- ��� ����� �� ���� �� ���������� + ������� + �������������
-- Function: lpSelect_Movement_Promo_Data()

DROP FUNCTION IF EXISTS lpSelect_Movement_Promo_Data (TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpSelect_Movement_Promo_Data (TDateTime, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Movement_Promo_Data(
    IN inOperDate     TDateTime , --
    IN inPartnerId    Integer   , --
    IN inContractId   Integer   , --
    IN inUnitId       Integer     --
--  IN inUserId       Integer     --
)
RETURNS TABLE (MovementId          Integer -- ��������
             , GoodsId             Integer
             , GoodsKindId         Integer
             , MovementPromo       TVarChar

             , TaxPromo              TFloat   -- % ��� ����� ������ �����
             , PromoDiscountKindId   Integer -- ��� ������ - % ��� �����

             , PriceWithOutVAT       TFloat  -- ���� �������� ��� ����� ���, � ������ ������, ���
             , PriceWithVAT          TFloat  -- ���� �������� � ������ ���, � ������ ������, ���
             , CountForPrice         TFloat
             , PriceWithOutVAT_orig  TFloat   -- ���� �������� ��� ����� ���, � ������ ������, ���
             , PriceWithVAT_orig     TFloat   -- ���� �������� � ������ ���, � ������ ������, ���

             , isChangePercent       Boolean -- ��������� % ������ �� ��������

               -- �����-��������
             , PromoSchemaKindId     Integer
               -- ����� (���� ��������), ���� �� ���� - ����� �����-��������
             , GoodsId_out           Integer
             , GoodsKindId_out       Integer
               -- �������� m
             , Value_m               TFloat
               -- �������� n
             , Value_n               TFloat
              )
AS
$BODY$
BEGIN
     -- RAISE EXCEPTION '% % % %', inOperDate, inPartnerId, inContractId, inUnitId;
     
     --
     -- IF inUserId = 5 AND 1=1 THEN RETURN; END IF;


     -- ���������
     RETURN QUERY
        SELECT tmp.MovementId
             , tmp.GoodsId
             , tmp.GoodsKindId
             , tmp.MovementPromo

               -- % ��� ����� ������ �����
             , tmp.TaxPromo
               -- ��� ������ - % ��� �����
             , tmp.PromoDiscountKindId

             , tmp.PriceWithOutVAT
             , tmp.PriceWithVAT
             , tmp.CountForPrice
             , tmp.PriceWithOutVAT_orig
             , tmp.PriceWithVAT_orig

             , tmp.isChangePercent

               -- �����-��������
             , tmp.PromoSchemaKindId
               -- ����� (���� ��������), ���� �� ���� - ����� �����-��������
             , tmp.GoodsId_out    
             , tmp.GoodsKindId_out
               -- �������� m
             , tmp.Value_m
               -- �������� n
             , tmp.Value_n

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

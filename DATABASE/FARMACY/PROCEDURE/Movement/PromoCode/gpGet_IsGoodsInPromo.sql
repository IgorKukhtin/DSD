-- �������� �������� �� �������� � �����
DROP FUNCTION IF EXISTS gpGet_IsGoodsInPromo(Integer, Integer, out Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_IsGoodsInPromo (
    IN  inPromoCodeId  				Integer,		  	-- ����� ���
    IN  inGoodsId   				Integer,		  	-- ��������
    OUT outResult 					Boolean,			-- ��������
    IN  inSession     				TVarChar        	-- ������ ������������
)
AS
$BODY$
BEGIN

    outResult := False;
    
    -- ���� ���� ���� �� ���� �������� � ������ ����������� � �����, �� ��������� ������ �� ��� � ���� ������
    IF EXISTS(SELECT  * 
              FROM MovementItem PromoCode
                  INNER JOIN Movement Promo ON Promo.id = PromoCode.movementid
                  INNER JOIN MovementItem PromoGoods ON Promo.id = PromoGoods.movementid 
                                                    AND PromoGoods.descid = zc_MI_Master()                  
                                                    AND PromoGoods.Amount = 1
                                                    AND PromoGoods.isErased = False
              WHERE PromoCode.id = inPromoCodeId) THEN
    	IF EXISTS(SELECT  * 
              FROM MovementItem PromoCode
                  INNER JOIN Movement Promo ON Promo.id = PromoCode.movementid
                  INNER JOIN MovementItem PromoGoods ON Promo.id = PromoGoods.movementid 
                                                    AND PromoGoods.descid = zc_MI_Master()                  
                                                    AND PromoGoods.Amount = 1
                                                    AND PromoGoods.isErased = False
              WHERE PromoCode.id = inPromoCodeId AND PromoGoods.objectid = inGoodsId) THEN
        	outResult := True;
        END IF;
    ELSE
    	outResult := True;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.   ������������ �.�.
 02.02.18                                                                                        *
*/

-- select * from gpGet_IsGoodsInPromo(inPromoCodeId := 356725110, inGoodsId := 4351, inSession := '3');


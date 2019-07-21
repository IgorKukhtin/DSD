-- Function: gpUpdate_Promo_GoodsGroupPromo()

DROP FUNCTION IF EXISTS gpUpdate_Promo_GoodsGroupPromo (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Promo_GoodsGroupPromo(
    IN inGoodsId             Integer   , -- ���� ������� <�����>
    IN inGoodsGroupPromoID   Integer   , -- ������ ������� ��� ����������
    IN inSession             TVarChar    -- ������ ������������
)

RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;
   
   -- �������� <inName>
   IF COALESCE (inGoodsId, 0) = 0 THEN
      RAISE EXCEPTION '������. ����� �� ���������.';
   END IF;
   
    
   -- ��������� �������� <����� ��� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupPromo(), inGoodsId, COALESCE(inGoodsGroupPromoID, 0));
 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsId, vbUserId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.07.19                                                       *
*/
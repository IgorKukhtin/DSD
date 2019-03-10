-- Function: gpUodate_Cash_DoesNotShare()

DROP FUNCTION IF EXISTS gpUodate_Cash_DoesNotShare(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUodate_Cash_DoesNotShare(
    IN inGoodsID             Integer   ,    -- ���� ������� <�����>
    IN inDoesNotShare        BOOLEAN   ,    -- ������� ���������� ������� �������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inGoodsID, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_DoesNotShare(), inGoodsID, inDoesNotShare);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inGoodsID, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUodate_Cash_DoesNotShare(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.   ������ �.�.
 09.03.19                                                                        *

*/
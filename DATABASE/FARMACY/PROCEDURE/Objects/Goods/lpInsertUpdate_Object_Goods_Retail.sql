-- Function: gpInsertUpdate_Object_Goods_Retail()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_Retail(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inMinimumLot          TFloat    ,    -- ��������� ��������
    IN inReferCode           Integer   ,    -- ��� ��� �������� �����������
    IN inReferPrice          TFloat    ,    -- ����������� ���� ��������
    IN inPrice               TFloat    ,    -- ���� ����������
    IN inIsClose             Boolean   ,    -- ��� ������
    IN inTOP                 Boolean   ,    -- ��� - �������
    IN inPercentMarkup	     TFloat    ,    -- % �������
    IN inObjectId            Integer   ,    -- 
    IN inUserId              Integer        -- ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ��������� <����� �������� ����>
     ioId:= lpInsertUpdate_Object_Goods (ioId, inCode, inName, inGoodsGroupId, inMeasureId, inNDSKindId, inObjectId, inUserId, 0, '');

     -- !!!������!!!
     IF inMinimumLot = 0 THEN inMinimumLot := NULL; END IF;   	

     -- ��������� ��� �������� ��� <����� �������� ����>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_MinimumLot(), ioId, inMinimumLot);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ReferCode(), ioId, inReferCode);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ReferPrice(), ioId, inReferPrice);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Price(), ioId, inPrice);

     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Close(), ioId, inIsClose);
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), ioId, inTOP);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), ioId, inPercentMarkup);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (ioId, inUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, Integer, Integer) OWNER TO postgres;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.03.16                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods_Retail

-- Function: lpInsertUpdate_Object_Goods_andArea()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_andArea(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_andArea(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����
    IN inUserId              Integer   ,    -- 
    IN inMakerId             Integer   ,    -- �������������
    IN inAreaId              Integer   ,    -- 
    IN inMakerName           TVarChar  ,    -- �������������
    IN inCheckName           Boolean
)
RETURNS Integer
AS
$BODY$
BEGIN
   
-- RAISE EXCEPTION '<%>', inAreaId;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object_Goods (ioId                  := ioId
                                      , inCode                := inCode
                                      , inName                := inName
                                      , inGoodsGroupId        := inGoodsGroupId
                                      , inMeasureId           := inMeasureId
                                      , inNDSKindId           := inNDSKindId
                                      , inObjectId            := inObjectId
                                      , inUserId              := inUserId
                                      , inMakerId             := inMakerId
                                      , inMakerName           := inMakerName
                                      , inCheckName           := inCheckName
                                      , inAreaId              := COALESCE (inAreaId, 0)
                                       );


  -- ��������� �������� <����� ��� ������>
  PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Area(), ioId, inAreaId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.17                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Goods_andArea

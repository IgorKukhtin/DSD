-- Function: lpInsertUpdate_Object_Goods_andArea()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_andArea(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_andArea(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean);

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
    IN inCodeUKTZED          TVarChar  ,    -- Code UKTZED
    IN inCheckName           Boolean
)
RETURNS Integer
AS
$BODY$
  DECLARE text_var1 text;
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
 
  -- ��������� ��������
  PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_UKTZED(), ioId, inCodeUKTZED);
    
  -- ��������� � ������� �������
  BEGIN
    UPDATE Object_Goods_Juridical SET AreaId      = inAreaId
                                    , UKTZED      = inCodeUKTZED
    WHERE Object_Goods_Juridical.ID = ioId;  
  EXCEPTION
     WHEN others THEN 
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
       PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_andArea', text_var1::TVarChar, inUserId);
  END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.17         * add inCodeUKTZED
 25.10.17                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Goods_andArea

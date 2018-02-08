-- Function: gpInsertUpdate_Object_Goods_MinimumLot()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(TVarChar, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(TVarChar, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_MinimumLot(
    IN inGoodsCode           TVarChar  ,    -- ��� ������� <�����>
    IN inObjectId            Integer   ,    -- ���� ������� <���������>
    IN inMinimumLot          TFloat    ,    -- ����������� ����������
    IN inAreaId              Integer   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
    --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
    vbUserId := inSession;

    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� ����������';
    END IF;
    IF COALESCE(inMinimumLot,0) < 0
    THEN
        RAISE EXCEPTION '������.����������� ���������� <%> �� ����� ���� ������ ����.', inMCSValue;
    END IF;
    
    
    IF COALESCE (inAreaId, 0) = 0 
    THEN
        inAreaId := zc_Area_Basis();      --�����
    END IF;
    
    IF inMinimumLot = 0 
    THEN 
        inMinimumLot := NULL;
    END IF;
    
    -- ���� �� ���� � inObjectId  � ������    
    SELECT Object_Goods_View.Id INTO vbGoodsId
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = inObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode
      AND COALESCE (Object_Goods_View.AreaId, zc_Area_Basis()) = inAreaId;      -- zc_ObjectLink_Goods_Area = NULL, ��� ������ ��� ������ = ����� = zc_Area_Basis() �.�. update ��� ������ ����

    -- IF COALESCE(vbGoodsId,0) = 0
    -- THEN
        -- RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    -- END IF;
    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Goods_MinimumLot(), vbGoodsId, inMinimumLot);    
    END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 08.02.18         *
 15.08.15                                                          *

*/                                          

                                           
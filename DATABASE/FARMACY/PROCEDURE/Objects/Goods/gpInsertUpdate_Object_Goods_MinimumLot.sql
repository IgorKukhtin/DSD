-- Function: gpInsertUpdate_Object_Goods_MinimumLot()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_MinimumLot(TVarChar, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_MinimumLot(
    IN inGoodsCode           TVarChar   ,    -- ��� ������� <�����>
    IN inObjectId            Integer   ,    -- ���� ������� <���������>
    IN inMinimumLot          TFloat    ,    -- ����������� ����������
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
    
    IF inMinimumLot = 0 
    THEN 
        inMinimumLot := NULL;
    END IF;
    -- ���� �� ���� � inObjectId
    SELECT Object_Goods_View.Id INTO vbGoodsId
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = inObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode;   

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
ALTER FUNCTION gpInsertUpdate_Object_Goods_MinimumLot(TVarChar, Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 15.08.15                                                          *

*/                                          

                                           
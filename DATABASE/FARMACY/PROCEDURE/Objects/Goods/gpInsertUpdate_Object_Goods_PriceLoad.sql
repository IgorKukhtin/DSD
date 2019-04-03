-- Function: ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_PriceLoad(TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_PriceLoad(
    IN inGoodsCode           TVarChar  ,    -- ��� ������� <�����>
    IN inPrice               TFloat    ,    -- ����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
BEGIN
    --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
    vbUserId := inSession;

    -- ������������ <�������� ����>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
     
    -- ���� �� ���� � inObjectId    
    SELECT Object_Goods_View.Id 
     INTO vbGoodsId
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = vbObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode;

    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        -- ��������� ����
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Goods_Price(), vbGoodsId, inPrice);    

        IF COALESCE(inPrice,0) > 0
        THEN
            -- ���� ���� � ������ > 0 , ������� ���� ������� zc_ObjectBoolean_Goods_TOP
            -- ��� - �������
            PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), vbGoodsId, TRUE);
        END IF;
    ELSE 
        RAISE EXCEPTION '������.����� � ����� <%> �� ������.', inGoodsCode;
    END IF;
    

END;
$BODY$
LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.04.18         *
*/
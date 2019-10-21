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
   DECLARE text_var1 text;
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

         -- ��������� � ������� �������
        BEGIN

           -- ��������� ����
            -- ���� ���� � ������ > 0 , ������� ���� ������� zc_ObjectBoolean_Goods_TOP
            -- ��� - �������
          UPDATE Object_Goods_Retail SET Price  = inPrice
                                       , isTOP  = CASE WHEN COALESCE(inPrice,0) > 0 THEN TRUE ELSE isTOP END
          WHERE Object_Goods_Retail.GoodsMainId IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
        EXCEPTION
           WHEN others THEN 
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
             PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_Object_Goods_PriceLoad', text_var1::TVarChar, vbUserId);
        END;
    ELSE 
        RAISE EXCEPTION '������.����� � ����� <%> �� ������.', inGoodsCode;
    END IF;
    

END;
$BODY$
LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 21.10.19                                                      * 
 02.04.18         *
*/*/
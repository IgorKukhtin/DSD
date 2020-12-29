-- Function: ()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN1Load(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN1Load(
    IN inGoodsCode           Integer  ,    -- ��� ������� <�����>
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
    SELECT Object_Goods_Main.Id 
     INTO vbGoodsId
    FROM Object_Goods_Main 
    WHERE Object_Goods_Main.ObjectCode = inGoodsCode;

    IF COALESCE(vbGoodsId,0) <> 0
    THEN

       -- ��������� �������� <���������� ���1>
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN1(), vbGoodsId, TRUE);
       
        -- ��������� � ������� �������
       BEGIN
         UPDATE Object_Goods_Main SET isSupplementSUN1 = TRUE
         WHERE Object_Goods_Main.Id = vbGoodsId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Object_Goods_inSupplementSUN1Load', text_var1::TVarChar, vbUserId);
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
 28.12.20                                                      * 
*/
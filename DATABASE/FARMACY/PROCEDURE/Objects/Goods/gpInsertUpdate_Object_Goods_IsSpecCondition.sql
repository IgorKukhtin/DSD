-- Function: gpInsertUpdate_Object_Goods_IsSpecCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_IsSpecCondition(TVarChar, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_IsSpecCondition(
    IN inGoodsCode           TVarChar   ,    -- ��� ������� <�����>
    IN inObjectId            Integer    ,    -- ���� ������� <���������>
    IN inIsSpecCondition     Boolean    ,    -- ����� ��� ���� �������
    IN inSession             TVarChar        -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE text_var1 text;
BEGIN
    --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
    vbUserId := inSession;

    IF COALESCE(inObjectId,0) = 0
    THEN
        RAISE EXCEPTION '������. ������� �������� ����������';
    END IF;
    
    -- ���� �� ���� � inObjectId
    SELECT Object_Goods_View.Id INTO vbGoodsId
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = inObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode;   

    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Goods_SpecCondition(), vbGoodsId, inIsSpecCondition);    

          -- ��������� � ������� �������
        BEGIN
          UPDATE Object_Goods_Juridical SET isSpecCondition = COALESCE(inIsSpecCondition, FALSE)
                                          , UserUpdateId = vbUserId
                                          , DateUpdate   = CURRENT_TIMESTAMP
          WHERE Object_Goods_Juridical.Id = inId
            AND Object_Goods_Juridical.isSpecCondition <> COALESCE(inIsSpecCondition, FALSE);  
        EXCEPTION
           WHEN others THEN 
             GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
             PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_Object_Goods_IsSpecCondition', text_var1::TVarChar, vbUserId);
        END;
    END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Goods_IsSpecCondition(TVarChar, Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 21.10.19                                                                      * 
 18.02.16         *
*/                                          

                          
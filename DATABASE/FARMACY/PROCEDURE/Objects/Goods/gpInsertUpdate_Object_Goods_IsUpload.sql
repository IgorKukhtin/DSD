-- Function: gpInsertUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_IsUpload(TVarChar, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_IsUpload(
    IN inGoodsCode           TVarChar   ,    -- ��� ������� <�����>
    IN inObjectId            Integer    ,    -- ���� ������� <���������>
    IN inIsUpload            Boolean    ,    -- ����������� � ������ ��� ����������
    IN inSession             TVarChar        -- ������� ������������
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
    
    -- ���� �� ���� � inObjectId
    SELECT Object_Goods_View.Id INTO vbGoodsId
    FROM Object_Goods_View 
    WHERE Object_Goods_View.ObjectId = inObjectId
      AND Object_Goods_View.GoodsCode = inGoodsCode;   

/*     IF COALESCE(vbGoodsId,0) = 0
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    END IF; */
    IF COALESCE(vbGoodsId,0) <> 0
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Goods_IsUpload(), vbGoodsId, inIsUpload);    
    END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods_IsUpload(TVarChar, Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 23.11.15                                                          *
*/                                          

                                           
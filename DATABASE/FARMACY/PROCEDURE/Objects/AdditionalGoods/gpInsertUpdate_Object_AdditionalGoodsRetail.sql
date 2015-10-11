DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AdditionalGoodsRetail (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AdditionalGoodsRetail(
    IN inGoodsMainCode      TVarChar   , -- ������� �����
    IN inGoodsSecondCode    TVarChar   , -- ����� ��� ������
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;   
   DECLARE vbGoodsMainId Integer;
   DECLARE vbGoodsSecondId  Integer;
   DECLARE vbId  Integer;
   DECLARE vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession(inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    SELECT Id INTO vbGoodsMainId FROM Object_Goods_View
    WHERE ObjectId = vbObjectId AND GoodsCode = inGoodsMainCode;

    SELECT Id INTO vbGoodsSecondId FROM Object_Goods_View
    WHERE ObjectId = vbObjectId AND GoodsCode = inGoodsSecondCode;

    SELECT Id INTO vbId 
    FROM Object_AdditionalGoods_View
    WHERE Object_AdditionalGoods_View.GoodsMainId = vbGoodsMainId 
      AND Object_AdditionalGoods_View.GoodsSecondId = vbGoodsSecondId;

    IF (COALESCE(vbId,0) = 0) AND (COALESCE(vbGoodsMainId,0) <> 0) AND (COALESCE(vbGoodsSecondId,0) <> 0)
    THEN
        -- ��������� <������>
        vbId := lpInsertUpdate_Object (vbId, zc_Object_AdditionalGoods(), 0, '');
       
        -- ��������� ����� � <������� �������>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsMain(), vbId, vbGoodsMainId);   
        -- ��������� ����� � <��� �������>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_AdditionalGoods_GoodsSecond(), vbId, vbGoodsSecondId);

        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (inObjectId:= vbId, inUserId:= vbUserId, inIsUpdate:= FALSE, inIsErased:= NULL);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AdditionalGoodsRetail (TVarChar, TVarChar, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 11.10.15                                                          *
*/
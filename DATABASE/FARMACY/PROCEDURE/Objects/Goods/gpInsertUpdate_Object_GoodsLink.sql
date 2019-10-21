-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLink(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsMainId         Integer   ,    -- ������ �� ������� �����
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbId Integer;
   DECLARE text_var1 text;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   vbUserId := inSession;
   
   IF COALESCE(ioId, 0) = 0 THEN
     -- ���� �� ���� � inObjectId
     SELECT Object_Goods_View.Id INTO vbGoodsId
       FROM Object_Goods_View 
      WHERE Object_Goods_View.ObjectId = inObjectId
        AND Object_Goods_View.GoodsCode = inCode;   
    ELSE
      vbGoodsId := ioId;
    END IF;
   
    ioId := lpInsertUpdate_Object_Goods(vbGoodsId, inCode, inName, 0, 0, 0, inObjectId, vbUserId);

    SELECT Id INTO vbId 
       FROM Object_LinkGoods_View
      WHERE Object_LinkGoods_View.GoodsMainId = inGoodsMainId 
        AND Object_LinkGoods_View.GoodsId = vbGoodsId;

     IF COALESCE(vbId, 0) = 0 THEN
                 PERFORM gpInsertUpdate_Object_LinkGoods(
                                   ioId := 0                     ,  
                                   inGoodsMainId := inGoodsMainId, -- ������� �����
                                   inGoodsId  := vbGoodsId       , -- ����� ��� ������
                                   inSession  := inSession         -- ������ ������������
                                   );
     END IF;    

      -- ��������� � ������� �������
     BEGIN

       PERFORM lpInsertUpdate_Object_Goods_Link (vbGoodsId, inGoodsMainId, inObjectId, vbUserId); 
     EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
          PERFORM gpInsertUpdate_Object_GoodsLink('lpInsertUpdate_Object_Goods_Link', text_var1::TVarChar, vbUserId);
     END;

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 21.10.19                                                      *
 19.07.14                        *

*/                                          

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods

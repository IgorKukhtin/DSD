-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLoad(Integer, TVarChar, Integer, TVarChar, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLoad(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inMainCode            INTEGER   ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inObjectId            Integer   ,    -- �������� ����
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDS                 TFloat     ,    -- ���

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
  DECLARE vbNDSKindId Integer;
  DECLARE vbUserId Integer;
  DECLARE vbGoodsMainId Integer;
  DECLARE vbLinkId Integer;
BEGIN

    vbUserId := inSession;

    IF inNDS = 20 THEN 
       vbNDSKindId  := zc_Enum_NDSKind_Common();
    ELSE
       vbNDSKindId  := zc_Enum_NDSKind_Medical();
    END IF; 

    IF COALESCE(ioId, 0) = 0 THEN
       SELECT Object_Goods_View.Id INTO ioId
         FROM Object_Goods_View 
        WHERE Object_Goods_View.ObjectId = inObjectId
          AND Object_Goods_View.GoodsCode = inCode;   
    END IF; 

    ioId := lpInsertUpdate_Object_Goods(ioId, inCode, inName, 0, inMeasureId, vbNDSKindId, inObjectId, vbUserId);

     SELECT Id INTO vbGoodsMainId FROM Object_Goods_View
      WHERE ObjectId IS NULL AND GoodsCodeInt = inMainCode;

     SELECT Id INTO vbLinkId 
       FROM Object_LinkGoods_View
      WHERE Object_LinkGoods_View.GoodsMainId = vbGoodsMainId 
        AND Object_LinkGoods_View.GoodsId = ioId;

     IF COALESCE(vbLinkId, 0) = 0 THEN
                 PERFORM gpInsertUpdate_Object_LinkGoods(
                                   ioId := 0                     ,  
                                   inGoodsMainId := vbGoodsMainId, -- ������� �����
                                   inGoodsId  := ioId            , -- ����� ����
                                   inSession  := inSession         -- ������ ������������
                                   );
     END IF;  


END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLoad(Integer, TVarChar, TVarChar, Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.14                        *
 30.07.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods

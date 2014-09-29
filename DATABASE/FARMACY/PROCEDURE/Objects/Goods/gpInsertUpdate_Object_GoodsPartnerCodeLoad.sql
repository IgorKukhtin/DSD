
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPartnerCodeLoad(TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPartnerCodeLoad(
    IN inOKPO                TVarChar  ,    -- ����
    IN inMainCode            Integer   ,    -- ��� ������
    IN inGoodsCode           TVarChar  ,    -- ��� ������ ��������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
DECLARE vbJuridicalId Integer;
DECLARE vbGoodsMainId Integer;
BEGIN

   SELECT Id INTO vbGoodsMainId
     FROM Object_Goods_Main_View
    WHERE Object_Goods_Main_View.GoodsCode = inMainCode;

      SELECT JuridicalId INTO vbJuridicalId
        FROM ObjectHistory_JuridicalDetails_View
       WHERE OKPO = inOKPO;
   
   IF (COALESCE(vbGoodsMainId, 0) <> 0) AND (COALESCE(vbJuridicalId, 0) <> 0) THEN
      PERFORM gpInsertUpdate_Object_GoodsLink(0, inGoodsCode, inGoodsCode, vbGoodsMainId, vbJuridicalId, inSession);
   END IF;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsPartnerCodeLoad(TVarChar, Integer, TVarChar, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.07.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods

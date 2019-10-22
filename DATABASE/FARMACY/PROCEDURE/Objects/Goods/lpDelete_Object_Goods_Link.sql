-- Function: lpDelete_Object_Goods_Link()

DROP FUNCTION IF EXISTS lpDelete_Object_Goods_Link(Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpDelete_Object_Goods_Link(
    IN inGoodsId             Integer   ,    -- ���� ������� <�����>
    IN inGoodsMainId         Integer   ,    -- ���� ������� <������� �����>
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����

    IN inUserId              Integer       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE text_var1 text;
BEGIN

     -- ��������� � ������� �������
    BEGIN

         -- ****** ���� ����� ����������
       IF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Juridical())
       THEN

            -- ���� ���� ����� ��������
            IF EXISTS(SELECT 1 FROM Object_Goods_Juridical
                      WHERE COALESCE(Object_Goods_Juridical.GoodsMainId, 0) <> 0
                        AND Object_Goods_Juridical.Id = inGoodsId
                        AND (COALESCE(Object_Goods_Juridical.GoodsMainId, 0) = COALESCE(inGoodsMainId, 0) 
                          OR COALESCE(inGoodsMainId, 0) = 0))
            THEN
              UPDATE Object_Goods_Juridical SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Juridical.Id = inGoodsId;
            END IF;

         -- ************* ���� ����� ����
       ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Retail())
       THEN

            -- ���� ���� ����� ��������
            IF EXISTS(SELECT 1 FROM Object_Goods_Retail
                      WHERE COALESCE(Object_Goods_Retail.GoodsMainId, 0) <> 0
                        AND Object_Goods_Retail.Id = inGoodsId
                        AND (COALESCE(Object_Goods_Retail.GoodsMainId, 0) = COALESCE(inGoodsMainId, 0) 
                          OR COALESCE(inGoodsMainId, 0) = 0))
            THEN
              UPDATE Object_Goods_Retail SET GoodsMainId = NULL
                                           , UserUpdateId = inUserId
                                           , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Retail.Id = inGoodsId;
            END IF;
       
         -- ����� � ����������
       ELSEIF inObjectId =zc_Enum_GlobalConst_BarCode()
       THEN
       
         -- ������� ����� � ����� ����������       
         
         IF EXISTS(SELECT 1 FROM Object_Goods_BarCode WHERE  GoodsMainId = inGoodsMainId AND BarCodeId = inGoodsId)
         THEN
         
           DELETE FROM Object_Goods_BarCode WHERE  GoodsMainId = inGoodsMainId AND BarCodeId = inGoodsId;
         END IF;
       ELSEIF inObjectId =  zc_Enum_GlobalConst_Marion()
       THEN
          UPDATE Object_Goods_Main SET MorionCode = NULL
          WHERE Object_Goods_Main.Id = inGoodsMainId;
       ELSE
    /*     RAISE EXCEPTION '�������� <(%) %> �� ���������.', inObjectId,
           COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                     FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                     WHERE Object_GoodsObject.Id = inObjectId), '');
    */
            PERFORM lpAddObject_Goods_Temp_Error('lpDelete_Object_Goods_Link',
                Format('�������� <(%s) %s> �� ���������. ����� %s ������� ����� %s', inObjectId,
                       COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                       FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                       WHERE Object_GoodsObject.Id = inObjectId), ''), inGoodsId, inGoodsMainId) , inUserId);
       END IF;

    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('lpDelete_Object_Goods_Link', text_var1::TVarChar, inUserId);
    END;

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpDelete_Object_Goods_Link(Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 21.10.19                                                      *

*/

-- ����
-- SELECT * FROM lpDelete_Object_Goods_Link
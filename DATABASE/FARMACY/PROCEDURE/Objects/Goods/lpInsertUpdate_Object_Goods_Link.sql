-- Function: lpInsertUpdate_Object_Goods_Link()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Link(Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_Link(
    IN inGoodsId             Integer   ,    -- ���� ������� <�����>
    IN inGoodsMainId         Integer   ,    -- ������ �� ������� �����
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����

    IN inUserId              Integer       -- ������� ������������
)
RETURNS integer AS
$BODY$
   DECLARE text_var1 text;
BEGIN

     -- ��������� � ������� �������
    BEGIN

         -- ****** ���� ����� ����������
       IF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Juridical())
       THEN

          IF COALESCE(inGoodsMainId, 0) = 0
          THEN

            -- ���� ���� ����� ��������
            IF EXISTS(SELECT 1 FROM Object_Goods_Juridical
                      WHERE COALESCE(Object_Goods_Juridical.GoodsMainId, 0) <> 0
                        AND Object_Goods_Juridical.Id = inGoodsId)
            THEN
              UPDATE Object_Goods_Juridical SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Juridical.Id = inGoodsId;
            END IF;

          ELSE

            -- ���� ���� ����� �� ������ ����� ��������
            IF EXISTS(SELECT 1 FROM Object_Goods_Juridical
                      WHERE Object_Goods_Juridical.GoodsMainId = inGoodsMainId
                        AND Object_Goods_Juridical.Id <> inGoodsId)
            THEN
              UPDATE Object_Goods_Juridical SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Juridical.GoodsMainId = inGoodsMainId
                AND Object_Goods_Juridical.Id <> inGoodsId;
            END IF;

            -- ������������� �����
            UPDATE Object_Goods_Juridical SET GoodsMainId = NULLIF(inGoodsMainId, 0)
                                            , UserUpdateId = inUserId
                                            , DateUpdate   = CURRENT_TIMESTAMP
            WHERE Object_Goods_Juridical.Id = inGoodsId
              AND COALESCE(Object_Goods_Juridical.GoodsMainId, 0) <> COALESCE(inGoodsMainId, 0);
          END IF;

         -- ************* ���� ����� ����
       ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Retail())
       THEN

          IF COALESCE(inGoodsMainId, 0) = 0
          THEN

            -- ���� ���� ����� ��������
            IF EXISTS(SELECT 1 FROM Object_Goods_Retail
                      WHERE COALESCE(Object_Goods_Retail.GoodsMainId, 0) <> 0
                        AND Object_Goods_Retail.Id = inGoodsId)
            THEN
              UPDATE Object_Goods_Retail SET GoodsMainId = NULL
                                           , UserUpdateId = inUserId
                                           , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Retail.Id = inGoodsId;
            END IF;

          ELSE

            -- ���� ���� ����� �� ������ ����� ��������
            IF EXISTS(SELECT 1 FROM Object_Goods_Retail
                      WHERE Object_Goods_Retail.GoodsMainId = inGoodsMainId
                        AND Object_Goods_Retail.Id <> inGoodsId)
            THEN
              UPDATE Object_Goods_Retail SET GoodsMainId = NULL
                                              , UserUpdateId = inUserId
                                              , DateUpdate   = CURRENT_TIMESTAMP
              WHERE Object_Goods_Retail.GoodsMainId = inGoodsMainId
                AND Object_Goods_Retail.Id <> inGoodsId;
            END IF;

            -- ������������� �����
            UPDATE Object_Goods_Retail SET GoodsMainId = NULLIF(inGoodsMainId, 0)
                                            , UserUpdateId = inUserId
                                            , DateUpdate   = CURRENT_TIMESTAMP
            WHERE Object_Goods_Retail.Id = inGoodsId
              AND COALESCE(Object_Goods_Retail.GoodsMainId, 0) <> COALESCE(inGoodsMainId, 0);
          END IF;
       
         -- ����� � ����������
       ELSEIF inObjectId = zc_Enum_GlobalConst_BarCode()
       THEN
       
         -- ����� � ����� ����������       
         
         PERFORM lpInsertUpdate_Object_Goods_BarCode (inGoodsMainId, inGoodsId, 
                 (SELECT Object_Goods_BarCode.ValueData FROM Object AS Object_Goods_BarCode WHERE Object_Goods_BarCode.Id = inGoodsId), inUserId);
       ELSEIF inObjectId =  zc_Enum_GlobalConst_Marion()
       THEN
            -- ������������� ����� �������       
         IF COALESCE((SELECT Object_Goods_Morion.ObjectCode FROM Object AS Object_Goods_Morion WHERE Object_Goods_Morion.Id = inGoodsId), 0) <>
            COALESCE((SELECT Object_Goods_Main.MorionCode FROM Object_Goods_Main WHERE Object_Goods_Main.Id = inGoodsMainId), 0)
         THEN
            UPDATE Object_Goods_Main SET MorionCode = NULLIF((SELECT Object_Goods_Morion.ObjectCode AS MorionCode 
                                                              FROM Object AS Object_Goods_Morion 
                                                              WHERE Object_Goods_Morion.Id = inGoodsId), 0)
                                            , UserUpdateId = inUserId
                                            , DateUpdate   = CURRENT_TIMESTAMP
            WHERE Object_Goods_Main.Id = inGoodsMainId;
         END IF;
       ELSE 
    /*     RAISE EXCEPTION '�������� <(%) %> �� ���������.', inObjectId,
           COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                     FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                     WHERE Object_GoodsObject.Id = inObjectId), '');
    */
            PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Link',
                Format('�������� <(%s) %s> �� ���������.', inObjectId,
                       COALESCE((SELECT ObjectDesc_GoodsObject.ItemName
                       FROM Object AS Object_GoodsObject
                          LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId
                       WHERE Object_GoodsObject.Id = inObjectId), '')) , inUserId);
       END IF;

    EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Link', text_var1::TVarChar, vbUserId);
    END;

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods_Link(Integer, Integer, Integer, Integer) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 21.10.19                                                      *

*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Goods_Link
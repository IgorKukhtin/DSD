-- Function: gpUpdate_Goods_NDS()

DROP FUNCTION IF EXISTS gpUpdate_Goods_NDS(Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_NDS(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inNDS                 TFloat    ,    -- NDS_Goods
    IN inNDS_PriceList       TFloat    ,    -- NDS_PriceList
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   IF inNDS_PriceList = inNDS THEN 
      RETURN;
   END IF;   
   
   vbUserId := lpGetUserBySession (inSession);

   -- ��������� �������� <���> ��� ���� �����
   PERFORM 
           -- ��������� ����� �������� ���
           lpInsertUpdate_ObjectLink(inDescId        := zc_ObjectLink_Goods_NDSKind()
                                   , inObjectId      := COALESCE (tmpGoods.GoodsId, inId)
                                   , inChildObjectId := (SELECT OF_NDSKind_NDS.ObjectId
                                                         FROM ObjectFloat AS OF_NDSKind_NDS
                                                         WHERE OF_NDSKind_NDS.DescId    = zc_ObjectFloat_NDSKind_NDS()
                                                           AND OF_NDSKind_NDS.ValueData = inNDS_PriceList)
                                   ) 
         -- ��� ���������� �������� ��� ��� �� ���� = ��, ����� ���
         , CASE WHEN inNDS_PriceList < inNDS 
                THEN lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), COALESCE (tmpGoods.GoodsId, inId), TRUE)
                ELSE lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), COALESCE (tmpGoods.GoodsId, inId), FALSE)
           END
         -- ��� ���������� �������� ��� ������� = ������� ��� (inNDS), ����� = 0
         , CASE WHEN inNDS_PriceList < inNDS 
                THEN lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), COALESCE (tmpGoods.GoodsId, inId), inNDS)
                ELSE lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), COALESCE (tmpGoods.GoodsId, inId), 0)
           END

   FROM Object AS Object_Retail
        LEFT JOIN (SELECT DISTINCT
                          COALESCE (ObjectLink_LinkGoods_Goods_find.ChildObjectId, Object_Goods.Id) AS GoodsId
                        , ObjectLink_Goods_Object.ChildObjectId                                     AS RetailId
                   FROM Object AS Object_Goods
                        LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                             ON ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                            AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                             ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId
                                            AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                        LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain_find
                                             ON ObjectLink_LinkGoods_GoodsMain_find.ChildObjectId = ObjectLink_LinkGoods_GoodsMain.ChildObjectId
                                            AND ObjectLink_LinkGoods_GoodsMain_find.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                        LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods_find
                                             ON ObjectLink_LinkGoods_Goods_find.ObjectId = ObjectLink_LinkGoods_GoodsMain_find.ObjectId
                                            AND ObjectLink_LinkGoods_Goods_find.DescId = zc_ObjectLink_LinkGoods_Goods()

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                             ON ObjectLink_Goods_Object.ObjectId = COALESCE (ObjectLink_LinkGoods_Goods_find.ChildObjectId, Object_Goods.Id)
                                            AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                   WHERE Object_Goods.Id = inId
                  ) AS tmpGoods ON tmpGoods.RetailId = Object_Retail.Id AND tmpGoods.GoodsId > 0
   WHERE Object_Retail.DescId = zc_Object_Retail();
   
    -- ��������� � ������� �������
   BEGIN
       -- ��������� ����� �������� ��� � ������� �����
     UPDATE Object_Goods_Main SET NDSKindId = (SELECT OF_NDSKind_NDS.ObjectId
                                               FROM ObjectFloat AS OF_NDSKind_NDS
                                               WHERE OF_NDSKind_NDS.DescId    = zc_ObjectFloat_NDSKind_NDS()
                                               AND OF_NDSKind_NDS.ValueData = inNDS_PriceList)
     WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  

       -- ��� ���������� �������� ��� ��� �� ���� = ��, ����� ���
       -- ��� ���������� �������� ��� ������� = ������� ��� (inNDS), ����� = 0
     UPDATE Object_Goods_Retail SET isTOP         = CASE WHEN inNDS_PriceList < inNDS THEN TRUE ELSE FALSE END
                                  , PercentMarkup = CASE WHEN inNDS_PriceList < inNDS THEN inNDS ELSE 0 END
     WHERE Object_Goods_Retail.GoodsMainId IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_NDS', text_var1::TVarChar, vbUserId);
   END;
   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 17.10.19                                                                      *         
 04.01.18         *
*/

-- ����
-- Function: gpUpdate_Goods_GoodsPairSun()

DROP FUNCTION IF EXISTS gpUpdate_Goods_GoodsPairSun(Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_GoodsPairSun(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_GoodsPairSun(
    IN inId             Integer   ,    -- ���� ������� <>
    IN inGoodsPairSunId Integer   ,    --
    IN inPairSunAmount  TFloat    ,    --
    IN inSession        TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbGoodsPairSunId Integer;
   DECLARE text_var1     text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpGetUserBySession (inSession);

   -- �������� zc_ObjectDate_Goods_PairSun ����������� ���������, ����� ������� ���������� zc_ObjectLink_Goods_GoodsPairSun
   vbGoodsPairSunId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_Goods_GoodsPairSun() AND ObjectLink.ObjectId = inId);

   -- ���������� ������ ��� ������ ����������
   IF COALESCE (vbGoodsPairSunId,0) = 0 AND COALESCE (inGoodsPairSunId) <> 0
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_PairSun(), inId, CURRENT_Date);

       -- ��������� � ������� �������
       BEGIN
         UPDATE Object_Goods_Retail SET PairSunDate = CURRENT_Date
         WHERE Object_Goods_Retail.Id = inId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_PairSunDate', text_var1::TVarChar, vbUserId);
       END;

   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPairSun(), inId, inGoodsPairSunId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PairSunAmount(), inId, inPairSunAmount);

   -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Retail SET GoodsPairSunId = inGoodsPairSunId
                                  , PairSunAmount  = inPairSunAmount
     WHERE Object_Goods_Retail.Id = inId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_GoodsPairSunId', text_var1::TVarChar, vbUserId);
   END;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.05.20         *
*/


-- select * from gpUpdate_Goods_GoodsPairSun(inGoodsId := 596529 , inGoodsPairSunId := 42562 , inPairSunAmount := 2 ,  inSession := '3');
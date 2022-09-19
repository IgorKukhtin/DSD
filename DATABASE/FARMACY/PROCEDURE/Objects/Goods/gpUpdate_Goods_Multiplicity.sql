-- Function: gpUpdate_Goods_Multiplicity()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Multiplicity(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Multiplicity(
    IN inGoodsMainId             Integer   ,   -- ���� ������� <�����>
    IN inMultiplicity            TFloat  ,    -- ���������� ���1
    IN inSession                 TVarChar      -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;
   
/*   IF inMultiplicity <> 0
   THEN
     IF CEIL(1.0 / inMultiplicity) <> (1.0 / inMultiplicity) OR 
     THEN
        RAISE EXCEPTION '������. ��������� �������� �� ������ 1.';
     END IF;
   END IF;
*/
   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� �������� <���������� ���1>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Multiplicity(), inGoodsMainId, inMultiplicity);
   -- ��������� �������� <������������ ��� ��������� ��� �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_MultiplicityError(), inGoodsMainId, COALESCE (inMultiplicity, 0) <> 0);
   
    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET Multiplicity = inMultiplicity
                                , isMultiplicityError = COALESCE (inMultiplicity, 0) <> 0
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Multiplicity', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.03.21                                                       *  

*/

-- ����
--select * from gpUpdate_Goods_Multiplicity(inGoodsMainId := 39513 , inMultiplicity := '',  inSession := '3');
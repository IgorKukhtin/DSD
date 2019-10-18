-- Function: gpUpdate_Goods_isNotUploadSites()

DROP FUNCTION IF EXISTS gpUpdate_Goods_DoesNotShare(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_DoesNotShare(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inDoesNotShare        Boolean   ,    -- �� ������ �� ������
   OUT outDoesNotShare       Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN


   IF COALESCE(inId, 0) = 0 THEN
      outDoesNotShare := inDoesNotShare;
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outDoesNotShare := inDoesNotShare;

   IF inDoesNotShare = True or EXISTS(SELECT * FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inId and ObjectBoolean.DescId = zc_ObjectBoolean_Goods_DoesNotShare())
   THEN
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_DoesNotShare(), inId, inDoesNotShare);

      -- ��������� � ������� �������
     BEGIN
       UPDATE Object_Goods_Main SET isDoesNotShare = inDoesNotShare
       WHERE Object_Goods_Main.Id IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
     EXCEPTION
        WHEN others THEN 
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
          PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_DoesNotShare', text_var1::TVarChar, vbUserId);
     END;

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

   END IF;
   

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.10.19                                                       *  
 15.03.19                                                       *         

*/

-- ����
-- SELECT * FROM gpUpdate_Goods_DoesNotShare
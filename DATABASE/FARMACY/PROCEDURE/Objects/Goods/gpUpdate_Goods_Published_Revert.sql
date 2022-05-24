-- Function: gpUpdate_Object_Goods_Published()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Published_Revert(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_Published_Revert(
    IN inId                  Integer   ,    -- ���� ������� <�����>
    IN inIsPublished         Boolean   ,    -- ����������� �� �����
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

    vbUserId := lpGetUserBySession (inSession);

    
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Published(), inId, not inIsPublished);
    
    -- ��������� � ������� �������
    BEGIN
      UPDATE Object_Goods_Main SET isPublished = not inIsPublished
                                 , DateUpdateSite = CURRENT_TIMESTAMP
      WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
    EXCEPTION
       WHEN others THEN 
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
         PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Published_Revert', text_var1::TVarChar, vbUserId);
    END;
              
    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Goods_Published(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 17.05.22                                                                      *         
*/

--select * from gpUpdate_Goods_Published_Revert(inId := 559417 , inIsPublished := 'True' ,  inSession := '3');
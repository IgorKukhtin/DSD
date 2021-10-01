-- Function: gpUpdate_Object_GoodsAdditional()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsAdditional(Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsAdditional(
    IN inId                  Integer ,    -- ���� ������� <����� �������>
    IN inMakerName           TVarChar,    -- �������������
    IN inFormDispensingId    Integer ,    -- ����� �������
    IN inNumberPlates        Integer ,    -- ���-�� ������� � ��������:
    IN inQtyPackage          Integer ,    -- ���-�� � ��������:
    IN inIsRecipe            Boolean ,    -- ���������
    IN inSession             TVarChar     -- ������� ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE text_var1 text;
BEGIN

   vbUserId := inSession;

   IF COALESCE(inId, 0) = 0 OR
      EXISTS(SELECT * 
             FROM Object_Goods_Main
             WHERE Object_Goods_Main.Id                                = inId
               AND COALESCE(Object_Goods_Main.MakerName, '')           = COALESCE(inMakerName, '')  
               AND COALESCE(Object_Goods_Main.FormDispensingId, 0)     = COALESCE(inFormDispensingId, 0)  
               AND COALESCE(Object_Goods_Main.NumberPlates, 0)         = COALESCE(inNumberPlates, 0)  
               AND COALESCE(Object_Goods_Main.QtyPackage, 0)           = COALESCE(inQtyPackage, 0)  
               AND COALESCE(Object_Goods_Main.IsRecipe, False)         = COALESCE(inIsRecipe, FALSE)) 
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Maker(), inId, inMakerName);

   -- ��������� �������� <����� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_FormDispensing(), inId, inFormDispensingId);

   -- ��������� �������� <���-�� ������� � ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_NumberPlates(), inId, inNumberPlates);
   -- ��������� �������� <���-�� � ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_QtyPackage(), inId, inQtyPackage);
   
   -- ��������� �������� <���������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Recipe(), inId, inIsRecipe);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET MakerName          = NULLIF(inMakerName, '')  
                                , FormDispensingId   = NULLIF(inFormDispensingId, 0)  
                                , NumberPlates       = NULLIF(inNumberPlates, 0)    
                                , QtyPackage         = NULLIF(inQtyPackage, 0)    
                                , IsRecipe           = COALESCE(inIsRecipe, FALSE)  
     WHERE Object_Goods_Main.Id = inId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Object_GoodsAdditional', text_var1::TVarChar, vbUserId);
   END;
   
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.09.21                                                       *  

*/

-- ����
--

-- select * from gpUpdate_Object_GoodsAdditional(inId := 24168 , inMakerName := '1111' , inFormDispensingId := 18067783 , inNumberPlates := 1 , inQtyPackage := 1 , inIsRecipe := 'False' ,  inSession := '3');
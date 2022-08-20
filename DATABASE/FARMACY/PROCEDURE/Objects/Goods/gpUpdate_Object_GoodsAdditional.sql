-- Function: gpUpdate_Object_GoodsAdditional()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsAdditional(Integer, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsAdditional(
    IN inId                  Integer ,    -- ���� ������� <����� �������>
    IN inMakerName           TVarChar,    -- �������������
    IN inMakerNameUkr        TVarChar,    -- �������������
    IN inFormDispensingId    Integer ,    -- ����� �������
    IN inNumberPlates        Integer ,    -- ���-�� ������� � ��������:
    IN inQtyPackage          Integer ,    -- ���-�� � ��������:
    IN inDosage              TVarChar,    -- ���������
    IN inVolume              TVarChar,    -- �����
    IN inGoodsWhoCanList     TVarChar ,   -- ���� �����
    IN inGoodsMethodApplId   Integer ,    -- ������ ����������
    IN inGoodsSignOriginId   Integer ,    -- ������� �������������
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
               AND COALESCE(Object_Goods_Main.MakerNameUkr, '')        = COALESCE(inMakerNameUkr, '')  
               AND COALESCE(Object_Goods_Main.FormDispensingId, 0)     = COALESCE(inFormDispensingId, 0)  
               AND COALESCE(Object_Goods_Main.NumberPlates, 0)         = COALESCE(inNumberPlates, 0)  
               AND COALESCE(Object_Goods_Main.QtyPackage, 0)           = COALESCE(inQtyPackage, 0)  
               AND COALESCE(Object_Goods_Main.IsRecipe, False)         = COALESCE(inIsRecipe, FALSE)
               AND COALESCE(Object_Goods_Main.Dosage, '')              = COALESCE(inDosage, '')  
               AND COALESCE(Object_Goods_Main.Volume, '')              = COALESCE(inVolume, '')  
               AND COALESCE(Object_Goods_Main.GoodsWhoCanList, '')     = COALESCE(inGoodsWhoCanList, '')  
               AND COALESCE(Object_Goods_Main.GoodsMethodApplId, 0)    = COALESCE(inGoodsMethodApplId, 0)  
               AND COALESCE(Object_Goods_Main.GoodsSignOriginId, 0)    = COALESCE(inGoodsSignOriginId, 0))  
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Maker(), inId, inMakerName);
   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_MakerUkr(), inId, inMakerNameUkr);

   -- ��������� �������� <���������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Dosage(), inId, inDosage);
   -- ��������� �������� <�����>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Volume(), inId, inVolume);
   -- ��������� �������� <���� �����>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GoodsWhoCan(), inId, inGoodsWhoCanList);

   -- ��������� �������� <����� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_FormDispensing(), inId, inFormDispensingId);
   -- ��������� �������� <������ ����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsMethodAppl(), inId, inGoodsMethodApplId);
   -- ��������� �������� <������� �������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsSignOrigin(), inId, inGoodsSignOriginId);

   -- ��������� �������� <���-�� ������� � ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_NumberPlates(), inId, inNumberPlates);
   -- ��������� �������� <���-�� � ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_QtyPackage(), inId, inQtyPackage);
   
   -- ��������� �������� <���������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Recipe(), inId, inIsRecipe);

    -- ��������� � ������� �������
   BEGIN
     UPDATE Object_Goods_Main SET MakerName          = NULLIF(inMakerName, '')  
                                , MakerNameUkr       = NULLIF(inMakerNameUkr, '')  
                                , FormDispensingId   = NULLIF(inFormDispensingId, 0)  
                                , NumberPlates       = NULLIF(inNumberPlates, 0)    
                                , QtyPackage         = NULLIF(inQtyPackage, 0)    
                                , Dosage             = NULLIF(inDosage, '')  
                                , Volume             = NULLIF(inVolume, '')  
                                , GoodsWhoCanList    = NULLIF(inGoodsWhoCanList, '')  
                                , GoodsMethodApplId  = NULLIF(inGoodsMethodApplId, 0)  
                                , GoodsSignOriginId  = NULLIF(inGoodsSignOriginId, 0)  
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

-- 

select * from gpUpdate_Object_GoodsAdditional(inId := 55119 , inMakerName := '������������' , inMakerNameUkr := '' , inFormDispensingId := 18067783 , inNumberPlates := 1 , inQtyPackage := 1 , inDosage := '' , inVolume := '' , inGoodsWhoCanList := '20316673,20316674' , inGoodsMethodApplId := 0 , inGoodsSignOriginId := 0 , inIsRecipe := 'False' ,  inSession := '3');

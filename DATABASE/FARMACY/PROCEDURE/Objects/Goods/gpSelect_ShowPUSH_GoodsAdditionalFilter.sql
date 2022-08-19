-- Function: gpSelect_ShowPUSH_GoodsAdditionalFilter()

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_GoodsAdditionalFilter(Integer, TVarChar, Boolean, Integer, Boolean, Integer, Boolean, Integer, Boolean, Boolean, Boolean, 
                                                                TVarChar, Boolean, TVarChar, Boolean, TVarChar, Boolean, 
                                                                Integer, Boolean, Integer, Boolean, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_GoodsAdditionalFilter(
    IN inId                  Integer ,    -- ���� ������� <����� �������>
    IN inMakerName           TVarChar,    -- �������������
    IN inis_MakerName        Boolean ,    -- 
    IN inFormDispensingId    Integer ,    -- ����� �������
    IN inis_FormDispensingId Boolean ,    -- 
    IN inNumberPlates        Integer ,    -- ���-�� ������� � ��������:
    IN inis_NumberPlates     Boolean ,    -- 
    IN inQtyPackage          Integer ,    -- ���-�� � ��������:
    IN inis_QtyPackage       Boolean ,    -- 
    IN inIsRecipe            Boolean ,    -- ���������
    IN inis_IsRecipe         Boolean ,    -- 
    IN inMakerNameUkr        TVarChar,    -- �������������
    IN inis_MakerNameUkr     Boolean ,    -- 
    IN inDosage              TVarChar,    -- ���������
    IN inis_Dosage           Boolean ,    -- 
    IN inVolume              TVarChar,    -- �����
    IN inis_Volume           Boolean ,    -- 
    IN inGoodsWhoCanId       Integer ,    -- ���� �����
    IN inis_GoodsWhoCan      Boolean ,    -- 
    IN inGoodsMethodApplId   Integer ,    -- ������ ����������
    IN inis_GoodsMethodAppl  Boolean ,    -- 
    IN inGoodsSignOriginId   Integer ,    -- ������� �������������
    IN inis_GoodsSignOrigin  Boolean ,    -- 

   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������

    IN inSession             TVarChar     -- ������� ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbText      Text;
BEGIN

   vbUserId := inSession;

   outShowMessage := False;
   vbText := '';
   
   IF COALESCE (inMakerName, '') = '' AND inis_MakerName = TRUE
   THEN
     vbText := Chr(13)||'�������������';
   END IF;

   IF COALESCE (inMakerNameUkr, '') = '' AND inis_MakerNameUkr = TRUE
   THEN
     vbText := Chr(13)||'������������� ���. ��������';
   END IF;

   IF COALESCE (vbText, '') <> ''
   THEN
     outShowMessage := True;
     outPUSHType := zc_TypePUSH_Confirmation();
     outText := '�� ��������, ��� ����� ��������:'||Chr(13)||vbText||Chr(13)||Chr(13)||'�������� ������?';
   END IF;
    
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

select * from gpSelect_ShowPUSH_GoodsAdditionalFilter(inId := 0 , inMakerName := '' , inis_MakerName := 'False' , inFormDispensingId := 0 , inis_FormDispensing := 'False' , inNumberPlates := 0 , inis_NumberPlates := 'False' , inQtyPackage := 0 , inis_QtyPackage := 'False' , inIsRecipe := 'False' , inis_IsRecipe := 'False' , inMakerNameUkr := '' , inis_MakerNameUkr := 'True' , inDosage := '' , inis_Dosage := 'False' , inVolume := '' , inis_Volume := 'False' , inGoodsWhoCanId := 0 , inis_GoodsWhoCan := 'False' , inGoodsMethodApplId := 0 , inis_GoodsMethodAppl := 'False' , inGoodsSignOriginId := 0 , inis_GoodsSignOrigin := 'False' ,  inSession := '3');

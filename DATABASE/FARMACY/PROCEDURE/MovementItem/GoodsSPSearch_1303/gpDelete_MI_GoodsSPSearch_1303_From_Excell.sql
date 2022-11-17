-- Function: gpDelete_MI_GoodsSPSearch_1303_From_Excel()

DROP FUNCTION IF EXISTS gpDelete_MI_GoodsSPSearch_1303_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MI_GoodsSPSearch_1303_From_Excel(
    IN inMovementId               Integer   ,    -- ������������� ���������
    IN inIntenalSP_1303Name       TVarChar  ,    -- ̳�������� ������������� ��� ���������������� ����� ���������� ������ (1)
    IN inBrandSPName              TVarChar  ,    -- ����������� ����� ���������� ������ (2)
    IN inKindOutSP_1303Name       TVarChar  ,    -- ����� ������� (3)
    IN inDosage_1303Name          TVarChar  ,    -- ��������� (���. ������)(4)
    IN inCountSP_1303Name         TVarChar  ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (5)
    IN inMakerCountrySP_1303Name  TVarChar  ,    -- ������������ ���������, ����� (6)
    IN inSession                  TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpGetUserBySession (inSession);
  
  
  IF TRIM(COALESCE(inIntenalSP_1303Name, '')) = '' AND TRIM(COALESCE(inBrandSPName, '')) = ''
  THEN
    RETURN;
  END IF;

/*
����� �� ����� ��������: ̳�������� ������������� ��� ���������������� ����� ���������� ������
                         ����������� ����� ���������� ������  
                         ����� �������  
                         ���������  
                         ʳ������ ������� ���������� ������ � ��������� ��������  
                         ������������ ���������, �����
                         */

     -- ���� ���� ��� �������
     SELECT MovementItem.Id, MovementItem.ObjectId
     INTO vbId, vbGoodsId
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MI_IntenalSP_1303
                                           ON MI_IntenalSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_IntenalSP_1303.DescId = zc_MILinkObject_IntenalSP_1303()
          LEFT JOIN Object AS Object_IntenalSP_1303 ON Object_IntenalSP_1303.Id = MI_IntenalSP_1303.ObjectId
 
          LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                           ON MI_BrandSP.MovementItemId = MovementItem.Id
                                          AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()                                                    
          LEFT JOIN Object AS Object_BrandSP_1303 ON Object_BrandSP_1303.Id = MI_BrandSP.ObjectId

          LEFT JOIN MovementItemLinkObject AS MI_Dosage_1303
                                           ON MI_Dosage_1303.MovementItemId = MovementItem.Id
                                          AND MI_Dosage_1303.DescId = zc_MILinkObject_Dosage_1303()
          LEFT JOIN Object AS Object_Dosage_1303 ON Object_Dosage_1303.Id = MI_Dosage_1303.ObjectId

          LEFT JOIN MovementItemLinkObject AS MI_KindOutSP_1303
                                           ON MI_KindOutSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_KindOutSP_1303.DescId = zc_MILinkObject_KindOutSP_1303()

          LEFT JOIN Object AS Object_KindOutSP_1303 ON Object_KindOutSP_1303.Id = MI_KindOutSP_1303.ObjectId

          LEFT JOIN MovementItemLinkObject AS MI_CountSP_1303
                                           ON MI_CountSP_1303.MovementItemId = MovementItem.Id
                                          AND MI_CountSP_1303.DescId = zc_MILinkObject_CountSP_1303()
          LEFT JOIN Object AS Object_CountSP_1303 ON Object_CountSP_1303.Id = MI_CountSP_1303.ObjectId
          
          LEFT JOIN MovementItemLinkObject AS MI_MakerCountrySP_1303
                                           ON MI_MakerCountrySP_1303.MovementItemId = MovementItem.Id
                                          AND MI_MakerCountrySP_1303.DescId = zc_MILinkObject_MakerCountrySP_1303()
          LEFT JOIN Object AS Object_MakerCountrySP_1303 ON Object_MakerCountrySP_1303.Id = MI_MakerCountrySP_1303.ObjectId 

     WHERE MovementItem.MovementId = inMovementId
       AND zfCalc_Text_replace (COALESCE(Object_IntenalSP_1303.ValueData, ''), ' ','') = zfCalc_Text_replace(inIntenalSP_1303Name, ' ','') 
       AND zfCalc_Text_replace (COALESCE(Object_BrandSP_1303.ValueData, ''), ' ','')   = zfCalc_Text_replace(inBrandSPName, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_Dosage_1303.ValueData, ''), ' ','')    = zfCalc_Text_replace(inDosage_1303Name, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_KindOutSP_1303.ValueData, ''), ' ','') = zfCalc_Text_replace(inKindOutSP_1303Name, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_CountSP_1303.ValueData, ''), ' ','')   = zfCalc_Text_replace(inCountSP_1303Name, ' ','')
       AND zfCalc_Text_replace (COALESCE(Object_MakerCountrySP_1303.ValueData, ''), ' ','') = zfCalc_Text_replace(inMakerCountrySP_1303Name, ' ','')
     Limit 1 -- �� ������ ������
     ;
      
      --���� ����� ����� ������ ����� �� ��������                      
     /*IF EXISTS (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.Id = vbId AND MovementItem.isErased = FALSE)
     THEN 
       -- ������� �������� � ������
       --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), vbGoodsId, FALSE);
       --������� ������
       UPDATE MovementItem SET isErased = True WHERE MovementItem.Id = vbId AND MovementItem.isErased = FALSE;
     END IF;
     */
     RAISE EXCEPTION '������� <%> <%>.', vbId, inIntenalSP_1303Name;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.11.22         *
*/

-- ����
--
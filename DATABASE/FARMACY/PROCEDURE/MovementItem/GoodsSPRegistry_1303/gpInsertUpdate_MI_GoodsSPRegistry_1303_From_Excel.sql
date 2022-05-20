-- Function: gpInsertUpdate_MI_GoodsSPRegistry_1303_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPRegistry_1303_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                         , TDateTime, TDateTime, TFloat, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPRegistry_1303_From_Excel(
    IN inMovementId          Integer   ,    -- ������������� ���������

    IN inIntenalSPName_Lat   TVarChar  ,    -- ̳�������� ������������� ����� �� ����� (���. ������)(1)
    IN inIntenalSPName       TVarChar  ,    -- ̳�������� ������������� ����� (���. ������)(2)
    IN inBrandSPName         TVarChar  ,    -- ����������� ����� ���������� ������ (���. ������)(4)

    IN inKindOutSP_1303Name  TVarChar  ,    -- ����� ������� (���. ������)(5)
    IN inDosage_1303Name     TVarChar  ,    -- ��������� (���. ������)(6)
    IN inCountSP_1303Name    TVarChar  ,    -- ʳ������ �������� � �������� (���. ������)(7)
    IN inMakerSP_1303Name    TVarChar  ,    -- ����� ��������� (���. ������)(8)
    IN inCountry_1303Name    TVarChar  ,    -- ����� (���. ������)(9)

    IN inCodeATX             TVarChar  ,    -- ��� ��� (���. ������)(10)
    IN inReestrSP            TVarChar  ,    -- � ������������� ����������(���. ������)(11)
    IN inReestrDateSP        TDateTime ,    -- ���� ���������(���. ������)(12)
    IN inValiditySP          TDateTime ,    -- ����� 䳿(���. ������)(13)

    IN inPriceOptSP          TFloat    ,    -- ������������� ������-�������� ���� (���.)(���. ������)(14)
    IN inCurrencyName        TVarChar  ,    -- ������ (���. ������)(16)
    IN inExchangeRate        TFloat    ,    -- ��������� ����,������������ ������������ ������ ������ �� ���� ������� ���������� ���� ������-�������� ����(���. ������)(17)

    IN inOrderNumberSP       Integer   ,    -- � �����, � ����� ������� ��(���. ������)(18)
    IN inOrderDateSP         Integer   ,    -- ���� ������, � ����� ������� ��(���. ������)(19)

    IN inID_MED_FORM         Integer   ,    -- ID_MED_FORM(���. ������)(20)
    IN inMorionSP            Integer   ,    -- ��� �������(���. ������)(21)

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMainId Integer;
   DECLARE vbMI_Id Integer;
   DECLARE vbId Integer;

   DECLARE vbIntenalSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbKindOutSP_1303Id Integer;
   DECLARE vbDosage_1303Id Integer;
   DECLARE vbCountSP_1303Id Integer;
   DECLARE vbMakerSP_1303Id Integer;
   DECLARE vbCountry_1303Id Integer;
   DECLARE vbCurrencyId Integer;

   DECLARE vbOrderDateSP TDateTime;
   DECLARE vbIntenalSPName TVarChar;
   DECLARE text_var1 text;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� <inName>
     IF COALESCE (inID_MED_FORM, 0) = 0 THEN
        RETURN;--RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
     END IF; 

  BEGIN   
     -- !!!����� �� �������� ������!!!
     IF COALESCE (inMorionSP, 0) <> 0
     THEN
       vbMainId:= (SELECT Object_Goods_Main.Id
                   FROM Object_Goods_Main 
                   WHERE Object_Goods_Main.MorionCode = inMorionSP);
                   
       IF COALESCE (vbMainId, 0) <> 0
       THEN
                   
        vbMainId:= (SELECT ObjectLink_Main_Morion.ChildObjectId          AS GoodsMainId
                    FROM ObjectLink AS ObjectLink_Main_Morion
                         JOIN ObjectLink AS ObjectLink_Child_Morion
                                         ON ObjectLink_Child_Morion.ObjectId = ObjectLink_Main_Morion.ObjectId
                                        AND ObjectLink_Child_Morion.DescId = zc_ObjectLink_LinkGoods_Goods()
                         JOIN ObjectLink AS ObjectLink_Goods_Object_Morion
                                         ON ObjectLink_Goods_Object_Morion.ObjectId = ObjectLink_Child_Morion.ChildObjectId
                                        AND ObjectLink_Goods_Object_Morion.DescId = zc_ObjectLink_Goods_Object()
                                        AND ObjectLink_Goods_Object_Morion.ChildObjectId = zc_Enum_GlobalConst_Marion()
                         LEFT JOIN Object AS Object_Goods_Morion ON Object_Goods_Morion.Id = ObjectLink_Goods_Object_Morion.ObjectId
                    WHERE ObjectLink_Main_Morion.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                      AND ObjectLink_Main_Morion.ChildObjectId > 0
                      AND Object_Goods_Morion.ObjectCode = inMorionSP
                    LIMIT 1
                    );               
       END IF;
     END IF;
        
     -- �������� ����� "̳�������� ������������� ����� (���. ������)(2)" 
     -- ���� �� ������� ��������� ����� ������� � ����������
     IF inIntenalSPName <> ''
     THEN
       vbIntenalSPName := (TRIM (inIntenalSPName)||', '||TRIM (inIntenalSPName_Lat))::TVarChar; --������� ��� � ���. �������� ����� ���.
       vbIntenalSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP() AND UPPER (TRIM(Object.ValueData)) ILIKE UPPER (TRIM(vbIntenalSPName)) LIMIT 1);
       IF COALESCE (vbIntenalSPId, 0) = 0 AND COALESCE (vbIntenalSPName, '') <> '' THEN
          -- ���������� ����� �������
          vbIntenalSPId := gpInsertUpdate_Object_IntenalSP (ioId     := 0
                                                          , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP()) 
                                                          , inName   := TRIM(vbIntenalSPName)
                                                          , inSession:= inSession
                                                            );
       END IF;   
     END IF;   

     -- �������� ����� "����������� ����� ���������� ������ (���. ������)(4)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbBrandSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_BrandSP() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inBrandSPName)) LIMIT 1);
     IF COALESCE (vbBrandSPId, 0) = 0 AND COALESCE (inBrandSPName, '') <> '' THEN
        -- ���������� ����� �������
        vbBrandSPId := gpInsertUpdate_Object_BrandSP (ioId     := 0
                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_BrandSP()) 
                                                    , inName   := TRIM(inBrandSPName)
                                                    , inSession:= inSession
                                                     );
     END IF; 
     
     -- �������� ����� "����� ������� (���. ������)(5)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     WHILE POSITION('  ' IN inKindOutSP_1303Name) > 0 LOOP inKindOutSP_1303Name := REPLACE (inKindOutSP_1303Name, '  ', ' '); END LOOP;     
     vbKindOutSP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_KindOutSP_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inKindOutSP_1303Name)) LIMIT 1);
     IF COALESCE (vbKindOutSP_1303Id, 0) = 0 AND COALESCE (inKindOutSP_1303Name, '') <> '' THEN
        -- ���������� ����� �������
        vbKindOutSP_1303Id := gpInsertUpdate_Object_KindOutSP_1303 (ioId     := 0
                                                                  , inCode   := lfGet_ObjectCode(0, zc_Object_KindOutSP_1303()) 
                                                                  , inName   := TRIM(inKindOutSP_1303Name)
                                                                  , inSession:= inSession
                                                                    );
     END IF; 

     -- �������� ����� "��������� (���. ������)(6)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     WHILE POSITION('  ' IN inDosage_1303Name) > 0 LOOP inDosage_1303Name := REPLACE (inDosage_1303Name, '  ', ' '); END LOOP;     
     vbDosage_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Dosage_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inDosage_1303Name)) LIMIT 1);
     IF COALESCE (vbDosage_1303Id, 0) = 0 AND COALESCE (inDosage_1303Name, '') <> '' THEN
        -- ���������� ����� �������
        vbDosage_1303Id := gpInsertUpdate_Object_Dosage_1303 (ioId     := 0
                                                            , inCode   := lfGet_ObjectCode(0, zc_Object_Dosage_1303()) 
                                                            , inName   := TRIM(inDosage_1303Name)
                                                            , inSession:= inSession
                                                              );
     END IF; 

     -- �������� ����� "ʳ������ �������� � �������� (���. ������)(7)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     WHILE POSITION('  ' IN inCountSP_1303Name) > 0 LOOP inCountSP_1303Name := REPLACE (inCountSP_1303Name, '  ', ' '); END LOOP;     
     vbCountSP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CountSP_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inCountSP_1303Name)) LIMIT 1);
     IF COALESCE (vbCountSP_1303Id, 0) = 0 AND COALESCE (inCountSP_1303Name, '') <> '' THEN
        -- ���������� ����� �������
        vbCountSP_1303Id := gpInsertUpdate_Object_CountSP_1303 (ioId     := 0
                                                              , inCode   := lfGet_ObjectCode(0, zc_Object_CountSP_1303()) 
                                                              , inName   := TRIM(inCountSP_1303Name)
                                                              , inSession:= inSession
                                                                );
     END IF; 

     -- �������� ����� "����� ��������� (���. ������)(8)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     WHILE POSITION('  ' IN inMakerSP_1303Name) > 0 LOOP inMakerSP_1303Name := REPLACE (inMakerSP_1303Name, '  ', ' '); END LOOP;     
     vbMakerSP_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MakerSP_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inMakerSP_1303Name)) LIMIT 1);
     IF COALESCE (vbMakerSP_1303Id, 0) = 0 AND COALESCE (inMakerSP_1303Name, '') <> '' THEN
        -- ���������� ����� �������
        vbMakerSP_1303Id := gpInsertUpdate_Object_MakerSP_1303 (ioId     := 0
                                                              , inCode   := lfGet_ObjectCode(0, zc_Object_MakerSP_1303()) 
                                                              , inName   := TRIM(inMakerSP_1303Name)
                                                              , inSession:= inSession
                                                                );
     END IF; 

     -- �������� ����� "����� (���. ������)(9)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     WHILE POSITION('  ' IN inCountry_1303Name) > 0 LOOP inCountry_1303Name := REPLACE (inCountry_1303Name, '  ', ' '); END LOOP;     
     vbCountry_1303Id := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Country_1303() AND UPPER (TRIM(Object.ValueData)) = UPPER (TRIM(inCountry_1303Name)) LIMIT 1);
     IF COALESCE (vbCountry_1303Id, 0) = 0 AND COALESCE (inCountry_1303Name, '') <> '' THEN
        -- ���������� ����� �������
        vbCountry_1303Id := gpInsertUpdate_Object_Country_1303 (ioId     := 0
                                                              , inCode   := lfGet_ObjectCode(0, zc_Object_Country_1303()) 
                                                              , inName   := TRIM(inCountry_1303Name)
                                                              , inSession:= inSession
                                                                );
     END IF; 

     -- �������� ����� "������ (���. ������)(16)"
     IF POSITION('���' IN UPPER(inCurrencyName)) > 0
     THEN
        vbCurrencyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Currency() AND Object.ObjectCode = 840);     
     ELSEIF POSITION('����' IN UPPER(inCurrencyName)) > 0
     THEN
        vbCurrencyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Currency() AND Object.ObjectCode = 978);          
     ELSE
        vbCurrencyId := 0;
     END IF;

     vbOrderDateSP := '30.12.1899'::Date + (inOrderDateSP::TVarChar||' DAY')::Interval;

     -- ���� ���� ��� �������
     vbId := (SELECT MovementItem.Id
              FROM MovementItem

                   LEFT JOIN MovementItemFloat AS MIFloat_ID_MED_FORM
                                               ON MIFloat_ID_MED_FORM.MovementItemId = MovementItem.Id
                                              AND MIFloat_ID_MED_FORM.DescId = zc_MIFloat_ID_MED_FORM() 

                   LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                               ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                              AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  

                   LEFT JOIN MovementItemLinkObject AS MI_Dosage_1303
                                                    ON MI_Dosage_1303.MovementItemId = MovementItem.Id
                                                   AND MI_Dosage_1303.DescId = zc_MILinkObject_Dosage_1303()

                   LEFT JOIN MovementItemLinkObject AS MI_CountSP_1303
                                                    ON MI_CountSP_1303.MovementItemId = MovementItem.Id
                                                   AND MI_CountSP_1303.DescId = zc_MILinkObject_CountSP_1303()

              WHERE MovementItem.MovementId = inMovementId
                AND COALESCE (MI_Dosage_1303.ObjectId , 0) = COALESCE (vbDosage_1303Id, 0)
                AND COALESCE (MI_CountSP_1303.ObjectId , 0) = COALESCE (vbCountSP_1303Id, 0)   
                AND MIFloat_ID_MED_FORM.ValueData = inID_MED_FORM
                AND MIFloat_OrderNumberSP.ValueData = inOrderNumberSP
              Limit 1 -- �� ������ ������
              );
              
    /* IF COALESCE (vbId, 0) <> 0
     THEN
       PERFORM lpLog_Run_Schedule_Function('gpInsertUpdate_MI_GoodsSPRegistry_1303_From_Excel', False, (inID_MED_FORM::tvarchar||'  '||inMorionSP::tvarchar)::TVarChar, vbUserId);
     END IF;*/
       
     -- ���� ������ � ����� �������, ���� ���� ��������������
     IF COALESCE (vbMainId, 0) <> 0
     THEN
       vbMI_Id := (SELECT MovementItem.Id
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.ObjectId = COALESCE (vbMainId, 0)
                   Limit 1 -- �� ������ ������
                  );
     END IF;
    
     --raise notice 'Value 03: <%> <%>', vbId, vbMI_Id;      
     --RETURN;

    -- ��������� ������
    PERFORM lpInsertUpdate_MovementItem_GoodsSPRegistry_1303 (ioId                  := COALESCE(vbId, 0)
                                                            , inMovementId          := inMovementId
                                                            , inGoodsId             := COALESCE (vbMainId, 0)
                                                            , inIntenalSPId         := vbIntenalSPId
                                                            , inBrandSPId           := vbBrandSPId
                                                            , inKindOutSP_1303Id    := vbKindOutSP_1303Id
                                                            , inDosage_1303Id       := vbDosage_1303Id
                                                            , inCountSP_1303Id      := vbCountSP_1303Id
                                                            , inMakerSP_1303Id      := vbMakerSP_1303Id
                                                            , inCountry_1303Id      := vbCountry_1303Id
                                                            , inCodeATX             := TRIM(inCodeATX)::TVarChar
                                                            , inReestrSP            := TRIM(inReestrSP)::TVarChar
                                                            , inReestrDateSP        := inReestrDateSP
                                                            , inValiditySP          := inValiditySP
                                                            , inPriceOptSP          := COALESCE (inPriceOptSP, 0) :: TFloat
                                                            , inCurrencyId          := vbCurrencyId
                                                            , inExchangeRate        := COALESCE (inExchangeRate, 0) :: TFloat
                                                            , inOrderNumberSP       := inOrderNumberSP
                                                            , inOrderDateSP         := vbOrderDateSP
                                                            , inID_MED_FORM         := inID_MED_FORM
                                                            , inMorionSP            := COALESCE (inMorionSP, 0)
                                                            , inUserId              := vbUserId);

  EXCEPTION
     WHEN others THEN 
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
       PERFORM lpAddObject_Goods_Temp_Error('gpInsertUpdate_MI_GoodsSPRegistry_1303_From_Excel', text_var1::TVarChar, vbUserId);
  END;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.05.22                                                       *
*/

-- ����

-- select * from gpInsertUpdate_MI_GoodsSPRegistry_1303_From_Excel(inMovementId := 27854839 , inIntenalSPName_Lat := '' , inIntenalSPName := '' , inBrandSPName := '�̲����' , inKindOutSP_1303Name := '������� ��� ������� ��� ������, 500 ��/500 �� � ������ � �������' , inDosage_1303Name := '500 ��/500 �' , inCountSP_1303Name := '1' , inMakerSP_1303Name := '����� ������ ˳����' , inCountry_1303Name := '����' , inCodeATX := 'J01DH51' , inReestrSP := 'UA/17305/01/01' , inReestrDateSP := ('21.03.2019')::TDateTime , inValiditySP := ('21.03.2024')::TDateTime , inPriceOptSP := 265.66 , inCurrencyName := '��������' , inExchangeRate := 28.1126 , inOrderNumberSP := 764 , inOrderDateSP := 43923 , inID_MED_FORM := 306241 , inMorionSP := 525129 ,  inSession := '3');


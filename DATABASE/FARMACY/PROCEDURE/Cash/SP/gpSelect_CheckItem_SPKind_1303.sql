-- Function: gpSelect_CheckItem_SPKind_1303()

DROP FUNCTION IF EXISTS gpSelect_CheckItem_SPKind_1303 (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CheckItem_SPKind_1303(
    IN inSPKindId            Integer   , -- ��� ������
    IN inGoodsId             Integer   , -- ������
    IN inPriceSale           TFloat    , -- ���� ��� ������
   OUT outError              TVarChar  , -- ���������
   OUT outError2             TVarChar  , -- ���������
   OUT outSentence           TVarChar  , -- ����������� �� ����
   OUT outPrice              TFloat    , -- ���������� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbPriceCalc TFloat;
   DECLARE vbPriceSale TFloat;
   DECLARE vbDeviationsPrice1303 TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    outError := '';
    outError2 := '';
    outSentence := '';
    outPrice := 0;

    SELECT COALESCE(ObjectFloat_CashSettings_DeviationsPrice1303.ValueData, 1)    AS DeviationsPrice1303
    INTO vbDeviationsPrice1303
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeviationsPrice1303
                               ON ObjectFloat_CashSettings_DeviationsPrice1303.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_DeviationsPrice1303.DescId = zc_ObjectFloat_CashSettings_DeviationsPrice1303()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
         
    -- �������� ������ �� ������ ���������� � ������� ��� 20%, ��� ����. 1303
    IF inSPKindId = zc_Enum_SPKind_1303()
    THEN 
            --
            IF EXISTS (SELECT 1 
                       FROM ObjectLink
                            INNER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink.ChildObjectId 
                                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                                  AND ObjectFloat_NDSKind_NDS.ValueData = 20
                       WHERE ObjectLink.ObjectId = inGoodsId
                         AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind())
               THEN
                   outError := '������. ������ �� ������ ������ �� ���� 1303 �� ������� ���=20 ����.'||Chr(13)||Chr(10)||'(����� ��� ����������� !!!)';
                   RETURN;
            END IF;
            
            SELECT T1.PriceSale, T1.PriceSaleIncome  
            INTO vbPriceSale, vbPriceCalc                          
            FROM gpSelect_GoodsSPRegistry_1303_Unit (inUnitId := vbUnitId, inGoodsId := inGoodsId, inisCalc := True, inSession := inSession) AS T1;
                        
            IF COALESCE(vbPriceSale, 0) = 0
            THEN
                  outError :=  '���� ������� !'||Chr(13)||Chr(10)|| 
                               '����� �� ������ � ������� ������� ���. ������� 1303';
                  outError2 :=  Chr(13)||Chr(10)||'������� PrintScreen ������ � ������� � ��������� �� Telegram   � ������ ����1303  (���� ��� ������� ������)';
                  
                  RETURN;
            END IF;
            
            
            -- ����������� �� ����
            IF (COALESCE (vbPriceCalc,0) < inPriceSale) AND (COALESCE (trunc(vbPriceCalc * 10) / 10, 0) > 0)
            THEN
               outError :=  '������. ������ �� ������ ������ �� ���� 1303 � �������� ����� 10 ���������';
               outError2 :=  Chr(13)||Chr(10)||'������� PrintScreen ������ � ������� � ��������� �� Telegram ������ ��������� ���  ����������� ���� ����������'||Chr(13)||Chr(10)||'(����� ����������� - �������� ����� ��������� �� �������)';

               outPrice := trunc(vbPriceCalc * 10) / 10;
               outSentence :=  '��������� ����������� ���������� ���� - '||zfConvert_FloatToString(outPrice);
            END IF;

             -- raise notice 'Value 05: % % % %', vbPriceSale, vbPriceCalc, outPrice, (CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END / vbPriceSale * 100 - 100);
            
            IF vbPriceSale < inPriceSale and COALESCE(outPrice, 0) = 0 OR vbPriceSale < outPrice and COALESCE(outPrice, 0) > 0
            THEN
              outError :=  '���� ������� !'||Chr(13)||Chr(10)|| 
                           '��������� ���� ���� ��� �� ������� ������� ���. ������� 1303'||Chr(13)||Chr(10)||Chr(13)||Chr(10)||
                           '������������ ���� ���������� ������ ���� - '||zfConvert_FloatToString(vbPriceSale)||'���.'||Chr(13)||Chr(10)|| 
                           '� ��� �����. ���� ��� ������� �� ���� 1303 - '||zfConvert_FloatToString(CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END)||'���.';
              outError2 :=  Chr(13)||Chr(10)||'% ����������� '||zfConvert_FloatToString(CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END/vbPriceSale*100 - 100)||
                           Chr(13)||Chr(10)||Chr(13)||Chr(10)||'������� PrintScreen ������ � ������� � ��������� �� Telegram   � ������ ����1303  (���� ��� ������� ������)';
                           
              IF (CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END / vbPriceSale * 100 - 100) <= COALESCE(vbDeviationsPrice1303, 1.0)
              THEN
                outPrice := vbPriceSale;
                outSentence :=  '��������� ����������� ���������� ���� - '||zfConvert_FloatToString(outPrice);
              ELSE
                outSentence := '';
                outPrice := 0;               
              END IF;
            END IF;
    END IF;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.  ������ �.�.
 26.01.20                                                                                      *
*/

-- SELECT * FROM gpSelect_CheckItem_SPKind_1303(inSPKindId := zc_Enum_SPKind_1303(), inGoodsId := 36643, inPriceSale := 1000, inSession := '3');


select * from gpSelect_CheckItem_SPKind_1303(inSPKindId := 4823010 , inGoodsId := 37309 , inPriceSale := 1185.5 ,  inSession := '3');
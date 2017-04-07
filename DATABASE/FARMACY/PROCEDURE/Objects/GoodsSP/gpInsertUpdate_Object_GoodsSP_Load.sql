-- Function: gpInsertUpdate_Object_GoodsSP_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_Load (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_From_Excel (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_From_Excel (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_From_Excel (Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,
                                                                  TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_From_Excel (Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,
                                                                  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_From_Excel (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat,
                                                                  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSP_From_Excel(
    IN inCode                Integer   ,    -- ��� ������� <�����> MainID
  --  IN inName                TVarChar  ,    -- ������������
    IN inPriceSP             TFloat    ,    -- ���������� ���� �� ��, ��� (���. ������)
  --  IN inGroupSP             TFloat    ,    -- ����� �������-����� � � ��� ��
    IN inCountSP             TFloat    ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������) 

    IN inColSP               TFloat    ,    --
    IN inPriceOptSP          TFloat    ,    -- 
    IN inPriceRetSP          TFloat    ,    -- 
    IN inDailyNormSP         TFloat    ,    -- 
    IN inDailyCompensationSP TFloat    ,    -- 
    IN inPaymentSP           TFloat    ,    -- 

    IN inDateReestrSP        TVarChar  ,    -- 
    IN inPack                TVarChar  ,    -- ���������
    IN inIntenalSPName       TVarChar  ,    -- ̳�������� ������������� ����� (���. ������)
    IN inBrandSPName         TVarChar  ,    -- ����������� ����� ���������� ������ (���. ������)
    IN inKindOutSPName       TVarChar  ,    -- ����� ������� (���. ������)

    IN inCodeATX             TVarChar  ,    --
    IN inMakerSP             TVarChar  ,    --
    IN inReestrSP            TVarChar  ,    --  

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� <inName>
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN;--RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
     END IF; 

     -- !!!����� �� �������� ������!!!
     vbId:= (SELECT ObjectBoolean_Goods_isMain.ObjectId
            FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                 INNER JOIN Object AS Object_Goods 
                                   ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                  AND Object_Goods.ObjectCode = inCode
            WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain());
   
     IF COALESCE (vbId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� ���� % �� ������� � �����������.', inCode;
     END IF;  
   
     PERFORM gpInsertUpdate_Object_GoodsSP (inId              := vbId
                                          , inisSP            := TRUE
                                          , inPriceSP         := inPriceSP
                                          --, inGroupSP         := inGroupSP
                                          , inCountSP         := inCountSP

                                          , inColSP           := inColSP
                                          , inPriceOptSP      := inPriceOptSP
                                          , inPriceRetSP      := inPriceRetSP
                                          , inDailyNormSP     := inDailyNormSP
                                          , inDailyCompensationSP := inDailyCompensationSP
                                          , inPaymentSP       := inPaymentSP
                                          , inDateReestrSP    := TRIM(inDateReestrSP)  ::TVarChar

                                          , inPack            := TRIM(inPack)          ::TVarChar
                                          , inIntenalSPName   := TRIM(inIntenalSPName) ::TVarChar
                                          , inBrandSPName     := TRIM(inBrandSPName)   ::TVarChar
                                          , inKindOutSPName   := TRIM(inKindOutSPName) ::TVarChar
                                          , inCodeATX         := TRIM(inCodeATX)       ::TVarChar
                                          , inMakerSP         := TRIM(inMakerSP)       ::TVarChar
                                          , inReestrSP        := TRIM(inReestrSP)      ::TVarChar

                                          , inSession         := inSession
                                          );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.04.17         *
 22.12.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsSP_From_Excel (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');
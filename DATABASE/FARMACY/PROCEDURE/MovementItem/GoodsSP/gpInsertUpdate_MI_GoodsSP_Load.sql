-- Function: gpInsertUpdate_MI_GoodsSP_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSP_From_Excel (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                            , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSP_From_Excel (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                            , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSP_From_Excel(
    IN inMovementId          Integer   ,    -- 
    IN inCode                Integer   ,    -- ��� ������� <�����> MainID
    IN inPriceSP             TFloat    ,    -- ���������� ���� �� ��, ��� (���. ������)
    IN inCountSP             TFloat    ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������) 

    IN inColSP               TFloat    ,    --
    IN inPriceOptSP          TFloat    ,    -- 
    IN inPriceRetSP          TFloat    ,    -- 
    IN inDailyNormSP         TFloat    ,    -- 
    IN inDailyCompensationSP TFloat    ,    -- 
    IN inPaymentSP           TFloat    ,    -- 

    IN inReestrDateSP        TVarChar  ,    -- 
    IN inPack                TVarChar  ,    -- ���������
    IN inIntenalSPName       TVarChar  ,    -- ̳�������� ������������� ����� (���. ������)
    IN inBrandSPName         TVarChar  ,    -- ����������� ����� ���������� ������ (���. ������)
    IN inKindOutSPName       TVarChar  ,    -- ����� ������� (���. ������)

    IN inCodeATX             TVarChar  ,    --
    IN inMakerSP             TVarChar  ,    --
    IN inReestrSP            TVarChar  ,    --  
    IN inIdSP                TVarChar  ,    --
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
   DECLARE vbKindOutSPId Integer;
   DECLARE vbBrandSPId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� <inName>
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN;--RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
     END IF; 

     -- !!!����� �� �������� ������!!!
     vbMainId:= (SELECT ObjectBoolean_Goods_isMain.ObjectId
                 FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                      INNER JOIN Object AS Object_Goods 
                                        ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                       AND Object_Goods.ObjectCode = inCode
                 WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain());
   
     IF COALESCE (vbMainId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� ���� % �� ������� � �����������.', inCode;
     END IF;  

     -- �������� ����� "̳�������� ������������� ����� (���. ������)" 
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbIntenalSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inIntenalSPName)) );
     IF COALESCE (vbIntenalSPId, 0) = 0 AND COALESCE (inIntenalSPName, '')<> '' THEN
        -- ���������� ����� �������
        vbIntenalSPId := gpInsertUpdate_Object_IntenalSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP()) 
                                                        , inName   := TRIM(inIntenalSPName)
                                                        , inSession:= inSession
                                                          );
     END IF;   
     -- �������� ����� "����������� ����� ���������� ������ (���. ������)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbKindOutSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_KindOutSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inKindOutSPName)));
     IF COALESCE (vbKindOutSPId, 0) = 0 AND COALESCE (inKindOutSPName, '')<> '' THEN
        -- ���������� ����� �������
        vbKindOutSPId := gpInsertUpdate_Object_KindOutSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_KindOutSP()) 
                                                        , inName   := TRIM(inKindOutSPName)
                                                        , inSession:= inSession
                                                          );
     END IF; 
     -- �������� ����� "����� ������� (���. ������)"
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbBrandSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_BrandSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inBrandSPName)));
     IF COALESCE (vbBrandSPId, 0) = 0 AND COALESCE (inBrandSPName, '')<> '' THEN
        -- ���������� ����� �������
        vbBrandSPId := gpInsertUpdate_Object_BrandSP (ioId     := 0
                                                    , inCode   := lfGet_ObjectCode(0, zc_Object_BrandSP()) 
                                                    , inName   := TRIM(inBrandSPName)
                                                    , inSession:= inSession
                                                     );
     END IF; 

     -- ���� � �.�. �� ������ ���� ������� � ���������� �, ���� ������� �������� 
     IF COALESCE (inColSP, 0) <> 0 
        THEN
            vbId := (SELECT MovementItem.Id
                     FROM MovementItem
                          INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                      AND MovementItemFloat.DescId = zc_ObjectFloat_Goods_ColSP()
                                                      AND MovementItemFloat.ValueData = inColSP
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.ObjectId <> COALESCE (vbMainId, 0)
                     Limit 1 -- �� ������ ������
                    );

            IF COALESCE (vbId, 0) <> 0 
               THEN
                   --������� � �.�. ���� �����
                   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), vbId, 0);
            END IF;
     END IF;

     -- ���� ������ � ����� �������, ���� ���� ��������������
     vbMI_Id := (SELECT MovementItem.Id
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.ObjectId = COALESCE (vbMainId, 0)
                 Limit 1 -- �� ������ ������
                );
    
    -- ��������� ������
    PERFORM lpInsertUpdate_MovementItem_GoodsSP (ioId                  := COALESCE(vbMI_Id, 0)
                                               , inMovementId          := inMovementId
                                               , inGoodsId             := vbMainId
                                               , inIntenalSPId         := vbIntenalSPId
                                               , inBrandSPId           := vbBrandSPId
                                               , inKindOutSPId         := vbKindOutSPId
                                               , inColSP               := COALESCE (inColSP, 0) :: TFloat
                                               , inCountSP             := COALESCE (inCountSP, 0) :: TFloat
                                               , inPriceOptSP          := COALESCE (inPriceOptSP, 0) :: TFloat
                                               , inPriceRetSP          := COALESCE (inPriceRetSP, 0) :: TFloat
                                               , inDailyNormSP         := COALESCE (inDailyNormSP, 0) :: TFloat
                                               , inDailyCompensationSP := COALESCE (inDailyCompensationSP, 0) :: TFloat
                                               , inPriceSP             := COALESCE (inPriceSP, 0) :: TFloat
                                               , inPaymentSP           := COALESCE (inPaymentSP, 0) :: TFloat
                                               , inGroupSP             := 0 ::TFloat
                                               , inPack                := TRIM(inPack)          ::TVarChar
                                               , inCodeATX             := TRIM(inCodeATX)       ::TVarChar
                                               , inMakerSP             := TRIM(inMakerSP)       ::TVarChar
                                               , inReestrSP            := TRIM(inReestrSP)      ::TVarChar
                                               , inReestrDateSP        := TRIM(inReestrDateSP)  ::TVarChar
                                               , inIdSP                := TRIM(inIdSP)          ::TVarChar
                                               , inUserId              := vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.04.19         * add IdSP
 25.08.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsSP_From_Excel (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');
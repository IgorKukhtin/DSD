-- Function: gpInsertUpdate_Object_GoodsSP_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP_Load (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSP_Load(
    IN inCode                Integer   ,    -- ��� ������� <�����> MainID
    IN inName                TVarChar  ,    -- ������������
    IN inPriceSP             TFloat    ,    -- ���������� ���� �� ��, ��� (���. ������)
    IN inGroupSP             TFloat    ,    -- ����� �������-����� � � ��� ��
    IN inCountSP             TFloat    ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������) 
    IN inPack                TVarChar  ,    -- ���������
    IN inIntenalSPName       TVarChar  ,    -- ̳�������� ������������� ����� (���. ������)
    IN inBrandSPName         TVarChar  ,    -- ����������� ����� ���������� ������ (���. ������)
    IN inKindOutSPName       TVarChar  ,    -- ����� ������� (���. ������)
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
        RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
     END IF; 

     -- !!!����� �� �������� ������!!!
     vbId:= (SELECT ObjectBoolean_Goods_isMain.ObjectId
            FROM ObjectBoolean AS ObjectBoolean_Goods_isMain 
                 INNER JOIN Object AS Object_Goods 
                                   ON Object_Goods.Id = ObjectBoolean_Goods_isMain.ObjectId
                                  AND Object_Goods.ObjectCode = inCode
            WHERE ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain());
   
     IF COALESCE (vbId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� % �� ������� � �����������.', inName;
     END IF;  
   
     PERFORM gpInsertUpdate_Object_GoodsSP (ioId              := vbId
                                          , inisSP            := TRUE
                                          , inPriceSP         := inPriceSP
                                          , inGroupSP         := inGroupSP
                                          , inCountSP         := inCountSP
                                          , inPack            := TRIM(inPack)
                                          , inIntenalSPName   := TRIM(inIntenalSPName)
                                          , inBrandSPName     := TRIM(inBrandSPName)
                                          , inKindOutSPName   := TRIM(inKindOutSPName)
                                          , inSession         := inSession
                                          );
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsSP_Load (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');
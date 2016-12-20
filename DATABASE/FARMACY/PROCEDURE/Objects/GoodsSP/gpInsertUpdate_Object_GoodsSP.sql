-- Function: gpInsertUpdate_Object_GoodsSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSP (Integer, TVarChar, Boolean, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSP(
    IN inId                  Integer   ,    -- ���� ������� <�����> MainID
    IN inCountSP             TVarChar  ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������) 
    IN inisSP                Boolean   ,    -- ��������� � ���. �������
    IN inPriceSP             TFloat    ,    -- ���������� ���� �� ��, ��� (���. ������)
    IN inGroupSP             TFloat    ,    -- ����� �������-����� � � ��� ��
    IN inIntenalSPName       TVarChar  ,    -- ̳�������� ������������� ����� (���. ������)
    IN inBrandSPName         TVarChar  ,    -- ����������� ����� ���������� ������ (���. ������)
    IN inKindOutSPName       TVarChar  ,    -- ����� ������� (���. ������)
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIntenalSPId Integer;
   DECLARE vbKindOutSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� <inName>
     IF COALESCE (inId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
     END IF;

    -- !!!����� �� �������� ������!!!
   /* inId:= (SELECT ObjectLink_Main.ChildObjectId
                        FROM ObjectLink AS ObjectLink_Child 
                             LEFT JOIN ObjectLink AS ObjectLink_Main
                                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                        WHERE ObjectLink_Child.ChildObjectId = inId                      --Object_Goods.Id
                          AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods());
   */
     -- ��������� ���������� �� ��� ����� �����
  /* SELECT Object_Goods.ValueData 
     INTO vbName
     FROM ObjectBoolean
          LEFT JOIN Object AS Object_Goods 
                           ON Object_Goods.Id = ObjectBoolean.ObjectId
     WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Goods_SP() 
       AND ObjectBoolean.ObjectId = inId;
    
     IF COALESCE(vbName, '') <> ''
        RAISE EXCEPTION '������.��� ������ % ��� ������������ ������ �� ���.�������.',vbName;
     END IF;
*/

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
       
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_IntenalSP(), inId, vbIntenalSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_BrandSP(), inId, vbBrandSPId);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_KindOutSP(), inId, vbKindOutSPId ); 

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CountSP(), inId, inCountSP); 

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PriceSP(), inId, inPriceSP);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_GroupSP(), inId, inGroupSP);
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), inId, TRUE);


    -- ��������� ��������
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.12.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsSP (324, '17', True, 4::TFloat, 5::TFloat, 0, 0, 0, '3');
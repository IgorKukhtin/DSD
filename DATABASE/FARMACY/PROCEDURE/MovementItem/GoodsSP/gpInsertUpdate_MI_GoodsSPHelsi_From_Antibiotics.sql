-- Function: gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics (Integer, TVarChar, TVarChar, TFloat, TVarChar, TVarChar, TVarChar
                                                            , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                            , TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics(
    IN inMovementId          Integer   ,    -- 
    IN inCountSPMin          TVarChar  ,    -- ̳������� ������� ���� ������� �� ������� (5)
    IN inCountSP             TVarChar  ,    -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������) (4)

    IN inColSP               TFloat    ,    -- � �/� 
    IN inDenumeratorValue    TVarChar  ,    -- ʳ������ ������� (13)

    IN inReestrDateSP        TVarChar  ,    -- ���� ��������� ������ 䳿 ������������� ���������� �� ��������� ���� (7)
    IN inPack                TVarChar  ,    -- ��������� (14)
    IN inIntenalSPName       TVarChar  ,    -- ̳�������� ������������� ����� (���. ������) (16)
    IN inIntenalSPName_Lat   TVarChar  ,    -- ̳�������� ������������� ����� (���. ������) (17)
    IN inBrandSPName         TVarChar  ,    -- ����������� ����� ���������� ������ (���. ������) (2)
    IN inKindOutSPName       TVarChar  ,    -- ����� ������� (���. ������) (12)

    IN inCodeATX             TVarChar  ,    -- ��� ��� (3)
    IN inMakerSP             TVarChar  ,    -- ������������ ���������, ����� (8)
    IN inCountry             TVarChar  ,    -- ������������ ���������, ����� (9)
    IN inReestrSP            TVarChar  ,    -- ����� ������������� ���������� �� ��������� ���� (6) 
    IN inIdSP                TVarChar  ,    -- ID ����. ������ (1)
    
    IN inProgramId           TVarChar  ,    -- ID �������� �������� (0)
    IN inNumeratorUnit       TVarChar  ,    -- ������� ����� ���� 䳿 (12)
    IN inDenumeratorUnit     TVarChar  ,    -- ������� ����� ������� (10)

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbCountSPMin TFloat;
   DECLARE vbCountSP TFloat;
   DECLARE vbDenumeratorValue TFloat;

   DECLARE vbKindOutSPId Integer;
   DECLARE vbIntenalSPId Integer;
   DECLARE vbBrandSPId Integer;
   DECLARE vbIntenalSPName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� ����� "̳�������� ������������� ����� (���. ������)" 
     -- ���� �� ������� ��������� ����� ������� � ����������
     vbIntenalSPName := TRIM (inIntenalSPName)||', '||TRIM (inIntenalSPName_Lat); --������� ��� � ���. �������� ����� ���.
     vbIntenalSPId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_IntenalSP() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(vbIntenalSPName)) );
     IF COALESCE (vbIntenalSPId, 0) = 0 AND COALESCE (vbIntenalSPName, '') <> '' THEN
        -- ���������� ����� �������
        vbIntenalSPId := gpInsertUpdate_Object_IntenalSP (ioId     := 0
                                                        , inCode   := lfGet_ObjectCode(0, zc_Object_IntenalSP()) 
                                                        , inName   := TRIM(vbIntenalSPName)
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

     -- ���� Id
     SELECT MovementItem.Id, MovementItem.ObjectId
     INTO vbId, vbGoodsId
     FROM MovementItem
          LEFT JOIN MovementItemString AS MIString_IdSP
                                       ON MIString_IdSP.MovementItemId = MovementItem.Id
                                      AND MIString_IdSP.DescId = zc_MIString_IdSP()
          LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                       ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                      AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()
     WHERE MovementItem.MovementId = inMovementId
       AND MIString_IdSP.ValueData = inIdSP
       AND MIString_ProgramIdSP.ValueData = inProgramId
     Limit 1; -- �� ������ ������
     
     /*IF COALESCE (vbId, 0) > 0
     THEN
       RETURN;
     END IF;*/

     BEGIN  
       vbCountSPMin := inCountSPMin::TFloat;
     EXCEPTION WHEN others THEN 
       vbCountSPMin := Null;
     END;     

     BEGIN  
       vbCountSP := inCountSP::TFloat;
     EXCEPTION WHEN others THEN 
       vbCountSP := Null;
     END;     

     BEGIN  
       vbDenumeratorValue := inDenumeratorValue::TFloat;
     EXCEPTION WHEN others THEN 
       vbDenumeratorValue := Null;
     END;     
     
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    -- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (COALESCE(vbId, 0), zc_MI_Master(), COALESCE(vbGoodsId, 0), inMovementId, 0, NULL);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ColSP(), vbId, inColSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSPMin(), vbId, vbCountSPMin);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSP(), vbId, vbCountSP);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DenumeratorValueSP(), vbId, vbDenumeratorValue);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Pack(), vbId, TRIM(inPack));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_CodeATX(), vbId, TRIM(inCodeATX));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_MakerSP(), vbId, (TRIM(inMakerSP)||', '|| TRIM(inCountry)) ::TVarChar);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrSP(), vbId, TRIM(inReestrSP));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ReestrDateSP(), vbId, TRIM(inReestrDateSP));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), vbId, TRIM(inIdSP));

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ProgramIdSP(), vbId, TRIM(inProgramId));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_NumeratorUnitSP(), vbId, TRIM(inNumeratorUnit));
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DenumeratorUnitSP(), vbId, TRIM(inDenumeratorUnit));
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_IntenalSP(), vbId, vbIntenalSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BrandSP(), vbId, vbBrandSPId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_KindOutSP(), vbId, vbKindOutSPId);


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);
    
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.08.22                                                       *
*/

-- ����
 SELECT * FROM gpInsertUpdate_MI_GoodsSPHelsi_From_Antibiotics(
     inMovementId := 28396300,
     inCountSPMin := '10',
     inCountSP := '100',

     inColSP := 1,
     inDenumeratorValue := '1',

     inReestrDateSP := '2100-01-11',
     inPack := '10',
     inIntenalSPName := '��������',
     inIntenalSPName_Lat := 'dioxydine',
     inBrandSPName := 'Ĳ�������',
     inKindOutSPName := 'AMPOULE',

     inCodeATX := 'J01XX',
     inMakerSP := '�� "������"',
     inCountry := '������',
     inReestrSP := 'UA/6867/01/01',
     inIdSP := '47f99caa-50e8-4410-be61-c8bfd634b70e',
    
     inProgramId := 'bf9b0f7e-500e-48f9-946c-1a35e4e830a7',
     inNumeratorUnit := 'AMPOULE',
     inDenumeratorUnit := 'ML',

     inSession := '3');
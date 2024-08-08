-- Function: gpInsertUpdate_Object_ChoiceCell  

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ChoiceCell (Integer, Integer, TVarChar, Integer, Integer, TFloat,TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ChoiceCell(
 INOUT ioId                Integer   ,    -- ���� ������� <������ � ���������� �����������> 
    IN inCode              Integer   ,
    IN inName              TVarChar  ,    
    IN inGoodsId           Integer   ,    -- �����
    IN inGoodsKindId       Integer   ,    -- 
    IN inBoxCount          TFloat   ,    -- 
    IN inNPP               TFloat   ,    -- 
    IN inComment           TVarChar  ,    -- 
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
   DECLARE vbIsLoad Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   IF zfConvert_StringToNumber (inSession) < 0
   THEN
       vbIsLoad:= TRUE;
       vbUserId := lpCheckRight ((-1 * zfConvert_StringToNumber (inSession)) :: TVarChar, zc_Enum_Process_InsertUpdate_Object_ChoiceCell());
   ELSE
       vbIsLoad:= FAlSE;
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ChoiceCell());
   END IF;
   
   IF COALESCE (inNPP,0) = 0
   THEN
      RAISE EXCEPTION '������. � �/� �� �����������.';
   END IF;

   IF COALESCE (inCode,0) = 0
   THEN
      RAISE EXCEPTION '������. ��� �� ����������.';
   END IF;

   IF TRIM (COALESCE (inName,'')) = ''
   THEN
      RAISE EXCEPTION '������. �������� �� �����������.';
   END IF;


   IF COALESCE (inGoodsId,0) = 0 AND vbIsLoad = FALSE AND 1=0
   THEN
      RAISE EXCEPTION '������. ����� �� ����������.';
   END IF;


   IF COALESCE (inGoodsKindId,0) = 0 AND vbIsLoad = FALSE AND 1=0
   THEN
      RAISE EXCEPTION '������. ��� ������ �� ����������.';
   END IF;


   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   inCode:= lfGet_ObjectCode (inCode, zc_Object_ChoiceCell());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ChoiceCell(), inCode, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ChoiceCell_Goods(), ioId, inGoodsId);                          
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ChoiceCell_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ChoiceCell_NPP(), ioId, inNPP);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ChoiceCell_BoxCount(), ioId, inBoxCount);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ChoiceCell_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.24         * 
*/

-- ����
--
-- Function: gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BarCodeBox(
 INOUT ioId         Integer   , -- ���� ������� <������ �� �������>
    IN inCode       Integer   , -- �������� <��� >
    IN inBarCode    TVarChar  , -- �������� <�/�>
    IN inWeight     TFloat    , -- ������ ��� ��
    IN inBoxId      Integer   , -- ������ �� ����
    IN inSession    TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer;

BEGIN
    -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BarCodeBox());
   vbUserId := inSession;


    -- �������� <inName>
   IF TRIM (COALESCE (inBarCode, '')) = ''
   THEN
       RAISE EXCEPTION '������.�������� <�/�> ������ ���� �����������.';
   END IF;


   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_BarCodeBox());

   -- �������� ������������ ��� �������� <�/�>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_BarCodeBox(), inBarCode);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_BarCodeBox(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BarCodeBox(), vbCode_calc, inBarCode);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BarCodeBox_Box(), ioId, inBoxId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BarCodeBox_Weight(), ioId, inWeight);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.19         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_BarCodeBox()

-- Function: gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BarCodeBox(
 INOUT ioId           Integer   , -- ���� ������� <������ �� �������>
    IN inCode         Integer   , -- �������� <��� >
    IN inBarCode      TVarChar  , -- �������� <�/�>
    IN inWeight       TFloat    , -- ������ ��� ��
    IN inAmountPrint  TFloat    , -- ��� ��� ������
    IN inBoxId        Integer   , -- ������ �� ����
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BarCodeBox());
   vbUserId:= lpGetUserBySession (inSession);


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
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BarCodeBox_Print(), ioId, inAmountPrint);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.05.20         *
 14.05.19         *
*/
/*
SELECT *
    , gpInsertUpdate_Object_BarCodeBox(
     ioId          := 0
    , inCode       := tmp.a
    , inBarCode    := tmp.xxx
    , inWeight     := 0
    , inBoxId      := zc_Box_E3()
    , inSession    := '5'
)
from (
SELECT *, '1' || repeat ('0', 12 - LENGTH (tmp.a :: TVarChar) ) ||  tmp.a :: TVarChar as xxx
from (SELECT GENERATE_SERIES (300, 499) as a) as tmp
) as tmp
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Object_BarCodeBox()

-- Function: gpUpdate_Object_BarCodeBox_Print (Integer, Integer, TVarChar, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_BarCodeBox_Print (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_BarCodeBox_Print(
    IN inId           Integer   , -- ���� ������� <������ �� �������>
    IN inAmountPrint  TFloat    , -- ��� ��� ������
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BarCodeBox_Print(), inId, inAmountPrint);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.05.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_BarCodeBox_Print()

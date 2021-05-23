-- Function: gpUpdate_Object_DocumentTaxKind_Code(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentTaxKind_Code (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentTaxKind_Params (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DocumentTaxKind_Params(
 INOUT inId             Integer,       -- ���� ������� <>
    IN inCode           TVarChar,       -- �������� 
    IN inGoodsName      TVarChar,
    IN inMeasureName    TVarChar,
    IN inMeasureCode    TVarChar,
    In inPrice          TFloat,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_DocumentTaxKind_Code());


   -- ��������� �������� <��� �������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Code(), inId, inCode);
   -- ��������� �������� < >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Goods(), inId, inGoodsName);
   -- ��������� �������� < >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Measure(), inId, inMeasureName);
   -- ��������� �������� < >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_MeasureCode(), inId, inMeasureCode);
   -- ��������� �������� < >
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DocumentTaxKind_Price(), inId, inPrice);
    
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.18         *
 29.11.18         *
*/

-- ����
-- 
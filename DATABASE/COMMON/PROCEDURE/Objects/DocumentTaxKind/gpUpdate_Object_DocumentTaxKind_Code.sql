-- Function: gpUpdate_Object_DocumentTaxKind_Code(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_DocumentTaxKind_Code (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DocumentTaxKind_Code(
 INOUT inId             Integer,       -- ���� ������� <>
    IN inCode           TVarChar,       -- �������� 
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_DocumentTaxKind_Code());
   -- vbUserId := inSession;

   -- ��������� �������� <��� �������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DocumentTaxKind_Code(), inId, inCode);
 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.11.18         *
*/

-- ����
-- 
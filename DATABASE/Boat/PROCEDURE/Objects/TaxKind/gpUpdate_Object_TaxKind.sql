-- �������� �����

DROP FUNCTION IF EXISTS gpUpdate_Object_TaxKind (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_TaxKind(
    IN inId              Integer,       -- ���� ������� <>
    IN inName            TVarChar,      -- ������� �������� 
    IN inValue           TFloat  ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode   Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_TaxKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (inId, zc_Object_TaxKind(), inName, vbUserId);

   vbCode := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = inId AND Object.DescId = zc_Object_TaxKind());
   
   -- ���������
   PERFORM lpInsertUpdate_Object(inId, zc_Object_TaxKind(), vbCode, inName);
   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TaxKind_Value(), inId, inValue);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.21         *
*/

-- ����
--
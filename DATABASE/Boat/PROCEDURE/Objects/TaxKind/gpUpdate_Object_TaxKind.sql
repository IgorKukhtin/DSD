-- �������� �����

DROP FUNCTION IF EXISTS gpUpdate_Object_TaxKind (Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_TaxKind (Integer, TVarChar, TVarChar, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_TaxKind(
    IN inId              Integer,       -- ���� ������� <>
    IN inName            TVarChar,      -- ������� �������� 
    IN inCode_str        TVarChar,
    IN inValue           TFloat  ,
    IN inInfo            TVarChar,
    IN inEnum            TVarChar,
    IN inComment         TVarChar,
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
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_TaxKind_Code(), inId, inCode_str);
   -- ���������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Enum(), inId, inEnum);


   -- ���������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TaxKind_Value(), inId, inValue);

   -- ���������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_TaxKind_Info(), inId, inInfo);
   -- ���������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_TaxKind_Comment(), inId, inComment);

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
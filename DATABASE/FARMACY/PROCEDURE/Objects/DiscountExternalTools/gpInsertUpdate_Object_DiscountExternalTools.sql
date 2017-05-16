-- Function: gpInsertUpdate_Object_DiscountExternalTools()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalTools (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountExternalTools (Integer, Integer, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountExternalTools(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inUser                          TVarChar  , -- 
    IN inPassword                      TVarChar  , -- 
    IN inDiscountExternalId            Integer   , -- 
    IN inUnitId                        Integer   , -- 
    IN inExternalUnit                  TVarChar  , -- ������������� �������, ������������� ������, ������� ������������� �� ������� �������
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_DiscountExternalTools());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiscountExternalTools());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountExternalTools(), vbCode_calc, '');

 
   -- ��������� ����� � <������� (���������� �����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalTools_DiscountExternal(), ioId, inDiscountExternalId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountExternalTools_Unit(), ioId, inUnitId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalTools_User(), ioId, inUser);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalTools_Password(), ioId, inPassword);
   -- ��������� �������� <������������� �������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DiscountExternalTools_ExternalUnit(), ioId, inExternalUnit);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiscountExternalTools (ioId:=0, inCode:=0, inDiscountExternalToolsKindId:=0, inSession:='2')

-- Function: gpInsertUpdate_Object_DivisionParties (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_DivisionParties (Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DivisionParties(
    IN inId              Integer   ,    -- ���� ������� <>
    IN inCode            Integer   ,    -- ��� ������� <>
    IN inName            TVarChar  ,    -- ��������
    IN inisBanFiscalSale Boolean   ,    -- ������ ���������� �������
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDay Integer;
   DECLARE vbMonth Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_DivisionParties());

   -- ��������� <������>
   PERFORM lpInsertUpdate_Object (inId, zc_Object_DivisionParties(), inCode, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DivisionParties_BanFiscalSale(), inId, inBanFiscalSale);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.07.19                                                       *
*/

-- ����
--
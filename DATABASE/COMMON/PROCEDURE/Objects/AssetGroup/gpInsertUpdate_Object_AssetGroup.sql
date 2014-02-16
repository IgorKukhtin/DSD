-- Function: gpInsertUpdate_Object_AssetGroup()

-- DROP FUNCTION gpInsertUpdate_Object_AssetGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AssetGroup(
 INOUT ioId                  Integer   ,    -- ���� ������� < ������ �������� �������>
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� 
    IN inParentId            Integer   ,    -- ������ �� ������ �������� �������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_AssetGroup());
   vbUserId:= inSession;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_AssetGroup()); 

   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_AssetGroup(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_AssetGroup(), vbCode_calc);

   -- �������� ���� � ������
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_AssetGroup_Parent(), inParentId);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_AssetGroup(), inCode, inName);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_AssetGroup_Parent(), ioId, inParentId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AssetGroup(Integer, Integer, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.07.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_AssetGroup()

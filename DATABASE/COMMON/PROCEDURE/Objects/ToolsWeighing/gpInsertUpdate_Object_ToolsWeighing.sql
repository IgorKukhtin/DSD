-- Function: gpInsertUpdate_Object_ToolsWeighing

 DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ToolsWeighing(
 INOUT ioId                      Integer   , -- ���� �������
    IN inCode                    Integer   , -- ��� �������
    IN inValueData               TVarChar  , -- ��������
    IN inName                    TVarChar  , -- �������� �������
    IN inNameFull                TVarChar  , -- ������ ��������
    IN inNameUser                TVarChar  , -- �������� ��� ������������
    IN inParentId                Integer   , -- Parent ��������� �����������
    IN inSession                 TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbOldId Integer;
   DECLARE vbOldParentId integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ToolsWeighing());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!

   -- �������� ������������ <������������>
--   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ToolsWeighing(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ToolsWeighing(), vbCode_calc);

   -- �������� ���� � ������
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_ToolsWeighing_Parent(), inParentId);

   -- ���������
   vbOldId:= ioId;
   -- ���������
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_ToolsWeighing_Parent() AND ObjectId = ioId);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), vbCode_calc, inValueData, inAccessKeyId:= NULL);

   -- ��������� ����� � <��������� �����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ToolsWeighing_Parent(), ioId, inParentId);
   -- ��������� �������� <������ ��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameFull(), ioId, inNameFull);
   -- ��������� �������� <��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_Name(), ioId, inName);
   -- ��������� �������� <�������� ��� ������������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ToolsWeighing_NameUser(), ioId, inNameUser);

   -- ���� ���������
   IF vbOldId <> ioId THEN
      -- ���������� �������� ����\����� � ����
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- ����� ������ inParentId ���� ������
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_ToolsWeighing_Parent());
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.03.14                                                         *
*/

-- ����
 SELECT * FROM gpInsertUpdate_Object_ToolsWeighing (0,0, '','Name','Name Full','Name User',88935,'2')
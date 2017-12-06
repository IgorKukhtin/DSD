-- Function: gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_WorkTimeKind (Integer, Integer, TVarChar, TVarChar, Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_WorkTimeKind(
 INOUT ioId            Integer   ,    -- ���� ������� <>
    IN inCode          Integer   ,    -- ���
    IN inName          TVarChar  ,    -- ������������
    IN inShortName     TVarChar  ,    -- �������� ������������
    IN inTax           Tfloat    ,    -- % ��������� ������� �����	
    IN inSession       TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbIsUpdate Boolean;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_WorkTimeKind());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_WorkTimeKind());
   
   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_WorkTimeKind(), vbCode, TRIM (inName));
   
   
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_WorkTimeKind_ShortName(), ioId, inShortName);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_WorkTimeKind_Tax(), ioId, inTax);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, vbIsUpdate);

END;$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.17         *
*/

-- ����
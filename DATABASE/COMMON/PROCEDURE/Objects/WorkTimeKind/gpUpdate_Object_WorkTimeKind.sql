-- Function: gpUpdate_Object_WorkTimeKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_WorkTimeKind (Integer, TVarChar, Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_WorkTimeKind(
 INOUT inId            Integer   ,    -- ���� ������� <>
    IN inShortName     TVarChar  ,    -- �������� ������������ 	
    IN inTax           Tfloat    ,    -- % ��������� ������� �����
    IN inSession       TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_WorkTimeKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_WorkTimeKind_ShortName(), inId, inShortName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_WorkTimeKind_Tax(), inId, inTax);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.17         *
 01.10.13         * 

*/

-- ����
-- 
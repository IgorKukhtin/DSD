-- Function: gpInsertUpdate_Object_PartionDateKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionDateKind(
    IN inId            Integer   ,    -- ���� ������� <>
    IN inCode          Integer   ,    -- ��� ������� <>
    IN inName          TVarChar  ,    -- ��������
    IN inDay           Integer   ,    -- ���-�� ����
    IN inMonth 	       Integer   ,    -- ���-�� �������
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDay Integer;
   DECLARE vbMonth Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_PartionDateKind());

   -- ��������
   IF COALESCE (inDay,0) <> 0 AND COALESCE (inMonth,0) <> 0
   THEN
       RAISE EXCEPTION '������.������ ���� ������ ������ ���� �� ���������� ���.���� ��� ���.�������.';
   END IF;
   
   -- ��������� <������>
   PERFORM lpInsertUpdate_Object (inId, zc_Object_PartionDateKind(), inCode, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionDateKind_Day(), inId, inDay);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionDateKind_Month(), inId, inMonth);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.07.19         * inMonth
 15.07.19                                                       *
 19.04.19         * 
*/

-- ����
--
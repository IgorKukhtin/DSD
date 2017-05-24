-- Function: gpInsertUpdate_Object_SPKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_SPKind (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_SPKind(
 INOUT ioId            Integer   ,    -- ���� ������� <>
    IN inTax           TFloat    ,    -- % ������ �� �����
    IN inSession       TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SPKind());
   vbUserId := inSession;

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_SPKind_Tax(), ioId, inTax);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.05.17         * 

*/

-- ����
-- select * from gpUpdate_Object_SPKind(ioId := 3690840 , inTax := 100 ,  inSession := '3');

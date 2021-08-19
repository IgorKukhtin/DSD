-- Function: gpUpdate_Object_WorkTimeKind_NoSheetChoice (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_WorkTimeKind_NoSheetChoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_WorkTimeKind_NoSheetChoice(
    IN inId              Integer   ,    -- ���� ������� <>
    IN inisNoSheetChoice Boolean   ,    -- ����������� ����� � ������
   OUT outisNoSheetChoice Boolean  ,
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_WorkTimeKind_NoSheetChoice());

   outisNoSheetChoice := NOT inisNoSheetChoice;

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_WorkTimeKind_NoSheetChoice(), inId, outisNoSheetChoice);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, TRUE);

END;$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.08.21         *
*/

-- ����
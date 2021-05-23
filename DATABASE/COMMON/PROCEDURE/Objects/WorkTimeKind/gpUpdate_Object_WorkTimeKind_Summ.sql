-- Function: gpUpdate_Object_WorkTimeKind_Summ (Integer, Tfloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_WorkTimeKind_Summ (Integer, Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_WorkTimeKind_Summ(
 INOUT inId            Integer   ,    -- ���� ������� <>
    IN inSumm          TFloat    ,    -- ����� �� ���. ����, ���
    IN inSession       TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_WorkTimeKind_Summ());


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_WorkTimeKind_Summ(), inId, inSumm);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.20         *
*/

-- ����
-- 
-- Function: gpUpdate_Object_Maker_SendPlan ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_SendPlan (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_SendPlan(
    IN inId              Integer  ,     -- ���� ������� <�������������>
    IN inSendPlan        TDateTime,     -- ����� ��������� ���������(����/�����)
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendPlan(), inId, inSendPlan);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.01.19         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Maker()
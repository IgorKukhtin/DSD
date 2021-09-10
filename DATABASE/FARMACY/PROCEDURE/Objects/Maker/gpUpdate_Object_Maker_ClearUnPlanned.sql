-- Function: gpUpdate_Object_Maker_ClearUnPlanned (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_ClearUnPlanned (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_ClearUnPlanned(
    IN inId                  Integer  ,     -- ���� ������� <�������������>
    IN inSession             TVarChar       -- ������ ������������
)
 RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSendPlan TDateTime;    
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Maker_UnPlanned(), inId, False);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.09.21                                                       *
 
*/

-- ����
-- select * from gpUpdate_Object_Maker_ClearUnPlanned(inId := 3605302 , inSession := '3');
-- Function: gpUpdate_Object_Maker_UnPlanned (Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Maker_UnPlanned (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Maker_UnPlanned(
    IN inId                  Integer  ,     -- ���� ������� <�������������>
    IN inStartDateUnPlanned  TDateTime,     -- ���� ������ ��� ������������ ������
    IN inEndDateUnPlanned    TDateTime,     -- ���� ��������� ��� ������������ ������
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

   -- ��������� �������� <���� ������ ��� ������������ ������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_StartDateUnPlanned(), inId, inStartDateUnPlanned);
   -- ��������� �������� <���� ��������� ��� ������������ ������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_EndDateUnPlanned(), inId, inEndDateUnPlanned);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Maker_UnPlanned(), inId, True);


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
-- select * from gpUpdate_Object_Maker_UnPlanned(inId := 3605302 , inStartDateUnPlanned := ('01.05.2021')::TDateTime , inEndDateUnPlanned := ('31.08.2021')::TDateTime ,  inSession := '3');
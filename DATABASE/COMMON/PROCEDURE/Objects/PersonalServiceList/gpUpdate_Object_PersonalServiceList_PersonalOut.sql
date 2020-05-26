-- Function: gpUpdate_Object_PersonalServiceList_PersonalOut()

DROP FUNCTION IF EXISTS gpUpdate_Object_PersonalServiceList_PersonalOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PersonalServiceList_PersonalOut(
    IN inId                    Integer   ,     -- ���� ������� <> 
    IN inisPersonalOut         Boolean   ,     -- 
   OUT outisPersonalOut        Boolean   ,     --
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_PersonalServiceList_PersonalOut());

   -- �������� ��������
   outisPersonalOut:= Not inisPersonalOut;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_PersonalOut(), inId, outisPersonalOut);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.20         *
*/

-- ����
--
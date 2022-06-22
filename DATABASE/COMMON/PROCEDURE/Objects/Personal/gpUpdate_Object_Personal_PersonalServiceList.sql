-- Function: gpUpdate_Object_Personal_PersonalServiceList ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_PersonalServiceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_PersonalServiceList(
    IN inId                        Integer   , -- ���� ������� <����������>
    IN inPersonalServiceListId     Integer   , -- ����� ��������� ������.(�������)
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Personal_PersonalServiceList());

   --��������
   IF COALESCE (inPersonalServiceListId,0) = 0 
   THEN
        RAISE EXCEPTION '������.�������� ����� ��������� ������.(�������) �� �������.';
   END IF;

   -- ��������� ����� � <��������� ����������(�������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceList(), ioId, inPersonalServiceListId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.06.22         *
*/

-- ����
--
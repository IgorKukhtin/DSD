-- Function: gpUpdate_Object_Personal_PersonalServiceListCardSecond ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_PersonalServiceListCardSecond (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_PersonalServiceListCardSecond (
    IN inId                        Integer   , -- ���� ������� <����������>
    IN inPersonalServiceListId     Integer   , -- ����� ��������� ������.(����� �2)
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Personal_CardSecond());

   --��������
   IF COALESCE (inPersonalServiceListId,0) = 0 
   THEN
        RAISE EXCEPTION '������.�������� ����� ��������� ������.(����� �2) �� �������.';
   END IF;

   -- ��������� ����� � <��������� ����������(����� �2)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_PersonalServiceListCardSecond(), inId, inPersonalServiceListId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

  IF vbUserId = 9457
  THEN
        RAISE EXCEPTION 'Test.Ok.';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.04.25         *
*/

-- ����
--
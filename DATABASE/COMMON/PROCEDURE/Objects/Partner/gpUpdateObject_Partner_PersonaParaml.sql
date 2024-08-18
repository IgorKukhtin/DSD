-- Function: gpUpdate_Object_Partner_PersonalParam()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_PersonalParam (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_PersonalParam(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inPersonalId          Integer   ,    -- ��������� (�����������)
    IN inParam               Integer   ,    -- 1 ��������� �����������, 2 - ��������� (��������), 3 ��������� ����.
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Personal());

   
   IF inParam = 1
   THEN
       -- ��������� ����� � <��������� (�����������)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, inPersonalId);
   ELSEIF inParam = 2
   THEN
       -- ��������� ����� � <��������� (��������)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, inPersonalId);
   ELSEIF inParam = 3
   THEN
       -- ��������� ����� � <��������� (������������)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), inId, inPersonalId);
   END IF;    

 
   IF vbUserId = 9457
   THEN
       RAISE EXCEPTION 'Test. Ok!';
   END IF;     
     
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.08.24         *
*/

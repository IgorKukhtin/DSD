-- Function: gpUpdateObject_Partner_Personal()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_Personal (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_Personal(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inPersonalId          Integer   ,    -- ��������� (�����������)
    IN inPersonalTradeId     Integer   ,    -- ��������� (��������)
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_Params());

   -- ��������� ����� � <��������� (�����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- ��������� ����� � <��������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.05.20         *
*/

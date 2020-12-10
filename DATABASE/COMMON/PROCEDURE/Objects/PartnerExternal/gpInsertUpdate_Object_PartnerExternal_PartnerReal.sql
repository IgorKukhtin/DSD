-- Function: gpInsertUpdate_Object_PartnerExternal_PartnerReal  ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal_PartnerReal (Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerExternal_PartnerReal(
    IN inId            Integer   ,    --
    IN inPartnerRealId Integer   ,    --
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartnerId  Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PartnerExternal());

     -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_PartnerReal(), inId, inPartnerRealId);
                   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.12.20         *
*/

-- ����
--


-- Function: gpInsertUpdate_Object_PartnerExternal_Param  ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal_Param (Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerExternal_Param(
    IN inId            Integer   ,    --
    IN inPartnerId     Integer   ,    --
    IN inContractId    Integer   ,    --
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PartnerExternal());

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Partner(), inId, inPartnerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Contract(), inId, inContractId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.10.20         *
*/

-- ����
--
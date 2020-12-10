-- Function: gpInsertUpdate_Object_PartnerExternal_Param  ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal_Param (Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal_Param (Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerExternal_Param(
    IN inId            Integer   ,    --
    IN inPartnerId     Integer   ,    --
    IN inPartnerRealId Integer   ,    --
 INOUT ioContractId    Integer   ,    --
   OUT outContractName TVarChar ,
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartnerId  Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PartnerExternal());

   --���� �������� ���������� �������� �������
   vbPartnerId := (SELECT ObjectLink.ChildObjectId  
                   FROM ObjectLink 
                   WHERE ObjectLink.DescId = zc_ObjectLink_PartnerExternal_Partner()
                     AND ObjectLink.ObjectId = inId
                   );
   IF COALESCE (vbPartnerId,0) <> inPartnerId AND COALESCE (ioContractId, 0) <> 0
   THEN
      ioContractId := 0;
   END IF;

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_PartnerReal(), inId, inPartnerRealId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Partner(), inId, inPartnerId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartnerExternal_Contract(), inId, CASE WHEN COALESCE (vbPartnerId,0) <> inPartnerId THEN NULL ELSE ioContractId END);

  outContractName := COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Contract() AND Object.Id = ioContractId), '') :: TVarChar;
                    

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


-- Function: gpInsertUpdate_Object_PartnerExternal  ()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal (Integer,Integer,TVarChar,TVarChar,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartnerExternal (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartnerExternal(
 INOUT ioId                       Integer   ,    -- ���� ������� < > 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inObjectCode               TVarChar  ,    -- 
    IN inPartnerId                Integer   ,    --
    IN inContractId               Integer   ,    --
    IN inRetailId                 Integer   ,    --
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PartnerExternal());

   -- ��������� ��-�� <>
   ioId:= lpInsertUpdate_Object_PartnerExternal (ioId       := ioId
                                               , inCode       := inCode
                                               , inName       := inName
                                               , inObjectCode := inObjectCode
                                               , inPartnerId  := inPartnerId
                                               , inContractId := inContractId
                                               , inRetailId   := inRetailId
                                               , inUserId     := vbUserId
                                                );
   
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
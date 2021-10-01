-- Function: gpInsertUpdate_Object_MedicalProgramSPLink()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedicalProgramSPLink (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedicalProgramSPLink(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inMedicalProgramSPId            Integer   , -- 
    IN inUnitId                        Integer   , -- 
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MedicalProgramSPLink());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MedicalProgramSPLink());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MedicalProgramSPLink(), vbCode_calc, '');

 
   -- ��������� ����� � <������� (���������� �����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP(), ioId, inMedicalProgramSPId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MedicalProgramSPLink_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.10.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MedicalProgramSPLink (ioId:=0, inCode:=0, inMedicalProgramSPLinkKindId:=0, inSession:='2')

-- Function: gpInsertUpdate_Object_MedicalProgramSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedicalProgramSP (Integer, Integer, TVarChar, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedicalProgramSP(
 INOUT ioId	                       Integer   ,    -- ���� ������� <����������� ��������� ���. ��������> 
    IN inCode                      Integer   ,    -- ��� ������� 
    IN inName                      TVarChar  ,    -- �������� ������� <>
    IN inSPKindId                  Integer   ,    -- ���� ���. ��������
    IN inGroupMedicalProgramSPId   Integer   ,    -- ����������� ��������� ���. ��������
    IN inProgramId                 TVarChar  ,    -- ������������� ����������� ���������
    IN inisFree                    Boolean   ,    -- ���������
    IN inisElectronicPrescript     Boolean   ,    -- ����������� �������
    IN inSession                   TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;

   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MedicalProgramSP());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MedicalProgramSP(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MedicalProgramSP(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MedicalProgramSP(), vbCode_calc, inName);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MedicalProgramSP_SPKind(), ioId, inSPKindId);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MedicalProgramSP_GroupMedicalProgramSP(), ioId, inGroupMedicalProgramSPId);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MedicalProgramSP_ProgramId(), ioId, inProgramId);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_MedicalProgramSP_Free(), ioId, inisFree);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean( zc_ObjectBoolean_MedicalProgramSP_ElectronicPrescript(), ioId, inisElectronicPrescript);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.10.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MedicalProgramSP()
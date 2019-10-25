-- Function: gpUpdate_Object_Juridical_isBranchAll()

DROP FUNCTION IF EXISTS gpUpdate_Object_Juridical_isBranchAll (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Juridical_isBranchAll(
    IN inId                  Integer   ,  -- ���� ������� <> 
    IN inisBranchAll          boolean   , 
   OUT outisBranchAll         boolean   , 
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Juridical_BranchAll());

   outisBranchAll:= NOT inisBranchAll;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isBranchAll(), inId, outisBranchAll);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.19         *
*/

-- ����
--
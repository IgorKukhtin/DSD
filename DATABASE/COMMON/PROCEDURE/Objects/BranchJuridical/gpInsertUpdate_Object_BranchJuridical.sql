-- Function: gpInsertUpdate_Object_BranchJuridical  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BranchJuridical (Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BranchJuridical (Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BranchJuridical(
 INOUT ioId                Integer   ,    -- ���� ������� < > 
    IN inBranchId          Integer   ,    --   
    IN inJuridicalId       Integer   ,    --  
    IN inUnitId            Integer   ,    -- 
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BranchJuridical());
   
   
   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_Branch.ObjectId        
              FROM ObjectLink AS ObjectLink_Branch
                   LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                        ON ObjectLink_Juridical.ObjectId = ObjectLink_Branch.ObjectId 
                                       AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchJuridical_Juridical()

                   LEFT JOIN ObjectLink AS ObjectLink_Unit
                                        ON ObjectLink_Unit.ObjectId = ObjectLink_Branch.ObjectId 
                                       AND ObjectLink_Unit.DescId = zc_ObjectLink_BranchJuridical_Unit()
              WHERE ObjectLink_Branch.DescId = zc_ObjectLink_BranchJuridical_Branch()
                AND ObjectLink_Branch.ChildObjectId = inBranchId
                AND ObjectLink_Juridical.ChildObjectId = inJuridicalId
                AND ObjectLink_Unit.ChildObjectId = inUnitId
                AND ObjectLink_Branch.ObjectId <> COALESCE (ioId, 0)
              )
   THEN 
       RAISE EXCEPTION '������.%�������� ������ � <%> � ��.���� <%> ��� ���� � �����������.%������������ ���������.', CHR(13), lfGet_Object_ValueData (inBranchId), lfGet_Object_ValueData (inJuridicalId), CHR(13);
   END IF;   

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BranchJuridical(), 0, '');
                       
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchJuridical_Branch(), ioId, inBranchId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchJuridical_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchJuridical_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.11.24         *
 31.01.16         *

*/

-- ����
-- select * from gpInsertUpdate_Object_BranchJuridical(ioId := 0 , inCode := 1 , inName := '�����' , inPhone := '4444' , Mail := '���@kjjkj' , Comment := '' , inJuridicalId := 258441 , inJuridicalId := 0 , inBranchId := 0 , inBranchJuridicalKindId := 153272 ,  inSession := '5');

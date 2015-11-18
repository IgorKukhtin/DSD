-- Function: gpInsertUpdate_Object_(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BranchLink (Integer, Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BranchLink(
 INOUT ioId                       Integer   ,    -- ���� �������  
    IN inCode                     Integer   ,    -- ��� �������
    IN inName                     TVarChar  ,    -- �������� ������� 
    IN inBranchId                 Integer   ,    -- ������
    IN inPaidKindId               Integer   ,    -- ��� ������
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BranchLink(), 0, inName);

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchLink_Branch(), ioId, inBranchId);

   -- ��������� ����� � <��� ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchLink_PaidKind(), ioId, inPaidKindId);

   -- ��������� ��������
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_BranchLink (Integer, Integer, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.14                         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Car()

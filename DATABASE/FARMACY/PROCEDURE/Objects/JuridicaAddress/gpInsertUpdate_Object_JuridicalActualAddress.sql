-- Function: gpInsertUpdate_Object_JuridicalActualAddress (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalActualAddress (Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalActualAddress(
 INOUT ioId                Integer   ,    -- ���� ������� <>
    IN inCode              Integer   ,    -- ��� ������� <>
    IN inJuridicalId       Integer   ,    -- ��.����
    IN inAddressId         Integer   ,    -- �����
    IN inComment           TVarChar  ,    -- ����������
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalActualAddress());
   vbUserId := inSession; 

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_JuridicalActualAddress()); 
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalActualAddress(), vbCode_calc);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_JuridicalActualAddress(), vbCode_calc, inComment);

    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalActualAddress_Juridical(), ioId, inJuridicalId);
    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalActualAddress_Address(), ioId, inAddressId);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������ �.�.
 28.05.18        *
*/

-- ����
--
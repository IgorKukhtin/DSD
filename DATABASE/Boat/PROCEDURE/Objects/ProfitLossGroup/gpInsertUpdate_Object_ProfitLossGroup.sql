-- Function: gpInsertUpdate_Object_ProfitLossGroup(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_ProfitLossGroup (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLossGroup(
 INOUT ioId             Integer,       -- ���� ������� <������ ������ ������ � �������� � �������>
    IN inCode           Integer,       -- �������� <��� ������ ������ ������ � �������� � �������>
    IN inName           TVarChar,      -- �������� <������������ ������ ������ ������ � �������� � �������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_calc Integer;   
BEGIN
   -- !!! ��� �������� !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_ProfitLossGroup());

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ProfitLossGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
    Code_calc:=lfGet_ObjectCode (inCode, zc_Object_AccountGroup()); 
   
   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProfitLossGroup(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProfitLossGroup(), Code_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProfitLossGroup(), Code_calc, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.04.14                                        * rem !!! ��� �������� !!!
 08.09.13                                        * !!! ��� �������� !!!
 21.06.13          * zc_Enum_Process_InsertUpdate_Object_ProfitLossGroup(); Code_calc....  
 18.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProfitLossGroup()

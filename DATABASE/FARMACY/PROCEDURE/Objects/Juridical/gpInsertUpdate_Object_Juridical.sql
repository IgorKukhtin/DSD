-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������������>
    IN inCode                    Integer   ,    -- ��� ������� <�������������>
    IN inName                    TVarChar  ,    -- �������� ������� <�������������>
    IN inisCorporate             Boolean   ,    -- ������� ���� �� ������������� ��� ����������� ���� 
    IN inRetailId                Integer   ,    -- ������ �� �������������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId:= inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Juridical());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Juridical(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Juridical(), vbCode_calc, inName);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   
   -- ��������� ��������
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.14         * 

*/

-- ����
-- select * from gpInsertUpdate_Object_Juridical(ioId := 0 , inCode := 1 , inName := 'sdggsd' , inRetailId := 0 , inisCorporate := 'False' ,  inSession := '8');                        

-- Function: gpInsertUpdate_Object_RateFuelKind (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RateFuelKind (Integer,Integer,TVarChar, TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RateFuelKind (
 INOUT ioId              Integer   ,    -- ���� ������� <���� ���� ��� �������>
    IN inCode            Integer   ,    -- ��� ������� <>
    IN inName            TVarChar  ,    -- �������� ������� <>
    IN inTax             TFloat    ,    -- % ��������������� ������� � ����� � �������/������������
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RateFuelKind());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_RateFuelKind()); 
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_RateFuelKind(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RateFuelKind(), vbCode_calc);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RateFuelKind(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_RateFuelKind_Tax(), ioId, inTax);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ 

LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_RateFuelKind (Integer,Integer,TVarChar, TFloat,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.09.13          * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_RateFuelKind()

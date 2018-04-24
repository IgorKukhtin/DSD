-- Function: gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Currency(
 INOUT ioId           Integer,       -- ���� ������� <������>     
 INOUT ioCode         Integer,       -- ��� ������� <������>      
    IN inName         TVarChar,      -- �������� ������� <������> 
    IN inIncomeKoeff  TFloat  ,      -- ����������� ��� �������
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Currency());


   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Currency_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Currency_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- �������� ������������ ��� �������� <������������>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Currency(), inName); 
  

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Currency(), ioCode, inName);

   -- ��������� <����������� ��� �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Currency_IncomeKoeff(), ioId, inIncomeKoeff);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
24.04.18          *
13.05.17                                                          *
08.05.17                                                          *
02.03.17                                                          *
20.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Currency()

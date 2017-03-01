-- Function: gpInsertUpdate_Object_City (Integer,  TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_City (Integer,  TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_City(
 INOUT ioId           Integer,       -- ���� ������� <���������� �����>
    IN inName         TVarChar,      -- �������� ������� <���������� �����>
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_City());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (Code_max, 0) = 0 THEN Code_max := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_max:=lfGet_ObjectCode (Code_max, zc_Object_City()); 

   -- �������� ������������ ��� �������� <������������ ���������� �����>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_City(), inName);
   -- �������� ������������ ��� �������� <��� ���������� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_City(), Code_max);



   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_City(), Code_max, inName);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
28.02.2017                                                          *


*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_City()

-- Function: gpInsertUpdate_Object_CarModel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarModel (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CarModel(
 INOUT ioId             Integer   ,     -- ���� ������� < ����� ����������> 
    IN inCode           Integer   ,     -- ��� ������� <����� ����������> 
    IN inName           TVarChar  ,     -- �������� ������� <����� ����������>
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CarModel());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CarModel());
   
   -- �������� ���� ������������ ��� �������� <������������ ����� ����������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CarModel(), inName);
   -- �������� ���� ������������ ��� �������� <��� ����� ����������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CarModel(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CarModel(), vbCode_calc, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CarModel (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.13                                        * �������� ����� ���
 10.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CarModel()
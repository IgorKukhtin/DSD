-- Function: gpInsertUpdate_Object_TradeMark(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TradeMark(
 INOUT ioId                  Integer,       -- ���� ������� <�������>
    IN inCode                Integer,       -- �������� <��� ��������>
    IN inName                TVarChar,      -- �������� <������������ ��������>
    IN inColorReport         TFloat    ,     -- ���� ������ � "����� �� ��������"
    IN inColorBgReport       TFloat    ,     -- ���� ���� � "����� �� ��������"
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
 
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TradeMark());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_TradeMark();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- �������� ������������ ��� �������� <������������ ��������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_TradeMark(), inName);
   -- �������� ������������ ��� �������� <��� ��������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TradeMark(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TradeMark(), Code_max, inName);
   
   -- ��������� �������� <���� ������ � "����� �� ��������">
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorReport(), ioId, inColorReport);
   -- ��������� �������� <���� ���� � "����� �� ��������">
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorBgReport(), ioId, inColorBgReport);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.16         * 
 06.09.13                          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_TradeMark()

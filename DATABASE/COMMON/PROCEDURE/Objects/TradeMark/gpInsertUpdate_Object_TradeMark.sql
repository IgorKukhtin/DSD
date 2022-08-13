-- Function: gpInsertUpdate_Object_TradeMark(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TradeMark(
 INOUT ioId                  Integer,       -- ���� ������� <�������>
    IN inCode                Integer,       -- �������� <��� ��������>
    IN inName                TVarChar,      -- �������� <������������ ��������>
    IN inColorReport         TFloat  ,      -- ���� ������ � "����� �� ��������"
    IN inColorBgReport       TFloat  ,      -- ���� ���� � "����� �� ��������" 
    IN inRetailId            Integer ,      --
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TradeMark());
   vbUserId:= lpGetUserBySession (inSession);


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
   IF (COALESCE (inColorReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorReport(), ioId, inColorReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorReport(), ioId, Null);
   END IF;

   -- ��������� �������� <���� ���� � "����� �� ��������">
   IF (COALESCE (inColorBgReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorBgReport(), ioId, inColorBgReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_TradeMark_ColorBgReport(), ioId, Null);
   END IF;

   -- ��������� ����� � <���� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_TradeMark_Retail(), ioId, inRetailId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_TradeMark (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.22         * zc_ObjectLink_TradeMark_Retail
 05.12.16         * 
 06.09.13                          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_TradeMark()

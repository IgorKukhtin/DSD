-- Function: gpInsertUpdate_Object_GoodsInfo (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsInfo (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsInfo(
 INOUT ioId           Integer,       -- ���� ������� <GoodsInfo>
    IN inCode         Integer,       -- �������� <��� GoodsInfo�>
    IN inName         TVarChar,      -- ������� �������� GoodsInfo�
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer
  AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   UserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_GoodsInfo();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ������������ ��� �������� <������������ GoodsInfo�>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsInfo(), inName); 
   -- �������� ������������ ��� �������� <��� GoodsInfo�>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsInfo(), Code_max);



   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsInfo(), Code_max, inName);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
19.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsInfo()

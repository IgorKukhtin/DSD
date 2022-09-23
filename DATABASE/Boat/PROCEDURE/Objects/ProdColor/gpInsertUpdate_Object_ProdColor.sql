-- �������� �����

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColor (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColor (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColor(
 INOUT ioId              Integer,       -- ���� ������� <�����>
 INOUT ioCode            Integer,       -- �������� <��� ������>
    IN inName            TVarChar,      -- ������� �������� ������
    IN inComment         TVarChar,      -- 
    IN inValue           TVarChar,      --
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;  
   DECLARE vbColor_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProdColor());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_ProdColor()); 

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdColor(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdColor(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColor_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColor_Value(), ioId, inValue);
   
   IF inValue <> ''
   THEN
      BEGIN
         EXECUTE('SELECT CAST(x'''||SUBSTRING(inValue, 2, 7)||''' AS INT8)') INTO vbColor_calc;
      EXCEPTION
         WHEN others THEN vbColor_calc := zc_Color_White();
      END;     
   ELSE
     vbColor_calc := zc_Color_White();
   END IF;

   -- ��������� �������� <>
   IF vbColor_calc <> zc_Color_White() OR
      EXISTS(SELECT 1 FROM ObjectFloat
             WHERE ObjectId = ioId AND DescId = zc_ObjectFloat_ProdColor_Value())
   THEN
     PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ProdColor_Value(), ioId, vbColor_calc);
   END IF;
   

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdColor()
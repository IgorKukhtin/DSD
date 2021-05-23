-- Function: gpInsertUpdate_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag(Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsTag(Integer, Integer, TVarChar, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsTag(
 INOUT ioId                  Integer   ,     -- ���� ������� <������� ������> 
    IN inCode                Integer   ,     -- ��� �������  
    IN inName                TVarChar  ,     -- �������� ������� 
    IN inGoodsGroupAnalystId Integer   ,     -- ������ �� ������ ������� (���������) 
    IN inColorReport         TFloat    ,     -- ���� ������ � "����� �� ��������"
    IN inColorBgReport       TFloat    ,     -- ���� ���� � "����� �� ��������"
    IN inSession             TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag());
   vbUserId:= lpGetUserBySession (inSession);


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_GoodsTag());
   
   -- �������� ���� ������������ ��� �������� <������������>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsTag(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsTag(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsTag(), vbCode_calc, inName);
   
      -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsTag_GoodsGroupAnalyst(), ioId, inGoodsGroupAnalystId); 

   -- ��������� �������� <���� ������ � "����� �� ��������">
   IF (COALESCE (inColorReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorReport(), ioId, inColorReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorReport(), ioId, Null);
   END IF;

   -- ��������� �������� <���� ���� � "����� �� ��������">
   IF (COALESCE (inColorBgReport,0) <> 0 AND COALESCE (inColorBgReport,0) <> zc_Color_White())
      THEN
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorBgReport(), ioId, inColorBgReport);
      ELSE
          PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsTag_ColorBgReport(), ioId, Null);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsTag (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.12.16         * 
 12.01.15         * add GoodsGroupAnalyst
 15.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsTag(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')

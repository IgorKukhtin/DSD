-- Function: gpInsertUpdate_Object_Product()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat
                                                    , TDateTime, TDateTime, TDateTime
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     );

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Product(
 INOUT ioId            Integer   ,    -- ���� ������� <�����>
    IN inCode          Integer   ,    -- ��� �������
    IN inName          TVarChar  ,    -- �������� �������
    IN inBrandId       Integer   ,
    IN inModelId       Integer   ,
    IN inEngineId      Integer   ,
    IN inHours         TFloat    ,
    IN inDateStart     TDateTime ,
    IN inDateBegin     TDateTime ,
    IN inDateSale      TDateTime ,
    IN inArticle       TVarChar  ,
    IN inCIN           TVarChar  ,
    IN inEngineNum     TVarChar  ,
    IN inComment       TVarChar  ,
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
 --DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   -- vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Product());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- !!! �������� !!!
   IF COALESCE (ioId, 0) = 0 AND CEIL (inCode / 2) * 2 = inCode THEN inDateSale:= NULL; END IF;

   -- �������� - ������ ���� ������� - �����
   IF COALESCE (inCode, 0) = 0 THEN
      --RAISE EXCEPTION '������.������ ���� ��������� ��� - �����.';
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.������ ���� ��������� ��� - �����.' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                            );
   END IF;

   inName:= SUBSTRING (COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBrandId), ''), 1, 2)
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inModelId), '')
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inEngineId), '')
             || ' ' || inCIN
             ;

   -- �������� ���� ������������ ��� �������� <������������ >
 --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Product(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Product(), inCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Product_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Product_Hours(), ioId, inHours);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateStart(), ioId, inDateStart);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), ioId, inDateBegin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateSale(), ioId, inDateSale);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_CIN(), ioId, inCIN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), ioId, inEngineNum);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Brand(), ioId, inBrandId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Model(), ioId, inModelId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Engine(), ioId, inEngineId);

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

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Product()

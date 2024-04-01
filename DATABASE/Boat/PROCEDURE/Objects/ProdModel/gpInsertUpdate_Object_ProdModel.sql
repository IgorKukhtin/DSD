-- Function: gpInsertUpdate_Object_ProdModel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdModel(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdModel(
 INOUT ioId                  Integer   ,    -- ���� ������� <������>
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� 
    IN inLength              TFloat    ,
    IN inBeam                TFloat    ,
    IN inHeight              TFloat    ,
    IN inWeight              TFloat    ,
    IN inFuel                TFloat    ,
    IN inSpeed               TFloat    ,
    IN inSeating             TFloat    ,
    IN inPatternCIN          TVarChar  ,
    IN inComment             TVarChar  ,
    IN inBrandId             Integer   ,
    IN inProdEngineId        Integer   ,
    IN inReceiptProdModelId  Integer   , -- ��� ������ ������ ������ ��������� ����  
    IN inPriceListId         Integer   , 
    IN inOperDate            TDateTime ,   -- ���� ��������� ���� 
    IN inBasisPrice          TFloat,
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProdModel());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProdModel()); 

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdModel(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdModel(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdModel_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdModel_PatternCIN(), ioId, inPatternCIN);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Length(), ioId, inLength);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Beam(), ioId, inBeam);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Height(), ioId, inHeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Weight(), ioId, inWeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Fuel(), ioId, inFuel);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Speed(), ioId, inSpeed);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProdModel_Seating(), ioId, inSeating);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdModel_Brand(), ioId, inBrandId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdModel_ProdEngine(), ioId, inProdEngineId);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��� ������ ������ ������ ��������� ���� 
   PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := NULL                  -- ��� ������ ������ Id
                                                         , inPriceListId:= COALESCE (inPriceListId, zc_PriceList_Basis()) ::Integer  -- !!!������� �����!!!
                                                         , inGoodsId    := inReceiptProdModelId  :: Integer
                                                         , inOperDate   := inOperDate   :: TDateTime
                                                         , ioPriceNoVAT := inBasisPrice :: TFloat
                                                         , ioPriceWVAT  := 0            :: TFloat
                                                         , inIsLast     := TRUE         :: Boolean
                                                         , inSession    := inSession    :: TVarChar
                                                          ) AS tmp;
       
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.04.24         *
 11.01.21         * PatternCIN
 30.11.20         * add inProdEngineId
 24.11.20         * add inBrandId
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdModel()

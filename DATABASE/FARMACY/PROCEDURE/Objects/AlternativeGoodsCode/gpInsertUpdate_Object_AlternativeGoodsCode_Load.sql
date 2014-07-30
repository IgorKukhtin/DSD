-- Function: gpInsertUpdate_Object_AlternativeGoodsCode(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AlternativeGoodsCode (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AlternativeGoodsCode(
 INOUT ioId               Integer   , -- ���� ������� <������� ��������>
    IN inGoodsMainCode    TVarChar  , -- ������� �����
    IN inGoodsCode        TVarChar  , -- ����� ��� ������
    IN inRetailId         Integer   , -- �������� ����
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsMainId Integer;
   DECLARE vbGoodsId  Integer;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGoodsCode());
     SELECT Id from Object_Goods_View
      WHERE ObjectId = 25603 AND GoodsCode = 24673::TVarChar

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AlternativeGoodsCode(
    IN inGoodsMainId   , -- ������� �����
    IN inGoodsId       , -- ����� ��� ������
    IN inRetailId      , -- �������� ����
    IN inSession          TVarChar    -- ������ ������������
   

   -- ��������� ��������
--   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AlternativeGoodsCode (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.07.14         *
  
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_AlternativeGoodsCode (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')

--
DROP FUNCTION IF EXISTS gpInsert_Object_Goods_joint (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_Goods_joint(
    IN inGoodsGroupId    Integer ,
 INOUT ioGoodsId         Integer ,
    IN inGoodsName       TVarChar,
    IN inArticle         TVarChar,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   --���� ����� ��������, �� ������ �� ������
   IF COALESCE (ioGoodsId,0) <> 0
   THEN
        RETURN;
   END IF;

   -- ������� ����� �����
   IF COALESCE (inGoodsName, '') <> ''
   THEN
       -- �� ��������
       ioGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData = TRIM (inGoodsName));

       IF COALESCE (ioGoodsId, 0) = 0
       THEN
       -- �������
       ioGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (ioGoodsId,0):: Integer
                                              , inCode             := 0                     :: Integer
                                              , inName             := TRIM (inGoodsName)    :: TVarChar
                                              , inArticle          := TRIM (inArticle)     :: TVarChar
                                              , inArticleVergl     := ''                    :: TVarChar
                                              , inEAN              := ''                    :: TVarChar
                                              , inASIN             := ''                    :: TVarChar
                                              , inMatchCode        := ''                    :: TVarChar 
                                              , inFeeNumber        := ''                    :: TVarChar
                                              , inComment          := ''                    :: TVarChar
                                              , inIsArc            := False                 :: Boolean
                                              , inAmountMin        := 0                :: TFloat
                                              , inAmountRefer      := 0                :: TFloat
                                              , inEKPrice          := 0                :: TFloat
                                              , inEmpfPrice        := 0                :: TFloat
                                              , inGoodsGroupId     := inGoodsGroupId   :: Integer
                                              , inMeasureId        := 2761             :: Integer           --��
                                              , inGoodsTagId       := 0 -- vbGoodsTagId     :: Integer
                                              , inGoodsTypeId      := 0                :: Integer
                                              , inGoodsSizeId      := 0                :: Integer
                                              , inProdColorId      := 0                :: Integer
                                              , inPartnerId        := 0                :: Integer
                                              , inUnitId           := 0                :: Integer
                                              , inDiscountPartnerId := 0               :: Integer
                                              , inTaxKindId        := 2726             :: Integer                  --�������
                                              , inEngineId         := NULL
                                              , inSession          := inSession        :: TVarChar
                                              );
       END IF;

       --RAISE EXCEPTION '������.???';

   END IF;



   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods_From_Excel()
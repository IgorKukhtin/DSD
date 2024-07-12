 -- Function: gpInsertUpdate_Object_ChoiceCell_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ChoiceCell_Load (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ChoiceCell_Load(
    IN inNPP           Integer    , 
    IN inCode          Integer    , 
    IN inName          TVarChar    ,
    IN inGoodsCode     Integer    , 
    IN inGoodsName     TVarChar    , 
    IN inGoodsKindName TVarChar    ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbChoiceCellId Integer;
   DECLARE vbGoodsId      Integer;
   DECLARE vbGoodsKindId  Integer;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ��� - ����������!!!
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN; -- !!!�����!!!
     END IF;

     --������� ����� ������ �� ����
     vbChoiceCellId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ChoiceCell() AND Object.ObjectCode = inCode);
     
     --������� ����� �� ����
     vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);

     IF COALESCE (vbGoodsId,0) = 0
     THEN
        RAISE EXCEPTION '������. ����� <%>% �� ������.';     --, lfGet_Object_ValueData(UnitId), 
     END IF;
     
     --������� ��� ������
     vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());

     IF COALESCE (vbGoodsKindId,0) = 0
     THEN
        RAISE EXCEPTION '������. ��� ������ <%> �� ������.';
     END IF;

     IF COALESCE (vbChoiceCellId,0) = 0
     THEN
         PERFORM gpInsertUpdate_Object_ChoiceCell( ioId          := COALESCE (vbChoiceCellId,0) :: Integer
                                                 , inCode        := inCode                      :: Integer
                                                 , inName        := TRIM (inName) :: TVarChar
                                                 , inGoodsId     := vbGoodsId     :: Integer
                                                 , inGoodsKindId := vbGoodsKindId :: Integer
                                                 , inBoxCount    := NULL         :: TFloat
                                                 , inNPP         := NULL         :: TFloat
                                                 , inComment     := NULL      :: TVarChar
                                                 , inSession     := inSession :: TVarChar 
                                                 );
     ELSE 
         PERFORM gpInsertUpdate_Object_ChoiceCell( ioId          := COALESCE (vbChoiceCellId,0) :: Integer
                                                 , inCode        := inCode                      :: Integer
                                                 , inName        := TRIM (inName) :: TVarChar
                                                 , inGoodsId     := vbGoodsId     :: Integer
                                                 , inGoodsKindId := vbGoodsKindId :: Integer
                                                 , inBoxCount    := tmp.BoxCount  :: TFloat
                                                 , inNPP         := inNPP       :: TFloat
                                                 , inComment     := tmp.Comment   :: TVarChar
                                                 , inSession     := inSession     :: TVarChar 
                                                 )
         FROM gpSelect_Object_ChoiceCell (FALSE, inSession) AS tmp
         WHERE tmp.Id = vbChoiceCellId;
         
     END IF;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.24         *
*/

-- ����
--
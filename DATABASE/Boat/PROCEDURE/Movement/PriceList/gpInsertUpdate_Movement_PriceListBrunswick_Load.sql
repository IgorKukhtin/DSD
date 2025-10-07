--

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListBrunswick_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListBrunswick_Load(
    IN inOperDate                   TDateTime,     -- ���� ���������
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      --
    IN inGoodsGroupName             TVarChar,      --
    IN inNonStocking                TVarChar,      --
    IN inAmount                     TFloat  ,      --price
    IN inWeight                     TFloat  ,      --���
    IN inSession                    TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbGoodsGroupId     Integer;
  DECLARE vbCount            Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- RAISE EXCEPTION '������. inArticle = <%>  �� ������.', inArticle;

    IF TRIM (inNonStocking) ILIKE 'NON STOCKING ITEMS'
    THEN
        RETURN;
    END IF;

    -- E��� ��� ���� - �����
    IF COALESCE (inAmount, 0) = 0
    THEN
        RETURN;
    END IF;

    -- �������� - E��� �� �����
    IF COALESCE (inPartnerId,0) = 0
    THEN
         RAISE EXCEPTION '������.�� ������ ���������';
    END IF;


   IF COALESCE (inArticle,'') <> ''
   THEN
          -- ��������
          vbCount:= (SELECT COUNT(*) FROM ObjectString AS OS WHERE OS.ValueData ILIKE inArticle AND OS.DescId = zc_ObjectString_Article());

          -- ����� � ���. ������
          vbGoodsId := (SELECT ObjectString_Article.ObjectId
                        FROM ObjectString AS ObjectString_Article
                             INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                              AND Object.DescId   = zc_Object_Goods()
                                            --AND Object.isErased = FALSE
                        WHERE ObjectString_Article.ValueData ILIKE inArticle
                          AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                        LIMIT 1
                       );

          -- E��� �� ����� ������� �����
          IF COALESCE (vbGoodsId,0) = 0
          THEN

             vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inGoodsGroupName)));
             --���� ��� ����� ������ �������
              IF COALESCE (vbGoodsGroupId,0) = 0
              THEN
                   vbGoodsGroupId := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                           , ioCode            := 0         :: Integer
                                                                           , inName            := CAST (TRIM (inGoodsGroupName) AS TVarChar) ::TVarChar
                                                                           , inParentId        := 0         :: Integer
                                                                           , inInfoMoneyId     := 0         :: Integer
                                                                           , inModelEtiketenId := 0         :: Integer
                                                                           , inSession         := inSession :: TVarChar
                                                                            ) AS tmp);
              END IF;






             -- �������
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId                := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode              := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName              := TRIM (inGoodsName)       :: TVarChar
                                                    , inArticle           := TRIM (inArticle)         :: TVarChar
                                                    , inArticleVergl      := Null     :: TVarChar
                                                    , inEAN               := Null     :: TVarChar
                                                    , inASIN              := Null     :: TVarChar
                                                    , inMatchCode         := Null     :: TVarChar
                                                    , inFeeNumber         := Null     :: TVarChar
                                                    , inComment           := Null     :: TVarChar
                                                    , inGoodsSizeName     := Null     :: TVarChar
                                                    , inIsArc             := FALSE    :: Boolean
                                                    , inFeet              := 0        :: TFloat
                                                    , inMetres            := 0        :: TFloat
                                                    , inWeight            := inWeight :: TFloat -- ���
                                                    , inAmountMin         := 0        :: TFloat
                                                    , inAmountRefer       := 0        :: TFloat
                                                    , inEKPrice           := CAST (inAmount AS NUMERIC (16,2)) :: TFloat
                                                    , inEmpfPrice         := 0              :: TFloat
                                                    , inGoodsGroupId      := vbGoodsGroupId :: Integer  --NEW
                                                    , inMeasureId         := 0           :: Integer
                                                    , inGoodsTagId        := 0           :: Integer
                                                    , inGoodsTypeId       := 0           :: Integer
                                                    , inProdColorId       := 0           :: Integer
                                                    , inPartnerId         := inPartnerId :: Integer
                                                    , inUnitId            := 0           :: Integer
                                                    , inDiscountPartnerId := 0           :: Integer
                                                    , inTaxKindId         := 0           :: Integer
                                                    , inEngineId          := NULL        :: Integer
                                                    , inPriceListId       := Null        :: Integer
                                                    , inStartDate_price   := Null        :: TDateTime
                                                    , inOperPriceList     := 0           :: TFloat
                                                    , inSession           := inSession   :: TVarChar
                                                    );

          ELSEIF EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbGoodsId AND Object.isErased = TRUE)
          THEN
               UPDATE Object SET isErased = FALSE WHERE Object.Id = vbGoodsId AND Object.isErased = TRUE;
          END IF;


          -- ��������
          IF 1 < (SELECT COUNT(*)
                  FROM Movement
                       INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                     ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                    AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
                                                    AND MovementLinkObject_Partner.ObjectId   = inPartnerId
                  WHERE Movement.OperDate = inOperDate
                    AND Movement.DescId   = zc_Movement_PriceList()
                    AND Movement.StatusId <> zc_Enum_Status_Erased()
                 )
          THEN
              RAISE EXCEPTION '������.������ ���� ���� �������� � ������%��� ��������� = <%> �� = <%>.'
                             , CHR (13)
                             , lfGet_Object_ValueData_sh (inPartnerId)
                             , zfConvert_DateToString (inOperDate)
                              ;
          END IF;

          -- ������� ����� ��������
          vbMovementId := (SELECT Movement.Id
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                              ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                             AND MovementLinkObject_Partner.DescId     = zc_MovementLinkObject_Partner()
                                                             AND MovementLinkObject_Partner.ObjectId   = inPartnerId
                           WHERE Movement.OperDate = inOperDate
                             AND Movement.DescId   = zc_Movement_PriceList()
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                          );
          -- E��� �� ����� �������
          IF COALESCE (vbMovementId,0) = 0
          THEN
               --
               vbMovementId := lpInsertUpdate_Movement_PriceList(ioId         := 0
                                                               , inInvNumber  := CAST (NEXTVAL ('movement_PriceList_seq') AS TVarChar)
                                                               , inOperDate   := inOperDate
                                                               , inPartnerId  := inPartnerId
                                                               , inComment    := 'auto'
                                                               , inUserId     := vbUserId
                                                               );
          END IF;

          -- ����� �������� � ����� �������, ����� ��� ���������, ����� ���������
          vbMovementItemId := (SELECT MovementItem.Id
                               FROM MovementItem
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.ObjectId   = vbGoodsId
                              );


          -- ��������� <������� ���������>
          vbMovementItemId:=  lpInsertUpdate_MovementItem_PriceList (ioId                := COALESCE (vbMovementItemId,0) ::Integer
                                                                   , inMovementId        := vbMovementId                  ::Integer
                                                                   , inGoodsId           := vbGoodsId                     ::Integer
                                                                   , inDiscountPartnerId := 0            ::Integer
                                                                   , inMeasureId         := 0            ::Integer
                                                                   , inMeasureParentId   := 0            ::Integer
                                                                   , inAmount            := CAST (inAmount AS NUMERIC (16,2)) ::TFloat
                                                                   , inMeasureMult       := 0            ::TFloat
                                                                   , inPriceParent       := 0            ::TFloat
                                                                   , inEmpfPriceParent   := 0            ::TFloat
                                                                   , inMinCount          := 0            ::TFloat
                                                                   , inMinCountMult      := 0            ::TFloat
                                                                   , inWeightParent      := 0            ::TFloat
                                                                   , inCatalogPage       := ''           ::TVarChar
                                                                   , inisOutlet          := FALSE        ::Boolean
                                                                   , inUserId            := vbUserId     :: Integer
                                                                    );

        -- ��������
        IF vbCount < (SELECT COUNT(*) FROM ObjectString AS OS WHERE OS.ValueData ILIKE inArticle AND OS.DescId = zc_ObjectString_Article())
           AND vbCount > 0
        THEN
            RAISE EXCEPTION '������.������������ Article = <%> (%) (%) % <%>'
                           , inArticle
                           , vbCount
                           , (SELECT COUNT(*) FROM ObjectString AS OS WHERE OS.ValueData ILIKE inArticle AND OS.DescId = zc_ObjectString_Article())
                           , CHR (13)
                           , inGoodsName
                            ;
        END IF;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.10.25         *
*/

-- ����
--
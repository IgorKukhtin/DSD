
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PriceListOsculati_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PriceListOsculati_Load(
    IN inOperDate                   TDateTime,     -- ���� ���������
    IN inPartnerId                  Integer,
    IN inArticle                    TVarChar,      -- Article
    IN inGoodsName                  TVarChar,      -- 
    IN inMeasureName                TVarChar,      -- 
    IN inFeeNumber                  TVarChar,      -- 
    IN inMeasureMult                TFloat  ,      -- 
    IN inEmpfPriceParent            TFloat  ,
    IN inPriceParent                TFloat  ,
    IN inAmount                     TFloat  ,
    IN inMinCount                   TFloat  ,      -- 
    IN inMinCountMult               TFloat  ,
    IN inWeightParent               TFloat  ,      -- 
    IN inisOutlet                   TVarChar,
    IN inGoodsName_ita              TVarChar,
    IN inGoodsName_eng              TVarChar,
    IN inGoodsName_fra              TVarChar,
    IN inMeasure_ita                TVarChar,
    IN inMeasureParentName          TVarChar,
    IN inDiscountPartnerName        TVarChar,
    IN inEAN                        TVarChar,
    IN inCatalogPage                TVarChar,
    IN inSession                    TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId           Integer;
  DECLARE vbGoodsId          Integer;
  DECLARE vbMovementId       Integer;
  DECLARE vbMovementItemId   Integer;
  DECLARE vbMeasureId        Integer;
  DECLARE vbMeasureParentId        Integer;
  DECLARE vbObjectIdMeasure_ita    Integer;
  DECLARE vbObjectId_eng        Integer;
  DECLARE vbObjectId_fra        Integer;
  DECLARE vbObjectId_ita        Integer;
  DECLARE vbdiscountpartnerid Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

    -- E��� �� ����� ����������
    IF COALESCE (inPartnerId,0) = 0
    THEN
         RAISE EXCEPTION '������.�� ������ ���������';
    END IF;

  /*IF inArticle = '66.045.02'
    THEN
         RAISE EXCEPTION '������. %   %   %', inAmount, inPriceParent, inMeasureMult;
    END IF;*/


   IF COALESCE (inMeasureName,'')<> ''
   THEN
       vbMeasureId := (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_Measure() AND TRIM (Object.ValueData) = TRIM (inMeasureName) );    -- UPPER (TRIM (Object.ValueData))
       --���� �� ������� �������
       IF COALESCE (vbMeasureId,0) = 0
       THEN
   
        vbMeasureId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_Measure (ioId           := 0         :: Integer
                                                          , ioCode         := 0         :: Integer
                                                          , inName         := TRIM (inMeasureName) :: TVarChar
                                                          , inInternalCode := ''        :: TVarChar
                                                          , inInternalName := ''        :: TVarChar
                                                          , inSession      := inSession :: TVarChar
                                                           ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inMeasureParentName,'')<> ''
   THEN
       vbMeasureParentId := (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_Measure() AND TRIM (Object.ValueData) = TRIM (inMeasureParentName) );    --���� ����� ������ ������ ����� � ���. Id --AND Object.isErased = FALSE
       --���� �� ������� �������
       IF COALESCE (vbMeasureParentId,0) = 0
       THEN
   
        vbMeasureParentId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_Measure (ioId           := 0         :: Integer
                                                                , ioCode         := 0         :: Integer
                                                                , inName         := TRIM (inMeasureParentName) :: TVarChar
                                                                , inInternalCode := ''        :: TVarChar
                                                                , inInternalName := ''        :: TVarChar
                                                                , inSession      := inSession :: TVarChar
                                                                 ) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inDiscountPartnerName,'')<> ''
   THEN
       vbDiscountPartnerId := (SELECT MIN (Object.Id) FROM Object WHERE Object.DescId = zc_Object_DiscountPartner() AND TRIM (Object.ValueData) = TRIM (inDiscountPartnerName));    
       --���� �� ������� �������
       IF COALESCE (vbDiscountPartnerId,0) = 0
       THEN

       vbDiscountPartnerId := (SELECT tmp.ioId
                              FROM gpInsertUpdate_Object_DiscountPartner (ioId           := 0         :: Integer
                                                                        , ioCode         := 0         :: Integer
                                                                        , inName         := TRIM (inDiscountPartnerName) :: TVarChar
                                                                        , inComment      := ''        :: TVarChar
                                                                        , inSession      := inSession :: TVarChar
                                                                         ) AS tmp);
       END IF;
   END IF;
   
   IF COALESCE (inArticle,'') <> ''
   THEN
          -- ����� � ���. ������
          vbGoodsId := (SELECT ObjectString_Article.ObjectId
                        FROM ObjectString AS ObjectString_Article
                             INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                              AND Object.DescId   = zc_Object_Goods()
                                              AND Object.isErased = FALSE
                        WHERE ObjectString_Article.ValueData ILIKE inArticle
                          AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                        LIMIT 1
                       );

          -- E��� �� ����� ������� �����
          IF COALESCE (vbGoodsId,0) = 0
          THEN
             -- �������
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName             := CASE WHEN TRIM (inGoodsName) <> ''     THEN TRIM (inGoodsName)
                                                                                 WHEN TRIM (inGoodsName_eng) <> '' THEN TRIM (inGoodsName_eng)
                                                                                 WHEN TRIM (inGoodsName_ita) <> '' THEN TRIM (inGoodsName_ita)
                                                                                 WHEN TRIM (inGoodsName_fra) <> '' THEN TRIM (inGoodsName_fra)
                                                                            END
                                                    , inArticle          := TRIM (inArticle)
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := inEAN    :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := Null     :: TVarChar 
                                                    , inFeeNumber        := inFeeNumber :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inAmountMin        := 0             :: TFloat
                                                    , inAmountRefer      := 0             :: TFloat
                                                    , inEKPrice          := inAmount      :: TFloat
                                                    , inEmpfPrice        := 0             :: TFloat
                                                    , inGoodsGroupId     := 40422         :: Integer  --NEW
                                                    , inMeasureId        := vbMeasureId   :: Integer
                                                    , inGoodsTagId       := 0 -- vbGoodsTagId     :: Integer
                                                    , inGoodsTypeId      := 0        :: Integer
                                                    , inGoodsSizeId      := 0        :: Integer
                                                    , inProdColorId      := 0        :: Integer
                                                    , inPartnerId        := inPartnerId      :: Integer
                                                    , inUnitId           := 0                :: Integer
                                                    , inDiscountPartnerId := vbDiscountPartnerId    :: Integer
                                                    , inTaxKindId        := 0                :: Integer
                                                    , inEngineId         := NULL     
                                                    , inPriceListId      := Null     ::Integer
                                                    , inStartDate_price  := Null     ::TDateTime 
                                                    , inOperPriceList    := 0        :: TFloat
                                                    , inSession          := inSession        :: TVarChar
                                                    );
               
          END IF;


          ---��������� �������
              --������          
          IF COALESCE (inGoodsName_ita,'') <> ''
          THEN
              -- ��������
              IF 1 < (SELECT COUNT(*)
                      FROM Object AS Object_TranslateObject
                           INNER JOIN ObjectLink AS ObjectLink_Language
                                                 ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                AND ObjectLink_Language.ChildObjectId = 40528 --������
                           INNER JOIN ObjectLink AS ObjectLink_Object
                                                ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                               AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                               AND ObjectLink_Object.ChildObjectId = vbGoodsId
                           INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                            AND Object.DescId = zc_Object_Goods()
                      WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                        AND Object_TranslateObject.isErased = FALSE
                     )
              THEN
                  RAISE EXCEPTION '������.������� <%>  <%>', vbGoodsId, lfGet_Object_ValueData_sh (40528);
              END IF;

              -- ������� �����
              vbObjectId_ita := (SELECT Object_TranslateObject.Id
                                 FROM Object AS Object_TranslateObject
                                      INNER JOIN ObjectLink AS ObjectLink_Language
                                                            ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                           AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                           AND ObjectLink_Language.ChildObjectId = 40528 --������
                                      INNER JOIN ObjectLink AS ObjectLink_Object
                                                           ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                          AND ObjectLink_Object.ChildObjectId = vbGoodsId
                                      INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                       AND Object.DescId = zc_Object_Goods()
                                 WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                   AND Object_TranslateObject.isErased = FALSE
                                );
              
              IF COALESCE(vbObjectId_ita,0)=0
              THEN 
                   vbObjectId_ita := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectId_ita,0)   ::Integer,       -- ���� ������� <>
                                                                                 ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- �������� <��� 
                                                                                 inName        := inGoodsName_ita   ::TVarChar,      -- �������� 
                                                                                 inLanguageId  := 40528       ::Integer,
                                                                                 inObjectId    := vbGoodsId   ::Integer,
                                                                                 inComment     := ''          ::TVarChar,
                                                                                 inSession     := inSession   ::TVarChar
                                                                                 )AS tmp);
              END IF;
          END IF;

              --�������          
          IF COALESCE (inGoodsName_fra,'') <> ''
          THEN
              --������� �����
              vbObjectId_fra := (SELECT Object_TranslateObject.Id
                                FROM Object AS Object_TranslateObject
                                     INNER JOIN ObjectLink AS ObjectLink_Language
                                                           ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                          AND ObjectLink_Language.ChildObjectId = 40529  --fra
                                     INNER JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                         AND ObjectLink_Object.ChildObjectId = vbGoodsId
                                     INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                      AND Object.DescId = zc_Object_Goods()
                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                );
              
              IF COALESCE(vbObjectId_fra,0)=0
              THEN 
                   vbObjectId_fra := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectId_fra,0)   ::Integer,       -- ���� ������� <>
                                                                                 ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- �������� <��� 
                                                                                 inName        := inGoodsName_fra   ::TVarChar,      -- �������� 
                                                                                 inLanguageId  := 40529       ::Integer,
                                                                                 inObjectId    := vbGoodsId   ::Integer,
                                                                                 inComment     := ''          ::TVarChar,
                                                                                 inSession     := inSession   ::TVarChar
                                                                                 )AS tmp);
              END IF;
          END IF;

              --������          
          IF COALESCE (inGoodsName_eng,'') <> ''
          THEN
              --������� �����
              vbObjectId_eng := (SELECT Object_TranslateObject.Id
                                FROM Object AS Object_TranslateObject
                                     INNER JOIN ObjectLink AS ObjectLink_Language
                                                           ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                          AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                          AND ObjectLink_Language.ChildObjectId = 179 -- ����������
                                     INNER JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                         AND ObjectLink_Object.ChildObjectId = vbGoodsId
                                     INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                      AND Object.DescId = zc_Object_Goods()
                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                );
              
              IF COALESCE(vbObjectId_eng,0)=0
              THEN 
                   vbObjectId_eng := (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectId_eng,0)   ::Integer,       -- ���� ������� <>
                                                                                 ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- �������� <��� 
                                                                                 inName        := inGoodsName_eng   ::TVarChar,      -- �������� 
                                                                                 inLanguageId  := 179       ::Integer,
                                                                                 inObjectId    := vbGoodsId   ::Integer,
                                                                                 inComment     := ''          ::TVarChar,
                                                                                 inSession     := inSession   ::TVarChar
                                                                                 )AS tmp);
              END IF;
          END IF;

              --������          
          IF COALESCE (inMeasure_ita,'') <> ''
          THEN
              --������� �����
              vbObjectIdMeasure_ita := (SELECT Object_TranslateObject.Id
                                        FROM Object AS Object_TranslateObject
                                             INNER JOIN ObjectLink AS ObjectLink_Language
                                                                   ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                                  AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                                                  AND ObjectLink_Language.ChildObjectId = 40528 --������
                                             INNER JOIN ObjectLink AS ObjectLink_Object
                                                                  ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                                 AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                                                 AND ObjectLink_Object.ChildObjectId = vbMeasureParentId
                                             INNER JOIN Object ON Object.Id = ObjectLink_Object.ChildObjectId
                                                              AND Object.DescId = zc_Object_Measure()
                                        WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                          AND Object_TranslateObject.isErased = FALSE
                                        );
              
              IF COALESCE(vbObjectIdMeasure_ita,0)=0
              THEN 
                   vbObjectIdMeasure_ita := (SELECT tmp.ioId
                                             FROM gpInsertUpdate_Object_TranslateObject(ioId          := COALESCE (vbObjectIdMeasure_ita,0)   ::Integer,       -- ���� ������� <>
                                                                                        ioCode        := lfGet_ObjectCode(0, zc_Object_TranslateObject())   ::Integer,       -- �������� <��� 
                                                                                        inName        := TRIM (inMeasure_ita)   ::TVarChar,      -- �������� 
                                                                                        inLanguageId  := 40528       ::Integer,
                                                                                        inObjectId    := vbMeasureParentId   ::Integer,
                                                                                        inComment     := ''          ::TVarChar,
                                                                                        inSession     := inSession   ::TVarChar
                                                                                        )AS tmp);
              END IF;
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
                                 INNER JOIN MovementItemLinkObject AS MILO_DiscountPartner
                                                                  ON MILO_DiscountPartner.MovementItemId = MovementItem.Id
                                                                 AND MILO_DiscountPartner.DescId = zc_MILinkObject_DiscountPartner()
                                                                 AND MILO_DiscountPartner.ObjectId = vbDiscountPartnerId
                                 INNER JOIN MovementItemLinkObject AS MILO_Measure
                                                                  ON MILO_Measure.MovementItemId = MovementItem.Id
                                                                 AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                                                                 AND MILO_Measure.ObjectId = vbMeasureId
                                 INNER JOIN MovementItemLinkObject AS MILO_MeasureParent
                                                                  ON MILO_MeasureParent.MovementItemId = MovementItem.Id
                                                                 AND MILO_MeasureParent.DescId = zc_MILinkObject_MeasureParent()
                                                                 AND MILO_MeasureParent.ObjectId = vbMeasureParentId
                               WHERE MovementItem.MovementId = vbMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.ObjectId   = vbGoodsId
                              );


          -- ��������� <������� ���������>
          vbMovementItemId:=  lpInsertUpdate_MovementItem_PriceList (ioId                := COALESCE (vbMovementItemId,0) ::Integer
                                                                   , inMovementId        := vbMovementId                  ::Integer
                                                                   , inGoodsId           := vbGoodsId                     ::Integer
                                                                   , inDiscountPartnerId := vbDiscountPartnerId            ::Integer
                                                                   , inMeasureId         := vbMeasureId                   ::Integer
                                                                   , inMeasureParentId   := vbMeasureParentId
                                                                   , inAmount            := CASE WHEN inMeasureMult > 1 THEN inAmount ELSE inPriceParent END
                                                                   , inMeasureMult       := inMeasureMult ::TFloat
                                                                   , inPriceParent       := inPriceParent ::TFloat
                                                                   , inEmpfPriceParent   := inEmpfPriceParent ::TFloat
                                                                   , inMinCount          := inMinCount     ::TFloat
                                                                   , inMinCountMult      := inMinCountMult ::TFloat
                                                                   , inWeightParent      := inWeightParent ::TFloat
                                                                   , inCatalogPage       := TRIM (inCatalogPage) ::TVarChar
                                                                   , inisOutlet          := CASE WHEN COALESCE (inisOutlet,'') = 'YES' THEN TRUE ELSE FALSE END  ::Boolean
                                                                   , inUserId            := vbUserId      :: Integer
                                                                    );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.02.22         *
*/

-- ����
--
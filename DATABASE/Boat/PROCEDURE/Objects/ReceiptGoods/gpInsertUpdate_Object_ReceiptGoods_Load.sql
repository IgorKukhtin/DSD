--

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_Load(
    IN inArticle               TVarChar,  -- �������-���������
    IN inReceiptLevelName      TVarChar,  -- �������� ������
    IN inGoodsName             TVarChar,  -- ��������-���������
    IN inGroupName             TVarChar,  -- ������-���������
    IN inReplacement           TVarChar,  -- ������
    IN inArticle_child         TVarChar,  -- �������-��������/����
    IN inGoodsName_child       TVarChar,  -- ��������-��������/����
    IN inGroupName_child       TVarChar,  -- ������-��������/����
    IN inAmount                TVarChar,  -- ����������
    IN inSession               TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsGroupId Integer;
   DECLARE vbGoodsGroupId_child Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsId_child Integer;
   DECLARE vbReceiptGoodsId Integer;
   DECLARE vbReceiptGoodsChildId Integer;
   DECLARE vbAmount TFloat;
   
   DECLARE vbReceiptLevelId Integer;

   DECLARE vbArticleChild     TVarChar;  -- �������-���������
   DECLARE vbGoodsChildName   TVarChar;  -- ��������-���������
   DECLARE vbGroupChildName   TVarChar;  -- ������-���������
   DECLARE vbGoodsChildId Integer;
   DECLARE vbGroupChildId Integer;
   DECLARE text_var1 Text;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
   
   --
   IF COALESCE (TRIM (inGoodsName_child), '') = '' OR
      POSITION(SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2) IN inArticle_child) = 1 OR
      SPLIT_PART (inArticle, '-', 3) NOT IN ('01', '02', '03') THEN RETURN; END IF;
      
   -- ����������� ����������
   IF inAmount = '' OR inAmount = '0'
   THEN
     vbAmount := 0;
   ELSE
     vbAmount := zfConvert_CheckStringToFloat (inAmount);
     IF vbAmount <= 0
     THEN
       RAISE EXCEPTION '������ �������������� � ����� <%>.', inAmount;        
     END IF;
   END IF;
     
   -- �������� � 
   inGoodsName := REPLACE(inGoodsName, chr(1040)||'GL-', 'AGL-');
   inGoodsName_child := REPLACE(inGoodsName_child, chr(1040)||'GL-', 'AGL-');

   -- ���� ����� ������ ������
   IF (COALESCE (inReceiptLevelName, '') <> '') AND SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = '001'
   THEN
     vbArticleChild := inArticle;
     vbGoodsChildName := inGoodsName;
     vbGroupChildName := inGroupName;

     inGoodsName := '������ '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF (COALESCE (inReceiptLevelName, '') = '') AND SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = ''
   THEN
     inGoodsName := '������ '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';    
   ELSEIF SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = '02'
   THEN
     inReceiptLevelName := 'deck';
     vbArticleChild := inArticle;
     vbGoodsChildName := inGoodsName;
     vbGroupChildName := inGroupName;

     inGoodsName := '������� �������� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';    
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 4);
   ELSEIF SPLIT_PART (inArticle, '-', 3) = '02' AND SPLIT_PART (inArticle, '-', 4) = ''
   THEN
     inReceiptLevelName := '';
     inGoodsName := '������� �������� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';    
   ELSEIF SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = '03'
   THEN
     inReceiptLevelName := 'streeting console';
     vbArticleChild := inArticle;
     vbGoodsChildName := inGoodsName;
     vbGroupChildName := inGroupName;

     inGoodsName := '����� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ ������';    
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 4);
   ELSEIF SPLIT_PART (inArticle, '-', 3) = '03' AND SPLIT_PART (inArticle, '-', 4) = ''
   THEN
     inReceiptLevelName := '';
     inGoodsName := '����� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ ������';    
   END IF;

   BEGIN

     -- ������� ����� ����� - Child - ������� ������
     IF COALESCE (vbGoodsChildName, '') <> ''
     THEN

         IF TRIM (vbArticleChild) <> ''
         THEN
            -- �� ��������
            vbGoodsChildId := (SELECT ObjectString_Article.ObjectId
                               FROM ObjectString AS ObjectString_Article
                                    INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                     AND Object.DescId   = zc_Object_Goods()
                                                     AND Object.isErased = FALSE
                               WHERE ObjectString_Article.ValueData ILIKE TRIM (vbArticleChild)
                                 AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                               LIMIT 1
                              );
         ELSE

            -- �� ��������
            vbGoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (vbGoodsChildName));
         END IF;


            -- ������ - ��������/������������� ������ Child
            IF COALESCE (vbGoodsChildId, 0) = 0
            THEN

               -- ������ ������ ������� �����
               vbGroupChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (vbGroupChildName));

               -- ���� ��� ����� ������ �������
               IF COALESCE (vbGroupChildId, 0) = 0
               THEN
                    vbGroupChildId := (SELECT tmp.ioId
                                       FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM (vbGroupChildName) ::TVarChar
                                                                            , inParentId        := 0         :: Integer
                                                                            , inInfoMoneyId     := 0         :: Integer
                                                                            , inModelEtiketenId := 0         :: Integer
                                                                            , inSession         := inSession :: TVarChar
                                                                             ) AS tmp);
               END IF;

               -- ������� Child
               vbGoodsChildId := gpInsertUpdate_Object_Goods (ioId                := COALESCE (vbGoodsChildId, 0) :: Integer
                                                            , inCode              := CASE WHEN COALESCE (vbGoodsChildId, 0) = 0 THEN -1 ELSE 0 END
                                                            , inName              := TRIM (vbGoodsChildName) :: TVarChar
                                                            , inArticle           := TRIM (vbArticleChild)
                                                            , inArticleVergl      := NULL     :: TVarChar
                                                            , inEAN               := NULL     :: TVarChar
                                                            , inASIN              := NULL     :: TVarChar
                                                            , inMatchCode         := NULL     :: TVarChar
                                                            , inFeeNumber         := NULL     :: TVarChar
                                                            , inComment           := NULL     :: TVarChar
                                                            , inIsArc             := FALSE    :: Boolean
                                                            , inFeet              := 0        :: TFloat
                                                            , inMetres            := 0        :: TFloat
                                                            , inAmountMin         := 0        :: TFloat
                                                            , inAmountRefer       := 0        :: TFloat
                                                            , inEKPrice           := 0        :: TFloat
                                                            , inEmpfPrice         := 0        :: TFloat
                                                            , inGoodsGroupId      := vbGroupChildId  :: Integer
                                                            , inMeasureId         := 0        :: Integer
                                                            , inGoodsTagId        := 0        :: Integer
                                                            , inGoodsTypeId       := 0        :: Integer
                                                            , inGoodsSizeId       := 0        :: Integer
                                                            , inProdColorId       := 0        :: Integer
                                                            , inPartnerId         := 0        :: Integer
                                                            , inUnitId            := 0        :: Integer
                                                            , inDiscountPartnerId := 0       :: Integer
                                                            , inTaxKindId         := 0        :: Integer
                                                            , inEngineId          := NULL
                                                            , inSession           := inSession:: TVarChar
                                                             );

            ELSEIF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsChildId, 0) AND Object.ValueData ILIKE TRIM (vbGoodsChildName))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsChildId, 0), TRIM (vbGoodsChildName) :: TVarChar, vbUserId) ;
            END IF;
     ELSEIF SPLIT_PART (vbArticleChild, '-', 4) IN ('001', '02', '03')
     THEN
         -- �� �������
         vbGoodsChildId := (SELECT Object.Id 
                            FROM Object 
                                 INNER JOIN ObjectString AS ObjectString_Article
                                                         ON ObjectString_Article.ObjectId = Object.Id
                                                        AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                                        AND ObjectString_Article.ValueData = TRIM (vbArticleChild)
                            WHERE Object.DescId = zc_Object_Goods()
                            LIMIT 1);
     END IF;

     -- ������� ����� ����� - Master
     IF COALESCE (inGoodsName, '') <> ''
     THEN

         IF TRIM (inArticle) <> ''
         THEN
            -- �� ��������
            vbGoodsId := (SELECT ObjectString_Article.ObjectId
                          FROM ObjectString AS ObjectString_Article
                               INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                AND Object.DescId   = zc_Object_Goods()
                                                AND Object.isErased = FALSE
                          WHERE ObjectString_Article.ValueData ILIKE TRIM (inArticle)
                            AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                          LIMIT 1
                         );
         ELSE

            -- �� ��������
            vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName));
         END IF;

            -- ������ - ��������/������������� ������ Master
            IF COALESCE (vbGoodsId, 0) = 0
            THEN

               -- ������ ������ ������� �����
               vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName));

               -- ���� ��� ����� ������ �������
               IF COALESCE (vbGoodsGroupId, 0) = 0
               THEN
                    vbGoodsGroupId := (SELECT tmp.ioId
                                       FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM (inGroupName) ::TVarChar
                                                                            , inParentId        := 0         :: Integer
                                                                            , inInfoMoneyId     := 0         :: Integer
                                                                            , inModelEtiketenId := 0         :: Integer
                                                                            , inSession         := inSession :: TVarChar
                                                                             ) AS tmp);
               END IF;

               -- ������� Master
               vbGoodsId := gpInsertUpdate_Object_Goods (ioId                := COALESCE (vbGoodsId, 0) :: Integer
                                                       , inCode              := CASE WHEN COALESCE (vbGoodsId, 0) = 0 THEN -1 ELSE 0 END
                                                       , inName              := TRIM (inGoodsName) :: TVarChar
                                                       , inArticle           := TRIM (inArticle)
                                                       , inArticleVergl      := NULL     :: TVarChar
                                                       , inEAN               := NULL     :: TVarChar
                                                       , inASIN              := NULL     :: TVarChar
                                                       , inMatchCode         := NULL     :: TVarChar
                                                       , inFeeNumber         := NULL     :: TVarChar
                                                       , inComment           := NULL     :: TVarChar
                                                       , inIsArc             := FALSE    :: Boolean
                                                       , inFeet              := 0        :: TFloat
                                                       , inMetres            := 0        :: TFloat
                                                       , inAmountMin         := 0        :: TFloat
                                                       , inAmountRefer       := 0        :: TFloat
                                                       , inEKPrice           := 0        :: TFloat
                                                       , inEmpfPrice         := 0        :: TFloat
                                                       , inGoodsGroupId      := vbGoodsGroupId  :: Integer
                                                       , inMeasureId         := 0        :: Integer
                                                       , inGoodsTagId        := 0        :: Integer
                                                       , inGoodsTypeId       := 0        :: Integer
                                                       , inGoodsSizeId       := 0        :: Integer
                                                       , inProdColorId       := 0        :: Integer
                                                       , inPartnerId         := 0        :: Integer
                                                       , inUnitId            := 0        :: Integer
                                                       , inDiscountPartnerId := 0       :: Integer
                                                       , inTaxKindId         := 0        :: Integer
                                                       , inEngineId          := NULL
                                                       , inSession           := inSession:: TVarChar
                                                        );
                                                        
            ELSEIF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsId, 0) AND Object.ValueData ILIKE TRIM (inGoodsName))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsId, 0), TRIM (inGoodsName) :: TVarChar, vbUserId) ;
            END IF;
     END IF;


     -- ������� ����� ����� - Child
     IF COALESCE (inGoodsName_child, '') <> ''
     THEN

         IF TRIM (inArticle_child) <> ''
         THEN
            -- �� ��������
            vbGoodsId_child := (SELECT ObjectString_Article.ObjectId
                                FROM ObjectString AS ObjectString_Article
                                     INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                      AND Object.DescId   = zc_Object_Goods()
                                                      AND Object.isErased = FALSE
                                WHERE ObjectString_Article.ValueData = inArticle_child
                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                LIMIT 1
                               );
         ELSE

            -- �� ��������
            vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData = TRIM (inGoodsName_child));
         END IF;

            -- ������ - ��������/������������� ������ Child
            IF COALESCE (vbGoodsId_child, 0) = 0 
            THEN
               -- ������ ������ ������� �����
               vbGoodsGroupId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName_child));
               -- ���� ��� ����� ������ �������
               IF COALESCE (vbGoodsGroupId_child, 0) = 0
               THEN
                    vbGoodsGroupId_child := (SELECT tmp.ioId
                                             FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                                  , ioCode            := 0         :: Integer
                                                                                  , inName            := TRIM (inGroupName_child) ::TVarChar
                                                                                  , inParentId        := 0         :: Integer
                                                                                  , inInfoMoneyId     := 0         :: Integer
                                                                                  , inModelEtiketenId := 0         :: Integer
                                                                                  , inSession         := inSession :: TVarChar
                                                                                   ) AS tmp);
               END IF;

               -- ������� Child
               vbGoodsId_child := gpInsertUpdate_Object_Goods (ioId               := COALESCE (vbGoodsId_child,0)::  Integer
                                                             , inCode             := 0
                                                             , inName             := TRIM (inGoodsName_child) :: TVarChar
                                                             , inArticle          := TRIM (inArticle_child)
                                                             , inArticleVergl     := NULL     :: TVarChar
                                                             , inEAN              := NULL     :: TVarChar
                                                             , inASIN             := NULL     :: TVarChar
                                                             , inMatchCode        := NULL     :: TVarChar
                                                             , inFeeNumber        := NULL     :: TVarChar
                                                             , inComment          := NULL     :: TVarChar
                                                             , inIsArc            := FALSE    :: Boolean
                                                             , inFeet              := 0        :: TFloat
                                                             , inMetres            := 0        :: TFloat
                                                             , inAmountMin        := 0        :: TFloat
                                                             , inAmountRefer      := 0        :: TFloat
                                                             , inEKPrice          := 0        :: TFloat
                                                             , inEmpfPrice        := 0        :: TFloat
                                                             , inGoodsGroupId     := vbGoodsGroupId_child  :: Integer
                                                             , inMeasureId        := 0        :: Integer
                                                             , inGoodsTagId       := 0        :: Integer
                                                             , inGoodsTypeId      := 0        :: Integer
                                                             , inGoodsSizeId      := 0        :: Integer
                                                             , inProdColorId      := 0        :: Integer
                                                             , inPartnerId        := 0        :: Integer
                                                             , inUnitId           := 0        :: Integer
                                                             , inDiscountPartnerId := 0       :: Integer
                                                             , inTaxKindId        := 0        :: Integer
                                                             , inEngineId         := NULL
                                                             , inSession          := inSession:: TVarChar
                                                              );

            ELSEIF NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsId_child, 0) AND Object.ValueData ILIKE TRIM (inGoodsName_child))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsId_child, 0), TRIM (inGoodsName_child) :: TVarChar, vbUserId) ;
            END IF;
     END IF;


     --- ���� ReceiptGoods
     vbReceiptGoodsId := (SELECT ObjectLink.ObjectId
                          FROM ObjectLink
                          WHERE ObjectLink.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                            AND ObjectLink.ChildObjectId = vbGoodsId
                         );

     -- ������ ��������/�������������
     IF COALESCE (vbReceiptGoodsId, 0) = 0 OR 1=1
     THEN
         -- ���� �� ����� �������
         vbReceiptGoodsId :=  gpInsertUpdate_Object_ReceiptGoods (ioId               := vbReceiptGoodsId
                                                                , inCode             := 0   :: Integer
                                                                , inName             := TRIM (inGoodsName) :: TVarChar
                                                                , inColorPatternId   := 0
                                                                , inGoodsId          := vbGoodsId
                                                                , inisMain           := TRUE     :: Boolean
                                                                , inUserCode         := ''       :: TVarChar
                                                                , inComment          := NULL     :: TVarChar
                                                                , inSession          := inSession:: TVarChar
                                                                 );
     END IF;


     IF COALESCE (inReceiptLevelName, '') <> '' AND COALESCE (vbGoodsChildId, 0) <> 0
     THEN

         -- ���� ������ ������� �����
         vbReceiptLevelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptLevel() AND Object.ValueData = TRIM (inReceiptLevelName));

         -- ���� ��� ������ ���� ������
         IF COALESCE (vbReceiptLevelId, 0) = 0
         THEN
              vbReceiptLevelId := (SELECT tmp.ioId
                                   FROM gpInsertUpdate_Object_ReceiptLevel (ioId              := 0         :: Integer
                                                                          , ioCode            := 0         :: Integer
                                                                          , inName            := TRIM (inReceiptLevelName) ::TVarChar
                                                                          , inShortName       := TRIM (inReceiptLevelName) ::TVarChar
                                                                          , inObjectDesc      := 'zc_Object_ReceiptGoods'  ::TVarChar
                                                                          , inSession         := inSession :: TVarChar
                                                                           ) AS tmp);
           END IF;
     END IF;

     -- ���� ReceiptGoodsChild
     vbReceiptGoodsChildId := (SELECT Object_ReceiptGoodsChild.Id
                               FROM Object AS Object_ReceiptGoodsChild
                                    INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                          ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                         AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                         AND ObjectLink_ReceiptGoods.ChildObjectId = vbReceiptGoodsId
                                    INNER JOIN ObjectLink AS ObjectLink_Object
                                                          ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                         AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
                                                         AND ObjectLink_Object.ChildObjectId = vbGoodsId_child
                                    LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                         ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectLink_ReceiptLevel.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                               WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                 AND Object_ReceiptGoodsChild.isErased = FALSE
                                 AND COALESCE (ObjectLink_ReceiptLevel.ChildObjectId, 0) = COALESCE (vbReceiptLevelId, 0)
                               );

     IF COALESCE (vbReceiptGoodsChildId, 0) = 0
     THEN
         -- ���� �� ����� �������
         vbReceiptGoodsChildId := (SELECT tmp.ioId
                                   FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (vbReceiptGoodsChildId,0) ::Integer
                                                                               , inComment            := ''               ::TVarChar
                                                                               , inReceiptGoodsId     := vbReceiptGoodsId ::Integer
                                                                               , inObjectId           := vbGoodsId_child  ::Integer
                                                                               , inProdColorPatternId := 0                ::Integer
                                                                               , inMaterialOptionsId  := 0                ::Integer
                                                                               , inReceiptLevelId_top := 0                ::Integer
                                                                               , inReceiptLevelId     := vbReceiptLevelId ::Integer
                                                                               , inGoodsChildId       := vbGoodsChildId   ::Integer
                                                                               , ioValue              := vbAmount         ::TFloat
                                                                               , ioValue_service      := 0                ::TFloat
                                                                               , inIsEnabled          := TRUE             ::Boolean
                                                                               , inSession            := inSession        ::TVarChar
                                                                                ) AS tmp);
     END IF;
   EXCEPTION
      WHEN OTHERS THEN GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;	
      RAISE EXCEPTION '������ <%> %�������-��������� <%> %�������� ������ <%> %��������-��������� <%> %������-���������  <%> %������ <%> %�������-��������/���� <%> %��������-��������/���� <%> %������-��������/���� <%> %���������� <%>', 
             text_var1, Chr(13),
             inArticle, Chr(13),                 -- �������-���������
             inReceiptLevelName, Chr(13),        -- �������� ������
             inGoodsName, Chr(13),               -- ��������-���������
             inGroupName, Chr(13),               -- ������-���������
             inReplacement, Chr(13),             -- ������
             inArticle_child, Chr(13),           -- �������-��������/����
             inGoodsName_child, Chr(13),         -- ��������-��������/����
             inGroupName_child, Chr(13),         -- ������-��������/����
             vbAmount                            -- ����������
             ;
   END;
   

   RAISE EXCEPTION 'Goods Main <%> <%> <%> <%> <%> %Goods child 2 <%> <%> <%> <%> <%> <%>  %Goods child <%> <%> <%> <%> <%> <%> <%> %ReceiptGoods <%> %ReceiptGoodsChild <%> <%>', 
               inArticle, inGoodsName, inGroupName, vbGoodsId, vbGoodsGroupId, Chr(13), 
               inReceiptLevelName, vbArticleChild, vbGoodsChildName, vbGroupChildName, vbGoodsChildId, vbGroupChildId, Chr(13),
               inArticle_child, inGoodsName_child, vbGoodsId_child, inGroupName_child, vbGoodsGroupId_child, inAmount, vbAmount, Chr(13),
               vbReceiptGoodsId, Chr(13),
               vbReceiptGoodsChildId, vbReceiptLevelId; 

   RAISE EXCEPTION '� ������'; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.10.22                                                       *
 04.04.22         *
*/

-- ����
-- 


SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_Load('AGL-280-01-001', 'HULL/(������)', '�� ������ ����������������� �GL-280', '�� ������', '��', '54890600251', '', '������������� ��', '5,488', zfCalc_UserAdmin())
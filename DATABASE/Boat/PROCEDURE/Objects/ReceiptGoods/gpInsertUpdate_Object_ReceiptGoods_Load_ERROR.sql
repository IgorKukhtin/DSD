--

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_Load(
    IN inRecNum                Integer ,  -- ������ ��������
    IN inNPP                   TVarChar,  -- � �/�
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
   DECLARE vbAmount NUMERIC (16, 8);
   DECLARE vbForCount TFloat;

   DECLARE vbStage boolean; -- ������ ������� ������
   DECLARE vbNotRename boolean; -- �� ���������������
   DECLARE vbReceiptProdModel boolean; -- ������ �����

   DECLARE vbColorPatternId Integer;
   DECLARE vbModelId Integer;

   DECLARE vbReceiptLevelId Integer;
   DECLARE vbProdColorPatternId Integer;
   DECLARE vbMaterialOptionsId Integer;

   DECLARE vbReceiptProdModelId Integer;
   DECLARE vbReceiptProdModelChildId Integer;

   DECLARE vbArticle_GoodsChild     TVarChar;  -- �������-���������
   DECLARE vbGoods_GoodsChildName   TVarChar;  -- ��������-���������
   DECLARE vbGroup_GoodsChildName   TVarChar;  -- ������-���������
   DECLARE vbGoods_GoodsChildId Integer;
   DECLARE vbGroup_GoodsChildId Integer;

   DECLARE vbProdColorName TVarChar;
   DECLARE vbProdColor_ChildId Integer;
   DECLARE vbProdColorId Integer;

   DECLARE vbMeasureName TVarChar;
   DECLARE vbMeasureId Integer;

   DECLARE text_var1 Text;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


/* IF inRecNum = 218
   THEN
      RAISE EXCEPTION '������ %  <%>  %  <%>  %.'
    , inNPP                   
    , inArticle               
    , inArticle_child         
    , inGroupName_child       
    , inAmount                
    ;

   END IF;*/

   -- !!!����!!!
 /*IF TRIM (inArticle_child) ILIKE  '38.200.00'
   OR TRIM (inGoodsName_child) ILIKE 'Anti-vibration rubber peak latch 96x29 mm'
   THEN
      RAISE EXCEPTION '������ %<%>  %<%>  %<%>  %<%>.', CHR (13), inArticle_child, CHR (13), inGoodsName_child, CHR (13), zfConvert_CheckStringToFloat (inAmount), CHR (13), inAmount;
   END IF;*/


   -- !!!������!!!
   inArticle               := TRIM (inArticle);
   inReceiptLevelName      := TRIM (inReceiptLevelName);
   inGoodsName             := TRIM (inGoodsName);
   inGroupName             := TRIM (inGroupName);
   inReplacement           := TRIM (inReplacement);
   inArticle_child         := TRIM (inArticle_child);
   inGoodsName_child       := TRIM (inGoodsName_child);
   inGroupName_child       := TRIM (inGroupName_child);
   inAmount                := TRIM (inAmount);

   --
   IF inReceiptLevelName ILIKE 'Streeting console'
   THEN
       inReceiptLevelName:= 'Steering console';
   END IF;

   --
   inReceiptLevelName:= CASE inReceiptLevelName
                             WHEN 'HULL/(������)' THEN '1-HULL/(������)'
                             WHEN 'DECK/(������)' THEN '2-DECK/(������)'
                             WHEN '��' THEN '3-��'
                             WHEN '��' THEN '4-��'
                             ELSE inReceiptLevelName
                        END;

   --
   IF COALESCE (TRIM (inGoodsName_child), '') = '' OR
      upper(TRIM(SPLIT_PART (inArticle, '-', 3))) NOT IN ('01', '02', '03', '*ICE WHITE', 'BEL', 'BASIS') THEN RETURN; END IF;

   IF upper(TRIM(SPLIT_PART (inArticle_child, '-', 3))) = '02' AND upper(TRIM(SPLIT_PART (inArticle_child, '-', 4))) = '��' THEN RETURN; END IF;


   -- ��������
   IF zfConvert_StringToNumber (inNPP) = 0
   THEN
     RAISE EXCEPTION '������.�� ���������� NPP = <%> RecNum = <%> Article_ch = <%>.', inNPP, inRecNum, inArticle_child;
   END IF;


   -- ����������� ����������
   IF inAmount = '' OR inAmount = '0'
   THEN
     vbAmount := 0;
   ELSE
     vbAmount := zfConvert_CheckStringToFloat (inAmount);
     -- ���� ���� �������� ������
     IF vbAmount <> vbAmount :: TFloat
     THEN
         vbForCount:= 1000;
         vbAmount:= vbAmount * 1000;
     ELSE
         vbForCount:= 1;
     END IF;
     --
     IF vbAmount <= 0
     THEN
       RAISE EXCEPTION '������ �������������� � ����� <%>.', inAmount;
     END IF;
   END IF;


   -- Measure
   vbMeasureName:= CASE WHEN inAmount ILIKE '%�.�.%'  THEN '�.�.'
                        WHEN inAmount ILIKE '%�.��.%' THEN '�.��.'

                        WHEN inAmount ILIKE '%��.%'   THEN '��.'
                        WHEN inAmount ILIKE '%��%'    THEN '��.'

                        WHEN inAmount ILIKE '%��.%'   THEN '��.'
                        WHEN inAmount ILIKE '%��%'    THEN '��.'

                        WHEN inAmount ILIKE '%�-�.%'  THEN '�-�.'
                        WHEN inAmount ILIKE '%�-�%'   THEN '�-�.'

                        WHEN inAmount ILIKE '%ml.%'   THEN 'ml.'
                        WHEN inAmount ILIKE '%ml%'    THEN 'ml.'

                        WHEN inAmount ILIKE '%st.%'   THEN 'st.'
                        WHEN inAmount ILIKE '%st%'    THEN 'st.'

                        WHEN inAmount ILIKE '%�.%'    THEN '�.'
                        WHEN inAmount ILIKE '%�%'     THEN '�.'
                   END;

   -- �������� �
   inGoodsName := REPLACE(inGoodsName, chr(1040)||'GL-', 'AGL-');
   inGoodsName_child := REPLACE(inGoodsName_child, chr(1040)||'GL-', 'AGL-');
   IF POSITION('AGL ' IN inArticle_child) = 1 THEN inArticle_child := REPLACE(inArticle_child, 'AGL ', 'AGL'); END IF;
   vbStage := False;
   vbNotRename := False;
   vbReceiptProdModel := False;

   -- ���� ������ Boat Structure
   SELECT Object_ColorPattern.Id, ObjectLink_Model.ChildObjectId
   INTO vbColorPatternId, vbModelId
   FROM Object AS Object_ColorPattern
        LEFT JOIN ObjectLink AS ObjectLink_Model
                             ON ObjectLink_Model.ObjectId = Object_ColorPattern.Id
                            AND ObjectLink_Model.DescId = zc_ObjectLink_ColorPattern_Model()
   WHERE Object_ColorPattern.DescId = zc_Object_ColorPattern()
     AND Object_ColorPattern.isErased = FALSE
     AND Object_ColorPattern.ValueData ILIKE 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2))||'%';

   IF COALESCE (vbColorPatternId, 0) = 0
   THEN
     RAISE EXCEPTION '������ ������ Boat Structure <%> �� ������.', 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2));
   END IF;

   -- ���� ������ ������ �������� ������� ��� ���������� ������ ������
   IF inRecNum = 1
   THEN
     -- ����� ������ ������ ������
     vbReceiptProdModelId := (SELECT Object.Id FROM Object
                              WHERE Object.DescId = zc_Object_ReceiptProdModel()
                                AND Object.ValueData ILIKE '%'||SPLIT_PART (inArticle, '-', 2)||'-base%'
                                AND Object.isErased = False);

     IF COALESCE (vbReceiptProdModelId, 0) = 0
     THEN
       RAISE EXCEPTION '������ ������ ������ ������ <%> �� ������.', 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2));
     END IF;

     -- ��������
     PERFORM gpUpdate_Object_isErased_ReceiptProdModelChild(inObjectId := Object_ReceiptProdModelChild.Id
                                                          , inIsErased := TRUE
                                                          , inSession  := inSession)
     FROM Object AS Object_ReceiptProdModelChild
          -- ������ ProdModel
          INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                               AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                               AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId
     WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
       AND Object_ReceiptProdModelChild.isErased = FALSE;

   END IF;

   -- ���������� ����
   vbProdColorName := 'RAL 9010';

   -- ********* ��������� �������� *********

   IF SPLIT_PART (inArticle, '-', 3) = '01' -- ������ ������
   THEN

     -- ���� 2 ������
     IF LOWER(SPLIT_PART (inArticle, '-', 4)) = '��'
     THEN

       vbArticle_GoodsChild := inArticle;
       vbGoods_GoodsChildName := '�� ������ ����������������� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
       vbGroup_GoodsChildName := 'Boote'; --inGroupName;
       vbStage := True;
     END IF;

     -- ������������� ����
     inGroupName_child := 'Boote';

     -- ���� ���� ������ ������������� �� ���������� ���������
     IF inReplacement ILIKE '��'
     THEN
       vbProdColorId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                         WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE vbProdColorName);

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
      WHERE gpSelect.ModelId = vbModelId
        AND gpSelect.ProdColorGroupName ILIKE CASE WHEN inReceiptLevelName ILIKE 'Steering console'
                                                   THEN 'Fiberglass '   || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
                                                   ELSE 'Fiberglass - ' || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
                                              END;

     END IF;

     -- ���� ��������
     inGoodsName := '������ '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
     inGroupName := 'Boote'; --'������ �������';
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF SPLIT_PART (inArticle, '-', 3) = '02' -- ������ �������
   THEN

     -- ���� 2 ������
     IF LOWER(SPLIT_PART (inArticle, '-', 4)) = '��'
     THEN
       vbArticle_GoodsChild := inArticle;
       vbGoods_GoodsChildName := '�� ������� �������� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
       vbGroup_GoodsChildName := 'Boote'; --inGroupName;
       vbStage := True;
     END IF;

     -- ������������� ����
     inGroupName_child := 'Boote';

     -- ���� ���� ������ ������������� �� ���������� ���������
     IF inReplacement ILIKE '��' AND LOWER(SPLIT_PART (inArticle, '-', 4)) = '��'
     THEN
       vbProdColorId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                         WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE vbProdColorName);

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
       WHERE gpSelect.ModelId = vbModelId AND gpSelect.ProdColorGroupName ILIKE 'Fiberglass - DECK';

     ELSEIF inReplacement ILIKE '��'
     THEN
       vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                               WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE SPLIT_PART (inGoodsName_child, '-', 3));

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
       WHERE gpSelect.ModelId = vbModelId AND gpSelect.ProdColorGroupName ILIKE 'Fiberglass - DECK color';

     END IF;

     -- ���� ��������
     inGoodsName := '������� �������� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
     inGroupName := 'Boote'; --'������ �������';
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF SPLIT_PART (inArticle, '-', 3) = '03' -- ������ ������
   THEN

     -- ���� 2 ������
     IF LOWER(SPLIT_PART (inArticle, '-', 4)) = '��'
     THEN
       vbArticle_GoodsChild := inArticle;
       vbGoods_GoodsChildName := '�� ����� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
       vbGroup_GoodsChildName := 'Boote'; --inGroupName;
       vbStage := True;
     END IF;

     -- ������������� ����
     inGroupName_child := 'Boote';

     -- ���� ���� ������ ������������� �� ���������� ���������
     IF inReplacement ILIKE '��'
     THEN
       vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                               WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE vbProdColorName);

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
       WHERE gpSelect.ModelId = vbModelId AND gpSelect.ProdColorGroupName ILIKE 'Fiberglass Steering Console';

     END IF;

     -- ���� ��������
     inGoodsName := '����� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
     inGroupName := 'Boote'; --'������ ������';
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE '*ICE WHITE' -- ������
   THEN
     vbNotRename := True;
     inGoodsName := inArticle;
     inGroupName := 'Boote'; -- '������ �������';

     -- ������������� ����
     inGroupName_child := 'Boote';

     -- ���� ���� ������ ������������� �� ���������� ���������
     IF inReplacement ILIKE '��'
     THEN

       inGroupName_child := TRIM(inReceiptLevelName);

       IF TRIM(inReceiptLevelName) ILIKE 'primary'
       THEN
         vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                                 WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'ICE WHITE');
         inGroupName_child := 'Hypalon';
       ELSEIF TRIM(inReceiptLevelName) ILIKE 'secondary'
       THEN
         vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                                 WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'NEPTUNE GREY');
         inGroupName_child := 'Hypalon';
       ELSEIF TRIM(inReceiptLevelName) ILIKE 'fender'
       THEN
         vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                                 WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'NEPTUNE GREY');
       END IF;

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
       WHERE gpSelect.ModelId = vbModelId
         AND gpSelect.ProdColorGroupName ILIKE 'Hypalon'
         AND gpSelect.Name ILIKE TRIM(inReceiptLevelName);

     END IF;

   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE 'BEL' -- ������
   THEN
     vbNotRename := True;

     -- ������������� ����
     inGroupName_child := 'Boote';

     -- ���� ���� ������ ������������� �� ���������� ���������
     IF inReplacement ILIKE '��'
     THEN
       vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                               WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'pure white');
       vbProdColorId := vbProdColor_ChildId;

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = gpSelect.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
       WHERE gpSelect.ModelId = vbModelId
         AND gpSelect.ProdColorGroupName ILIKE 'Upholstery'
         AND gpSelect.Name ILIKE 'primary+secondary';

     END IF;

     -- ���� ��������
     inGroupName := 'Boote';

   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE 'basis' -- ������ �����
   THEN
     vbNotRename := True;
     vbReceiptProdModel := True;

     inGroupName_child := 'Boote';

     -- ���� ���� ������ ������������� �� ���������� ���������
     IF inReplacement ILIKE '��'
     THEN

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
       WHERE gpSelect.ModelId = vbModelId
         AND gpSelect.ProdColorGroupName ILIKE 'Teak';

     END IF;
   ELSE
     RAISE EXCEPTION '������ ��� <%> <%> �� ������� ���������.', inArticle, inArticle_child;
   END IF;

   IF inReplacement ILIKE '��' AND COALESCE (vbProdColorPatternId, 0) = 0
   THEN
     RAISE EXCEPTION '������ � Boat Structure �� ������� ������ ��� <%> <%> <%> <%>'
      , CASE WHEN inReceiptLevelName ILIKE 'Steering console'
                  THEN 'Fiberglass '   || TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))
             WHEN inReceiptLevelName ILIKE 'Hull' OR inReceiptLevelName ILIKE 'Deck' OR inReceiptLevelName ILIKE 'Deck color'
                  THEN 'Fiberglass - '   || TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))
             ELSE TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))
        END
      , inArticle, inGoodsName_child
      , CASE WHEN inReceiptLevelName ILIKE 'Steering console'
             THEN 'Fiberglass '   || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
             ELSE 'Fiberglass - ' || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
        END
       ;

   END IF;

   BEGIN

     -- ********* ������������� 2 ������ *********

     -- ������� ����� ����� - Child - ������� ������
     IF COALESCE (vbGoods_GoodsChildName, '') <> '' AND vbStage = True
     THEN

         IF TRIM (vbArticle_GoodsChild) <> ''
         THEN
            -- �� ��������
            vbGoods_GoodsChildId := (SELECT ObjectString_Article.ObjectId
                               FROM ObjectString AS ObjectString_Article
                                    INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                     AND Object.DescId   = zc_Object_Goods()
                                                     AND Object.isErased = FALSE
                               WHERE ObjectString_Article.ValueData ILIKE TRIM (vbArticle_GoodsChild)
                                 AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                               LIMIT 1
                              );
         ELSE

            -- �� ��������
            vbGoods_GoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (vbGoods_GoodsChildName));
         END IF;


            -- ������ - ��������/������������� ������ Child
            IF COALESCE (vbGoods_GoodsChildId, 0) = 0
            THEN

               raise notice 'Value 01: �� ����� Child 2';

               -- ������ ������ ������� �����
               vbGroup_GoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (vbGroup_GoodsChildName));

               -- ���� ��� ����� ������ �������
               IF COALESCE (vbGroup_GoodsChildId, 0) = 0
               THEN
                    vbGroup_GoodsChildId := (SELECT tmp.ioId
                                             FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                                  , ioCode            := 0         :: Integer
                                                                                  , inName            := TRIM (vbGroup_GoodsChildName) ::TVarChar
                                                                                  , inParentId        := 0         :: Integer
                                                                                  , inInfoMoneyId     := 0         :: Integer
                                                                                  , inModelEtiketenId := 0         :: Integer
                                                                                  , inSession         := inSession :: TVarChar
                                                                                   ) AS tmp);
               END IF;

               -- ������� Child
               vbGoods_GoodsChildId := gpInsertUpdate_Object_Goods (ioId                := COALESCE (vbGoods_GoodsChildId, 0) :: Integer
                                                                  , inCode              := CASE WHEN COALESCE (vbGoods_GoodsChildId, 0) = 0 THEN -1 ELSE 0 END
                                                                  , inName              := TRIM (vbGoods_GoodsChildName) :: TVarChar
                                                                  , inArticle           := TRIM (vbArticle_GoodsChild)
                                                                  , inArticleVergl      := NULL     :: TVarChar
                                                                  , inEAN               := NULL     :: TVarChar
                                                                  , inASIN              := NULL     :: TVarChar
                                                                  , inMatchCode         := NULL     :: TVarChar
                                                                  , inFeeNumber         := NULL     :: TVarChar
                                                                  , inComment           := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                      WHERE OC.Id = COALESCE (vbGoods_GoodsChildId, 0)
                                                                                                        AND OC.DescId = zc_ObjectString_Goods_Comment()), '') ::TVarChar
                                                                  , inIsArc             := FALSE    :: Boolean
                                                                  , inFeet              := 0        :: TFloat
                                                                  , inMetres            := 0        :: TFloat
                                                                  , inAmountMin         := 0        :: TFloat
                                                                  , inAmountRefer       := 0        :: TFloat
                                                                  , inEKPrice           := 0        :: TFloat
                                                                  , inEmpfPrice         := 0        :: TFloat
                                                                  , inGoodsGroupId      := vbGroup_GoodsChildId  :: Integer
                                                                  , inMeasureId         := 0        :: Integer
                                                                  , inGoodsTagId        := 0        :: Integer
                                                                  , inGoodsTypeId       := 0        :: Integer
                                                                  , inGoodsSizeId       := 0        :: Integer
                                                                  , inProdColorId       := 0        :: Integer
                                                                  , inPartnerId         := 0        :: Integer
                                                                  , inUnitId            := 0        :: Integer
                                                                  , inDiscountPartnerId := 0        :: Integer
                                                                  , inTaxKindId         := 0        :: Integer
                                                                  , inEngineId          := NULL
                                                                  , inSession           := inSession:: TVarChar
                                                                   );

            ELSEIF vbNotRename = False
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoods_GoodsChildId, 0) AND Object.ValueData ILIKE TRIM (vbGoods_GoodsChildName))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoods_GoodsChildId, 0), TRIM (vbGoods_GoodsChildName) :: TVarChar, vbUserId) ;
            END IF;
     ELSEIF SPLIT_PART (vbArticle_GoodsChild, '-', 4) ILIKE '��' AND vbStage = True
     THEN
         -- �� �������
         vbGoods_GoodsChildId := (SELECT Object.Id
                                  FROM Object
                                       INNER JOIN ObjectString AS ObjectString_Article
                                                               ON ObjectString_Article.ObjectId = Object.Id
                                                              AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                                              AND ObjectString_Article.ValueData = TRIM (vbArticle_GoodsChild)
                                  WHERE Object.DescId = zc_Object_Goods()
                                  LIMIT 1);
     END IF;


     -- ********* ������� ������������� *********

     -- ������� ����� ����� - Master
     IF COALESCE (inGoodsName, '') <> '' and vbReceiptProdModel = False
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

         IF COALESCE (vbGoodsId, 0)  = 0 AND vbNotRename = True
         THEN
            -- �� ��������
            vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName));
         END IF;

            -- ������ - ��������/������������� ������ Master
            IF COALESCE (vbGoodsId, 0) = 0
            THEN

               raise notice 'Value 02: �� ����� Master';

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
                                                       , inComment           := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                           WHERE OC.Id = COALESCE (vbGoodsId, 0)
                                                                                             AND OC.DescId = zc_ObjectString_Goods_Comment()), '') ::TVarChar
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
                                                       , inProdColorId       := vbProdColorId :: Integer
                                                       , inPartnerId         := 0        :: Integer
                                                       , inUnitId            := 0        :: Integer
                                                       , inDiscountPartnerId := 0       :: Integer
                                                       , inTaxKindId         := 0        :: Integer
                                                       , inEngineId          := NULL
                                                       , inSession           := inSession:: TVarChar
                                                        );

            ELSEIF vbNotRename = False
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsId, 0) AND Object.ValueData ILIKE TRIM (inGoodsName))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsId, 0), TRIM (inGoodsName) :: TVarChar, vbUserId) ;
            END IF;
     END IF;

     -- ********* ������������� *********

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
             IF vbGoodsId_child <> 0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbGoodsId_child AND Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child))
            AND inGoodsName_child NOT ILIKE '��%'
            -- !!!�������� ��������!!!
            AND 1=1
             THEN
                 -- �������� �������� ������ "���������" ���������, �.�. � ������ �������� ����� ���� ������ ��������
                 UPDATE Object SET ValueData = TRIM (inGoodsName_child) WHERE Object.Id = vbGoodsId_child AND Object.DescId = zc_Object_Goods();

               /*RAISE EXCEPTION '������.��� ������� = <%>%������ �������� ������������� %<%> %<%> %<%> %<%> %'
                                , inArticle_child
                                , CHR (13)
                                , CHR (13)
                                , TRIM (inGoodsName_child)
                                , CHR (13)
                                , (SELECT Object.ValueData FROM Object WHERE Object.Id = vbGoodsId_child)
                                , CHR (13)
                                , vbGoodsId_child
                                , CHR (13)
                                , inNPP
                                , CHR (13)
                                 ;*/
             END IF;

         ELSE
             -- �� ��������
             vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child));

         END IF;

         IF vbReceiptProdModel = TRUE AND COALESCE (vbGoodsId_child, 0) = 0
         THEN
            -- �� ��������
            vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child));
         END IF;


            -- ������ - ��������/������������� ������ Child
            IF COALESCE (vbGoodsId_child, 0) = 0
            THEN

               raise notice 'Value 03: �� ����� Child';

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
                                                             , inComment          := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                WHERE OC.Id = COALESCE (vbGoodsId_child, 0)
                                                                                                  AND OC.DescId = zc_ObjectString_Goods_Comment()), '') ::TVarChar
                                                             , inIsArc            := FALSE    :: Boolean
                                                             , inFeet             := 0        :: TFloat
                                                             , inMetres           := 0        :: TFloat
                                                             , inAmountMin        := 0        :: TFloat
                                                             , inAmountRefer      := 0        :: TFloat
                                                             , inEKPrice          := 0        :: TFloat
                                                             , inEmpfPrice        := 0        :: TFloat
                                                             , inGoodsGroupId     := vbGoodsGroupId_child  :: Integer
                                                             , inMeasureId        := 0        :: Integer
                                                             , inGoodsTagId       := 0        :: Integer
                                                             , inGoodsTypeId      := 0        :: Integer
                                                             , inGoodsSizeId      := 0        :: Integer
                                                             , inProdColorId      := COALESCE(vbProdColor_ChildId, 0) :: Integer
                                                             , inPartnerId        := 0        :: Integer
                                                             , inUnitId           := 0        :: Integer
                                                             , inDiscountPartnerId:= 0       :: Integer
                                                             , inTaxKindId        := 0        :: Integer
                                                             , inEngineId         := NULL
                                                             , inSession          := inSession:: TVarChar
                                                              );

            ELSEIF vbNotRename = False
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsId_child, 0) AND Object.ValueData ILIKE TRIM (inGoodsName_child))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsId_child, 0), TRIM (inGoodsName_child) :: TVarChar, vbUserId) ;
            END IF;
     END IF;

     -- ********* ������� ������ *********

     -- ������ ������ ����
     IF vbReceiptProdModel = False
     THEN

       -- ���� ReceiptGoods
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
                                                                  , inColorPatternId   := vbColorPatternId
                                                                  , inGoodsId          := vbGoodsId
                                                                  , inUnitId           := 0
                                                                  , inIsMain           := TRUE     :: Boolean
                                                                  , inUserCode         := ''       :: TVarChar
                                                                  , inComment          := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                     WHERE OC.Id = COALESCE (vbReceiptGoodsId, 0)
                                                                                                       AND OC.DescId = zc_ObjectString_ReceiptGoods_Comment()), '') ::TVarChar
                                                                  , inSession          := inSession:: TVarChar
                                                                   );
       END IF;


       IF COALESCE (inReceiptLevelName, '') <> '' AND COALESCE (vbGoods_GoodsChildId, 0) <> 0
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
       /*vbReceiptGoodsChildId := (SELECT Object_ReceiptGoodsChild.Id
                                 FROM Object AS Object_ReceiptGoodsChild
                                      INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                            ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                           AND ObjectLink_ReceiptGoods.ChildObjectId = vbReceiptGoodsId
                                      INNER JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
                                                           AND ObjectLink_Object.ChildObjectId = vbGoodsId_child
                                      LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                      LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                           ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_GoodsChild.DescId = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                      LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                           ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_ReceiptLevel.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                                 WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                   AND Object_ReceiptGoodsChild.isErased = FALSE
                                   AND COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) = COALESCE (vbProdColorPatternId, 0)
                                   AND (COALESCE (ObjectLink_GoodsChild.ChildObjectId, 0) = 0 OR
                                        COALESCE (ObjectLink_GoodsChild.ChildObjectId, 0) = COALESCE (vbGoods_GoodsChildId, 0))
                                   AND COALESCE (ObjectLink_ReceiptLevel.ChildObjectId, 0) = COALESCE (vbReceiptLevelId, 0)
                                 );*/

       -- ���� ReceiptGoodsChild
       vbReceiptGoodsChildId := (SELECT Object_ReceiptGoodsChild.Id
                                 FROM Object AS Object_ReceiptGoodsChild
                                      INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                            ON ObjectLink_ReceiptGoods.ObjectId      = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                           AND ObjectLink_ReceiptGoods.ChildObjectId = vbReceiptGoodsId
                                      -- NPP
                                      INNER JOIN ObjectFloat AS ObjectFloat_NPP
                                                             ON ObjectFloat_NPP.ObjectId  = Object_ReceiptGoodsChild.Id
                                                            AND ObjectFloat_NPP.DescId    = zc_ObjectFloat_ReceiptGoodsChild_NPP()
                                                            AND ObjectFloat_NPP.ValueData = inNPP :: Integer
                                 WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                   AND Object_ReceiptGoodsChild.isErased = FALSE
                                );

       /*IF inReceiptLevelName ILIKE 'fender'
         THEN
             RAISE EXCEPTION '������.<%>  <%>'
             , inReceiptLevelName
             , vbReceiptGoodsChildId
         END IF;*/


         -- ����
         --IF inReceiptLevelName ILIKE 'Steering console'
         IF 1=0 -- inArticle_child = '54890600251'
         THEN
           RAISE EXCEPTION '������.<%>  <%>  <%>  <%>   <%>   <%>   <%>   <%>   <%>'
                       , (inArticle)
                       , vbReceiptGoodsChildId
                       , lfGet_Object_ValueData (vbGoods_GoodsChildId)
                       , inArticle_child

                       , vbReceiptGoodsId
                       , vbGoodsId_child

                       , vbProdColorPatternId
                       , vbGoods_GoodsChildId
                       , vbReceiptLevelId
                          ;
         END IF;

       -- ������ ������
       IF 1=1
        /*COALESCE (vbReceiptGoodsChildId, 0) = 0 OR
          NOT EXISTS (SELECT Object_ReceiptGoodsChild.Id
                      FROM Object AS Object_ReceiptGoodsChild
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                           LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_GoodsChild.DescId = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_ReceiptLevel.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                      WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                        AND Object_ReceiptGoodsChild.ID = vbReceiptGoodsChildId
                        AND COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) = COALESCE (vbProdColorPatternId, 0)
                        AND COALESCE (ObjectLink_MaterialOptions.ChildObjectId, 0) = COALESCE (vbMaterialOptionsId, 0)
                        AND COALESCE (ObjectLink_GoodsChild.ChildObjectId, 0) = COALESCE (vbGoods_GoodsChildId, 0)
                        AND COALESCE (ObjectLink_ReceiptLevel.ChildObjectId, 0) = COALESCE (vbReceiptLevelId, 0))*/
       THEN

           -- ���� �� ����� ������� ��� ������ ���� ����
           vbReceiptGoodsChildId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (vbReceiptGoodsChildId,0) ::Integer
                                                                                 , inComment            := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                                      WHERE OC.Id = COALESCE (vbReceiptGoodsChildId, 0)
                                                                                                                        AND OC.DescId = zc_Object_ReceiptGoodsChild()), '') ::TVarChar
                                                                                 , inNPP                := inNPP                ::Integer
                                                                                 , inReceiptGoodsId     := vbReceiptGoodsId     ::Integer
                                                                                 , inObjectId           := vbGoodsId_child      ::Integer
                                                                                 , inProdColorPatternId := vbProdColorPatternId ::Integer
                                                                                 , inMaterialOptionsId  := vbMaterialOptionsId -- (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbReceiptGoodsChildId AND OL.DescId = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()))  ::Integer
                                                                                 , inReceiptLevelId_top := 0                    ::Integer
                                                                                 , inReceiptLevelId     := vbReceiptLevelId     ::Integer
                                                                                 , inGoodsChildId       := vbGoods_GoodsChildId ::Integer
                                                                                 , ioValue              := vbAmount             ::TVarChar
                                                                                 , ioValue_service      :='0'                   ::TVarChar
                                                                                 , ioForCount           := vbForCount
                                                                                 , inIsEnabled          := TRUE                 ::Boolean
                                                                                 , inSession            := inSession            ::TVarChar
                                                                                  ) AS tmp);

           -- ��� ��� ��-��
           -- PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_NPP(), vbReceiptGoodsChildId, inNPP :: Integer);

       END IF;
     END IF;

     -- ������ ������ �����
     IF vbReceiptProdModel = True
     THEN

        -- ����� ������ ������ ������
       vbReceiptProdModelId := (SELECT Object.Id FROM Object
                                WHERE Object.DescId = zc_Object_ReceiptProdModel()
                                  AND Object.ValueData ILIKE '%'||SPLIT_PART (inArticle, '-', 2)||'-base%'
                                  AND Object.isErased = False);

         -- ���� ������ ������� �����
       IF COALESCE (inReceiptLevelName, '') <> ''
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
                                                                            , inObjectDesc      := 'zc_Object_ReceiptProdModel'  ::TVarChar
                                                                            , inSession         := inSession :: TVarChar
                                                                             ) AS tmp);
             END IF;
       END IF;

       -- ����� ReceiptProdModelChild
       vbReceiptProdModelChildId:= (SELECT Object_ReceiptProdModelChild.Id
                                    FROM Object AS Object_ReceiptProdModelChild

                                         INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                               ON ObjectLink_ReceiptProdModel.ObjectId      = Object_ReceiptProdModelChild.Id
                                                              AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId
                                                              AND ObjectLink_ReceiptProdModel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()

                                         INNER JOIN ObjectLink AS ObjectLink_Object
                                                               ON ObjectLink_Object.ObjectId      = Object_ReceiptProdModelChild.Id
                                                              AND ObjectLink_Object.ChildObjectId = vbGoodsId_child
                                                              AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptProdModelChild_Object()

                                    WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                                      AND Object_ReceiptProdModelChild.isErased = FALSE
                                   );

       -- ���� ������� �� ��������������
       IF COALESCE (vbReceiptProdModelChildId, 0) <> 0
          AND EXISTS (SELECT 1 FROM Object WHERE Object.ID = vbReceiptProdModelChildId AND Object.isErased = TRUE)
       THEN

         PERFORM gpUpdate_Object_isErased_ReceiptProdModelChild(inObjectId := vbReceiptProdModelChildId
                                                              , inIsErased := FALSE
                                                              , inSession  := inSession);

       END IF;

       --
       IF COALESCE (vbReceiptProdModelChildID, 0) = 0 OR
          COALESCE (vbReceiptLevelId, 0) <> 0 AND
          NOT EXISTS(SELECT OC.ValueData
                     FROM Object AS OC
                          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                               ON ObjectLink_ReceiptLevel.ObjectId      = OC.Id
                                              AND ObjectLink_ReceiptLevel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                     WHERE OC.Id = COALESCE (vbReceiptProdModelChildId, 0)
                       AND OC.DescId = zc_Object_ReceiptProdModelChild()
                       AND COALESCE(ObjectLink_ReceiptLevel.ChildObjectId, 0) <> COALESCE(vbReceiptLevelId, 0))
       THEN

         raise notice 'Value 05: �� ����� ReceiptProdModelChild';

         vbReceiptProdModelChildID:= (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_ReceiptProdModelChild (ioId                 := COALESCE (vbReceiptProdModelChildId, 0)
                                                                                      , inComment            := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                                           WHERE OC.Id = COALESCE (vbReceiptProdModelChildId, 0)
                                                                                                                             AND OC.DescId = zc_Object_ReceiptProdModelChild()), '')    ::TVarChar
                                                                                      , inReceiptProdModelId := vbReceiptProdModelId  ::Integer
                                                                                      , inObjectId           := vbGoodsId_child       ::Integer
                                                                                      , inReceiptLevelId_top := vbReceiptLevelId      ::Integer
                                                                                      , inReceiptLevelId     := vbReceiptLevelId      ::Integer
                                                                                      , ioValue              := vbAmount              ::TVarChar
                                                                                      , ioValue_service      := 0                     ::TVarChar
                                                                                      , ioForCount           := vbForCount
                                                                                      , ioIsCheck            := FALSE
                                                                                      , inSession            := inSession             ::TVarChar
                                                                                       ) AS tmp);
       END IF;

     END IF;


   -- ���������
   IF vbMeasureName  <> ''
   THEN
       vbMeasureId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbMeasureName LIMIT 1);
       IF COALESCE (vbMeasureId, 0) = 0
       THEN
           -- ���������
           vbMeasureId := lpInsertUpdate_Object (vbMeasureId, zc_Object_Measure(), 0, vbMeasureName);
       END IF;

        -- ���������
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), vbGoodsId_child, vbMeasureId);
   END IF;



   EXCEPTION
      WHEN OTHERS THEN GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
      RAISE EXCEPTION '������ <%> %������ �������� <%> %�������-��������� <%> %�������� ������ <%> %��������-��������� <%> %������-���������  <%> %������ <%> %�������-��������/���� <%> %��������-��������/���� <%> %������-��������/���� <%> %���������� <%>',
             text_var1, Chr(13),
             inRecNum, Chr(13),                  -- ������ ��������
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


  /* RAISE EXCEPTION 'Goods Main <%> <%> <%> <%> <%> %Goods child 2 <%> <%> <%> <%> <%> <%>  %Goods child <%> <%> <%> <%> <%> <%> <%> %ReceiptGoods <%> <%> <%> %ReceiptGoodsChild <%> <%> <%> <%> %ReceiptProdModel <%> <%>',
     --Goods Main
     inArticle, inGoodsName, inGroupName, vbGoodsId, vbGoodsGroupId, Chr(13),
     --Goods child 2
     inReceiptLevelName, vbArticle_GoodsChild, vbGoods_GoodsChildName, vbGroup_GoodsChildName, vbGoods_GoodsChildId, vbGroup_GoodsChildId, Chr(13),
     --Goods child
     inArticle_child, inGoodsName_child, vbGoodsId_child, inGroupName_child, vbGoodsGroupId_child, inAmount, vbAmount, Chr(13),
     --ReceiptGoods
     vbReceiptGoodsId, vbColorPatternId, vbModelId, Chr(13),
     --ReceiptGoodsChild
     vbReceiptGoodsChildId, vbReceiptLevelId, vbProdColorPatternId, vbMaterialOptionsId, Chr(13),
     --ReceiptProdModel
     vbReceiptProdModelId, vbReceiptProdModelChildId; */

   -- RAISE EXCEPTION '� ������';

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
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_Load(3, 'AGL-280-01-��', '1-HULL/(������)', '', '', '', '77083888883', 'SYNOLITE 8388-P-1', '������������� ��', '16,7124', zfCalc_UserAdmin())

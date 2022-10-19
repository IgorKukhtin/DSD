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
   DECLARE vbStage boolean;
   DECLARE vbNotRename boolean;
   DECLARE vbReceiptProdModel boolean;
   
   DECLARE vbColorPatternId Integer;
   DECLARE vbReceiptLevelId Integer;
   DECLARE vbProdColorPatternId Integer;
   DECLARE vbMaterialOptionsId Integer;
   DECLARE vbCommentChild TVarChar;
   DECLARE vbCommentMain TVarChar;
   DECLARE vbComment TVarChar;
   
   DECLARE vbReceiptProdModelId Integer;
   DECLARE vbReceiptProdModelChildId Integer;

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
      POSITION(SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2) IN inArticle_child) = 1 AND inArticle NOT ILIKE '%basis%' OR
      upper(TRIM(SPLIT_PART (inArticle, '-', 3))) NOT IN ('01', '02', '03', '*ICE WHITE', 'BEL', 'BASIS') THEN RETURN; END IF;
      
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
   IF POSITION('AGL ' IN inArticle_child) = 1 THEN inArticle_child := REPLACE(inArticle_child, 'AGL ', 'AGL'); END IF;
   vbStage := False;
   vbNotRename := False;
   vbReceiptProdModel := False;
   
   -- ���� ������ Boat Structure
   SELECT Object_ColorPattern.Id
   INTO vbColorPatternId
   FROM Object AS Object_ColorPattern                                 
   WHERE Object_ColorPattern.DescId = zc_Object_ColorPattern()
     AND Object_ColorPattern.isErased = FALSE    
     AND Object_ColorPattern.ValueData ILIKE 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2))||'%';
     
   IF COALESCE (vbColorPatternId, 0) = 0
   THEN
     RAISE EXCEPTION '������ ������ Boat Structure <%> �� ������.', 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2));        
   END IF;
                                    

   -- ���� ����� ������ ������
   IF (COALESCE (inReceiptLevelName, '') <> '') AND SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = '001'
   THEN
     vbArticleChild := inArticle;
     vbGoodsChildName := inGoodsName;
     vbGroupChildName := inGroupName;
     vbCommentChild := 'HULL/DECK';
     vbStage := True;

     inGoodsName := '������ '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);
     vbCommentMain := 'HULL/DECK';

     IF inReplacement ILIKE '��'
     THEN
       SELECT Object_ProdColorPattern.id, Object_ProdColorGroup.ValueData 
       INTO vbProdColorPatternId, vbComment
       FROM Object AS Object_ProdColorPattern

            INNER JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                 AND ObjectLink_ColorPattern.ChildObjectId = vbColorPatternId
                                                          
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                                  ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                                 AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
            LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
                                                          
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = '1'
         AND Object_ProdColorGroup.ValueData ILIKE '%'||TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))||'%';

       SELECT MIN(ObjectLink_MaterialOptions.ChildObjectId)
       INTO vbMaterialOptionsId
       FROM Object AS Object_ReceiptGoodsChild
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                 AND ObjectLink_ProdColorPattern.ChildObjectId = vbProdColorPatternId
            INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                            
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                            

            -- ��������� �����
            INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                                                 
       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
         AND Object_ReceiptGoodsChild.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = '1'
         AND Object_ProdColorGroup.ValueData ILIKE '%'||TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))||'%';         
     END IF;

   ELSEIF (COALESCE (inReceiptLevelName, '') = '') AND SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = ''
   THEN
     inGoodsName := '������ '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';    
     vbCommentMain := 'HULL/DECK';
   ELSEIF SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = '02' -- ������ �������
   THEN
     inReceiptLevelName := 'deck';
     vbArticleChild := inArticle;
     vbGoodsChildName := inGoodsName;
     vbGroupChildName := inGroupName;
     vbCommentChild := 'DECK';
     vbStage := True;

     inGoodsName := '������� �������� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';    
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 4);
     vbCommentMain := 'DECK';

     IF inReplacement ILIKE '��'
     THEN
       SELECT Object_ProdColorPattern.id, Object_ProdColorGroup.ValueData  
       INTO vbProdColorPatternId, vbComment
       FROM Object AS Object_ProdColorPattern

            INNER JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                 AND ObjectLink_ColorPattern.ChildObjectId = vbColorPatternId
                                                          
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                                  ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                                 AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
            LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
                                                          
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = '1'
         AND Object_ProdColorGroup.ValueData ILIKE '%'||inReceiptLevelName||'%';

       SELECT MIN(ObjectLink_MaterialOptions.ChildObjectId)
       INTO vbMaterialOptionsId
       FROM Object AS Object_ReceiptGoodsChild
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                 AND ObjectLink_ProdColorPattern.ChildObjectId = vbProdColorPatternId
            INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                            
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                            

            -- ��������� �����
            INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                                                 
       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
         AND Object_ReceiptGoodsChild.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = '1'
         AND Object_ProdColorGroup.ValueData ILIKE '%'||inReceiptLevelName||'%';
     END IF;

   ELSEIF SPLIT_PART (inArticle, '-', 3) = '02' AND SPLIT_PART (inArticle, '-', 4) = ''
   THEN
     inReceiptLevelName := '';
     inGoodsName := '������� �������� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ �������';    
     vbCommentMain := 'DECK';

     IF inReplacement ILIKE '��'
     THEN
       SELECT Object_ProdColorPattern.id, Object_ProdColorGroup.ValueData  
       INTO vbProdColorPatternId, vbComment
       FROM Object AS Object_ProdColorPattern

            INNER JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                 AND ObjectLink_ColorPattern.ChildObjectId = vbColorPatternId
                                                          
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                                  ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                                 AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
            LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
                                                          
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = 'farbe'
         AND Object_ProdColorGroup.ValueData ILIKE 'Stitching Naht';

       SELECT MIN(ObjectLink_MaterialOptions.ChildObjectId)
       INTO vbMaterialOptionsId
       FROM Object AS Object_ReceiptGoodsChild
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                 AND ObjectLink_ProdColorPattern.ChildObjectId = vbProdColorPatternId
            INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                            
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                            

            -- ��������� �����
            INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                                                 
       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
         AND Object_ReceiptGoodsChild.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = 'farbe'
         AND Object_ProdColorGroup.ValueData ILIKE 'Stitching Naht';
     END IF;
   ELSEIF SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = '03' -- ������ ������
   THEN
     inReceiptLevelName := 'streeting console';
     vbArticleChild := inArticle;
     vbGoodsChildName := inGoodsName;
     vbGroupChildName := inGroupName;
     vbCommentChild := 'STEERING CONSOLE';
     vbStage := True;

     inGoodsName := '����� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ ������';    
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 4);
     vbCommentMain := 'STEERING CONSOLE';

     IF inReplacement ILIKE '��'
     THEN
       SELECT Object_ProdColorPattern.id, Object_ProdColorGroup.ValueData  
       INTO vbProdColorPatternId, vbComment
       FROM Object AS Object_ProdColorPattern

            INNER JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                 AND ObjectLink_ColorPattern.ChildObjectId = vbColorPatternId
                                                          
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                                  ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                                 AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
            LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
                                                          
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = '1'
         AND Object_ProdColorGroup.ValueData ILIKE '%Fiberglass Steering Console%';

       SELECT MIN(ObjectLink_MaterialOptions.ChildObjectId)
       INTO vbMaterialOptionsId
       FROM Object AS Object_ReceiptGoodsChild
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                 AND ObjectLink_ProdColorPattern.ChildObjectId = vbProdColorPatternId
            INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                            
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                            

            -- ��������� �����
            INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                                                 
       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
         AND Object_ReceiptGoodsChild.isErased = FALSE
         AND Object_ProdColorPattern.ValueData = '1'
         AND Object_ProdColorGroup.ValueData ILIKE '%Fiberglass Steering Console%';
     END IF;

   ELSEIF SPLIT_PART (inArticle, '-', 3) = '03' AND SPLIT_PART (inArticle, '-', 4) = ''
   THEN
     inReceiptLevelName := '';
     inGoodsName := '����� '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := '������ ������';    
     vbCommentMain := 'STEERING CONSOLE';
   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE '*ICE WHITE' -- ������
   THEN
     vbNotRename := True;  
     IF COALESCE (inGoodsName, '') = '' THEN inGoodsName := inArticle; END IF;
     IF COALESCE (inGroupName, '') = '' THEN inGroupName := '������ �������'; END IF;
     
     IF inReplacement ILIKE '��'
     THEN
       SELECT Object_ProdColorPattern.id, Object_ProdColorGroup.ValueData  
       INTO vbProdColorPatternId, vbComment
       FROM Object AS Object_ProdColorPattern

            INNER JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                 AND ObjectLink_ColorPattern.ChildObjectId = vbColorPatternId
                                                          
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                                  ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                                 AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
            LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
                                                          
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.isErased = FALSE
         AND Object_ProdColorPattern.ValueData ILIKE CASE WHEN inReceiptLevelName ILIKE 'fender' THEN 'moldings' ELSE inReceiptLevelName END
         AND Object_ProdColorGroup.ValueData ILIKE 'Hypalon';

       SELECT MIN(ObjectLink_MaterialOptions.ChildObjectId)
       INTO vbMaterialOptionsId
       FROM Object AS Object_ReceiptGoodsChild
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                 AND ObjectLink_ProdColorPattern.ChildObjectId = vbProdColorPatternId
            INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                            
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                            

            -- ��������� �����
            INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                                                 
       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
         AND Object_ReceiptGoodsChild.isErased = FALSE
         AND Object_ProdColorPattern.ValueData ILIKE CASE WHEN inReceiptLevelName ILIKE 'fender' THEN 'moldings' ELSE inReceiptLevelName END
         AND Object_ProdColorGroup.ValueData ILIKE 'Hypalon';
     END IF;

   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE 'BEL' -- ������
   THEN
     vbNotRename := True;  
     
     IF inReplacement ILIKE '��'
     THEN
       SELECT Object_ProdColorPattern.id, Object_ProdColorGroup.ValueData  
       INTO vbProdColorPatternId, vbComment
       FROM Object AS Object_ProdColorPattern

            INNER JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                 AND ObjectLink_ColorPattern.ChildObjectId = vbColorPatternId
                                                          
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                                  ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                                 AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
            LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
                                                          
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.isErased = FALSE
         AND Object_ProdColorPattern.ValueData ILIKE 'primary+secondary'
         AND Object_ProdColorGroup.ValueData ILIKE 'Upholstery';
         
       SELECT MIN(ObjectLink_MaterialOptions.ChildObjectId)
       INTO vbMaterialOptionsId
       FROM Object AS Object_ReceiptGoodsChild
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                 AND ObjectLink_ProdColorPattern.ChildObjectId = vbProdColorPatternId
            INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                            
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                            

            -- ��������� �����
            INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                                                 
       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
         AND Object_ReceiptGoodsChild.isErased = FALSE
         AND Object_ProdColorPattern.ValueData ILIKE 'primary+secondary'
         AND Object_ProdColorGroup.ValueData ILIKE 'Upholstery';         
     END IF;
   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE 'basis' -- ������ �����
   THEN
     vbNotRename := True;  
     vbReceiptProdModel := True;
     
     IF inReplacement ILIKE '��'
     THEN
       SELECT Object_ProdColorPattern.id, Object_ProdColorGroup.ValueData  
       INTO vbProdColorPatternId, vbComment
       FROM Object AS Object_ProdColorPattern

            INNER JOIN ObjectLink AS ObjectLink_ColorPattern
                                  ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                 AND ObjectLink_ColorPattern.ChildObjectId = vbColorPatternId
                                                          
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                                                          
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorKind
                                  ON ObjectLink_ProdColorKind.ObjectId = Object_ProdColorGroup.Id
                                 AND ObjectLink_ProdColorKind.DescId = zc_ObjectLink_ProdColorGroup_ProdColorKind()
            LEFT JOIN Object AS Object_ProdColorKind ON Object_ProdColorKind.Id = ObjectLink_ProdColorKind.ChildObjectId
                                                          
       WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
         AND Object_ProdColorPattern.isErased = FALSE
         AND Object_ProdColorPattern.ValueData ILIKE '1'
         AND Object_ProdColorGroup.ValueData ILIKE 'Teak';

       SELECT MIN(ObjectLink_MaterialOptions.ChildObjectId)
       INTO vbMaterialOptionsId
       FROM Object AS Object_ReceiptGoodsChild
            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                 AND ObjectLink_ProdColorPattern.ChildObjectId = vbProdColorPatternId
            INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                            
            INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                  ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                 AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            INNER JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                            

            -- ��������� �����
            INNER JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                                                 
       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
         AND Object_ReceiptGoodsChild.isErased = FALSE
         AND Object_ProdColorPattern.ValueData ILIKE '1'
         AND Object_ProdColorGroup.ValueData ILIKE 'Teak';
     END IF;
   END IF;

   IF inReplacement ILIKE '��' AND COALESCE (vbProdColorPatternId, 0) = 0
   THEN
     RAISE EXCEPTION '������ � Boat Structure �� ������� ������ ��� <%> <%>', inArticle, inReceiptLevelName;        
   END IF;

--   BEGIN

     -- ������� ����� ����� - Child - ������� ������
     IF COALESCE (vbGoodsChildName, '') <> '' AND vbStage = True
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
              
               raise notice 'Value 01: �� ����� Child 2'; 

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
                                                            , inComment           := vbCommentChild
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

            ELSEIF vbNotRename = False 
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsChildId, 0) AND Object.ValueData ILIKE TRIM (vbGoodsChildName))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsChildId, 0), TRIM (vbGoodsChildName) :: TVarChar, vbUserId) ;
            END IF;
     ELSEIF SPLIT_PART (vbArticleChild, '-', 4) IN ('001', '02', '03') AND vbStage = True
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
                                                       , inComment           := vbCommentMain
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
                                                        
            ELSEIF vbNotRename = False 
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsId, 0) AND Object.ValueData ILIKE TRIM (inGoodsName))
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
                                                             , inComment          := vbComment
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
                                                             , inProdColorId      := 0        :: Integer
                                                             , inPartnerId        := 0        :: Integer
                                                             , inUnitId           := 0        :: Integer
                                                             , inDiscountPartnerId := 0       :: Integer
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

     IF vbReceiptProdModel = False
     THEN
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
                                                                  , inColorPatternId   := vbColorPatternId
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
                                 
       IF COALESCE (vbReceiptGoodsChildId, 0) = 0 OR
          NOT EXISTS (SELECT Object_ReceiptGoodsChild.Id
                      FROM Object AS Object_ReceiptGoodsChild
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                           LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                      WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                        AND Object_ReceiptGoodsChild.ID = vbReceiptGoodsChildId
                        AND COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) = COALESCE (vbProdColorPatternId, 0)
                        and COALESCE (ObjectLink_MaterialOptions.ChildObjectId, 0) = COALESCE (vbMaterialOptionsId, 0))
       THEN

           -- ���� �� ����� ������� ��� ������ ���� ����
           vbReceiptGoodsChildId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (vbReceiptGoodsChildId,0) ::Integer
                                                                                 , inComment            := ''                   ::TVarChar
                                                                                 , inReceiptGoodsId     := vbReceiptGoodsId     ::Integer
                                                                                 , inObjectId           := vbGoodsId_child      ::Integer
                                                                                 , inProdColorPatternId := vbProdColorPatternId ::Integer
                                                                                 , inMaterialOptionsId  := vbMaterialOptionsId  ::Integer
                                                                                 , inReceiptLevelId_top := 0                    ::Integer
                                                                                 , inReceiptLevelId     := vbReceiptLevelId     ::Integer
                                                                                 , inGoodsChildId       := vbGoodsChildId       ::Integer
                                                                                 , ioValue              := vbAmount             ::TFloat
                                                                                 , ioValue_service      := 0                    ::TFloat
                                                                                 , inIsEnabled          := TRUE                 ::Boolean
                                                                                 , inSession            := inSession            ::TVarChar
                                                                                  ) AS tmp);
       END IF;
     
     ELSE
     
        -- ����� ������ ������ ������
       vbReceiptProdModelId := (SELECT Object.Id FROM Object 
                                WHERE Object.DescId = zc_Object_ReceiptProdModel() 
                                  AND Object.ValueData ILIKE '%'||SPLIT_PART (inArticle, '-', 2)||'-base%'
                                  AND Object.isErased = False);

         -- ���� ������ ������� �����
       IF COALESCE ('01-Boat', '') <> ''
       THEN

           -- ���� ������ ������� �����
           vbReceiptLevelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptLevel() AND Object.ValueData = TRIM ('01-Boat'));

           -- ���� ��� ������ ���� ������
           IF COALESCE (vbReceiptLevelId, 0) = 0
           THEN
                vbReceiptLevelId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptLevel (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM ('01-Boat') ::TVarChar
                                                                            , inShortName       := TRIM ('01-Boat') ::TVarChar
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

       --
       IF COALESCE (vbReceiptProdModelChildID, 0) = 0
       THEN

         raise notice 'Value 05: �� ����� ReceiptProdModelChild'; 

         vbReceiptProdModelChildID:= (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_ReceiptProdModelChild (ioId                 := COALESCE (vbReceiptProdModelChildId, 0)
                                                                                      , inComment            := inGoodsName_child     ::TVarChar
                                                                                      , inReceiptProdModelId := vbReceiptProdModelId  ::Integer
                                                                                      , inObjectId           := vbGoodsId_child       ::Integer
                                                                                      , inReceiptLevelId_top := vbReceiptLevelId      ::Integer
                                                                                      , inReceiptLevelId     := (SELECT OL.ChildObjectId FROM ObjectLink AS OL 
                                                                                                                 WHERE OL.ObjectId = COALESCE (vbReceiptProdModelChildId, 0) 
                                                                                                                   AND OL.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel())
                                                                                      , ioValue              := vbAmount              ::TFloat
                                                                                      , ioValue_service      := 0                     ::TFloat
                                                                                      , ioIsCheck            := FALSE
                                                                                      , inSession            := inSession             ::TVarChar
                                                                                       ) AS tmp);
       END IF;
    
     END IF;
     
     
   /*EXCEPTION
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
   END;*/
   

  /* RAISE EXCEPTION 'Goods Main <%> <%> <%> <%> <%> %Goods child 2 <%> <%> <%> <%> <%> <%>  %Goods child <%> <%> <%> <%> <%> <%> <%> %ReceiptGoods <%> <%> %ReceiptGoodsChild <%> <%> <%> <%> %ReceiptProdModel <%> <%>', 
               inArticle, inGoodsName, inGroupName, vbGoodsId, vbGoodsGroupId, Chr(13), 
               inReceiptLevelName, vbArticleChild, vbGoodsChildName, vbGroupChildName, vbGoodsChildId, vbGroupChildId, Chr(13),
               inArticle_child, inGoodsName_child, vbGoodsId_child, inGroupName_child, vbGoodsGroupId_child, inAmount, vbAmount, Chr(13),
               vbReceiptGoodsId, vbColorPatternId, Chr(13),
               vbReceiptGoodsChildId, vbReceiptLevelId, vbProdColorPatternId, vbMaterialOptionsId, Chr(13),
               vbReceiptProdModelId, vbReceiptProdModelChildId; 

   RAISE EXCEPTION '� ������'; */

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
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_Load('AGL-280-*ICE WHITE - *NEPTUNE GREY', 'primary', 'AGL-280-*ICE WHITE - *NEPTUNE GREY', '������ �������', '��', 'AGL 000032', 'ICE WHITE', '������ �������', '10 �.�.', zfCalc_UserAdmin())
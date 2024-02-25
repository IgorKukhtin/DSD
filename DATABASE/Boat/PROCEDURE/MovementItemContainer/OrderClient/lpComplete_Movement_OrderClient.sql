-- Function: lpComplete_Movement_OrderClient()

DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Integer);
DROP FUNCTION IF EXISTS lpComplete_Movement_OrderClient (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_OrderClient(
    IN inMovementId        Integer  , -- ���� ���������
    IN inIsChild_Recalc    Boolean  , -- �������� �������������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbProductId          Integer;
  DECLARE vbReceiptProdModelId Integer;
  DECLARE vbModelId            Integer;
  DECLARE vbIsBasicConf        Boolean;

  DECLARE vbClientId_From  Integer;
  DECLARE vbUnitId_To      Integer;

  DECLARE vbPartionId_1    Integer;
  DECLARE vbPartionId_2    Integer;
BEGIN
     -- ����� �����
     vbProductId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product());

     --
     IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbProductId AND Object.isErased = TRUE)
     THEN
         -- ������������ �����
         PERFORM lpUpdate_Object_isErased (inObjectId:= vbProductId
                                         , inIsErased:= FALSE
                                         , inUserId  := inUserId
                                          );
     END IF;

     -- ��������� �� ����� - ������ � ������
     SELECT COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId
            -- ���� "���������" ������ ReceiptProdModel, �.�. ������ ���������
          , CASE WHEN ObjectLink_Product_Model.ChildObjectId = ObjectLink_ReceiptProdModel_Model.ChildObjectId THEN ObjectLink_Product_Model.ChildObjectId ELSE 0 END AS ModelId
            -- !!!��������� �� � ��������� ��� ������� ������������!!
          , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) AS isBasicConf
            --
            INTO vbReceiptProdModelId, vbModelId, vbIsBasicConf
     FROM -- ������
          ObjectLink AS ObjectLink_Product_Model
          -- ������ ������ ������
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                               ON ObjectLink_ReceiptProdModel.ObjectId = vbProductId
                              AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
          -- ��� ��� ������, ��� ��������
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                               ON ObjectLink_ReceiptProdModel_Model.ObjectId = ObjectLink_ReceiptProdModel.ChildObjectId
                              AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                  ON ObjectBoolean_BasicConf.ObjectId = vbProductId
                                 AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()

     WHERE ObjectLink_Product_Model.ObjectId = vbProductId
       AND ObjectLink_Product_Model.DescId   = zc_ObjectLink_Product_Model();


     -- ��������� �� ���������
     SELECT MovementLinkObject_From.ObjectId AS ClientId_From
          , MovementLinkObject_To.ObjectId   AS UnitId_To
            INTO vbClientId_From, vbUnitId_To
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
     WHERE Movement.Id       = inMovementId
       AND Movement.DescId   = zc_Movement_OrderClient()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
    ;

     -- ������������� VATPercent
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0))
     FROM ObjectLink AS OL_Client_TaxKind
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = OL_Client_TaxKind.ChildObjectId 
                               AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
     WHERE OL_Client_TaxKind.ObjectId = vbClientId_From
       AND OL_Client_TaxKind.DescId   = zc_ObjectLink_Client_TaxKind()
    ;

     -- �������� - Boat Structure
     IF EXISTS (SELECT ObjectLink_ProdColorPattern.ChildObjectId
                FROM Object AS Object_ProdColorItems
                     -- �����
                     INNER JOIN ObjectLink AS ObjectLink_Product
                                           ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                          AND ObjectLink_Product.ChildObjectId = vbProductId
                     -- ����� �������
                     INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                            ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                           AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                           AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId
                     -- �������
                     INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                          AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                  AND Object_ProdColorItems.isErased = FALSE
                  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                GROUP BY ObjectLink_ProdColorPattern.ChildObjectId
                HAVING COUNT(*) > 1
               )
     THEN
         RAISE EXCEPTION '��������-1.������� Boat Structure = <%> �� ����� �������������.'
             , (SELECT lfGet_Object_ValueData_pcp (ObjectLink_ProdColorPattern.ChildObjectId)
                FROM Object AS Object_ProdColorItems
                     -- �����
                     INNER JOIN ObjectLink AS ObjectLink_Product
                                           ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                          AND ObjectLink_Product.ChildObjectId = vbProductId
                     -- ����� �������
                     INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                            ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                           AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                           AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId
                     -- �������
                     INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                          AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                  AND Object_ProdColorItems.isErased = FALSE
                  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                GROUP BY ObjectLink_ProdColorPattern.ChildObjectId
                HAVING COUNT(*) > 1
               )
               ;

     END IF;

     -- �������� - Kunden
     IF COALESCE (vbClientId_From, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <Kunden>.';
     END IF;
     -- �������� - �������������
     IF COALESCE (vbUnitId_To, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <������������� (����)>.';
     END IF;
     -- �������� - ������������� - ������������
     IF vbUnitId_To <> zc_Unit_Production() AND EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product() AND MLO.ObjectId > 0)
     THEN
         RAISE EXCEPTION '������.��� <������������� (����)> ���������� ���������� �������� = <%>.', lfGet_Object_ValueData_sh (zc_Unit_Production());
     END IF;


     -- RAISE EXCEPTION '������. <%>.', inIsChild_Recalc;

     -- !!!������ ���� ����� ��������!!!
     -- !!!��� �������� ���� � ������ ������ ��������!!!
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Product() AND MLO.ObjectId > 0)
        AND (inIsChild_Recalc = TRUE
          OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE)
            )
     THEN
         -- ������� - �������� ���������, ������ ������ �����
         CREATE TEMP TABLE _tmpItem_Child (MovementItemId Integer
                                         , ObjectId_parent_find Integer, ObjectId_parent Integer, ObjectDescId Integer
                                         , ReceiptGoodsId_find Integer
                                         , ProdOptionsId Integer
                                           --
                                         , OperCount TFloat, ForCount TFloat
                                         , OperPrice TFloat
                                           --
                                         , Key_Id Text, Key_Id_text Text
                                          ) ON COMMIT DROP;
        -- ������� - �������� ���������, ������ �����
        CREATE TEMP TABLE _tmpItem_Detail (MovementItemId Integer
                                         , ObjectId_parent Integer, ObjectId Integer, ObjectDescId Integer
                                         , ProdOptionsId Integer
                                         , ColorPatternId Integer
                                          -- Boat Structure
                                         , ProdColorPatternId Integer
                                           -- ��������� �����
                                         , MaterialOptionsId Integer
                                           --
                                         , ReceiptLevelId Integer
                                           --
                                         , GoodsId_child Integer
                                         , GoodsId_child_find Integer
                                           --
                                         , NPP Integer
                                           -- ���� - ������ ����������
                                         , ProdColorName TVarChar
                                           --
                                         , OperCount TFloat, ForCount TFloat
                                         , OperPrice TFloat
                                          ) ON COMMIT DROP;

         -- ������� - �������� ���������, �� �������
         CREATE TEMP TABLE _tmpItem_Reserv (MovementItemId Integer
                                          , ContainerId_Goods Integer
                                          , ObjectId Integer, PartionId Integer
                                          , OperCount TFloat
                                          , OperCountPartner TFloat
                                          , OperPricePartner TFloat
                                          , ObjectDescId Integer
                                           ) ON COMMIT DROP;


         -- ��� �������� ������ ������ - ����� ��� ����
         CREATE TEMP TABLE _tmpReceiptProdModel ON COMMIT DROP AS
            SELECT lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                   -- !!!������ - �� ��������� ������ ��� ������
                 , lpSelect.ObjectId_parent
                   -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                 , lpSelect.ObjectId
                   --
                 , COALESCE (lpSelect.ReceiptGoodsId, 0) AS ReceiptGoodsId
                 , COALESCE (lpSelect.ReceiptLevelId, 0) AS ReceiptLevelId
                   --
                 , lpSelect.GoodsId_child
                   -- �������� - ����
                 , lpSelect.Value_parent_orig AS Value_parent
                 , lpSelect.ForCount_parent
                   -- �������� - �������
                 , lpSelect.Value_orig AS Value
                 , lpSelect.ForCount
                   -- ���� ��. ��� ��� - ����
                 , lpSelect.EKPrice_parent
                   -- ���� ��. ��� ��� - �������
                 , lpSelect.EKPrice
                   -- Boat Structure
                 , lpSelect.ProdColorPatternId
                   -- Boat Structure
                 , ObjectFloat_NPP.ValueData AS NPP

            FROM lpSelect_Object_ReceiptProdModelChild_detail (inIsGroup:=FALSE, inUserId:= inUserId) AS lpSelect
                 -- NPP
                 LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                       ON ObjectFloat_NPP.ObjectId  = lpSelect.ReceiptGoodsChildId
                                      AND ObjectFloat_NPP.DescId    = zc_ObjectFloat_ReceiptGoodsChild_NPP()
            WHERE lpSelect.ReceiptProdModelId = vbReceiptProdModelId
           ;


         -- ������� - � ���� ������ ReceiptGoods ����� ������
         CREATE TEMP TABLE _tmpReceiptItems_Key ON COMMIT DROP AS
           WITH -- ������ ������ ���� - �������� Boat Structure
                tmpReceiptItems AS (SELECT Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                                         , ObjectLink_ReceiptGoods.ChildObjectId           AS ReceiptGoodsId
                                           -- ����
                                         , ObjectLink_Goods.ChildObjectId                  AS ObjectId_parent
                                           -- ���� ������ �� ������ �����, �� ��� ��� � Boat Structure
                                         , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                           -- ����� � Boat Structure
                                         , ObjectLink_ProdColorPattern_Goods.ChildObjectId AS ObjectId_pcp
                                           -- Boat Structure
                                         , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
                                           -- ��������� �����
                                         , ObjectLink_MaterialOptions.ChildObjectId        AS MaterialOptionsId
                                           -- ������ Boat Structure
                                         , ObjectLink_ColorPattern.ChildObjectId           AS ColorPatternId
                                           -- ReceiptLevel
                                         , COALESCE (ObjectLink_ReceiptLevel.ChildObjectId, 0) AS ReceiptLevelId
                                           -- GoodsChild
                                         , ObjectLink_GoodsChild.ChildObjectId             AS GoodsId_child
                                           -- ����
                                         , CASE WHEN ObjectLink_Object.ChildObjectId > 0
                                                     THEN ''
                                                WHEN Object_ReceiptGoodsChild.ValueData <> ''
                                                     THEN Object_ReceiptGoodsChild.ValueData
                                                ELSE COALESCE (ObjectString_Comment_pcp.ValueData, '')
                                           END AS ProdColorName
                                           -- ����
                                         , COALESCE (ObjectString_Comment_pcp.ValueData, '') AS ProdColorName_pcp
                                           -- NPP
                                         , ObjectFloat_NPP.ValueData                       AS NPP

                                    FROM -- ����
                                         Object AS Object_ReceiptGoodsChild
                                         -- Boat Structure
                                         INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                               ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                              AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                                              -- !!!���� ��� Boat Structure
                                                              AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                                         INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                                         -- NPP
                                         LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                                               ON ObjectFloat_NPP.ObjectId  = Object_ReceiptGoodsChild.Id
                                                              AND ObjectFloat_NPP.DescId    = zc_ObjectFloat_ReceiptGoodsChild_NPP()
                                         -- ��������� �����
                                         LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                              ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                                         -- ������ ������ ����
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                              ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                         -- ���� - ��� ����������
                                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                              ON ObjectLink_Goods.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                         -- ������������ - �� ���� ����������
                                         LEFT JOIN ObjectLink AS ObjectLink_Object
                                                              ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                         -- ReceiptLevel
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                              ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                                         -- GoodsChild
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                              ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                         -- ����
                                         LEFT JOIN ObjectString AS ObjectString_Comment_pcp
                                                                ON ObjectString_Comment_pcp.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                               AND ObjectString_Comment_pcp.DescId   = zc_ObjectString_ProdColorPattern_Comment()
                                         -- ������ Boat Structure
                                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                              ON ObjectLink_ColorPattern.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                             AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                         -- ������������ - �� Boat Structure
                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_Goods
                                                              ON ObjectLink_ProdColorPattern_Goods.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                             AND ObjectLink_ProdColorPattern_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()

                                    WHERE Object_ReceiptGoodsChild.DescId   = zc_Object_ReceiptGoodsChild()
                                      AND Object_ReceiptGoodsChild.isErased = FALSE
                                    ORDER BY ObjectLink_ColorPattern.ChildObjectId
                                           , ObjectLink_Goods.ChildObjectId
                                           , COALESCE (ObjectLink_Object.ChildObjectId, -1) DESC
                                           , COALESCE (ObjectLink_MaterialOptions.ChildObjectId, 0)
                                           , Object_ReceiptGoodsChild.ValueData
                                           , COALESCE (ObjectString_Comment_pcp.ValueData, '')
                                   )
           -- � ���� ������ ����� ������
         , tmpReceiptItems_key AS (SELECT tmpReceiptItems.ColorPatternId
                                        , tmpReceiptItems.ObjectId_parent
                                        , STRING_AGG (CASE WHEN tmpReceiptItems.MaterialOptionsId > 0 THEN tmpReceiptItems.MaterialOptionsId :: TVarChar || '-' ELSE '' END
                                                   || CASE WHEN tmpReceiptItems.ObjectId > 0 THEN tmpReceiptItems.ObjectId :: TVarChar ELSE UPPER (tmpReceiptItems.ProdColorName) END, ';') AS Key_Id
                                        , STRING_AGG (CASE WHEN tmpReceiptItems.MaterialOptionsId > 0 THEN lfGet_Object_ValueData_sh (tmpReceiptItems.MaterialOptionsId) || '-' ELSE '' END
                                                   || CASE WHEN tmpReceiptItems.ObjectId > 0 THEN lfGet_Object_ValueData_sh (tmpReceiptItems.ObjectId) ELSE UPPER (tmpReceiptItems.ProdColorName) END, ';') AS Key_Id_text
                                   FROM (SELECT *
                                         FROM tmpReceiptItems
                                         ORDER BY tmpReceiptItems.ColorPatternId, tmpReceiptItems.ObjectId_parent
                                                , COALESCE (tmpReceiptItems.ObjectId, -1) DESC
                                                , COALESCE (tmpReceiptItems.MaterialOptionsId, 0)
                                                , tmpReceiptItems.ProdColorName
                                        ) AS tmpReceiptItems
                                   GROUP BY tmpReceiptItems.ColorPatternId
                                          , tmpReceiptItems.ObjectId_parent
                                  )
           -- ���������
           SELECT tmpReceiptItems.ReceiptGoodsChildId
                , tmpReceiptItems.ReceiptGoodsId
                , tmpReceiptItems.ObjectId_parent
                , tmpReceiptItems.ObjectId
                , tmpReceiptItems.ObjectId_pcp
                , tmpReceiptItems.ProdColorPatternId
                , tmpReceiptItems.MaterialOptionsId
                , tmpReceiptItems.ColorPatternId
                , tmpReceiptItems.ReceiptLevelId
                , tmpReceiptItems.GoodsId_child
                , tmpReceiptItems.NPP
                  -- ���� - ������ ����������
                , tmpReceiptItems.ProdColorName
                  -- ���� - ������ ����������
                , tmpReceiptItems.ProdColorName_pcp
                  --
                , tmpReceiptItems_key.Key_Id
                , tmpReceiptItems_key.Key_Id_text
           FROM tmpReceiptItems
                LEFT JOIN tmpReceiptItems_key ON tmpReceiptItems_key.ColorPatternId  = tmpReceiptItems.ColorPatternId
                                             AND tmpReceiptItems_key.ObjectId_parent = tmpReceiptItems.ObjectId_parent
          ;


--    RAISE EXCEPTION '������. %   %', (select max (LENGTH (Key_Id)) from _tmpReceiptItems_Key)
  --  , (select max (LENGTH (Key_Id_text)) from _tmpReceiptItems_Key)
    --;

         -- ������������ �������� ProdOptItems - � �����
         CREATE TEMP TABLE _tmpProdOptItems ON COMMIT DROP AS
            SELECT lpSelect.ProdOptionsId
                   -- Boat Structure - ���� ����
                 , lpSelect.ProdColorPatternId
                   -- ��������� �����
                 , lpSelect.MaterialOptionsId
                   --
                 , lpSelect.GoodsId
                   --
               --, lpSelect.ReceiptLevelId
                   --
               --, lpSelect.GoodsId_child
                   -- ���-�� �����
                 , lpSelect.Amount_goods AS Amount
                   -- ���-�� ��� ������ ����
                 , lpSelect.AmountBasis
                   -- ���� ��. ��� GoodsId
                 , lpSelect.EKPrice

            FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= 0
                                             , inIsShowAll:= FALSE
                                             , inIsErased := FALSE
                                             , inIsSale   := TRUE
                                             , inSession  := inUserId :: TVarChar
                                              ) AS lpSelect
            WHERE lpSelect.MovementId_OrderClient = inMovementId
              AND lpSelect.ProductId              = vbProductId
           ;

         -- ������������ �������� ProdColorItems - � ����� (����� Boat Structure)
         CREATE TEMP TABLE _tmpProdColorItems ON COMMIT DROP AS
           SELECT -- ���� ����� ��� ������
                  ObjectLink_Goods.ChildObjectId            AS GoodsId
                   -- Boat Structure
                , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
                   -- ��������� �����
                , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
                  -- ���� - ������ ���������� (����� ��� GoodsId)
                , CASE WHEN ObjectLink_Goods.ChildObjectId > 0
                            THEN ''
                       WHEN TRIM (ObjectString_Comment.ValueData) <> ''
                            THEN TRIM (ObjectString_Comment.ValueData)
                       ELSE -- ���, �.�. � ReceiptGoodsChild ����� ��������, � ���� ��� ����� ������ ����� ����������� Boat Structure
                            ''
                            -- TRIM (COALESCE (ObjectString_ProdColorPattern_Comment.ValueData, ''))
                  END AS ProdColorName

           FROM Object AS Object_ProdColorItems
                -- �����
                INNER JOIN ObjectLink AS ObjectLink_Product
                                      ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                     AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                     AND ObjectLink_Product.ChildObjectId = vbProductId
                -- ����� �������
                INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                       ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                      AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                      AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId

                -- ����� ����, ���� ���� ��������� ��� ����� (����� ��� GoodsId)
                LEFT JOIN ObjectString AS ObjectString_Comment
                                       ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                      AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorItems_Comment()

                -- ���� ������ �� ������ �����, �� ��� ��� � ReceiptGoodsChild
                LEFT JOIN ObjectLink AS ObjectLink_Goods
                                     ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                    AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
                -- �������
                LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                     ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                    AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                -- ��������� �����
                LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                     ON ObjectLink_MaterialOptions.ObjectId = Object_ProdColorItems.Id
                                    AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ProdColorItems_MaterialOptions()
           WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
             AND Object_ProdColorItems.isErased = FALSE
          ;


         -- ��������
         IF EXISTS (SELECT _tmpProdColorItems.ProdColorPatternId FROM _tmpProdColorItems GROUP BY _tmpProdColorItems.ProdColorPatternId HAVING COUNT(*) > 1)
         THEN
             RAISE EXCEPTION '������.������� Boat Structure = <%> �� ����� �������������.'
                   , (SELECT lfGet_Object_ValueData_pcp (_tmpProdColorItems.ProdColorPatternId) FROM _tmpProdColorItems GROUP BY _tmpProdColorItems.ProdColorPatternId HAVING COUNT(*) > 1 LIMIT 1);
         END IF;



         -- 1. ��������� - �������� ��������� zc_MI_Child - ������ ������ �����
         WITH tmpRes AS (-- 1. ������� - ��� ������������� � ����� - !!!��� ������� ��� ������ �����!!! - ������� DISTINCT
                         SELECT DISTINCT
                                -- ����� ��������
                                0                                   AS MovementItemId
                                -- ����� c ������ Boat Structure, ����� ������/��������
                              , CASE WHEN lpSelect.ObjectId_parent = lpSelect.ObjectId THEN lpSelect.ObjectId_parent ELSE 0 END AS ObjectId_parent_find
                                -- ����/����� �� �������
                              , lpSelect.ObjectId_parent               AS ObjectId_parent
                                -- �������
                              , lpSelect.ReceiptGoodsId                AS ReceiptGoodsId

                                -- ����� ��� �����
                              , 0                                      AS ProdOptionsId
                                --
                              , COALESCE (lpSelect.Value_parent, 0)    AS OperCount
                              , COALESCE (lpSelect.ForCount_parent, 1) AS ForCount
                                -- ��� ������ ���� - ����� �����������
                              , CASE WHEN lpSelect.ObjectId_parent = lpSelect.ObjectId THEN COALESCE (lpSelect.EKPrice_parent, 0) ELSE 0 END AS OperPrice
                                --

                         FROM _tmpReceiptProdModel AS lpSelect
                         WHERE -- !!!���� ��������� � ��������� ��� ������� ������������!!
                               vbIsBasicConf = TRUE
                           OR -- ��� ��������� ��� ���������
                               lpSelect.ObjectId_parent IN (SELECT _tmpReceiptProdModel.ObjectId_parent
                                                            FROM _tmpReceiptProdModel
                                                                 JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpReceiptProdModel.ProdColorPatternId)

                        UNION ALL
                         -- 2. �����
                         SELECT -- ����� ��������
                                0                AS MovementItemId
                                -- ��� �� �����
                              , CASE WHEN lpSelect.GoodsId > 0 THEN lpSelect.GoodsId ELSE lpSelect.ProdOptionsId END AS ObjectId_parent
                                -- Goods
                              , CASE WHEN lpSelect.GoodsId > 0 THEN lpSelect.GoodsId ELSE lpSelect.ProdOptionsId END AS ObjectId
                                -- �������
                              , 0 AS ReceiptGoodsId

                                -- �����
                              , lpSelect.ProdOptionsId
                                --
                              , CASE WHEN lpSelect.GoodsId > 0 THEN lpSelect.Amount ELSE 1 END AS OperCount
                              , 1 AS ForCount
                              , COALESCE (lpSelect.EKPrice, 0) AS OperPrice

                         FROM _tmpProdOptItems AS lpSelect
                         -- ��� ���� ���������
                         WHERE COALESCE (lpSelect.ProdColorPatternId, 0) = 0
                           -- !!!��������, ���� �� ���������� �����
                         --AND lpSelect.GoodsId > 0
                        )
         -- ��������� - ������ ������ �����
         INSERT INTO _tmpItem_Child (MovementItemId, ObjectId_parent_find, ObjectId_parent, ObjectDescId, ReceiptGoodsId_find, ProdOptionsId, OperCount, ForCount, OperPrice)
            SELECT 0 AS MovementItemId
                 , tmpRes.ObjectId_parent_find
                 , tmpRes.ObjectId_parent
                 , COALESCE (Object_Object.DescId, 0) AS ObjectDescId
                   --
                 , tmpRes.ReceiptGoodsId
                   --
                 , tmpRes.ProdOptionsId
                   --
                 , tmpRes.OperCount, tmpRes.ForCount
                 , tmpRes.OperPrice
            FROM tmpRes
                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpRes.ObjectId_parent
            ;



         -- 2. ��������� - �������� ��������� zc_MI_Detail - ������ �����
         WITH
              tmpRes AS (-- 1. ������� - ������
                         SELECT
                                -- ���� �� �������
                                lpSelect.ObjectId_parent
                                -- Goods - ���� ��� Boat Structure, ���� �� ������� (����� ��������, �.�. �������� ������), ���� �����
                              , CASE WHEN _tmpProdColorItems.ProdColorPatternId > 0 THEN _tmpProdColorItems.GoodsId ELSE lpSelect.ObjectId END AS ObjectId

                                -- ������ ���� �� ����� ��� �����
                              , COALESCE (_tmpProdOptItems.ProdOptionsId, 0) AS ProdOptionsId

                                -- Boat Structure
                              , lpSelect.ProdColorPatternId
                                -- ��������� �����
                              , _tmpProdColorItems.MaterialOptionsId
                                --
                              , lpSelect.ReceiptLevelId
                                --
                              , lpSelect.GoodsId_child
                                --
                              , lpSelect.NPP
                                -- ���� - ������ ���������� (����� ��� GoodsId)
                              , _tmpProdColorItems.ProdColorName

                                -- �������� - ������� ������
                              , COALESCE (lpSelect.Value, 0)                            AS OperCount
                              , COALESCE (lpSelect.ForCount, 0)                         AS ForCount
                                -- ���� ��. ��� ��� - ������� ������
                              , COALESCE (_tmpProdOptItems.EKPrice, lpSelect.EKPrice, 0) AS OperPrice

                         FROM _tmpReceiptProdModel AS lpSelect
                              LEFT JOIN _tmpProdColorItems  ON _tmpProdColorItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                              LEFT JOIN _tmpProdOptItems ON _tmpProdOptItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                                        AND _tmpProdOptItems.ProdColorPatternId > 0
                                                       -- ?���� �� ��� �������?
                                                       -- AND COALESCE (_tmpProdOptItems.MaterialOptionsId, 0) = COALESCE (tmpProdColorItems.MaterialOptionsId, 0)

                         WHERE -- !!!���� ��������� � ��������� ��� ������� ������������!!
                              (vbIsBasicConf = TRUE
                           OR -- ��� ��������� ��� ���������
                               lpSelect.ObjectId_parent IN (SELECT _tmpReceiptProdModel.ObjectId_parent FROM _tmpReceiptProdModel JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpReceiptProdModel.ProdColorPatternId)
                              )
                          AND (-- ������ ���� ������
                               lpSelect.ObjectId_parent <> lpSelect.ObjectId
                               -- ��� ��� ���������
                            OR lpSelect.ProdColorPatternId > 0
                              )
                        )
         -- ��������� - �������� ���������, ������ �����
         INSERT INTO _tmpItem_Detail (ObjectId_parent, ObjectId, ObjectDescId, ProdOptionsId, ColorPatternId, ProdColorPatternId, MaterialOptionsId, ReceiptLevelId, GoodsId_child, NPP
                                    , ProdColorName, OperCount, ForCount, OperPrice)

            SELECT tmpRes.ObjectId_parent
                 , tmpRes.ObjectId
                 , COALESCE (Object_Object.DescId, 0) AS ObjectDescId
                   --
                 , tmpRes.ProdOptionsId
                   -- ������ Boat Structure
                 , ObjectLink_ColorPattern.ChildObjectId AS ColorPatternId
                   -- Boat Structure
                 , tmpRes.ProdColorPatternId
                   -- ��������� �����
                 , tmpRes.MaterialOptionsId
                   --
                 , tmpRes.ReceiptLevelId
                 , tmpRes.GoodsId_child
                 , tmpRes.NPP
                   -- ���� - ������ ���������� (����� ��� GoodsId)
                 , tmpRes.ProdColorName
                   --
                 , tmpRes.OperCount
                 , tmpRes.ForCount
                 , tmpRes.OperPrice
            FROM tmpRes
                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpRes.ObjectId
                 -- ������ Boat Structure
                 LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                      ON ObjectLink_ColorPattern.ObjectId = tmpRes.ProdColorPatternId
                                     AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
            ;

         -- ��������� - �������� ��������� - �������� Key_Id
         UPDATE _tmpItem_Child SET Key_Id      = tmp.Key_Id
                                 , Key_Id_text = tmp.Key_Id_text
         FROM (SELECT _tmpItem.ColorPatternId
                    , _tmpItem.ObjectId_parent
                    , STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0 THEN _tmpItem.MaterialOptionsId :: TVarChar || '-' ELSE '' END
                               || CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId :: TVarChar ELSE UPPER (_tmpItem.ProdColorName) END, ';') AS Key_Id
                    , STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0 THEN lfGet_Object_ValueData_sh (_tmpItem.MaterialOptionsId) || '-' ELSE '' END
                               || CASE WHEN _tmpItem.ObjectId > 0 THEN lfGet_Object_ValueData_sh (_tmpItem.ObjectId) ELSE UPPER (_tmpItem.ProdColorName) END, ';') AS Key_Id_text
               FROM -- ������� �������������
                    (SELECT * FROM _tmpItem_Detail AS _tmpItem ORDER BY _tmpItem.ColorPatternId, _tmpItem.ObjectId_parent
                                                                      , COALESCE (_tmpItem.ObjectId, -1) DESC
                                                                      , COALESCE (_tmpItem.MaterialOptionsId, 0)
                                                                      , _tmpItem.ProdColorName
                    ) AS _tmpItem
               GROUP BY _tmpItem.ColorPatternId
                      , _tmpItem.ObjectId_parent
              ) AS tmp
         WHERE _tmpItem_Child.ObjectId_parent = tmp.ObjectId_parent
        ;

--            RAISE EXCEPTION '������-1.  <%>', (select count(*) FROM _tmpItem_Child where Key_Id_text ilike '%RAL%');

         -- ������� ObjectId_parent ��� Boat Structure
         UPDATE _tmpItem_Child SET ObjectId_parent_find = _tmpItem_find.ObjectId_parent_find
                                 , ReceiptGoodsId_find  = _tmpItem_find.ReceiptGoodsId
         FROM (WITH -- ������������ ������
                    tmpList_from AS (SELECT DISTINCT
                                            _tmpItem.ColorPatternId
                                          , _tmpItem.ObjectId_parent
                                          , _tmpItem_Child.Key_Id
                                          , TRIM (SPLIT_PART (Object_Goods.ValueData, 'AGL', 1)) AS Comment_goods
                                     FROM _tmpItem_Detail AS _tmpItem
                                          JOIN _tmpItem_Child ON _tmpItem_Child.ObjectId_parent = _tmpItem.ObjectId_parent
                                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpItem.ObjectId_parent
                                     WHERE _tmpItem.ColorPatternId > 0
                                    )
                      -- � ���� ������ ����� ������
                    , tmpList_to AS (SELECT DISTINCT
                                            _tmpReceiptItems_Key.ColorPatternId
                                          , _tmpReceiptItems_Key.ObjectId_parent
                                          , _tmpReceiptItems_Key.Key_Id
                                          ,  _tmpReceiptItems_Key.ReceiptGoodsId
                                          , TRIM (SPLIT_PART (Object_Goods.ValueData, 'AGL', 1)) AS Comment_goods
                                     FROM _tmpReceiptItems_Key
                                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpReceiptItems_Key.ObjectId_parent
                                    )
               -- ���������
               SELECT tmpList_from.ObjectId_parent
                      -- ����� ����� ���� � ����� ����������
                    , COALESCE (tmpList_to.ObjectId_parent, 0) AS ObjectId_parent_find
                      -- 
                    , COALESCE (tmpList_to.ReceiptGoodsId, 0)  AS ReceiptGoodsId
               FROM tmpList_from
                    LEFT JOIN tmpList_to ON tmpList_to.ColorPatternId = tmpList_from.ColorPatternId
                                        AND tmpList_to.Key_Id         = tmpList_from.Key_Id
                                        AND tmpList_to.Comment_goods  = tmpList_from.Comment_goods
              ) AS _tmpItem_find
         WHERE _tmpItem_Child.ObjectId_parent = _tmpItem_find.ObjectId_parent
        ;

         -- ������� GoodsId_child ��� ObjectId_parent_find - ���� �� ������ ����
         UPDATE _tmpItem_Detail SET GoodsId_child_find = _tmpItem_find.GoodsId_child_find
         FROM (SELECT _tmpItem_Child.ObjectId_parent      AS ObjectId_parent
                    , ObjectLink_Object.ChildObjectId     AS ObjectId
                    , ObjectLink_GoodsChild.ChildObjectId AS GoodsId_child_find
               FROM _tmpItem_Child
                    INNER JOIN ObjectLink AS ObjectLink_Goods
                                          ON ObjectLink_Goods.ChildObjectId = _tmpItem_Child.ObjectId_parent_find
                                         AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                    INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_Goods.ObjectId
                                                            AND Object_ReceiptGoods.isErased = FALSE
                    INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                          ON ObjectLink_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                         AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                    INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId
                                                                 AND Object_ReceiptGoods.isErased = FALSE

                    LEFT JOIN ObjectLink AS ObjectLink_Object
                                         ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                        AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                    LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                         ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                        AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                    LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = ObjectLink_GoodsChild.ChildObjectId
              ) AS _tmpItem_find
         WHERE _tmpItem_Detail.ObjectId_parent = _tmpItem_find.ObjectId_parent
           AND _tmpItem_Detail.ObjectId        = _tmpItem_find.ObjectId
           AND _tmpItem_Detail.GoodsId_child > 0
          ;


        -- ��������
        IF EXISTS (SELECT 1
                   FROM _tmpItem_Child AS _tmpItem
                       JOIN _tmpItem_Child AS _tmpItem_find
                                         ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                         AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                   WHERE _tmpItem.ObjectId_parent > 0
                  )
        --AND 1=0
        THEN
            RAISE EXCEPTION '������-1.�� � ���� ��������� ���������� ObjectId_parent_find.<%> <%> <%> <%>'
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent)
                              FROM _tmpItem_Child AS _tmpItem
                                  JOIN _tmpItem_Child AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent_find)
                              FROM _tmpItem_Child AS _tmpItem
                                  JOIN _tmpItem_Child AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent_find)
                              FROM _tmpItem_Child AS _tmpItem
                                  JOIN _tmpItem_Child AS _tmpItem_find
                                                    ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                    AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                              WHERE _tmpItem.ObjectId_parent > 0
                              ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find DESC, _tmpItem.ObjectId ASC
                              LIMIT 1)
                           , (SELECT COUNT (*)
                              FROM _tmpItem_Child AS _tmpItem
                              WHERE _tmpItem.ObjectId_parent IN (SELECT _tmpItem.ObjectId_parent
                                                                 FROM _tmpItem_Child AS _tmpItem
                                                                     JOIN _tmpItem_Child AS _tmpItem_find
                                                                                       ON _tmpItem_find.ObjectId_parent = _tmpItem.ObjectId_parent
                                                                                       AND COALESCE (_tmpItem_find.ObjectId_parent_find, 0) <> COALESCE (_tmpItem.ObjectId_parent_find, 0)
                                                                 WHERE _tmpItem.ObjectId_parent > 0
                                                                 ORDER BY _tmpItem.ObjectId_parent ASC, _tmpItem.ObjectId_parent_find ASC, _tmpItem.ObjectId ASC
                                                                 LIMIT 1)
                             )
                            ;
        END IF;



--        RAISE EXCEPTION '������.<%>  <%>'
--        , (select count(*) from _tmpReceiptItems_Key where _tmpReceiptItems_Key.Key_Id ILIKE '%ral%')
--        , (select count(*) from _tmpItem_Child         where _tmpItem_Child.Key_Id     ILIKE '%ral%')
--         ;


         -- ������� - ������ ��������� ����� + ��� �������������
         CREATE TEMP TABLE _tmpReceiptItems_new (ReceiptGoodsChildId Integer, ReceiptGoodsId Integer
                                               , ObjectId_parent_old Integer, ObjectId_parent Integer, ObjectId Integer, ProdColorPatternId Integer
                                               , MaterialOptionsId Integer, ColorPatternId Integer, ReceiptLevelId Integer, GoodsId_child Integer, GoodsId_child_old Integer
                                               , ProdColorName TVarChar
                                               , OperCount TFloat, ForCount TFloat
                                               , NPP Integer
                                               , Key_Id TVarChar, Key_Id_text TVarChar
                                                ) ON COMMIT DROP;
        -- ������� �������
        INSERT INTO _tmpReceiptItems_new (ReceiptGoodsChildId, ReceiptGoodsId
                                        , ObjectId_parent_old, ObjectId_parent, ObjectId, ProdColorPatternId
                                        , MaterialOptionsId, ColorPatternId, ReceiptLevelId, GoodsId_child, GoodsId_child_old
                                        , ProdColorName
                                        , OperCount, ForCount
                                        , NPP
                                        , Key_Id, Key_Id_text
                                         )
           SELECT 0 AS ReceiptGoodsChildId
                , 0 AS ReceiptGoodsId
                  -- ���������� ����
                , _tmpItem_Child.ObjectId_parent AS ObjectId_parent_old
                  -- �������� ����
                , 0 AS ObjectId_parent
                  -- �������������, �� ������� �������� ����
                , _tmpItem_Detail.ObjectId

                  -- ������������� - �� Boat Structure
                  --, _tmpItem_Detail.ObjectId_pcp

                  -- Boat Structure - �� ��������
                , _tmpItem_Detail.ProdColorPatternId
                  -- ��������� ����� - �� ������� �������� ����
                , _tmpItem_Detail.MaterialOptionsId
                  --  ������ Boat Structure
                , _tmpItem_Detail.ColorPatternId
                  --
                , _tmpItem_Detail.ReceiptLevelId
                  --
                , 0 AS GoodsId_child
                , _tmpItem_Detail.GoodsId_child AS GoodsId_child_old
                  -- ���� �� ������� �������� ���� - ������ ���������� (����� ��� GoodsId)
                , _tmpItem_Detail.ProdColorName

                  -- OperCount
                , _tmpItem_Detail.OperCount
                , _tmpItem_Detail.ForCount

                  -- NPP
                , _tmpItem_Detail.NPP

                  -- ���� - �� Boat Structure
                  -- , _tmpItem_Detail.ProdColorName_pcp

                  --
                , _tmpItem_Child.Key_Id, _tmpItem_Child.Key_Id_text

           FROM _tmpItem_Child
                JOIN _tmpItem_Detail ON _tmpItem_Detail.ObjectId_parent = _tmpItem_Child.ObjectId_parent
           WHERE _tmpItem_Child.ObjectId_parent_find = 0
             AND _tmpItem_Detail.ProdColorPatternId  > 0
          ;


        /*RAISE EXCEPTION '������.<%>  <%> <%>'
        , (select count(*) from _tmpReceiptItems_new where COALESCE (_tmpReceiptItems_new.GoodsId_child_old, 0) = 0 and Key_Id_text ilike '%magenta%')
        , (select count(*) from _tmpReceiptItems_new where COALESCE (_tmpReceiptItems_new.GoodsId_child_old, 0) > 0 and Key_Id_text ilike '%magenta%')
        , (select count(*) from _tmpReceiptItems_new )
         ;*/


        -- ������� ����� ���� - master
        UPDATE _tmpReceiptItems_new SET ObjectId_parent = tmpGoods.GoodsId
        FROM (WITH tmpColor AS (SELECT _tmpReceiptItems_new.ObjectId_parent_old AS GoodsId_parent_old
                                     , _tmpReceiptItems_new.ObjectId            AS GoodsId
                                     , _tmpReceiptItems_new.ProdColorPatternId  AS ProdColorPatternId
                                     , _tmpReceiptItems_new.ProdColorName       AS ProdColorName
                                     , Object_ProdColor_goods.Id                AS ProdColorId_goods
                                     , Object_ProdColor_goods.ValueData         AS ProdColorName_goods
                                     , OS_Article.ValueData                     AS Article_goods
                                     , Object_MaterialOptions.ValueData         AS MaterialOptionsName
                                       -- � �/�
                                     , ROW_NUMBER() OVER (PARTITION BY _tmpReceiptItems_new.ObjectId_parent_old ORDER BY Object_ProdColorPattern.ObjectCode ASC) AS Ord

                                FROM _tmpReceiptItems_new
                                     -- Boat Structure
                                     LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = _tmpReceiptItems_new.ProdColorPatternId
                                     --
                                     LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                          ON ObjectLink_Goods_ProdColor.ObjectId = _tmpReceiptItems_new.ObjectId
                                                         AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                     LEFT JOIN Object AS Object_ProdColor_goods ON Object_ProdColor_goods.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                                     --
                                     LEFT JOIN ObjectString AS OS_Article ON OS_Article.ObjectId = _tmpReceiptItems_new.ObjectId
                                                                         AND OS_Article.DescId   = zc_ObjectString_Article()
                                     --
                                     LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = _tmpReceiptItems_new.MaterialOptionsId

                               )
                 , tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent_old AS GoodsId_parent_old, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT tmpGoods.GoodsId_parent_old
                   , gpInsertUpdate_Object_Goods (ioId                     := 0
                                                , inCode                   := -1 -- (SELECT MIN (Object.ObjectCode) - 1 FROM Object WHERE Object.DescId = zc_Object_Goods())
                                                                              -- <(-3835)AGL-280-*ICE WHITE - *NEPTUNE GREY(Hypalon)>.
                                                , inName                   := CASE WHEN ObjectString_Comment.ValueData ILIKE 'Hypalon'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                     ||   '-*' || tmpColor_1.ProdColorName_goods
                                                                                     || ' - *' || tmpColor_2.ProdColorName_goods
                                                                                             --|| CASE WHEN tmpColor_3.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp THEN ' *'  || tmpColor_3.ProdColorName ELSE '' END
                                                                                               || CASE WHEN tmpColor_3.GoodsId <> _tmpReceiptItems_Key.ObjectId_pcp THEN ' *'  || tmpColor_3.ProdColorName_goods ELSE '' END

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Teak'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || LEFT (tmpColor_1.MaterialOptionsName, 2)
                                                                                        || '-' || tmpColor_1.ProdColorName

                                                                                   /*WHEN ObjectString_Comment.ValueData ILIKE 'HULL/DECK'
                                                                                   THEN
                                                                                        '������ '
                                                                                      ||'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.ProdColorName_goods
                                                                                               || CASE WHEN tmpColor_2.ProdColorName_goods <> tmpColor_1.ProdColorName_goods
                                                                                                       THEN '-'  || tmpColor_2.ProdColorName_goods
                                                                                                       ELSE ''
                                                                                                  END

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'DECK'
                                                                                   THEN
                                                                                        '������� �������� '
                                                                                      ||'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.ProdColorName_goods

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'STEERING CONSOLE'
                                                                                   THEN
                                                                                        '����� '
                                                                                      ||'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.ProdColorName_goods
                                                                                      */

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Kreslo'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || COALESCE (tmpColor_1.Article_goods, '')
--                                                                                    ||   '-' || (SELECT COUNT(*) FROM tmpColor WHERE tmpColor.GoodsId_parent_old = tmpGoods.GoodsId_parent_old) :: TVarChar
                                                                                      ||   '-' || LOWER (LEFT (tmpColor_2.ProdColorName, 3))
                                                                                      ||   '-' || LOWER (LEFT (tmpColor_3.ProdColorName, 3))

                                                                                   -- ��� �������������
                                                                                   ELSE TRIM (SPLIT_PART (Object_Goods.ValueData, 'AGL', 1))
                                                                                     ||' AGL-' || Object_Model.ValueData
                                                                                     ||   ' '  || tmpColor_1.ProdColorName_goods
                                                                                               || CASE WHEN tmpColor_2.ProdColorName_goods <> tmpColor_1.ProdColorName_goods
                                                                                                       THEN '-'  || tmpColor_2.ProdColorName_goods
                                                                                                       ELSE ''
                                                                                                  END

                                                                              END


                                                , inArticle                := CASE WHEN ObjectString_Comment.ValueData ILIKE 'Hypalon'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                     ||   '-*' || tmpColor_1.ProdColorName_goods
                                                                                     || ' - *' || tmpColor_2.ProdColorName_goods
                                                                                             --|| CASE WHEN tmpColor_3.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp THEN ' *'  || LEFT (tmpColor_3.ProdColorName, 1) ELSE '' END
                                                                                               || CASE WHEN tmpColor_3.GoodsId <> _tmpReceiptItems_Key.ObjectId_pcp THEN ' *'  || LEFT (tmpColor_3.ProdColorName_goods, 1) ELSE '' END

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Teak'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || LEFT (tmpColor_1.MaterialOptionsName, 2)
                                                                                        || '-' || LEFT (tmpColor_1.ProdColorName, 1)

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'HULL/DECK'
                                                                                     OR ObjectString_Comment.ValueData ILIKE 'DECK'
                                                                                     OR ObjectString_Comment.ValueData ILIKE 'STEERING CONSOLE'
                                                                                   THEN
                                                                                        lfGet_Object_Goods_Article_value ('AGL-' || Object_Model.ValueData)

                                                                                   WHEN ObjectString_Comment.ValueData ILIKE 'Kreslo'
                                                                                   THEN
                                                                                        'AGL-' || Object_Model.ValueData
                                                                                      ||   '-' || tmpColor_1.Article_goods
                                                                                      ||   '-' || LOWER (LEFT (tmpColor_2.ProdColorName, 1))
                                                                                      ||    '' || LOWER (LEFT (tmpColor_3.ProdColorName, 1))
                                                                              END
                                                , inArticleVergl           := ''
                                                , inEAN                    := ''
                                                , inASIN                   := ''
                                                , inMatchCode              := ''
                                                , inFeeNumber              := ObjectString_FeeNumber.ValueData
                                                , inComment                := ObjectString_Comment.ValueData
                                                , inIsArc                  := FALSE
                                                , inFeet                   := ObjectFloat_Feet.ValueData
                                                , inMetres                 := ObjectFloat_Metres.ValueData
                                                , inAmountMin              := ObjectFloat_Min.ValueData
                                                , inAmountRefer            := ObjectFloat_Refer.ValueData
                                                , inEKPrice                := ObjectFloat_EKPrice.ValueData
                                                , inEmpfPrice              := ObjectFloat_EmpfPrice.ValueData
                                                , inGoodsGroupId           := ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                , inMeasureId              := ObjectLink_Goods_Measure.ChildObjectId
                                                , inGoodsTagId             := ObjectLink_Goods_GoodsTag.ChildObjectId
                                                , inGoodsTypeId            := ObjectLink_Goods_GoodsType.ChildObjectId
                                                , inGoodsSizeId            := ObjectLink_Goods_GoodsSize.ChildObjectId
                                                , inProdColorId            := tmpColor_1.ProdColorId_goods
                                                , inPartnerId              := ObjectLink_Goods_Partner.ChildObjectId
                                                , inUnitId                 := ObjectLink_Goods_Unit.ChildObjectId
                                                , inDiscountPartnerId      := ObjectLink_Goods_DiscountPartner.ChildObjectId
                                                , inTaxKindId              := ObjectLink_Goods_TaxKind.ChildObjectId
                                                , inEngineId               := NULL
                                                , inSession                := inUserId :: TVarChar
                                                 ) AS GoodsId
              FROM tmpGoods
                   LEFT JOIN tmpColor AS tmpColor_1 ON tmpColor_1.GoodsId_parent_old = tmpGoods.GoodsId_parent_old
                                                   AND tmpColor_1.Ord                = 1
                   LEFT JOIN tmpColor AS tmpColor_2 ON tmpColor_2.GoodsId_parent_old = tmpGoods.GoodsId_parent_old
                                                   AND tmpColor_2.Ord                = 2
                   LEFT JOIN tmpColor AS tmpColor_3 ON tmpColor_3.GoodsId_parent_old = tmpGoods.GoodsId_parent_old
                                                   AND tmpColor_3.Ord                = 3

                   LEFT JOIN _tmpReceiptItems_Key ON _tmpReceiptItems_Key.ObjectId_parent    = tmpGoods.GoodsId_parent_old
                                                 AND _tmpReceiptItems_Key.ProdColorPatternId = tmpColor_3.ProdColorPatternId

                   LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                        ON ObjectLink_ColorPattern_Model.ObjectId = tmpGoods.ColorPatternId
                                       AND ObjectLink_ColorPattern_Model.DescId   = zc_ObjectLink_ColorPattern_Model()
                   LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_ColorPattern_Model.ChildObjectId

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId_parent_old

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                        ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                        ON ObjectLink_Goods_GoodsType.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                        ON ObjectLink_Goods_GoodsSize.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()

                   LEFT JOIN ObjectString AS ObjectString_Comment
                                          ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                         AND ObjectString_Comment.DescId   = zc_ObjectString_Goods_Comment()
                   LEFT JOIN ObjectString AS ObjectString_FeeNumber
                                          ON ObjectString_FeeNumber.ObjectId = Object_Goods.Id
                                         AND ObjectString_FeeNumber.DescId   = zc_ObjectString_Goods_FeeNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                        ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                        ON ObjectLink_Goods_Unit.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Unit.DescId = zc_ObjectLink_Goods_Unit()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_DiscountPartner
                                        ON ObjectLink_Goods_DiscountPartner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_DiscountPartner.DescId = zc_ObjectLink_Goods_DiscountPartner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                        ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                         ON ObjectFloat_Min.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Min.DescId   = zc_ObjectFloat_Goods_Min()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Refer
                                         ON ObjectFloat_Refer.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Refer.DescId   = zc_ObjectFloat_Goods_Refer()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                         ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                         ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Feet
                                         ON ObjectFloat_Feet.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Feet.DescId   = zc_ObjectFloat_Goods_Feet()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Metres
                                         ON ObjectFloat_Metres.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Metres.DescId   = zc_ObjectFloat_Goods_Metres()

              -- ������� ������ ����� ����
              WHERE ObjectString_Comment.ValueData ILIKE 'Hypalon'
                 OR ObjectString_Comment.ValueData ILIKE 'Teak'
                 OR ObjectString_Comment.ValueData ILIKE 'HULL/DECK'
                 OR ObjectString_Comment.ValueData ILIKE 'DECK'
                 OR ObjectString_Comment.ValueData ILIKE 'STEERING CONSOLE'
                 OR ObjectString_Comment.ValueData ILIKE 'Kreslo'

             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent_old = tmpGoods.GoodsId_parent_old
       ;



        -- ������� ����� ���� - child
        UPDATE _tmpReceiptItems_new SET GoodsId_child = tmpGoods.GoodsId_child
        FROM (SELECT tmpGoods_1.GoodsId
                   , tmpGoods_1.GoodsId_child_old
                   , gpInsertUpdate_Object_Goods (ioId                     := 0
                                                , inCode                   := -1
                                                , inName                   := '�� ' || Object_Goods_new.ValueData
                                                , inArticle                := ObjectString_Article_new.ValueData || '-��'
                                              --, inArticle                := tmpGoods_1.GoodsId :: TVarChar
                                                , inArticleVergl           := ''
                                                , inEAN                    := ''
                                                , inASIN                   := ''
                                                , inMatchCode              := ''
                                                , inFeeNumber              := ObjectString_FeeNumber.ValueData
                                                , inComment                := ObjectString_Comment.ValueData
                                                , inIsArc                  := FALSE
                                                , inFeet                   := ObjectFloat_Feet.ValueData
                                                , inMetres                 := ObjectFloat_Metres.ValueData
                                                , inAmountMin              := ObjectFloat_Min.ValueData
                                                , inAmountRefer            := ObjectFloat_Refer.ValueData
                                                , inEKPrice                := ObjectFloat_EKPrice.ValueData
                                                , inEmpfPrice              := ObjectFloat_EmpfPrice.ValueData
                                                , inGoodsGroupId           := ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                , inMeasureId              := ObjectLink_Goods_Measure.ChildObjectId
                                                , inGoodsTagId             := ObjectLink_Goods_GoodsTag.ChildObjectId
                                                , inGoodsTypeId            := ObjectLink_Goods_GoodsType.ChildObjectId
                                                , inGoodsSizeId            := ObjectLink_Goods_GoodsSize.ChildObjectId
                                                , inProdColorId            := ObjectLink_Goods_ProdColor_new.ChildObjectId
                                                , inPartnerId              := ObjectLink_Goods_Partner.ChildObjectId
                                                , inUnitId                 := ObjectLink_Goods_Unit.ChildObjectId
                                                , inDiscountPartnerId      := ObjectLink_Goods_DiscountPartner.ChildObjectId
                                                , inTaxKindId              := ObjectLink_Goods_TaxKind.ChildObjectId
                                                , inEngineId               := NULL
                                                , inSession                := inUserId :: TVarChar
                                                 ) AS GoodsId_child
              FROM (SELECT DISTINCT
                           _tmpReceiptItems_new.ObjectId_parent    AS GoodsId
                         , _tmpReceiptItems_new.GoodsId_child_old  AS GoodsId_child_old
                    FROM _tmpReceiptItems_new
                    WHERE _tmpReceiptItems_new.GoodsId_child_old > 0
                   ) AS tmpGoods_1
                   LEFT JOIN Object AS Object_Goods_new ON Object_Goods_new.Id = tmpGoods_1.GoodsId
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor_new
                                        ON ObjectLink_Goods_ProdColor_new.ObjectId = tmpGoods_1.GoodsId
                                       AND ObjectLink_Goods_ProdColor_new.DescId = zc_ObjectLink_Goods_ProdColor()
                   LEFT JOIN ObjectString AS ObjectString_Article_new
                                          ON ObjectString_Article_new.ObjectId = tmpGoods_1.GoodsId
                                         AND ObjectString_Article_new.DescId   =  zc_ObjectString_Article()

                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods_1.GoodsId_child_old

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                        ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                        ON ObjectLink_Goods_GoodsType.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                        ON ObjectLink_Goods_GoodsSize.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()

                   LEFT JOIN ObjectString AS ObjectString_Comment
                                          ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                         AND ObjectString_Comment.DescId   = zc_ObjectString_Goods_Comment()
                   LEFT JOIN ObjectString AS ObjectString_FeeNumber
                                          ON ObjectString_FeeNumber.ObjectId = Object_Goods.Id
                                         AND ObjectString_FeeNumber.DescId   = zc_ObjectString_Goods_FeeNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                        ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                        ON ObjectLink_Goods_Unit.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Unit.DescId = zc_ObjectLink_Goods_Unit()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_DiscountPartner
                                        ON ObjectLink_Goods_DiscountPartner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_DiscountPartner.DescId = zc_ObjectLink_Goods_DiscountPartner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                        ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                         ON ObjectFloat_Min.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Min.DescId   = zc_ObjectFloat_Goods_Min()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Refer
                                         ON ObjectFloat_Refer.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Refer.DescId   = zc_ObjectFloat_Goods_Refer()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                         ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                         ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Feet
                                         ON ObjectFloat_Feet.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Feet.DescId   = zc_ObjectFloat_Goods_Feet()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Metres
                                         ON ObjectFloat_Metres.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Metres.DescId   = zc_ObjectFloat_Goods_Metres()
             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent   = tmpGoods.GoodsId
          AND _tmpReceiptItems_new.GoodsId_child_old = tmpGoods.GoodsId_child_old
       ;


        -- ������� ����� ReceiptGoods
        UPDATE _tmpReceiptItems_new SET ReceiptGoodsId = tmpGoods.ReceiptGoodsId
        FROM (WITH tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent AS GoodsId_parent, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT tmpGoods.GoodsId_parent
                   , gpInsertUpdate_Object_ReceiptGoods (ioId               := 0
                                                       , inCode             := 0
                                                       , inName             := ''
                                                       , inColorPatternId   := tmpGoods.ColorPatternId
                                                       , inGoodsId          := tmpGoods.GoodsId_parent
                                                       , inUnitId           := 0
                                                       , inUnitChildId      := 0
                                                       , inIsMain           := TRUE
                                                       , inUserCode         := (ABS (Object_Goods.ObjectCode) :: Integer) :: TVarChar
                                                       , inComment          := ''
                                                       , inSession          := inUserId :: TVarChar
                                                        ) AS ReceiptGoodsId
              FROM tmpGoods
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId_parent
              -- ���� ��������� ����
              WHERE tmpGoods.GoodsId_parent > 0
             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent = tmpGoods.GoodsId_parent
       ;

        -- ������� ����� ReceiptGoodsChild
        UPDATE _tmpReceiptItems_new SET ReceiptGoodsChildId = tmpGoods.ReceiptGoodsChildId
        FROM (WITH tmpGoods AS (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent AS GoodsId_parent, _tmpReceiptItems_new.ColorPatternId FROM _tmpReceiptItems_new
                               )
              --
              SELECT _tmpReceiptItems_new.ObjectId_parent
                   , _tmpReceiptItems_new.ObjectId
                   , _tmpReceiptItems_new.ProdColorPatternId
                   , (SELECT gpInsertUpdate.ioId
                      FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                  := 0
                                                                  , inComment             := CASE WHEN COALESCE (_tmpReceiptItems_new.ObjectId, 0) = 0
                                                                                                  THEN CASE WHEN _tmpReceiptItems_new.ProdColorName <> _tmpReceiptItems_Key.ProdColorName_pcp
                                                                                                       -- ���� �� ����� ��� � Boat Structure
                                                                                                       THEN _tmpReceiptItems_new.ProdColorName
                                                                                                       ELSE ''
                                                                                                       END
                                                                                                   ELSE ''
                                                                                             END
                                                                  , inNPP                 := _tmpReceiptItems_new.NPP :: Integer
                                                                  , inReceiptGoodsId      := _tmpReceiptItems_new.ReceiptGoodsId
                                                                  , inObjectId            := _tmpReceiptItems_new.ObjectId
                                                                  , inProdColorPatternId  := _tmpReceiptItems_new.ProdColorPatternId
                                                                  , inMaterialOptionsId   := _tmpReceiptItems_new.MaterialOptionsId
                                                                  , inReceiptLevelId_top  := NULL
                                                                  , inReceiptLevelId      := _tmpReceiptItems_new.ReceiptLevelId
                                                                  , inGoodsChildId        := _tmpReceiptItems_new.GoodsId_child
                                                                  , ioValue               := _tmpReceiptItems_new.OperCount :: TVarChar
                                                                  , ioValue_service       := '0'
                                                                  , ioForCount            := _tmpReceiptItems_new.ForCount
                                                                  , inIsEnabled           := TRUE
                                                                  , inSession             := inUserId :: TVarChar
                                                                   ) AS gpInsertUpdate
                     ) AS ReceiptGoodsChildId
              FROM _tmpReceiptItems_new
                   LEFT JOIN _tmpReceiptItems_Key ON _tmpReceiptItems_Key.ObjectId_parent    = _tmpReceiptItems_new.ObjectId_parent_old
                                                 AND _tmpReceiptItems_Key.ProdColorPatternId = _tmpReceiptItems_new.ProdColorPatternId
              -- ���� ��������� ����
              WHERE _tmpReceiptItems_new.ObjectId_parent > 0


            UNION ALL
             -- ��� ��������� ��� ������ ����
             SELECT  0 AS ObjectId_parent
                   , _tmpReceiptProdModel.ObjectId       AS ObjectId
                   , 0 AS ProdColorPatternId
                   , (SELECT gpInsertUpdate.ioId
                      FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                  := 0
                                                                  , inComment             := ''
                                                                  , inNPP                 := _tmpReceiptProdModel.NPP :: Integer
                                                                  , inReceiptGoodsId      := _tmpReceiptItems_new.ReceiptGoodsId
                                                                  , inObjectId            := _tmpReceiptProdModel.ObjectId
                                                                  , inProdColorPatternId  := 0
                                                                  , inMaterialOptionsId   := NULL
                                                                  , inReceiptLevelId_top  := NULL
                                                                  , inReceiptLevelId      := _tmpReceiptProdModel.ReceiptLevelId
                                                                  , inGoodsChildId        := _tmpReceiptItems_new.GoodsId_child
                                                                  , ioValue               := _tmpReceiptProdModel.Value :: TVarChar
                                                                  , ioValue_service       := '0'
                                                                  , ioForCount            := _tmpReceiptProdModel.ForCount
                                                                  , inIsEnabled           := TRUE
                                                                  , inSession             := inUserId :: TVarChar
                                                                   ) AS gpInsertUpdate
                     ) AS ReceiptGoodsChildId
             FROM _tmpReceiptProdModel
                  INNER JOIN Object AS Object_Object
                                    ON Object_Object.Id     = _tmpReceiptProdModel.ObjectId
                                   AND Object_Object.DescId = zc_Object_Goods()
                  INNER JOIN (-- ����� �������� ReceiptGoodsId + ���� GoodsId_child
                              SELECT DISTINCT
                                     _tmpReceiptItems_new.ReceiptGoodsId
                                   , _tmpReceiptItems_new.ObjectId_parent_old
                                   , _tmpReceiptItems_new.GoodsId_child, _tmpReceiptItems_new.GoodsId_child_old
                                 --, _tmpReceiptItems_new.ReceiptLevelId
                              FROM _tmpReceiptItems_new
                              -- ���� GoodsId_child
                              WHERE _tmpReceiptItems_new.GoodsId_child_old > 0

                             UNION
                              -- ����� �������� ReceiptGoodsId + ��� GoodsId_child
                              SELECT DISTINCT
                                     _tmpReceiptItems_new.ReceiptGoodsId
                                   , _tmpReceiptItems_new.ObjectId_parent_old
                                     -- ����� ������
                                   , 0 AS GoodsId_child
                                     -- ����������� ������
                                   , 0 AS GoodsId_child_old
                                 --, -1 AS ReceiptLevelId
                              FROM _tmpReceiptItems_new

                             ) AS _tmpReceiptItems_new
                               ON _tmpReceiptItems_new.ObjectId_parent_old = _tmpReceiptProdModel.ObjectId_parent
                              AND _tmpReceiptItems_new.GoodsId_child_old   = COALESCE (_tmpReceiptProdModel.GoodsId_child, 0)
                            --AND _tmpReceiptItems_new.ReceiptLevelId      = COALESCE (_tmpReceiptProdModel.ReceiptLevelId, 0)

             WHERE COALESCE (_tmpReceiptProdModel.ProdColorPatternId, 0) = 0
              -- ������ ����� ������ ����
              AND _tmpReceiptProdModel.ObjectId_parent > 0

             ) AS tmpGoods
        WHERE _tmpReceiptItems_new.ObjectId_parent    = tmpGoods.ObjectId_parent
          AND _tmpReceiptItems_new.ObjectId           = tmpGoods.ObjectId
          AND _tmpReceiptItems_new.ProdColorPatternId = tmpGoods.ProdColorPatternId
       ;

       -- ��������� ����� ����
        UPDATE _tmpItem_Child SET ObjectId_parent_find = _tmpReceiptItems_new.ObjectId_parent
                                , ReceiptGoodsId_find  = _tmpReceiptItems_new.ReceiptGoodsId
        FROM (SELECT DISTINCT _tmpReceiptItems_new.ObjectId_parent_old, _tmpReceiptItems_new.ObjectId_parent, _tmpReceiptItems_new.ReceiptGoodsId
              FROM _tmpReceiptItems_new
             ) AS _tmpReceiptItems_new
        WHERE _tmpItem_Child.ObjectId_parent    = _tmpReceiptItems_new.ObjectId_parent_old
        --AND _tmpItem_Child.ObjectId           = _tmpReceiptItems_new.ObjectId
        --AND _tmpItem_Child.ProdColorPatternId = _tmpReceiptItems_new.ProdColorPatternId
         ;

--        RAISE EXCEPTION '������.<%> <%>', (select distinct lfGet_Object_ValueData (_tmpReceiptItems_new.ObjectId_parent_old) from _tmpReceiptItems_new)
  --      , (select distinct lfGet_Object_ValueData (_tmpReceiptItems_new.ObjectId_parent) from _tmpReceiptItems_new)
    --    ;


        -- ��������
        IF EXISTS (SELECT 1 FROM _tmpItem_Child AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0 /*AND _tmpItem.ProdColorPatternId > 0*/)
        --AND 1=0
        THEN
            RAISE EXCEPTION '������.�� ������ ������ ���%<%>.%��� ����� ���������: <%>%����� �� ������� <%> ��.'
                                        , CHR (13)
                                        , (SELECT lfGet_Object_ValueData (_tmpItem.ObjectId_parent) || COALESCE ('(' || OS.ValueData || ')', '') || COALESCE ('(' || _tmpItem.ObjectId_parent :: TVarChar || ')', '')
                                           FROM (SELECT DISTINCT _tmpItem.ObjectId_parent FROM _tmpItem_Child AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0
                                                ) AS _tmpItem
                                                LEFT JOIN ObjectString AS OS ON OS.ObjectId = _tmpItem.ObjectId_parent AND OS.DescId = zc_ObjectString_Goods_Comment()
                                           LIMIT 1)
                                        , CHR (13)
                                        , (SELECT lfGet_Object_ValueData (_tmpItem.ColorPatternId)
                                                || ' : '
                                                || CHR (13)
                                                || CHR (13)
                                                || _tmpItem_Child.Key_Id
                                                || CHR (13)
                                                || CHR (13)
                                                || STRING_AGG (CASE WHEN _tmpItem.MaterialOptionsId > 0
                                                                    THEN lfGet_Object_ValueData_sh (_tmpItem.MaterialOptionsId) || ' - '
                                                                    ELSE ''
                                                               END
                                                            || CASE WHEN _tmpItem.ObjectId > 0
                                                                    THEN COALESCE (Object_ProdColor.ValueData, lfGet_Object_ValueData_sh (_tmpItem.ObjectId))
                                                                    ELSE _tmpItem.ProdColorName
                                                               END, CHR (13)
                                                              ) AS Key_Id

                                           FROM -- ������� �������������
                                                (SELECT * FROM _tmpItem_Detail AS _tmpItem
                                                 WHERE _tmpItem.ObjectId_parent = (SELECT MAX (_tmpItem.ObjectId_parent) FROM _tmpItem_Child AS _tmpItem WHERE _tmpItem.ObjectId_parent_find = 0)
                                                   AND _tmpItem.ColorPatternId > 0
                                                 ORDER BY _tmpItem.ColorPatternId
                                                        , COALESCE (_tmpItem.ObjectId, -1) DESC
                                                        , _tmpItem.ProdColorName
                                                ) AS _tmpItem
                                                LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                                     ON ObjectLink_Goods_ProdColor.ObjectId = _tmpItem.ObjectId
                                                                    AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                                LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                                                LEFT JOIN _tmpItem_Child ON _tmpItem_Child.ObjectId_parent = _tmpItem.ObjectId_parent

                                           GROUP BY _tmpItem.ColorPatternId
                                                  , _tmpItem_Child.Key_Id
                                          )
                                        , CHR (13)
                                        , (SELECT COUNT(*) FROM _tmpItem_Child WHERE _tmpItem_Child.ObjectId_parent_find = 0);
        END IF;


        -- ������� ��� �������
        PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail(), zc_MI_Reserv())
          AND MovementItem.isErased   = FALSE
        ;

        -- 1. ��������� ������ ��� - ���������� ������ ������
        UPDATE _tmpItem_Child
               SET MovementItemId = lpInsertUpdate_MI_OrderClient_Child (ioId                  := 0
                                                                       , inMovementId          := inMovementId
                                                                       , inObjectId            := _tmpItem.ObjectId_parent_find
                                                                       , inGoodsId_Basis       := _tmpItem.ObjectId_Basis
                                                                       , inReceiptGoodsId      := _tmpItem.ReceiptGoodsId_find
                                                                       , inAmount              := _tmpItem.OperCount
                                                                       , inAmountPartner       := 0 -- !!!��������!!!
                                                                                                  -- CASE WHEN _tmpItem.ObjectId_parent > 0 THEN 0 ELSE _tmpItem.OperCount END
                                                                       , inForCount            := _tmpItem.ForCount
                                                                       , inOperPrice           := _tmpItem.OperPrice
                                                                       , inCountForPrice       := 1
                                                                       , inPartnerId           := _tmpItem.PartnerId
                                                                       , inProdOptionsId       := _tmpItem.ProdOptionsId
                                                                       , inUserId              := inUserId
                                                                        )
        FROM (-- ������� ����
              SELECT _tmpItem.ObjectId_parent_find
                   , _tmpItem.ReceiptGoodsId_find
                     -- ���� ���� ������, ����� ���� ��� � ReceiptProdModel
                   , CASE WHEN _tmpItem.ObjectId_parent_find <> _tmpItem.ObjectId_parent THEN _tmpItem.ObjectId_parent ELSE 0 END AS ObjectId_Basis
                   , _tmpItem.OperCount
                   , _tmpItem.ForCount
                   , CASE WHEN tmpItem_Detail.OperSumm > 0
                               THEN tmpItem_Detail.OperSumm / (CASE WHEN _tmpItem.OperCount > 0 THEN _tmpItem.OperCount ELSE 1 END
                                                             / CASE WHEN _tmpItem.ForCount > 0  THEN _tmpItem.ForCount  ELSE 1 END)
                          ELSE _tmpItem.OperPrice
                     END AS OperPrice
                   , _tmpItem.ProdOptionsId
                   , OL_Goods_Partner.ChildObjectId AS PartnerId
              FROM _tmpItem_Child AS _tmpItem
                   -- ������� ����
                   LEFT JOIN (SELECT _tmpItem_Detail.ObjectId_parent
                                   , SUM (COALESCE (_tmpItem_Detail.OperCount * _tmpItem_Detail.OperPrice
                                                  / CASE WHEN _tmpItem_Detail.ForCount > 0  THEN _tmpItem_Detail.ForCount  ELSE 1 END, 0)) AS OperSumm
                              FROM _tmpItem_Detail
                              GROUP BY _tmpItem_Detail.ObjectId_parent
                             ) AS tmpItem_Detail ON tmpItem_Detail.ObjectId_parent = _tmpItem.ObjectId_parent
                   LEFT JOIN ObjectLink AS OL_Goods_Partner
                                        ON OL_Goods_Partner.ObjectId = _tmpItem.ObjectId_parent
                                       AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()
             ) AS _tmpItem
        WHERE _tmpItem_Child.ObjectId_parent_find = _tmpItem.ObjectId_parent_find
       ;

-- if exists (select 1 from _tmpItem_Detail join Object on  Object.Id = _tmpItem_Detail.GoodsId_child_find and Object.ValueData ilike '%9010%')
-- if exists (select 1 from _tmpItem_Detail join Object on  Object.Id = _tmpItem_Detail.GoodsId_child_find and Object.ValueData ilike '%9010%')
-- then 
--    RAISE EXCEPTION '������.<%>', (select Object.ValueData from _tmpItem_Detail join Object on  Object.Id = _tmpItem_Detail.GoodsId_child and Object.ValueData ilike '%9010%' limit 1);
--end if;

        -- �������� ��� ��������� RAL - ����������
        /*IF EXISTS (SELECT _tmpItem.ObjectId
                   FROM _tmpItem_Detail AS _tmpItem
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpItem.ObjectId
                        LEFT JOIN ObjectString AS ObjectString_Article
                                               ON ObjectString_Article.ObjectId = Object_Goods.Id
                                              AND ObjectString_Article.DescId = zc_ObjectString_Article()
                   WHERE ObjectString_Article.ValueData = Object_Goods.ValueData
                  )
        THEN
            RAISE EXCEPTION '������.��� �������� ������ ��� �������� ������� = <%> ��� = <%> �������� = <%>'
                          , (SELECT Object.ValueData from _tmpItem_Detail join Object on  Object.Id = _tmpItem_Detail.GoodsId_child and Object.ValueData ilike '%9010%' limit 1);
                          , (SELECT ObjectString_Article.ValueData
                             FROM _tmpItem_Detail AS _tmpItem
                                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpItem.ObjectId
                                  LEFT JOIN ObjectString AS ObjectString_Article
                                                         ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                        AND ObjectString_Article.DescId = zc_ObjectString_Article()
                             WHERE ObjectString_Article.ValueData = Object_Goods.ValueData
                             ORDER BY _tmpItem.ObjectId
                             LIMIT 1
                            )
        END IF;*/

        -- 2. ��������� ������ ��� - ���������� ��� ������ ����
        UPDATE _tmpItem_Detail
               SET MovementItemId = lpInsertUpdate_MI_OrderClient_Detail (ioId                  := 0
                                                                        , inMovementId          := inMovementId
                                                                        , inObjectId            := CASE WHEN _tmpItem.ObjectId > 0 THEN _tmpItem.ObjectId ELSE _tmpItem.ProdColorPatternId END
                                                                        , inGoodsId             := _tmpItem.ObjectId_parent_find
                                                                        , inGoodsId_basis       := _tmpItem.GoodsId_child
                                                                        , inAmount              := _tmpItem.OperCount
                                                                        , inAmountPartner       := 0 -- !!!��������!!!
                                                                                                   -- CASE WHEN _tmpItem.ObjectId_parent_find > 0 THEN 0 ELSE _tmpItem.OperCount END
                                                                        , inForCount            := _tmpItem.ForCount
                                                                        , inOperPrice           := _tmpItem.OperPrice
                                                                        , inCountForPrice       := 1
                                                                        , inPartnerId           := _tmpItem.PartnerId
                                                                        , inProdOptionsId       := _tmpItem.ProdOptionsId
                                                                        , inColorPatternId      := _tmpItem.ColorPatternId
                                                                        , inProdColorPatternId  := _tmpItem.ProdColorPatternId
                                                                        , inReceiptLevelId      := _tmpItem.ReceiptLevelId
                                                                        , inUserId              := inUserId
                                                                         )
        FROM (-- ������� ����
              SELECT _tmpItem_Child.ObjectId_parent_find
                   , _tmpItem_Child.MovementItemId
                   , _tmpItem.ObjectId_parent
                   , _tmpItem.ObjectId
                   , _tmpItem.ReceiptLevelId
                   , _tmpItem.OperCount AS OperCount
                   , _tmpItem.ForCount  AS ForCount
                   , _tmpItem.OperPrice
                   , _tmpItem.ColorPatternId
                   , _tmpItem.ProdColorPatternId
                   , _tmpItem.ProdOptionsId
                   , _tmpItem.NPP
                   , OL_Goods_Partner.ChildObjectId AS PartnerId
                   , COALESCE (_tmpReceiptItems_new.GoodsId_child, _tmpItem.GoodsId_child_find, _tmpItem.GoodsId_child) AS GoodsId_child
              FROM _tmpItem_Detail AS _tmpItem
                   -- ����
                   LEFT JOIN (SELECT DISTINCT 
                                     _tmpItem_Child.ObjectId_parent_find
                                  ,  _tmpItem_Child.ObjectId_parent
                                   , _tmpItem_Child.MovementItemId
                              FROM _tmpItem_Child
                             ) AS _tmpItem_Child ON _tmpItem_Child.ObjectId_parent = _tmpItem.ObjectId_parent
                   --
                   LEFT JOIN ObjectLink AS OL_Goods_Partner
                                        ON OL_Goods_Partner.ObjectId = _tmpItem.ObjectId
                                       AND OL_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()
                   -- ��������� ����� GoodsId_child, �� ���� ����
                   LEFT JOIN (SELECT DISTINCT
                                     _tmpReceiptItems_new.ObjectId_parent_old
                                     -- ����� �����
                                   , _tmpReceiptItems_new.GoodsId_child
                              FROM _tmpReceiptItems_new
                              WHERE _tmpReceiptItems_new.GoodsId_child_old > 0
                             ) AS _tmpReceiptItems_new
                               ON _tmpReceiptItems_new.ObjectId_parent_old = _tmpItem.ObjectId_parent
                              AND _tmpItem.GoodsId_child > 0
-- where 1=0

             ) AS _tmpItem
        WHERE _tmpItem_Detail.ObjectId_parent     = _tmpItem.ObjectId_parent
          AND (_tmpItem_Detail.ObjectId           = _tmpItem.ObjectId
           AND _tmpItem_Detail.ProdColorPatternId = _tmpItem.ProdColorPatternId
           AND _tmpItem_Detail.ReceiptLevelId     = _tmpItem.ReceiptLevelId
           AND _tmpItem_Detail.NPP                = _tmpItem.NPP

          --OR (_tmpItem_Detail.ProdColorPatternId = _tmpItem.ProdColorPatternId
          --AND _tmpItem_Detail.ColorPatternId     = _tmpItem.ColorPatternId)
              )
       ;

/*    RAISE EXCEPTION '������. <%>    <%>    <%>  <%> '
-- , (select count(*) from MovementItem join Object on  Object.Id = MovementItem.ObjectId and Object.ValueData ilike '%����� AGL-280-RAL 5004%' where MovementItem.MovementId= inMovementId and MovementItem.DescId = zc_MI_Child() and MovementItem.isErased= false)
    , (select count(*) from MovementItem join Object on  Object.Id = MovementItem.ObjectId and Object.ObjectCode = 197570 where MovementItem.MovementId= inMovementId and MovementItem.DescId = zc_MI_Detail() and MovementItem.isErased= false)
 
    , (select lfGet_Object_ValueData_sh (max (_tmpReceiptItems_new.ObjectId)) from _tmpReceiptItems_new join Object on  Object.Id = _tmpReceiptItems_new.ObjectId  and _tmpReceiptItems_new.ObjectId_parent_old in (252244) and _tmpReceiptItems_new.GoodsId_child <> 0)
    , (select                           (max (_tmpReceiptItems_new.ObjectId)) from _tmpReceiptItems_new join Object on  Object.Id = _tmpReceiptItems_new.ObjectId  and _tmpReceiptItems_new.ObjectId_parent_old not in (252234, 19761, 19749, 6357))
    , (select  count(*) from _tmpReceiptItems_new join Object on  Object.Id = _tmpReceiptItems_new.ObjectId  and _tmpReceiptItems_new.ObjectId  in (6357))
    ;
*/

        -- !!!3.�������� ���������, �� �������!!!
        WITH -- ������ ObjectId
             tmpItem AS   (SELECT MovementItem.Id                        AS MovementItemId
                                , MILinkObject_Partner.ObjectId          AS PartnerId
                                , MovementItem.ObjectId                  AS ObjectId
                                , MovementItem.Amount / CASE WHEN MIFloat_ForCount.ValueData > 0 THEN MIFloat_ForCount.ValueData ELSE 1 END AS Amount
                                , CASE WHEN MIFloat_ForCount.ValueData > 0 THEN MIFloat_ForCount.ValueData ELSE 1 END AS ForCount
                                , MIFloat_OperPrice.ValueData            AS OperPrice
                                , COALESCE (Object_Object.DescId, 0)     AS ObjectDescId

                           FROM MovementItem
                                LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                 ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                                LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                            ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail())
                           --AND MovementItem.DescId     IN (zc_MI_Detail())
                             AND MovementItem.isErased   = FALSE
                             -- !!!��� �����!!!
                             AND Object_Object.DescId    <> zc_Object_ReceiptService()
                          )
                -- ������������ ������� - � ������� ��������
              , tmpOrderClient AS (SELECT MovementItem.PartionId     AS PartionId
                                        , MILinkObject_Unit.ObjectId AS UnitId
                                        , SUM (MovementItem.Amount)  AS Amount
                                   FROM Movement
                                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                               AND MovementItem.DescId     = zc_MI_Reserv()
                                                               AND MovementItem.isErased   = FALSE
                                                               -- ���������� ��������
                                                               AND MovementItem.ObjectId IN (SELECT DISTINCT tmpItem.ObjectId FROM tmpItem)
                                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                        AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                                   WHERE Movement.DescId   = zc_Movement_OrderClient()
                                     -- !!!�����������!!!
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                   GROUP BY MovementItem.PartionId
                                          , MILinkObject_Unit.ObjectId
                                  )
                -- ����������� ��� ������ - ���� ��� ������
              , tmpSend AS (SELECT MovementItem.PartionId     AS PartionId
                                 , MLO_To.ObjectId            AS UnitId
                                 , SUM (MovementItem.Amount)  AS Amount
                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Child()
                                                        AND MovementItem.isErased   = FALSE
                                                        -- ���������� ��������
                                                        AND MovementItem.ObjectId IN (SELECT DISTINCT tmpItem.ObjectId FROM tmpItem)
                                 -- zc_MI_Master �� ������
                                 INNER JOIN MovementItem AS MI_Master
                                                         ON MI_Master.MovementId = Movement.Id
                                                        AND MI_Master.DescId     = zc_MI_Master()
                                                        AND MI_Master.Id         = MovementItem.ParentId
                                                        AND MI_Master.isErased   = FALSE
                                 LEFT JOIN MovementLinkObject AS MLO_To
                                                              ON MLO_To.MovementId = MovementItem.MovementId
                                                             AND MLO_To.DescId     = zc_MovementLinkObject_To()
                            WHERE Movement.DescId   = zc_Movement_Send()
                              -- !!!�����������!!!
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              -- !!!test!!!
                              -- AND 1=0
                            GROUP BY MovementItem.PartionId
                                   , MLO_To.ObjectId
                           )
            -- �� ������� ������ �������
          , tmpContainer_all AS (SELECT Container.Id
                                      , Container.PartionId
                                      , Container.ObjectId
                                      , Container.WhereObjectId
                                        -- !!!���� ����� ������� ������� - ������ � �� ��� ������
                                      , Container.Amount - COALESCE (tmpOrderClient.Amount, 0) + COALESCE (tmpSend.Amount, 0) AS Amount
                                 FROM Container
                                      -- ������� - � ������� ��������
                                      LEFT JOIN tmpOrderClient ON tmpOrderClient.PartionId = Container.PartionId
                                                              AND tmpOrderClient.UnitId    = Container.WhereObjectId
                                      -- ����������� ��� ������ - ������
                                      LEFT JOIN tmpSend ON tmpSend.PartionId = Container.PartionId
                                                       AND tmpSend.UnitId    = Container.WhereObjectId
                                 WHERE Container.DescId = zc_Container_Count()
                                   AND Container.Amount - COALESCE (tmpOrderClient.Amount, 0) - COALESCE (tmpSend.Amount, 0) > 0
                                   -- ���������� ��������
                                   AND Container.ObjectId IN (SELECT tmpItem.ObjectId FROM tmpItem)
                                   -- !!! �������� ��� �������
                                   AND NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())

                                )
                -- ������������� ������ - �������� �� �������
              , tmpContainer AS (SELECT Container.Id             AS ContainerId
                                      , Container.PartionId      AS PartionId
                                      , Container.ObjectId       AS ObjectId
                                      , Container.WhereObjectId  AS WhereObjectId
                                      , Container.Amount         AS ContainerAmount
                                      , tmpItem.Amount           AS OperCount
                                        -- ������������� ���-��
                                      , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId
                                                                     ORDER BY -- ������� ������
                                                                              CASE WHEN Container.WhereObjectId = vbUnitId_To THEN 0 ELSE 1 END
                                                                            , Object_PartionGoods.OperDate ASC
                                                                            , Container.Id ASC
                                                                    ) AS ContainerAmountSUM
                                 FROM tmpContainer_all AS Container
                                      LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = Container.PartionId
                                      LEFT JOIN tmpItem ON tmpItem.ObjectId = Container.ObjectId
                                )
                -- ������� �� �������
              , tmpRes_partion AS
                       (SELECT DD.ContainerId
                             , DD.PartionId
                             , DD.ObjectId
                             , CASE WHEN DD.OperCount - DD.ContainerAmountSUM > 0
                                         THEN DD.ContainerAmount
                                    ELSE DD.OperCount - DD.ContainerAmountSUM + DD.ContainerAmount
                               END AS OperCount
                        FROM (SELECT * FROM tmpContainer) AS DD
                        WHERE DD.OperCount - (DD.ContainerAmountSUM - DD.ContainerAmount) > 0
                       )
         -- ���������
         INSERT INTO _tmpItem_Reserv (MovementItemId, ContainerId_Goods, ObjectId, PartionId, OperCount, OperCountPartner, OperPricePartner, ObjectDescId)
            -- 0.1. �������
            SELECT tmpItem.MovementItemId
                   -- �����!!
                 , tmpRes_partion.ContainerId
                   --
                 , tmpItem.ObjectId
                   -- �����!!
                 , tmpRes_partion.PartionId
                   -- �����!!
                 , COALESCE (tmpRes_partion.OperCount, 0) AS OperCount
                   --
                 , 0 AS OperCountPartner

                   -- �����, ���� ��� ������� - ������������
                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0) AS OperPricePartner

                 , tmpItem.ObjectDescId

            FROM tmpItem
                 INNER JOIN tmpRes_partion ON tmpRes_partion.ObjectId = tmpItem.ObjectId
                 -- ����
                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                       ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                      AND ObjectFloat_EKPrice.ObjectId = tmpItem.ObjectId

           UNION ALL
            -- 0.2. �����
            SELECT tmpItem.MovementItemId
                   --
                 , 0 AS ContainerId_Goods
                   --
                 , tmpItem.ObjectId
                   --
                 , 0 AS PartionId
                   --
                 , 0 AS OperCount

                 , -- ��� ������ �������� ������� �� �������
                   tmpItem.Amount - COALESCE (tmpRes_partion_total.OperCount, 0) AS OperCountPartner

                   -- �����
                 , COALESCE (ObjectFloat_EKPrice.ValueData, 0) AS OperPricePartner

                 , tmpItem.ObjectDescId

            FROM tmpItem
                 -- ����
                 LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                       ON ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                      AND ObjectFloat_EKPrice.ObjectId = tmpItem.ObjectId

                 -- ����� �� �������, � ������� �� ������� - ����� � ����������
                 LEFT JOIN (SELECT tmpRes_partion.ObjectId, SUM (tmpRes_partion.OperCount) AS OperCount FROM tmpRes_partion GROUP BY tmpRes_partion.ObjectId
                           ) AS tmpRes_partion_total ON tmpRes_partion_total.ObjectId = tmpItem.ObjectId
            -- ���� ����� �����
            WHERE tmpItem.Amount - COALESCE (tmpRes_partion_total.OperCount, 0) > 0
            ;

         -- ����� ����������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPricePartner(), _tmpItem_Reserv.MovementItemId, _tmpItem_Reserv.OperPricePartner)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(),    _tmpItem_Reserv.MovementItemId, _tmpItem_Reserv.OperCountPartner)
         FROM _tmpItem_Reserv
         WHERE _tmpItem_Reserv.ContainerId_Goods = 0
           AND _tmpItem_Reserv.OperCountPartner  > 0
           -- !!!�������� ��������
           AND 1=0
        ;


         -- 3. ��������� ������ ��� - ������ �� �������
         PERFORM lpInsertUpdate_MI_OrderClient_Reserv (ioId                  := 0
                                                     , inParentId            := _tmpItem_Reserv.MovementItemId
                                                     , inMovementId          := inMovementId
                                                     , inPartionId           := _tmpItem_Reserv.PartionId
                                                     , inObjectId            := _tmpItem_Reserv.ObjectId
                                                     , inAmount              := _tmpItem_Reserv.OperCount
                                                     , inOperPrice           := _tmpItem_Reserv.OperPricePartner -- ������������
                                                     , inCountForPrice       := 1
                                                     , inUnitId              := CLO_Unit.ObjectId
                                                     , inUserId              := inUserId
                                                      )
         FROM _tmpItem_Reserv
              LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItem_Reserv.ContainerId_Goods AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
         WHERE _tmpItem_Reserv.ContainerId_Goods > 0
           -- !!!�������� ��������
           AND 1=0
        ;



         -- !!! �������� ��� �������
         IF NOT EXISTS (SELECT 1 FROM MovementString AS MS WHERE MS.ValueData = '1' AND MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment())
         -- !!!�������� ��������
        AND 1=0
         THEN
             -- ������� ������ � Engine Nr
             SELECT MIN (_tmpItem_Reserv.PartionId), MAX (_tmpItem_Reserv.PartionId)
                    INTO vbPartionId_1, vbPartionId_2
             FROM _tmpItem_Reserv
                  INNER JOIN ObjectLink AS ObjectLink_Goods_Engine
                                        ON ObjectLink_Goods_Engine.ObjectId = _tmpItem_Reserv.ObjectId
                                       AND ObjectLink_Goods_Engine.DescId   = zc_ObjectLink_Goods_Engine()
                                       -- !!! ����������� ��� ��-��
                                       AND ObjectLink_Goods_Engine.ChildObjectId > 0
                  INNER JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = _tmpItem_Reserv.PartionId
                                               AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                                               AND MIString_PartNumber.ValueData      <> ''
                                              ;

             -- ��������
             IF COALESCE (vbPartionId_1, 0) <> COALESCE (vbPartionId_2, 0)
             THEN
                 RAISE EXCEPTION '������.������� ������ ������ Engine Nr. <%> + <%>.'
                               , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                               , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_2 AND MIS.DescId = zc_MIString_PartNumber())
                             ;
             END IF;
             -- ��������
             IF COALESCE (vbPartionId_1, 0) = 0
                AND NOT EXISTS (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
             THEN
                 RAISE EXCEPTION '������.�� ������� ������ � Engine Nr';
             END IF;
             -- ��������
             IF COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
                        , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber()))
                <> (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                AND vbPartionId_1 > 0
                AND 1=0
             THEN
                 RAISE EXCEPTION '������.� ����� ��� ���������� Engine Nr = <%>. ������ ���������� ����� Engine Nr = <%>'
                               , (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> '')
                               , (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                                ;
             END IF;

             -- ��������� � ����� ������ � Engine Nr
             IF COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbProductId AND OS.DescId = zc_ObjectString_Product_EngineNum() AND OS.ValueData <> ''), '')
                <> (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber())
                AND vbPartionId_1 > 0
             THEN
                 -- ���������
                 PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), vbProductId, (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = vbPartionId_1 AND MIS.DescId = zc_MIString_PartNumber()));

                 -- ��������� ��������
                 PERFORM lpInsert_ObjectProtocol (vbProductId, inUserId);
             END IF;

         END IF;

     END IF; -- !!!������ ���� ����� ��������!!!


    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_OrderClient()
                               , inUserId     := inUserId
                                );

    -- RAISE EXCEPTION '������. ok ';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_OrderClient (inMovementId:= 662, inStatusCode:= 2, inIsChild_Recalc:= 'True', inSession:= '5');
-- select * from gpUpdate_Status_OrderClient(inMovementId := 703 , inStatusCode := 2 , inIsChild_Recalc := 'False' ,  inSession := '5');

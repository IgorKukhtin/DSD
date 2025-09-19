-- Function: gpSelect_Object_Product_StructureGoodsPrint ()

DROP FUNCTION IF EXISTS gpSelect_Object_Product_StructureGoodsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product_StructureGoodsPrint(
    IN inMovementId_OrderClient       Integer   ,   --
    IN inSession                      TVarChar      -- ������ ������������
)
RETURNS TABLE (GroupId Integer, GroupName TVarChar
             , ObjectId Integer, ObjectCode Integer, Article_Object TVarChar, ObjectName TVarChar, DescName TVarChar, ProdColorName TVarChar
             , ObjectId_dt Integer, ObjectCode_dt Integer, Article_Object_dt TVarChar, ObjectName_dt TVarChar, DescName_dt TVarChar, ProdColorName_dt TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , PartnerId_dt Integer, PartnerName_dt TVarChar
             , Amount_ch TFloat, Amount_unit_ch TFloat, Value_service_ch TFloat, Amount_partner_ch TFloat
             , Amount_dt NUMERIC(16, 8), Amount_unit_dt TFloat, Value_service_dt TFloat, Amount_partner_dt TFloat
             , GoodsGroupId Integer, GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , GoodsGroupId_dt Integer, GoodsGroupNameFull_dt TVarChar, GoodsGroupName_dt TVarChar
             , ReceiptLevelName TVarChar, ReceiptLevelName_dt TVarChar
             , isProdOptions_level Boolean
             , NPP_1 Integer, NPP_2 Integer
             , NPP_pcp Integer,ProdColorPatternId Integer, ProdColorPatternCode Integer, ProdColorPatternName TVarChar
             , mi_child_count Integer
             , Color_Value Integer
              )
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbProductId          Integer;
    DECLARE vbReceiptProdModelId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� �����
     SELECT MovementLinkObject_Product.ObjectId               AS ProductId
          , ObjectLink_Product_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
            INTO vbProductId
               , vbReceiptProdModelId
     FROM Movement AS Movement_OrderClient
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                       ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                      AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
          LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                               ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                              AND ObjectLink_Product_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()
     WHERE Movement_OrderClient.Id     = inMovementId_OrderClient
       AND Movement_OrderClient.DescId = zc_Movement_OrderClient();

     -- ProdColorItems
     CREATE TEMP TABLE tmpProdColorItems ON COMMIT DROP
        AS (SELECT gpSelect.Npp
                   -- Boat Structure
                 , gpSelect.ProdColorPatternId, gpSelect.ProdColorPatternName_sh AS ProdColorPatternName
                 , gpSelect.ProdColorGroupId, gpSelect.ProdColorGroupName
                   -- ��������� �����
                 , gpSelect.MaterialOptionsId, gpSelect.MaterialOptionsName
                   --
                 , gpSelect.GoodsId
                   --
                 , gpSelect.ProdColorName, gpSelect.Color_Value
            FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS gpSelect
            WHERE gpSelect.ProductId              = vbProductId
              AND gpSelect.MovementId_OrderClient = inMovementId_OrderClient
           );
     -- ProdOptItems
     CREATE TEMP TABLE tmpProdOptItems ON COMMIT DROP
        AS (SELECT gpSelect.Npp
                 , gpSelect.ProdOptionsId, gpSelect.ProdOptionsName
                 , gpSelect.ProdOptPatternId, gpSelect.ProdOptPatternName
                 , gpSelect.MaterialOptionsId, gpSelect.MaterialOptionsName
                 , gpSelect.GoodsId, gpSelect.GoodsCode, gpSelect.GoodsName
                 , gpSelect.ProdColorName
                 , gpSelect.ProdColorPatternId
            FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= FALSE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS gpSelect
            WHERE gpSelect.ProductId              = vbProductId
              AND gpSelect.MovementId_OrderClient = inMovementId_OrderClient
           );


     -- ���������
     RETURN QUERY
      WITH -- �������� - ������ ������ ������
           tmpItem_�hild AS (SELECT MovementItem.Id                           AS MovementItemId
                                  , MILinkObject_Partner.ObjectId             AS PartnerId
                                    --
                                  , MILinkObject_Goods_basis.ObjectId         AS ObjectId_basis
                                    --
                                  , COALESCE (MILinkObject_ProdOptions.ObjectId, 0) AS ProdOptionsId
                                    -- ���� / ������������� / ������/������
                                  , MovementItem.ObjectId                     AS ObjectId
                                    -- ���������� ������ ������
                                  , zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData) AS Amount
                                    -- ���������� ����� ����������
                                  , MIFloat_AmountPartner.ValueData           AS AmountPartner

                             FROM MovementItem
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                   ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                                   ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                                   ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()

                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                  LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                              ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                             WHERE MovementItem.MovementId = inMovementId_OrderClient
                               AND MovementItem.DescId     = zc_MI_Child()
                               AND MovementItem.isErased   = FALSE
                            )
  -- �������� - ������������� ������ ����
, tmpItem_Detail_mi AS (SELECT MovementItem.Id                           AS MovementItemId
                               -- ���������
                             , MILinkObject_Partner.ObjectId             AS PartnerId

                               -- ����� ���� ���������� = zc_MI_Child.ObjectId, ������ ��������
                             , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                             , COALESCE (MILinkObject_Goods_basis.ObjectId, 0) AS GoodsId_basis
                               -- ������������� / ������/������
                             , MovementItem.ObjectId                     AS ObjectId
                               --  �����
                             , MILinkObject_ProdOptions.ObjectId         AS ProdOptionsId
                               -- ������ Boat Structure
                             , MILinkObject_ColorPattern.ObjectId        AS ColorPatternId
                               --  Boat Structure
                             , MILinkObject_ProdColorPattern.ObjectId    AS ProdColorPatternId
                               --
                             , MILinkObject_ReceiptLevel.ObjectId        AS ReceiptLevelId
                               -- ���������� ��� ������ ����
                             , zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData) AS Amount
                               -- ���������� ����� ����������
                             , MIFloat_AmountPartner.ValueData           AS AmountPartner

                        FROM MovementItem
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                              ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                              ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                              ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                              ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                              ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                              ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                              ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                             LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                         ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                        AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                        WHERE MovementItem.MovementId = inMovementId_OrderClient
                          AND MovementItem.DescId     = zc_MI_Detail()
                          AND MovementItem.isErased   = FALSE
                       )

    , tmpReceiptLevel AS (-- ������� ReceiptProdModel
                          SELECT DISTINCT
                                 -- �����
                                 0                             AS GoodsId_parent
                                 -- �������������/����
                               , tmpItem_�hild.ObjectId        AS GoodsId
                                 -- LevelName
                               , Object_ReceiptLevel.ValueData AS ReceiptLevelName
                                 --
                               , 0                             AS Value
                                 -- "�����������" ����
                               , 0                             AS GoodsId_child
                               , ROW_NUMBER() OVER (ORDER BY Object_ReceiptLevel.ValueData) :: Integer AS NPP_1
                          FROM tmpItem_�hild
                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                    ON ObjectLink_ReceiptProdModelChild_Object.ChildObjectId = CASE WHEN tmpItem_�hild.ObjectId_basis > 0 THEN tmpItem_�hild.ObjectId_basis ELSE tmpItem_�hild.ObjectId END
                                                   AND ObjectLink_ReceiptProdModelChild_Object.DescId        = zc_ObjectLink_ReceiptProdModelChild_Object()
                               --- ����� �� ���������
                               INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                                                AND Object_ReceiptProdModelChild.IsErased = FALSE
                               -- ReceiptProdModel �� �����
                               INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                     ON ObjectLink_ReceiptProdModel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                    AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                                    AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId

                               LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptLevel
                                                    ON ObjectLink_ReceiptProdModelChild_ReceiptLevel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                   AND ObjectLink_ReceiptProdModelChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                               LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptProdModelChild_ReceiptLevel.ChildObjectId
                         )
     -- ������������� ������ ����
   , tmpItem_Detail AS (-- ������� 3 - �������� �����
                        SELECT
                               -1 AS GoodsId
                             , tmpItem_�hild.ObjectId
                             , tmpItem_�hild.PartnerId
                             , tmpItem_�hild.Amount
                             , tmpItem_�hild.AmountPartner
                             , 0 AS GoodsId_basis
                             , 0 AS ReceiptLevelId
                             , 0 AS ProdColorPatternId
                             , tmpItem_�hild.ProdOptionsId
                        FROM tmpItem_�hild
                      --WHERE tmpItem_�hild.ProdOptionsId = 0

                       UNION ALL
                        -- ������� 1 - �������� ������ "�����������" ����
                        SELECT
                               tmpItem_Detail.GoodsId_basis AS GoodsId
                             , tmpItem_Detail.ObjectId
                             , tmpItem_Detail.PartnerId
                             , tmpItem_Detail.Amount
                             , tmpItem_Detail.AmountPartner
                             , tmpItem_Detail.GoodsId_basis
                             , tmpItem_Detail.ReceiptLevelId
                             , tmpItem_Detail.ProdColorPatternId
                             , 0 AS ProdOptionsId
                        FROM tmpItem_Detail_mi AS tmpItem_Detail
                        WHERE tmpItem_Detail.GoodsId_basis > 0

                       UNION ALL
                        -- ������� 2 - �������� ���� � ����������� "�����������" ����
                        SELECT DISTINCT
                               tmpItem_Detail.GoodsId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN tmpItem_Detail.GoodsId_basis ELSE tmpItem_Detail.ObjectId END AS ObjectId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.PartnerId     END AS PartnerId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 1 ELSE tmpItem_Detail.Amount        END AS Amount
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.AmountPartner END AS AmountPartner
                             , 0 AS GoodsId_basis
                             , 0 AS ReceiptLevelId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.ProdColorPatternId END AS ProdColorPatternId
                             , 0 AS ProdOptionsId
                        FROM tmpItem_Detail_mi AS tmpItem_Detail

                       )
      -- ���������
      -- 1. ProdColorItems
      SELECT
             CASE WHEN tmpReceiptLevel.NPP_1 = 1  THEN 22
                  WHEN tmpReceiptLevel.NPP_1 = 2  THEN 24
                  WHEN tmpItem_�hild.GroupId = 22 THEN 23
                  ELSE tmpItem_�hild.GroupId
             END :: Integer AS GroupId
           , CASE WHEN tmpItem_�hild.GroupId = 1
                      THEN '������������'

                  WHEN tmpItem_�hild.GroupId = 2
                      THEN '�����'

                  WHEN tmpItem_�hild.GroupId = 3
                      THEN '������ �����'

                  WHEN tmpItem_�hild.GroupId = 11
                      THEN '������ ����� Level 1'

                  WHEN tmpItem_�hild.GroupId = 22
                      THEN '������ ����� Level 2'
             END                              :: TVarChar AS GroupName
           , Object_ch.Id                                 AS ObjectId
           , Object_ch.ObjectCode                         AS ObjectCode
           , ObjectString_Article_ch.ValueData            AS Article_Object
           , Object_ch.ValueData                          AS ObjectName
           , ObjectDesc_ch.ItemName                       AS DescName
           , Object_ProdColor_ch.ValueData                AS ProdColorName

           , Object_dt.Id                                 AS ObjectId_dt
           , Object_dt.ObjectCode                         AS ObjectCode_dt
           , ObjectString_Article_dt.ValueData            AS Article_Object_dt

           , CASE WHEN 1=1 AND vbUserId = 5 AND LENGTH (Object_dt.ValueData) > 121
                       THEN '*error*' || LENGTH (Object_dt.ValueData) :: TVarChar || '* ' || LEFT (Object_dt.ValueData, 100)
                  ELSE LEFT (Object_dt.ValueData, 121)
             END :: TVarChar  AS ObjectName_dt

         --, (Object_dt.ValueData || ' '  || tmpItem_Detail.GoodsId_basis :: TVarChar) :: TVarChar AS ObjectName_dt

           , ObjectDesc_dt.ItemName                       AS DescName_dt
           , Object_ProdColor_dt.ValueData                AS ProdColorName_dt

           , Object_Partner_ch.Id                         AS PartnerId
           , Object_Partner_ch.ValueData                  AS PartnerName

           , Object_Partner_dt.Id                         AS PartnerId_dt
           , Object_Partner_dt.ValueData                  AS PartnerName_dt

             -- ���������� ������ ������
           , tmpItem_�hild.Amount               :: TFloat AS Amount_ch
             -- ����������
           , CASE WHEN ObjectDesc_ch.Id = zc_Object_Goods()          THEN tmpItem_�hild.Amount ELSE 0 END :: TFloat AS Amount_unit_ch
             -- ������/������
           , CASE WHEN ObjectDesc_ch.Id = zc_Object_ReceiptService() THEN tmpItem_�hild.Amount ELSE 0 END :: TFloat AS Value_service_ch
             -- ���������� ����� ����������
           , tmpItem_�hild.AmountPartner        :: TFloat AS Amount_partner_ch

             -- ���������� ������ ����
           , CAST (tmpItem_Detail.Amount AS NUMERIC(16, 8))  AS Amount_dt
             -- ����������
           , CASE WHEN ObjectDesc_dt.Id = zc_Object_Goods()          THEN tmpItem_Detail.Amount ELSE 0 END :: TFloat AS Amount_unit_dt
             -- ������/������
           , CASE WHEN ObjectDesc_dt.Id = zc_Object_ReceiptService() THEN tmpItem_Detail.Amount ELSE 0 END :: TFloat AS Value_service_dt
             -- ���������� ����� ����������
           , tmpItem_Detail.AmountPartner       :: TFloat AS Amount_partner_dt

           , ObjectLink_GoodsGroup_ch.ChildObjectId   AS GoodsGroupId
           , ObjectString_GoodsGroupFull_ch.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup_ch.ValueData           AS GoodsGroupName
           , ObjectLink_GoodsGroup_dt.ChildObjectId   AS GoodsGroupId_dt
           , ObjectString_GoodsGroupFull_dt.ValueData AS GoodsGroupNameFull_dt
           , Object_GoodsGroup_dt.ValueData           AS GoodsGroupName_dt

           , tmpReceiptLevel.ReceiptLevelName    :: TVarChar AS ReceiptLevelName
           , CASE WHEN tmpItem_Detail.ProdOptionsId > 0 AND tmpItem_�hild.GroupId = 3
                       THEN '�����'
                  ELSE COALESCE (Object_ReceiptLevel_dt.ValueData, tmpReceiptLevel_dt.ReceiptLevelName)
             END :: TVarChar AS ReceiptLevelName_dt

             -- ��� ����� � ������ �����
           , CASE WHEN tmpItem_Detail.ProdOptionsId > 0 AND tmpItem_�hild.GroupId = 3
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isProdOptions_level

           , COALESCE (tmpReceiptLevel.NPP_1, Object_ch.Id) :: Integer AS NPP_1
           , ROW_NUMBER() OVER (PARTITION BY tmpItem_�hild.GroupId, tmpItem_�hild.ObjectId
                                ORDER BY -- ��� ������ Hypalon
                                         CASE WHEN tmpItem_Detail.ProdColorPatternId > 0 AND tmpItem_�hild.GroupId <> 11
                                              THEN 0
                                              ELSE 1
                                         END
                                         -- � �/� ��� ������ Hypalon
                                       , CASE WHEN tmpItem_�hild.GroupId <> 11
                                              THEN COALESCE (tmpProdColorItems.Npp, 0)
                                              ELSE 1000
                                         END

                                         -- ��� ��������� �� - � ������
                                       , CASE WHEN ObjectString_Article_dt.ValueData ILIKE '%��' THEN 0 ELSE 1 END
                                         -- ��� ������� �� - � ������
                                       , CASE WHEN Object_dt.ValueData ILIKE '��%' THEN 0 ELSE 1 END
                                         -- ��� ������ ������ 01+02+03 � ��� ������ ����� 1+2+3
                                       , COALESCE (Object_ReceiptLevel_dt.ValueData, tmpReceiptLevel_dt.ReceiptLevelName)

                                         -- ��� ������ Hypalon
                                       , CASE WHEN tmpItem_Detail.ProdColorPatternId > 0 AND tmpItem_�hild.GroupId = 11
                                              THEN 0
                                              ELSE 1
                                         END
                                         -- � �/� ��� ������ Hypalon
                                       , COALESCE (tmpProdColorItems.Npp, 0)

                                         -- ��� ������ ������ - ������� ����
                                       , CASE WHEN EXISTS (SELECT 1 FROM tmpItem_Detail AS tmp WHERE tmp.GoodsId = tmpItem_Detail.ObjectId)
                                                   THEN 0
                                              ELSE 1
                                         END
                                         -- ��� ������ ������ - ����� � �����
                                       , CASE WHEN tmpItem_Detail.ProdOptionsId > 0 AND tmpItem_�hild.GroupId = 3
                                                   THEN 1
                                              ELSE 0
                                         END
                                       , Object_dt.ValueData
                               ) :: Integer AS NPP_2

           , tmpProdColorItems.Npp   :: Integer AS NPP_pcp
           , Object_ProdColorPattern.Id         AS ProdColorPatternId
           , Object_ProdColorPattern.ObjectCode AS ProdColorPatternCode
           , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName

           , (SELECT COUNT(*) FROM tmpItem_Detail WHERE tmpItem_Detail.GoodsId = tmpItem_�hild.ObjectId) :: Integer AS mi_child_count
           , zc_Color_White() :: Integer AS Color_Value

       FROM (-- ������� 3 - �������� �����
             SELECT DISTINCT
                    3 AS GroupId
                  , -1 AS ObjectId
                  , 0 AS PartnerId
                  , 0 AS Amount
                  , 0 AS AmountPartner

            UNION ALL
             -- ������� 1 - �������� ������ "�����������" ����
             SELECT DISTINCT
                    11 AS GroupId
                  , tmpItem_Detail.GoodsId_basis AS ObjectId
                  , 0 AS PartnerId
                  , 1 AS Amount
                  , 0 AS AmountPartner
             FROM tmpItem_Detail
             WHERE tmpItem_Detail.GoodsId_basis > 0

            UNION ALL
             -- ������� 2 - �������� ���� � ����������� "�����������" ����
             SELECT 22 AS GroupId
                  , tmpItem_�hild.ObjectId
                  , tmpItem_�hild.PartnerId
                  , tmpItem_�hild.Amount
                  , tmpItem_�hild.AmountPartner
             FROM tmpItem_�hild

            ) AS tmpItem_�hild
            -- �������� - ������ ������
            LEFT JOIN Object AS Object_ch ON Object_ch.Id = tmpItem_�hild.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_ch
                                   ON ObjectString_Article_ch.ObjectId = tmpItem_�hild.ObjectId
                                  AND ObjectString_Article_ch.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_ch ON ObjectDesc_ch.Id = Object_ch.DescId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull_ch
                                   ON ObjectString_GoodsGroupFull_ch.ObjectId = tmpItem_�hild.ObjectId
                                  AND ObjectString_GoodsGroupFull_ch.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor_ch
                                 ON ObjectLink_ProdColor_ch.ObjectId = tmpItem_�hild.ObjectId
                                AND ObjectLink_ProdColor_ch.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_ch
                                 ON ObjectLink_GoodsGroup_ch.ObjectId = tmpItem_�hild.ObjectId
                                AND ObjectLink_GoodsGroup_ch.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_Partner_ch    ON Object_Partner_ch.Id    = tmpItem_�hild.PartnerId
            LEFT JOIN Object AS Object_GoodsGroup_ch ON Object_GoodsGroup_ch.Id = ObjectLink_GoodsGroup_ch.ChildObjectId
            LEFT JOIN Object AS Object_ProdColor_ch  ON Object_ProdColor_ch.Id  = ObjectLink_ProdColor_ch.ChildObjectId

            -- ������ ��� ReceiptProdModel
            LEFT JOIN tmpReceiptLevel ON tmpReceiptLevel.GoodsId = tmpItem_�hild.ObjectId
                                     AND tmpItem_�hild.GroupId   = 22

            -- ������������� ������ ����
            INNER JOIN tmpItem_Detail ON tmpItem_Detail.GoodsId = tmpItem_�hild.ObjectId


            LEFT JOIN tmpProdColorItems ON tmpProdColorItems.ProdColorPatternId = tmpItem_Detail.ProdColorPatternId
                                       AND tmpProdColorItems.GoodsId            = tmpItem_Detail.ObjectId
                    --AND 1=0

            -- Boat Structure
            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpItem_Detail.ProdColorPatternId
            -- ������ Boat Structure
            LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                 ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
            LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Model
                                 ON ObjectLink_Model.ObjectId = Object_ColorPattern.Id
                                AND ObjectLink_Model.DescId = zc_ObjectLink_ColorPattern_Model()
            LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
            -- ���������/������ Boat Structure
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                 ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId


            LEFT JOIN Object AS Object_dt ON Object_dt.Id = tmpItem_Detail.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_dt
                                   ON ObjectString_Article_dt.ObjectId = Object_dt.Id
                                  AND ObjectString_Article_dt.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_dt ON ObjectDesc_dt.Id = Object_dt.DescId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull_dt
                                   ON ObjectString_GoodsGroupFull_dt.ObjectId = Object_dt.Id
                                  AND ObjectString_GoodsGroupFull_dt.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor_dt
                                 ON ObjectLink_ProdColor_dt.ObjectId = Object_dt.Id
                                AND ObjectLink_ProdColor_dt.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_dt
                                 ON ObjectLink_GoodsGroup_dt.ObjectId = Object_dt.Id
                                AND ObjectLink_GoodsGroup_dt.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_Partner_dt    ON Object_Partner_dt.Id    = tmpItem_Detail.PartnerId
            LEFT JOIN Object AS Object_GoodsGroup_dt ON Object_GoodsGroup_dt.Id = ObjectLink_GoodsGroup_dt.ChildObjectId
            LEFT JOIN Object AS Object_ProdColor_dt  ON Object_ProdColor_dt.Id  = ObjectLink_ProdColor_dt.ChildObjectId

            LEFT JOIN Object AS Object_ReceiptLevel_dt ON Object_ReceiptLevel_dt.Id = tmpItem_Detail.ReceiptLevelId
            LEFT JOIN tmpReceiptLevel AS tmpReceiptLevel_dt ON tmpReceiptLevel_dt.GoodsId = Object_dt.Id
            /*LEFT JOIN tmpReceiptLevel AS tmpReceiptLevel_dt ON tmpReceiptLevel_dt.GoodsId = Object_dt.Id
                                                           AND (tmpReceiptLevel_dt.Value = tmpItem_Detail.Amount
                                                             OR tmpItem_Detail.GoodsId   = -1
                                                               )*/

       WHERE ObjectDesc_dt.Id = zc_Object_Goods()

      UNION ALL
       SELECT
             1  :: Integer AS GroupId
           , '������������' :: TVarChar AS GroupName
           , -2  :: Integer  AS ObjectId
           , 0  :: Integer  AS ObjectCode
           , '' :: TVarChar AS Article_Object
           , '������������' :: TVarChar AS ObjectName
           , '' :: TVarChar AS DescName
           , '' :: TVarChar AS ProdColorName

           , tmpProdColorItems.ProdColorPatternId        AS ObjectId_dt
           , 0  :: Integer  AS ObjectCode_dt
           , '' :: TVarChar AS Article_Object_dt
           , ('' || ''  || '') :: TVarChar AS ObjectName_dt

           , '' :: TVarChar AS DescName_dt
           , tmpProdColorItems.ProdColorName AS ProdColorName_dt

           , 0  :: Integer  AS PartnerId
           , '' :: TVarChar AS PartnerName

           , 0  :: Integer  AS PartnerId_dt
           , '' :: TVarChar AS PartnerName_dt

             -- ���������� ������ ������
           , 0  :: TFloat   AS Amount_ch
             -- ����������
           , 0  :: TFloat   AS Amount_unit_ch
             -- ������/������
           , 0  :: TFloat   AS Value_service_ch
             -- ���������� ����� ����������
           , 0  :: TFloat   AS Amount_partner_ch

             -- ���������� ������ ����
           , CAST (0  AS NUMERIC(16, 8)) AS Amount_dt
             -- ����������
           , 0  :: TFloat   AS Amount_unit_dt
             -- ������/������
           , 0  :: TFloat   AS Value_service_dt
             -- ���������� ����� ����������
           , 0  :: TFloat   AS Amount_partner_dt

           , 0  :: Integer  AS GoodsGroupId
           , '' :: TVarChar AS GoodsGroupNameFull
           , '' :: TVarChar AS GoodsGroupName
           , 0  :: Integer  AS GoodsGroupId_dt
           , '' :: TVarChar AS GoodsGroupNameFull_dt
           , '' :: TVarChar AS GoodsGroupName_dt

           , ''    :: TVarChar AS ReceiptLevelName
           , tmpProdColorItems.ProdColorPatternName :: TVarChar AS ReceiptLevelName_dt
           , FALSE :: Boolean  AS isProdOptions_level

           , -2                    :: Integer AS NPP_1
           , tmpProdColorItems.Npp :: Integer AS NPP_2

           , tmpProdColorItems.Npp :: Integer AS NPP_pcp
           , 0  :: Integer  AS ProdColorPatternId
           , 0  :: Integer  AS ProdColorPatternCode
           , '' :: TVarChar AS ProdColorPatternName
           , 0  :: Integer  AS mi_child_count

           , tmpProdColorItems.Color_Value

       FROM tmpProdColorItems

      UNION ALL
       SELECT
             1  :: Integer AS GroupId
           , '�����' :: TVarChar AS GroupName
           , -1 :: Integer  AS ObjectId
           , 0  :: Integer  AS ObjectCode
           , '' :: TVarChar AS Article_Object
           , '�����' :: TVarChar AS ObjectName
           , '' :: TVarChar AS DescName
           , '' :: TVarChar AS ProdColorName

           , tmpProdOptItems.ProdOptPatternId AS ObjectId_dt
           , 0  :: Integer  AS ObjectCode_dt
           , '' :: TVarChar AS Article_Object_dt
           , (tmpProdOptItems.ProdOptionsName || ''  || '') :: TVarChar AS ObjectName_dt

           , '' :: TVarChar AS DescName_dt
           , tmpProdOptItems.ProdColorName AS ProdColorName_dt

           , 0  :: Integer  AS PartnerId
           , '' :: TVarChar AS PartnerName

           , 0  :: Integer  AS PartnerId_dt
           , '' :: TVarChar AS PartnerName_dt

             -- ���������� ������ ������
           , 0  :: TFloat   AS Amount_ch
             -- ����������
           , 0  :: TFloat   AS Amount_unit_ch
             -- ������/������
           , 0  :: TFloat   AS Value_service_ch
             -- ���������� ����� ����������
           , 0  :: TFloat   AS Amount_partner_ch

             -- ���������� ������ ����
           , CAST (1  AS NUMERIC(16, 8)) AS Amount_dt
             -- ����������
           , 0  :: TFloat   AS Amount_unit_dt
             -- ������/������
           , 0  :: TFloat   AS Value_service_dt
             -- ���������� ����� ����������
           , 0  :: TFloat   AS Amount_partner_dt

           , 0  :: Integer  AS GoodsGroupId
           , '' :: TVarChar AS GoodsGroupNameFull
           , '' :: TVarChar AS GoodsGroupName
           , 0  :: Integer  AS GoodsGroupId_dt
           , '' :: TVarChar AS GoodsGroupNameFull_dt
           , '' :: TVarChar AS GoodsGroupName_dt

           , ''    :: TVarChar AS ReceiptLevelName
           , ''    :: TVarChar AS ReceiptLevelName_dt
           , FALSE :: Boolean  AS isProdOptions_level

           , -1                  :: Integer AS NPP_1
           , tmpProdOptItems.Npp :: Integer AS NPP_2

           , 0  :: Integer  AS NPP_pcp
           , 0  :: Integer  AS ProdColorPatternId
           , 0  :: Integer  AS ProdColorPatternCode
           , '' :: TVarChar AS ProdColorPatternName
           , 0  :: Integer  AS mi_child_count

           , zc_Color_White()    :: Integer AS Color_Value

       FROM tmpProdOptItems
       WHERE COALESCE (tmpProdOptItems.ProdColorPatternId, 0) = 0

       ORDER BY 1
              , 35
              , 36
            --, tmpItem_Detail.Amount
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.22          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Product_StructureGoodsPrint (inMovementId_OrderClient:= 662, inSession:= zfCalc_UserAdmin())

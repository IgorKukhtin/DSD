 -- Function: gpSelect_MI_Invoice_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderClient_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderClient_Child(
    IN inMovementId       Integer      , -- ���� ���������
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReceiptProdModelId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������

     vbUserId:= lpGetUserBySession (inSession);

     --�� ����� ����� �� ��� ������� ������
     vbReceiptProdModelId := (SELECT ObjectLink_Product_ReceiptProdModel.ChildObjectId
                              FROM MovementLinkObject AS MovementLinkObject_Product
                                   LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                                                        ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                                                       AND ObjectLink_Product_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                              WHERE MovementLinkObject_Product.MovementId = inMovementId
                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                              );

     -- ������� - �������� ���������, �� ����� ����������
     CREATE TEMP TABLE _tmpItem (DescId_mi Integer
                               , MovementItemId Integer, ParentId Integer, PartionId Integer
                               , UnitId Integer, PartnerId Integer
                               , GoodsId Integer, ObjectId Integer, ObjectId_basis Integer, ReceiptGoodsId Integer, ReceiptLevelId Integer
                               , ProdOptionsId Integer
                               , ColorPatternId Integer
                               , ProdColorPatternId  Integer
                               , Amount TFloat
                               , AmountPartner TFloat
                               , ForCount TFloat
                               , OperPrice TFloat
                               , OperPricePartner TFloat
                               , isErased Boolean
                                ) ON COMMIT DROP;
     -- �������� ���������
     INSERT INTO _tmpItem (DescId_mi, MovementItemId, ParentId, PartionId, UnitId, PartnerId
                         , GoodsId, ObjectId, ObjectId_basis, ReceiptGoodsId, ReceiptLevelId, ProdOptionsId, ColorPatternId, ProdColorPatternId
                         , Amount, AmountPartner, ForCount, OperPrice, OperPricePartner, isErased)
        SELECT MovementItem.DescId                                                 AS DescId_mi
             , MovementItem.Id                                                     AS MovementItemId
             , COALESCE (MovementItem.ParentId, 0)                                 AS ParentId
             , MovementItem.PartionId                                              AS PartionId
             , MILinkObject_Unit.ObjectId                                          AS UnitId
             , MILinkObject_Partner.ObjectId                                       AS PartnerId
                                                                                   
               -- ����� ���� ����������
             , COALESCE (MILinkObject_Goods.ObjectId, 0)                           AS GoodsId
               -- �������������
             , MovementItem.ObjectId                                               AS ObjectId

               -- ����� ���� ��� � ReceiptProdModel - ��� zc_MI_Child ��� ����� "��" ���� ���������� - ��� zc_MI_Detail
             , CASE WHEN MovementItem.DescId = zc_MI_Child()
                        -- ����� ���� ��� � ReceiptProdModel
                         THEN COALESCE (MILinkObject_Goods_basis.ObjectId, 0)
                    WHEN MovementItem.DescId = zc_MI_Detail()
                         -- ����� "��" ���� ����������
                         THEN COALESCE (MILinkObject_Goods_basis.ObjectId, 0)
               END AS ObjectId_basis
           --, COALESCE (MILinkObject_Goods_basis.ObjectId, MovementItem.ObjectId) AS ObjectId_basis

               -- ������ ��� zc_MI_Child
             , CASE WHEN MovementItem.DescId = zc_MI_Child()
                         THEN COALESCE (MILinkObject_ReceiptGoods.ObjectId, 0)
               END AS ReceiptGoodsId
               -- ������ ��� zc_MI_Detail
             , CASE WHEN MovementItem.DescId = zc_MI_Detail()
                         THEN COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0)
               END AS ReceiptLevelId

               --
             , MILinkObject_ProdOptions.ObjectId                                   AS ProdOptionsId
             , MILinkObject_ColorPattern.ObjectId                                  AS ColorPatternId
             , MILinkObject_ProdColorPattern.ObjectId                              AS ProdColorPatternId
                                                                                   
             , MovementItem.Amount                                                 AS Amount
             , 0                                                                   AS AmountPartner
           --, MIFloat_AmountPartner.ValueData                                     AS AmountPartner
             , MIFloat_ForCount.ValueData                                          AS ForCount
             , MIFloat_OperPrice.ValueData                                         AS OperPrice
             , MIFloat_OperPricePartner.ValueData                                  AS OperPricePartner
               -- !!! �������� ��� �������
           --,  CASE WHEN MS.ValueData = '1' THEN MIFloat_OperPrice.ValueData

             , MovementItem.isErased

        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail(), zc_MI_Reserv())
                                    AND MovementItem.isErased   = tmpIsErased.isErased
               -- !!! �������� ��� �������
             LEFT JOIN MovementString AS MS ON MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                              ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
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

             LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptGoods
                                              ON MILinkObject_ReceiptGoods.MovementItemId = MovementItem.Id
                                             AND MILinkObject_ReceiptGoods.DescId         = zc_MILinkObject_ReceiptGoods()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                              ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                             AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                         ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                        AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
             LEFT JOIN MovementItemFloat AS MIFloat_OperPricePartner
                                         ON MIFloat_OperPricePartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_OperPricePartner.DescId         = zc_MIFloat_OperPricePartner()
             LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                         ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                        AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
            ;


     -- ������� - �������� ProdColorItems
     CREATE TEMP TABLE _tmpProdColorItems (ProductId Integer, ProdColorPatternId Integer, MaterialOptionsId Integer, GoodsId Integer, ProdColorName TVarChar) ON COMMIT DROP;
     --
     INSERT INTO _tmpProdColorItems (ProductId, ProdColorPatternId, MaterialOptionsId, GoodsId, ProdColorName)
        SELECT ObjectLink_Product.ChildObjectId          AS ProductId
             , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
               -- ��������� �����
             , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
               --
             , ObjectLink_Goods.ChildObjectId            AS GoodsId
               -- ����� ���� (����� ��� GoodsId)
             , CASE WHEN ObjectLink_Goods.ChildObjectId > 0 THEN COALESCE (Object_ProdColor.ValueData) WHEN TRIM (ObjectString_Comment.ValueData) <> '' THEN TRIM (ObjectString_Comment.ValueData) ELSE TRIM (COALESCE (ObjectString_Comment_pcp.ValueData, '')) END AS ProdColorName

        FROM Object AS Object_ProdColorItems
             -- �����
             INNER JOIN ObjectLink AS ObjectLink_Product
                                   ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                  AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
             -- ����� �������
             INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                    ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                   AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                   AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId

             -- ��������� �����
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = Object_ProdColorItems.Id
                                 AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ProdColorItems_MaterialOptions()
             -- ����� ����, ���� ���� ��������� ��� ����� (����� ��� GoodsId)
             LEFT JOIN ObjectString AS ObjectString_Comment
                                    ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                   AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorItems_Comment()

             -- ���� ������ �� ������ �����, �� ��� ��� � ReceiptGoodsChild
             LEFT JOIN ObjectLink AS ObjectLink_Goods
                                  ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                 AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
             -- ����
             LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                  ON ObjectLink_ProdColor.ObjectId = ObjectLink_Goods.ChildObjectId
                                 AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
             LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId
             -- �������
             LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                 AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
             -- ����� ���� �� Boat Structure (����� ��� GoodsId)
             LEFT JOIN ObjectString AS ObjectString_Comment_pcp
                                    ON ObjectString_Comment_pcp.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                   AND ObjectString_Comment_pcp.DescId   = zc_ObjectString_ProdColorPattern_Comment()

        WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
          AND Object_ProdColorItems.isErased = FALSE
       ;

     -- ������� - �������� _tmpReceiptLevel
     CREATE TEMP TABLE _tmpReceiptLevel (GoodsId Integer, ReceiptLevelName TVarChar) ON COMMIT DROP;
     --
     INSERT INTO _tmpReceiptLevel (GoodsId, ReceiptLevelName)
        SELECT DISTINCT
               CASE WHEN _tmpItem.ObjectId_basis > 0 THEN _tmpItem.ObjectId_basis ELSE _tmpItem.ObjectId END AS GoodsId
             , Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName
        FROM _tmpItem
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                 ON ObjectLink_ReceiptProdModelChild_Object.ChildObjectId = CASE WHEN _tmpItem.ObjectId_basis > 0 THEN _tmpItem.ObjectId_basis ELSE _tmpItem.ObjectId END
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
       ;

     -- ���������
     OPEN Cursor1 FOR
      WITH tmpSumm AS (SELECT _tmpItem.ParentId
                            , SUM (zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount)) AS Amount_unit
                            , SUM (zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice))  AS TotalSumm_unit
                            , SUM (zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice, 0)))  AS TotalSummCost_unit
                            , STRING_AGG (DISTINCT COALESCE (MIString_PartNumber.ValueData, ''), '; ') AS PartNumber
                            , STRING_AGG (DISTINCT COALESCE (Object_Unit.ValueData, ''), '; ')         AS UnitName
                       FROM _tmpItem
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpItem.UnitId
                            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem.PartionId
                            LEFT JOIN MovementItemString AS MIString_PartNumber
                                                         ON MIString_PartNumber.MovementItemId = _tmpItem.PartionId
                                                        AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                       WHERE _tmpItem.DescId_mi = zc_MI_Reserv()
                       GROUP BY _tmpItem.ParentId
                      )
           -- ��� ����� ��� ����
         , tmpProdColor AS (SELECT _tmpItem.GoodsId
                                 , CASE WHEN Object_MaterialOptions.ValueData <> '' THEN Object_MaterialOptions.ValueData || ' - ' ELSE '' END || _tmpProdColorItems.ProdColorName AS ProdColorName
                            FROM _tmpItem
                                 JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpItem.ProdColorPatternId
                                                        AND _tmpProdColorItems.ProdColorName      <> ''
                                 LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = _tmpProdColorItems.MaterialOptionsId
                                 LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = _tmpProdColorItems.ProdColorPatternId
                            WHERE _tmpItem.DescId_mi = zc_MI_Detail()
                            ORDER BY _tmpItem.GoodsId, Object_ProdColorPattern.ObjectCode
                           )
       -- ����� ��� �������� ��� ����
     , tmpProdColor_all AS (SELECT _tmpItem.GoodsId
                                 , STRING_AGG (DISTINCT CASE WHEN Object_MaterialOptions.ValueData <> '' THEN Object_MaterialOptions.ValueData || ' - ' ELSE '' END || _tmpProdColorItems.ProdColorName, '; ') AS ProdColorName
                            FROM _tmpItem
                                 JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpItem.ProdColorPatternId
                                                        AND _tmpProdColorItems.ProdColorName      <> ''
                                 LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = _tmpProdColorItems.MaterialOptionsId
                            WHERE _tmpItem.DescId_mi = zc_MI_Detail()
                            GROUP BY _tmpItem.GoodsId
                           )

      -- ���������
      SELECT
             _tmpItem.MovementItemId                  AS MovementItemId
           , _tmpItem.ObjectId                        AS KeyId

           , Object_Object.Id                         AS ObjectId
           , Object_Object.ObjectCode                 AS ObjectCode
           , ObjectString_Article_Object.ValueData    AS Article_Object
           , ObjectString_ArticleVergl.ValueData      AS ArticleVergl_Object
           , Object_Object.ValueData                  AS ObjectName
           , CASE WHEN _tmpItem_child.GoodsId > 0 THEN '����'
                  WHEN ObjectDesc_Object.Id = zc_Object_ProdOptions() THEN '�����'
                  ELSE ObjectDesc_Object.ItemName
             END AS DescName
           
           , Object_Object_basis.Id                   AS GoodsId_basis
           , Object_Object_basis.ObjectCode           AS GoodsCode_basis
           , Object_Object_basis.ValueData            AS GoodsName_basis
           , ObjectString_Article_basis.ValueData     AS Article_basis

           , Object_ReceiptGoods.Id                   AS ReceiptGoodsId
           , Object_ReceiptGoods.ObjectCode           AS ReceiptGoodsCode
           , Object_ReceiptGoods.ValueData            AS ReceiptGoodsName

           , 0 :: Integer                             AS UnitId
           , tmpSumm.UnitName :: TVarChar             AS UnitName
           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName

             -- ���������� ������ ������
           , zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) AS Amount_basis
             -- ���������� ������
           , CASE WHEN 1=1 THEN 0 WHEN ObjectDesc_Object.Id = zc_Object_Goods()          THEN zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount)  ELSE 0 END :: NUMERIC (16, 8) AS Amount_unit
             -- ������/������
           , CASE WHEN ObjectDesc_Object.Id = zc_Object_ReceiptService() THEN zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount)  ELSE 0 END :: NUMERIC (16, 8) AS Value_service
             -- ���������� ����� ����������
           , zfCalc_Value_ForCount (_tmpItem.AmountPartner, _tmpItem.ForCount) AS Amount_partner
             --
           , _tmpItem.ForCount                        AS ForCount

             -- ���� �� ��� ���
           , _tmpItem.OperPrice                       AS OperPrice_basis
             -- ���� �� ��� ���
           , _tmpItem.OperPricePartner                AS OperPrice_partner
             -- ���� ��. � ��������� ��� ���
           , CASE WHEN tmpSumm.Amount_unit > 0 THEN COALESCE (tmpSumm.TotalSummCost_unit / tmpSumm.Amount_unit) ELSE 0 END :: TFloat AS OperPrice_unit

           , (zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) * _tmpItem.OperPrice)                :: TFloat AS TotalSumm_basis
           , COALESCE (tmpSumm.TotalSummCost_unit, zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) * _tmpItem.OperPrice) :: TFloat AS TotalSumm_unit
           , (zfCalc_Value_ForCount (_tmpItem.AmountPartner, _tmpItem.ForCount) * _tmpItem.OperPricePartner) :: TFloat AS TotalSumm_partner

           , (COALESCE (tmpSumm.TotalSummCost_unit, zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) * _tmpItem.OperPrice, 0)
            + COALESCE (zfCalc_Value_ForCount (_tmpItem.AmountPartner, _tmpItem.ForCount) * _tmpItem.OperPricePartner, 0)) :: TFloat AS TotalSumm_real

           , _tmpItem.isErased

           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData           AS GoodsGroupName
           , Object_Measure.ValueData              AS MeasureName
           , ObjectString_Goods_Comment.ValueData  AS Comment_goods
           , Object_GoodsTag.ValueData             AS GoodsTagName
           , Object_GoodsType.ValueData            AS GoodsTypeName

           , CASE WHEN Object_ProdColor.ValueData <> ''
                  THEN CASE WHEN 1=0 THEN Object_ProdColor.ValueData ELSE '' END
                    || CASE WHEN (SELECT STRING_AGG (tmpProdColor.ProdColorName, '; ') FROM tmpProdColor WHERE tmpProdColor.GoodsId = _tmpItem.ObjectId) <> ''
                            THEN '*' || (SELECT STRING_AGG (tmpProdColor .ProdColorName, '; ') FROM tmpProdColor WHERE tmpProdColor.GoodsId = _tmpItem.ObjectId)
                            ELSE ''
                       END
                  ELSE (SELECT STRING_AGG (DISTINCT tmpProdColor .ProdColorName, '; ') FROM tmpProdColor WHERE tmpProdColor.GoodsId = _tmpItem.ObjectId)
             END :: TVarChar                       AS ProdColorName
           , (CASE WHEN Object_MaterialOptions_opt.ValueData <> '' THEN Object_MaterialOptions_opt.ValueData || ' ' ELSE '' END || Object_ProdOptions.ValueData) :: TVarChar AS ProdOptionsName

           , Movement_OrderPartner.Id                                   AS MovementId_OrderPartner
           , zfConvert_StringToNumber (Movement_OrderPartner.InvNumber) AS InvNumber
           , Movement_OrderPartner.OperDate
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner

           , tmpSumm.PartNumber :: TVarChar AS PartNumber
           , _tmpReceiptLevel.ReceiptLevelName :: TVarChar AS ReceiptLevelName

           , ROW_NUMBER() OVER (ORDER BY CASE WHEN _tmpReceiptLevel.ReceiptLevelName <> '' THEN 0 ELSE 1 END
                                       , _tmpReceiptLevel.ReceiptLevelName
                                       , Object_Object.ValueData
                                       , CASE WHEN Object_ProdOptions.ValueData <> '' THEN 1 ELSE 0 END
                                       , Object_ProdOptions.ValueData
                               ) :: Integer AS NPP

       FROM _tmpItem
            LEFT JOIN tmpSumm      ON tmpSumm.ParentId     = _tmpItem.MovementItemId
            LEFT JOIN (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem WHERE _tmpItem.GoodsId <> _tmpItem.ObjectId) AS _tmpItem_child ON _tmpItem_child.GoodsId = _tmpItem.ObjectId

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = _tmpItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_object
                                   ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                   ON ObjectString_ArticleVergl.ObjectId = Object_Object.Id
                                  AND ObjectString_ArticleVergl.DescId = zc_ObjectString_ArticleVergl()
            LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

            LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = _tmpItem.ObjectId_basis
            LEFT JOIN ObjectString AS ObjectString_Article_basis
                                   ON ObjectString_Article_basis.ObjectId = Object_Object_basis.Id
                                  AND ObjectString_Article_basis.DescId   = zc_ObjectString_Article()

            LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                   ON ObjectString_Goods_Comment.ObjectId = Object_Object.Id
                                  AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

            LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = _tmpItem.ReceiptGoodsId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpItem.UnitId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = _tmpItem.ObjectId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                 ON ObjectLink_ProdColor.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                                 ON ObjectLink_GoodsTag.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_GoodsTag.DescId   = zc_ObjectLink_Goods_GoodsTag()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsType
                                 ON ObjectLink_GoodsType.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = _tmpItem.ProdOptionsId
            LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_MaterialOptions
                                 ON ObjectLink_ProdOptions_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                AND ObjectLink_ProdOptions_MaterialOptions.DescId   = zc_ObjectLink_ProdOptions_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions_opt ON Object_MaterialOptions_opt.Id = ObjectLink_ProdOptions_MaterialOptions.ChildObjectId

            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = _tmpItem.PartnerId
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = ObjectLink_GoodsGroup.ChildObjectId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = ObjectLink_Measure.ChildObjectId
            LEFT JOIN Object AS Object_GoodsTag    ON Object_GoodsTag.Id    = ObjectLink_GoodsTag.ChildObjectId
            LEFT JOIN Object AS Object_GoodsType   ON Object_GoodsType.Id   = ObjectLink_GoodsType.ChildObjectId
            LEFT JOIN Object AS Object_ProdColor   ON Object_ProdColor.Id   = ObjectLink_ProdColor.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_OrderPartner ON Movement_OrderPartner.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_OrderPartner.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()

            LEFT JOIN _tmpReceiptLevel ON _tmpReceiptLevel.GoodsId = CASE WHEN _tmpItem.ObjectId_basis > 0 THEN _tmpItem.ObjectId_basis ELSE _tmpItem.ObjectId END

       -- ��� ���� ���������
       WHERE _tmpItem.GoodsId  = 0
         AND _tmpItem.ParentId = 0
         AND _tmpItem.DescId_mi = zc_MI_Child()
      ;
     RETURN NEXT Cursor1;


     -- ���������
     OPEN Cursor2 FOR
      SELECT _tmpItem.MovementItemId                  AS MovementItemId
           , COALESCE (_tmpItem_parent.ObjectId, _tmpItem.GoodsId) :: Integer AS KeyId

           , Object_Object.Id                         AS ObjectId
           , Object_Object.ObjectCode                 AS ObjectCode
           , ObjectString_Article_Object.ValueData    AS Article_Object
           , CASE WHEN Object_Object.DescId = zc_Object_ProdColorPattern()
                       THEN Object_ProdColorGroup.ValueData || ' ' || Object_Object.ValueData
                  ELSE Object_Object.ValueData
             END :: TVarChar AS ObjectName
           , ObjectDesc_Object.ItemName               AS DescName
           
           , Object_Object_basis.Id                   AS GoodsId_basis
           , Object_Object_basis.ObjectCode           AS GoodsCode_basis
           , Object_Object_basis.ValueData            AS GoodsName_basis
           , ObjectString_Article_basis.ValueData     AS Article_basis

           , Object_Unit.Id                           AS UnitId
           , Object_Unit.ValueData                    AS UnitName
           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName

             -- ���������� ������ ������
           , zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) AS Amount_basis
             -- ���������� ������
           , CASE WHEN Object_Object.DescId = zc_Object_ReceiptService() THEN 0 ELSE 0 END :: TFloat AS Amount_unit        
             -- ���������� ����� ����������
           , zfCalc_Value_ForCount (_tmpItem.AmountPartner, _tmpItem.ForCount) AS Amount_partner     
             -- 
           , _tmpItem.ForCount                        AS ForCount

             -- ���� �� ��� ���
           , _tmpItem.OperPrice                       AS OperPrice_basis
             -- ���� �� ��� ���
           , _tmpItem.OperPricePartner                AS OperPrice_partner   
             -- ���� ��. � ��������� ��� ���
           , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice, 0)) :: TFloat AS OperPrice_unit

           , (zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount)   * _tmpItem.OperPrice) :: TFloat AS TotalSumm_basis
           , (0 * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice, 0))) :: TFloat AS TotalSumm_unit
           , (zfCalc_Value_ForCount (_tmpItem.AmountPartner, _tmpItem.ForCount) * _tmpItem.OperPricePartner) :: TFloat AS TotalSumm_partner

           , _tmpItem.isErased

           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , _tmpProdColorItems.ProdColorName :: TVarChar AS ProdColorName
           , (CASE WHEN Object_MaterialOptions_opt.ValueData <> '' THEN Object_MaterialOptions_opt.ValueData || ' ' ELSE '' END || Object_ProdOptions.ValueData) :: TVarChar AS ProdOptionsName

           , Object_PartionGoods.Amount     AS Amount_in
           , Object_PartionGoods.CountForPrice

             -- ���� ������ ��� ���
           , Object_PartionGoods.CostPrice :: TFloat CostPrice

           , Movement_OrderPartner.Id                                   AS MovementId_OrderPartner
           , zfConvert_StringToNumber (Movement_OrderPartner.InvNumber) AS InvNumber
           , Movement_OrderPartner.OperDate
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner

           , MIString_PartNumber.ValueData AS PartNumber

           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber_partion
           , Movement.OperDate  AS OperDate_partion

           , _tmpItem.PartionId

           , Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName

       FROM _tmpItem
            LEFT JOIN _tmpItem AS _tmpItem_parent ON _tmpItem_parent.MovementItemId = _tmpItem.ParentId

            LEFT JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpItem.ProdColorPatternId

            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem.PartionId
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = _tmpItem.PartionId
                                        AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
            LEFT JOIN Movement ON Movement.Id = Object_PartionGoods.MovementId

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = _tmpItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_object
                                   ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

            LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = _tmpItem.ObjectId_basis
            LEFT JOIN ObjectString AS ObjectString_Article_basis
                                   ON ObjectString_Article_basis.ObjectId = Object_Object_basis.Id
                                  AND ObjectString_Article_basis.DescId   = zc_ObjectString_Article()

            LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                 ON ObjectLink_ProdColorGroup.ObjectId = _tmpItem.ProdColorPatternId
                                AND ObjectLink_ProdColorGroup.DescId    = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpItem.UnitId

            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = _tmpItem.ProdOptionsId
            LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_MaterialOptions
                                 ON ObjectLink_ProdOptions_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                AND ObjectLink_ProdOptions_MaterialOptions.DescId   = zc_ObjectLink_ProdOptions_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions_opt ON Object_MaterialOptions_opt.Id = ObjectLink_ProdOptions_MaterialOptions.ChildObjectId

            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = COALESCE (Object_PartionGoods.FromId, _tmpItem.PartnerId)
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_GoodsGroup.ChildObjectId)
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = COALESCE (Object_PartionGoods.MeasureId, ObjectLink_Measure.ChildObjectId)

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_OrderPartner ON Movement_OrderPartner.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_OrderPartner.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()

            LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = _tmpItem.ReceiptLevelId

       WHERE _tmpItem.DescId_mi = zc_MI_Detail()
     --WHERE _tmpItem.GoodsId > 0
--       WHERE Object_Object.DescId <> zc_Object_ProdColorPattern()
     ;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.22         * ForCount
 18.07.16         *
*/

-- ����
-- SELECT * from gpSelect_MI_OrderClient_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());

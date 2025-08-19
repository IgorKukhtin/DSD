 -- Function: gpSelect_MI_OrderClient_detail()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderClient_detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderClient_detail(
    IN inMovementId       Integer      , -- ���� ���������
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE ( Id                      Integer
               , ObjectId_Uzel         Integer
               , ObjectCode_Uzel       Integer
               , ObjectName_Uzel       TVarChar
               , Article_Uzel          TVarChar
               , ReceiptLevelName_Uzel TVarChar
               , ProdOptionsName_Uzel  TVarChar
               , NPP_Uzel              Integer
               , ObjectId              Integer
               , ObjectCode            Integer
               , ObjectName            TVarChar
               , Article               TVarChar 
               , DescName              TVarChar
               , GoodsGroupName        TVarChar
               , MeasureName           TVarChar
               , ReceiptLevelName      TVarChar
               , ProdOptionsName       TVarChar
               , Amount                TFloat 
               , ForCount              TFloat
               , Amount_remains        TFloat
               , Amount_send           TFloat
               , isErased              Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReceiptProdModelId Integer;
BEGIN
 /*
 1) � �� ���� 
 2) �������  (����) 
 3) ���� ���� 
 4)  ���� ����-�� 
 5) ReceiptLevel 
  6)����� 
 7) ������� + �������� ������������� 
 8) zc_MI_Detail.Amount - ��������� � ����� 
 + ��������� � ����� ������ 
 + ������  (����� ������ ) �������� ��� ������� 

 + ������� �� �� ������
 + ������� � �� ������ � �������� � ����� ������ 
 + ������ ����� �������� ������ �� ��������� �� �� ������

*/
     --�� ����� ����� �� ��� ������� ������
     vbReceiptProdModelId := (SELECT ObjectLink_Product_ReceiptProdModel.ChildObjectId
                              FROM MovementLinkObject AS MovementLinkObject_Product
                                   LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                                                        ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                                                       AND ObjectLink_Product_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                              WHERE MovementLinkObject_Product.MovementId = inMovementId
                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                              );
     RETURN QUERY
     WITH 
     _tmpItem AS (SELECT MovementItem.DescId                                                 AS DescId_mi
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
                                              AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail())
                                              AND MovementItem.isErased   = tmpIsErased.isErased
                         -- !!! !!! �������� ��� �������
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
          )

  , _tmpReceiptLevel AS (SELECT DISTINCT
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
                         )
   , tmpMI_Child AS (SELECT
                            _tmpItem.MovementItemId                  AS MovementItemId
                          , _tmpItem.ObjectId                        AS KeyId

                          , _tmpItem.ObjectId                        AS ObjectId
                          , Object_Object.ValueData                  AS ObjectName

                          , CASE WHEN _tmpItem_child.GoodsId > 0 THEN '����'
                                 WHEN ObjectDesc_Object.Id = zc_Object_ProdOptions() THEN '�����'
                                 ELSE ObjectDesc_Object.ItemName
                            END AS DescName

                          , _tmpItem.Amount
                          , _tmpItem.ForCount

                          , (CASE WHEN Object_MaterialOptions_opt.ValueData <> '' THEN Object_MaterialOptions_opt.ValueData || ' ' ELSE '' END || Object_ProdOptions.ValueData) :: TVarChar AS ProdOptionsName

               
                          , ROW_NUMBER() OVER (ORDER BY CASE WHEN _tmpReceiptLevel.ReceiptLevelName <> '' THEN 0 ELSE 1 END
                                                      , _tmpReceiptLevel.ReceiptLevelName
                                                      , Object_Object.ValueData
                                                      , CASE WHEN Object_ProdOptions.ValueData <> '' THEN 1 ELSE 0 END
                                                      , Object_ProdOptions.ValueData
                                              ) :: Integer AS NPP
                     FROM _tmpItem
                          LEFT JOIN (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem WHERE _tmpItem.GoodsId <> _tmpItem.ObjectId) AS _tmpItem_child ON _tmpItem_child.GoodsId = _tmpItem.ObjectId

                          LEFT JOIN Object AS Object_Object ON Object_Object.Id = _tmpItem.ObjectId
                          LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

                          LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = _tmpItem.ReceiptGoodsId

                          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = _tmpItem.ProdOptionsId
                          LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_MaterialOptions
                                               ON ObjectLink_ProdOptions_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                              AND ObjectLink_ProdOptions_MaterialOptions.DescId   = zc_ObjectLink_ProdOptions_MaterialOptions()
                          LEFT JOIN Object AS Object_MaterialOptions_opt ON Object_MaterialOptions_opt.Id = ObjectLink_ProdOptions_MaterialOptions.ChildObjectId

                          LEFT JOIN _tmpReceiptLevel ON _tmpReceiptLevel.GoodsId = CASE WHEN _tmpItem.ObjectId_basis > 0 THEN _tmpItem.ObjectId_basis ELSE _tmpItem.ObjectId END

                     -- ��� ���� ���������
                     WHERE _tmpItem.GoodsId  = 0
                       AND _tmpItem.ParentId = 0
                       AND _tmpItem.DescId_mi = zc_MI_Child()
                     )

   -- ����� �������
   , tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                         , SUM (Container.Amount) AS Remains
                    FROM Container
                    WHERE Container.WhereObjectId = zc_Unit_Sklad() -- ������ ��� ����� ������
                      AND Container.DescId        = zc_Container_Count()
                      AND Container.ObjectId IN (SELECT DISTINCT _tmpItem.ObjectId FROM _tmpItem)
                    GROUP BY Container.ObjectId
                   )
   -- ��� �����������
   , tmpSend AS (SELECT MI.ObjectId                  AS GoodsId
                      , SUM (COALESCE (MI.Amount,0)) AS Amount
                 FROM MovementItemFloat AS MIFloat_MovementId
                      LEFT JOIN MovementItem AS MI
                                             ON MI.Id = MIFloat_MovementId.MovementItemId
                                            AND MI.DescId     = zc_MI_Master()
                                            AND MI.isErased   = FALSE
                      INNER JOIN Movement AS Movement_Send
                                          ON Movement_Send.Id = MI.MovementId
                                         AND Movement_Send.DescId = zc_Movement_Send()
                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                   AND MovementLinkObject_From.ObjectId = zc_Unit_Sklad()
                 WHERE MIFloat_MovementId.ValueData :: Integer = inMovementId
                   AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 
                 GROUP BY MI.ObjectId
                )




   SELECT _tmpItem.MovementItemId                  AS Id
         --���� /���� ��
        , Object_Uzel.Id                         AS ObjectId_Uzel
        , Object_Uzel.ObjectCode                 AS ObjectCode_Uzel
        , Object_Uzel.ValueData                  AS ObjectName_Uzel
        , ObjectString_Article_uzel.ValueData    AS Article_Uzel
        , _tmpReceiptLevel.ReceiptLevelName :: TVarChar AS ReceiptLevelName_Uzel
        , tmpMI_Child.ProdOptionsName  :: TVarChar AS ProdOptionsName_Uzel
        , tmpMI_Child.NPP                          AS NPP_Uzel
        
          -- �������������
        , Object_Object.Id                        AS ObjectId
        , Object_Object.ObjectCode                AS ObjectCode
        , Object_Object.ValueData                 AS ObjectName
        , ObjectString_Article_Detail.ValueData   AS Article
        , ObjectDesc_Detail.ItemName              AS DescName
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , Object_Measure.ValueData       AS MeasureName
        , Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName
        , (CASE WHEN Object_MaterialOptions_opt.ValueData <> '' THEN Object_MaterialOptions_opt.ValueData || ' ' ELSE '' END || Object_ProdOptions.ValueData) :: TVarChar AS ProdOptionsName
        , CASE WHEN Object_Uzel.Id IS NULL THEN tmpMI_Child.Amount ELSE _tmpItem.Amount END     ::TFloat AS Amount
        , CASE WHEN Object_Uzel.Id IS NULL THEN tmpMI_Child.ForCount ELSE _tmpItem.ForCount END ::TFloat AS ForCount
        
        --
        , tmpRemains.Remains ::TFloat AS Amount_remains
        , tmpSend.Amount     ::TFloat AS Amount_send   
        
        , _tmpItem.isErased  ::Boolean AS isErased
        
  FROM tmpMI_Child
            LEFT JOIN _tmpItem ON _tmpItem.GoodsId = tmpMI_Child.KeyId 
                              AND _tmpItem.DescId_mi = zc_MI_Detail()
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem.PartionId
            
            LEFT JOIN Object AS Object_Uzel ON Object_Uzel.Id = CASE WHEN _tmpItem.ObjectId_basis > 0 THEN  _tmpItem.ObjectId_basis ELSE _tmpItem.GoodsId END
            LEFT JOIN _tmpReceiptLevel ON _tmpReceiptLevel.GoodsId = Object_Uzel.Id

            LEFT JOIN ObjectString AS ObjectString_Article_uzel
                                   ON ObjectString_Article_uzel.ObjectId = Object_Uzel.Id
                                  AND ObjectString_Article_uzel.DescId   = zc_ObjectString_Article()

            
            LEFT JOIN Object AS Object_Object ON Object_Object.Id = CASE WHEN Object_Uzel.Id IS NULL THEN tmpMI_Child.ObjectId ELSE _tmpItem.ObjectId END  --���� ����� ������������� �� ���������� ��� � �������������� 
            LEFT JOIN ObjectString AS ObjectString_Article_Detail
                                   ON ObjectString_Article_Detail.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_Detail.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Detail ON ObjectDesc_Detail.Id = Object_Object.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (Object_PartionGoods.MeasureId, ObjectLink_Measure.ChildObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = Object_Object.Id
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_GoodsGroup.ChildObjectId)

            LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = _tmpItem.GoodsId --_tmpItem.ObjectId_basis

            LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = _tmpItem.ReceiptLevelId

            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = _tmpItem.ProdOptionsId
            LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_MaterialOptions
                                 ON ObjectLink_ProdOptions_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                AND ObjectLink_ProdOptions_MaterialOptions.DescId   = zc_ObjectLink_ProdOptions_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions_opt ON Object_MaterialOptions_opt.Id = ObjectLink_ProdOptions_MaterialOptions.ChildObjectId

            -- ����� �������
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = Object_Object.Id
            -- ����� �����������
            LEFT JOIN tmpSend ON tmpSend.GoodsId = Object_Object.Id 
  ;

  /*
 1) � �� ���� 
 2) �������  (����) 
 3) ���� ���� 
 4)  ���� ����-�� 
 5) ReceiptLevel 
  6)����� 
 7) ������� + �������� ������������� 
 8) zc_MI_Detail.Amount - ��������� � ����� 
 + ��������� � ����� ������ 

 + ������  (����� ������ ) �������� ��� ������� 

 + ������� �� �� ������
 + ������� � �� ������ � �������� � ����� ������ 
 + ������ ����� �������� ������ �� ��������� �� �� ������

*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.25         *
*/

-- ����
-- SELECT * from gpSelect_MI_OrderClient_detail (inMovementId:= 5489, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
  
select * from gpSelect_MI_OrderClient_detail(inMovementId := 5490 , inIsErased := 'False' ,  inSession := '5');

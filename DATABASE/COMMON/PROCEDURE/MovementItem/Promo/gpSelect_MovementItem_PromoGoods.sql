-- Function: gpSelect_MovementItem_PromoGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoGoods(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (
        Id                  Integer --�������������
      , MovementId          Integer --�� ��������� <�����>
      , GoodsId             Integer --�� ������� <�����>
      , GoodsCode           Integer --��� �������  <�����>
      , GoodsName           TVarChar --������������ ������� <�����>
      , MeasureName         TVarChar --������� ���������
      , TradeMarkName       TVarChar --�������� �����
      , Amount              TFloat --% ������ �� �����
      , Price               TFloat --���� � ������
      , PriceSale           TFloat --���� �� �����
      , PriceWithOutVAT     TFloat --���� �������� ��� ����� ���, � ������ ������, ���
      , PriceWithVAT        TFloat --���� �������� � ������ ���, � ������ ������, ���
      , AmountReal          TFloat --����� ������ � ����������� ������, ��
      , AmountRealWeight    TFloat --����� ������ � ����������� ������, �� ���
      , AmountRetIn         TFloat --����� ������� � ����������� ������, ��
      , AmountRetInWeight   TFloat --����� ������� � ����������� ������, �� ���
      , AmountPlanMin       TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��)
      , AmountPlanMinWeight TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
      , AmountPlanMax       TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��)
      , AmountPlanMaxWeight TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
      , AmountOrder         TFloat --���-�� ������ (����)
      , AmountOrderWeight   TFloat --���-�� ������ (����) ���
      , AmountOut           TFloat --���-�� ���������� (����)
      , AmountOutWeight     TFloat --���-�� ���������� (����) ���
      , AmountIn            TFloat --���-�� ������� (����)
      , AmountInWeight      TFloat --���-�� ������� (����) ���
      , GoodsKindId         Integer --�� ������� <��� ������>
      , GoodsKindName       TVarChar --������������ ������� <��� ������>
      , GoodsKindName_List  TVarChar --������������ ������� <��� ������ (���������)>
      , Comment             TVarChar --�����������
      , isErased            Boolean  --������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoGoods());
    vbUserId:= lpGetUserBySession (inSession);


    CREATE TEMP TABLE _tmpPromoPartner (PartnerId Integer) ON COMMIT DROP;
    INSERT INTO _tmpPromoPartner (PartnerId)
            SELECT MI_PromoPartner.ObjectId        AS PartnerId   --�� ������� <�������>
            FROM Movement AS Movement_PromoPartner
                 INNER JOIN MovementItem AS MI_PromoPartner
                                         ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                        AND MI_PromoPartner.DescId = zc_MI_Master()
                                        AND MI_PromoPartner.IsErased = FALSE
            WHERE Movement_PromoPartner.ParentId = inMovementId
              AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner();

    CREATE TEMP TABLE _tmpGoodsKind_inf (GoodsId Integer, ValueData TVarChar) ON COMMIT DROP;
    INSERT INTO _tmpGoodsKind_inf (GoodsId, ValueData) 
            SELECT ObjectLink_GoodsListSale_Goods.ChildObjectId AS GoodsId
                 , STRING_AGG (DISTINCT ObjectString_GoodsKind.ValueData :: TVarChar, ',') AS ValueData
            FROM _tmpPromoPartner
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                      ON ObjectLink_GoodsListSale_Partner.ChildObjectId = _tmpPromoPartner.PartnerId
                                     AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                     
                 LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                      ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                     AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                 INNER JOIN (SELECT MovementItem.ObjectId 
                             FROM MovementItem 
                             WHERE MovementItem.MovementId = inMovementId 
                               AND MovementItem.DescId = zc_MI_Master() 
                               AND MovementItem.isErased = FALSE) AS MI_Master ON MI_Master.ObjectId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                 INNER JOIN ObjectString AS ObjectString_GoodsKind
                                         ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                        AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                        AND ObjectString_GoodsKind.ValueData <> ''
            GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId;
                                       
    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList) 
            SELECT DISTINCT _tmpGoodsKind_inf.ValueData AS WordList
            FROM _tmpGoodsKind_inf;
            
    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);


    RETURN QUERY
        WITH
        tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, STRING_AGG (DISTINCT Object.ValueData :: TVarChar, ',')  AS GoodsKindName_list
                         FROM _tmpWord_Split_to  
                              LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                         GROUP BY _tmpWord_Split_to.WordList
                         )
      , tmpGoodsKind_list AS (SELECT _tmpGoodsKind_inf.GoodsId
                                   , STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName_List :: TVarChar, ',')  AS GoodsKindName_List
                              FROM _tmpGoodsKind_inf
                                   LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = _tmpGoodsKind_inf.ValueData
                              GROUP BY _tmpGoodsKind_inf.GoodsId
                             )
      
             
        SELECT
            MI_PromoGoods.Id                     -- �������������
          , MI_PromoGoods.MovementId             -- �� ��������� <�����>
          , MI_PromoGoods.GoodsId                -- �� ������� <�����>
          , MI_PromoGoods.GoodsCode              -- ��� �������  <�����>
          , MI_PromoGoods.GoodsName              -- ������������ ������� <�����>
          , MI_PromoGoods.Measure                -- ������� ���������
          , MI_PromoGoods.TradeMark              -- �������� �����
          , MI_PromoGoods.Amount                 -- % ������ �� �����
          , MI_PromoGoods.Price                  -- ���� � ������
          , MI_PromoGoods.PriceSale              -- ���� �� �����
          , MI_PromoGoods.PriceWithOutVAT        -- ���� �������� ��� ����� ���, � ������ ������, ���
          , MI_PromoGoods.PriceWithVAT           -- ���� �������� � ������ ���, � ������ ������, ���
          , MI_PromoGoods.AmountReal             -- ����� ������ � ����������� ������, ��
          , MI_PromoGoods.AmountRealWeight       -- ����� ������ � ����������� ������, �� ���
          , MI_PromoGoods.AmountRetIn            -- ����� ������� � ����������� ������, ��
          , MI_PromoGoods.AmountRetInWeight      -- ����� ������� � ����������� ������, �� ���
          , MI_PromoGoods.AmountPlanMin          -- ������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMinWeight    -- ������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanMax          -- �������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMaxWeight    -- �������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountOrder            -- ���-�� ������ (����)
          , MI_PromoGoods.AmountOrderWeight      -- ���-�� ������ (����) ���
          , MI_PromoGoods.AmountOut              -- ���-�� ���������� (����)
          , MI_PromoGoods.AmountOutWeight        -- ���-�� ���������� (����) ���
          , MI_PromoGoods.AmountIn               -- ���-�� ������� (����)
          , MI_PromoGoods.AmountInWeight         -- ���-�� ������� (����) ���
          , MI_PromoGoods.GoodsKindId            -- �� ������� <��� ������>
          , MI_PromoGoods.GoodsKindName          -- ������������ ������� <��� ������>
          , tmpGoodsKind_list.GoodsKindName_List ::TVarChar  -- ������������ ������� <��� ������ (���������)>
          , MI_PromoGoods.Comment                -- �����������
          , MI_PromoGoods.isErased                -- ������
          
        FROM MovementItem_PromoGoods_View AS MI_PromoGoods
             LEFT JOIN tmpGoodsKind_list ON tmpGoodsKind_list.GoodsId = MI_PromoGoods.GoodsId
        WHERE MI_PromoGoods.MovementId = inMovementId
          AND (MI_PromoGoods.isErased = FALSE OR inIsErased = TRUE);
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PromoGoods (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 05.11.15                                                          *
*/
-- ����
-- SELECT * FROM gpSelect_MovementItem_PromoGoods (5083159 , FALSE, zfCalc_UserAdmin());

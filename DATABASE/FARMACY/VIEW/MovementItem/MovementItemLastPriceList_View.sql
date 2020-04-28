DROP MATERIALIZED VIEW IF EXISTS MovementItemLastPriceList_View;

CREATE MATERIALIZED VIEW MovementItemLastPriceList_View
   ( MovementId
   , JuridicalId
   , ContractId
   , MovementItemId
   , Price
   , GoodsId
   , GoodsCode
   , GoodsName
   , MakerName
   , PartionGoodsDate
   , AreaId)

AS
    SELECT LastMovement.MovementId
         , LastMovement.JuridicalId
         , LastMovement.ContractId
         , MovementItem.Id                    AS MovementItemId
--         , MovementItem.Amount                AS Price
         , COALESCE(MIFloat_Price.ValueData,0)::TFloat  AS Price
         , MILinkObject_Goods.ObjectId        AS GoodsId
         , ObjectString_GoodsCode.ValueData   AS GoodsCode
         , Object_Goods.ValueData             AS GoodsName
         , ObjectString_Goods_Maker.ValueData AS MakerName
         , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
         , LastMovement.AreaId                AS AreaId
    FROM
        (
            SELECT 
                PriceList.JuridicalId
              , PriceList.ContractId
              , PriceList.AreaId
              , PriceList.MovementId 
            FROM 
                (
                    SELECT 
                        MAX (Movement.OperDate) 
                        OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId 
                                         , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                         , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                             ) AS Max_Date
                      , Movement.OperDate                                  AS OperDate
                      , Movement.Id                                        AS MovementId
                      , MovementLinkObject_Juridical.ObjectId              AS JuridicalId 
                      , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                      , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
                    FROM 
                        Movement
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                     ON MovementLinkObject_Area.MovementId = Movement.Id
                                                    AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area() 
                    WHERE 
                        Movement.DescId = zc_Movement_PriceList()
                    AND Movement.StatusId = zc_Enum_Status_UnComplete()
                ) AS PriceList
            WHERE PriceList.Max_Date = PriceList.OperDate 
        ) AS LastMovement
        INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                               AND MovementItem.DescId = zc_MI_Master()
        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods -- ������ � �����-�����
                                         ON MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                        AND MILinkObject_Goods.MovementItemId = MovementItem.Id

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT OUTER JOIN Object AS Object_Goods
                               ON Object_Goods.Id = MILinkObject_Goods.ObjectId
        LEFT JOIN ObjectString AS ObjectString_GoodsCode 
                               ON ObjectString_GoodsCode.ObjectId = MILinkObject_Goods.ObjectId
                              AND ObjectString_GoodsCode.DescId = zc_ObjectString_Goods_Code()
        LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                               ON ObjectString_Goods_Maker.ObjectId = MILinkObject_Goods.ObjectId
                              AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()  
        LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                   ON MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                  AND MIDate_PartionGoods.MovementItemId =  MovementItem.Id
        ;
                                  
ALTER TABLE MovementItemLastPriceList_View OWNER TO postgres;

CREATE INDEX MovementItemLastPriceList_GoodsId
    ON MovementItemLastPriceList_View (GoodsId);
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 11.10.17         *
 24.05.16                                                        *
 */

-- ����
-- SELECT * FROM MovementItemLastPriceList_View

-- ���������� 
-- REFRESH MATERIALIZED VIEW MovementItemLastPriceList_View
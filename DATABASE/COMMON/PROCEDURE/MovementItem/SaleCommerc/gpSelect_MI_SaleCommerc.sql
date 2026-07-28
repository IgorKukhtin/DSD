	-- Function: gpSelect_MI_SaleCommerc()

DROP FUNCTION IF EXISTS gpSelect_MI_SaleCommerc (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_SaleCommerc(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , JuridicalName TVarChar, RetailName TVarChar, SectionName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , isErased_master Boolean
             --
             , Id_Child Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , MeasureName TVarChar, TradeMarkName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsGroupPropertyName TVarChar, GoodsGroupPropertyName_Parent TVarChar
             
             , Amount                TFloat
             , Amount_sh             TFloat
             , Amount_weight         TFloat
             , Summ                  TFloat
             , Summ_Basis            TFloat   --Собівартість відвантаження, грн
             , Summ_Bonus            TFloat   --Бонуси, грн  - % бонусу * Відвантаження, грн
             , Summ_diff             TFloat   --націнка, грн
             , AmountPromo           TFloat
             , AmountPromo_sh        TFloat
             , AmountPromo_weight    TFloat
             , SummPromo             TFloat
             , SummPromo_Basis       TFloat   --Собівартість відвантаження, грн
             , SummPromo_Bonus       TFloat   --Бонуси, грн  - % бонусу * Відвантаження, грн
             , SummPromo_diff        TFloat   --націнка, грн
             , AmountNoPromo         TFloat
             , AmountNoPromo_sh      TFloat
             , AmountNoPromo_weight  TFloat
             , SummNoPromo           TFloat
             , SummNoPromo_Basis     TFloat   --Собівартість відвантаження, грн 
             , SummNoPromo_Bonus     TFloat   --Бонуси, грн  - % бонусу * Відвантаження, грн
             , SummNoPromo_diff      TFloat   --націнка, грн   
             
             , Bonus TFloat, Price TFloat
             , isErased_child Boolean
             , isErased Boolean

             , Color_yellow          Integer--желтый
             , Color_blue            Integer--голубой
             , Color_rose            Integer--розовый 
             , Color_green           Integer--зеленый
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SaleCommerc());
     vbUserId:= lpGetUserBySession (inSession);

 
    --
     RETURN QUERY
        WITH
        tmpMI_Master AS (SELECT MovementItem.*
                         FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                              INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = tmpIsErased.isErased
                         )
      , tmpMI_Child AS (SELECT MovementItem.*
                         FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                              INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                     AND MovementItem.DescId     = zc_MI_Child()
                                                     AND MovementItem.isErased   = tmpIsErased.isErased
                         )                   

      , tmpMILO_Master AS (SELECT MovementItemLinkObject.*
                           FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                             AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Partner()
                                                                 , zc_MILinkObject_Branch()
                                                                 , zc_MILinkObject_PaidKind()
                                                                 )
                           )
      , tmpParams_Partner AS (
                              SELECT Object_Partner.Id              AS PartnerId
                                   , Object_Partner.ObjectCode      AS PartnerCode
                                   , Object_Partner.ValueData       AS PartnerName
                                   , Object_Juridical.ValueData     AS JuridicalName
                                   , Object_Retail.ValueData        AS RetailName
                                   , Object_Section.ValueData       AS SectionName
                              FROM (SELECT DISTINCT tmpMILO_Master.ObjectId
                                    FROM tmpMILO_Master
                                    WHERE tmpMILO_Master.DescId = zc_MILinkObject_Partner()
                                    ) AS MILinkObject_Partner
                                   LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId
                                   
                                   LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId      = Object_Partner.Id
                                                       AND ObjectLink_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
                                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                       
                                   LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                        ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                                       AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                   LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                       
                                   LEFT JOIN ObjectLink AS ObjectLink_Juridical_Section
                                                        ON ObjectLink_Juridical_Section.ObjectId = Object_Juridical.Id
                                                       AND ObjectLink_Juridical_Section.DescId = zc_ObjectLink_Juridical_Section()
                                   LEFT JOIN Object AS Object_Section ON Object_Section.Id = ObjectLink_Juridical_Section.ChildObjectId  
                              
                              )

      , tmpMILO_Child AS (SELECT MovementItemLinkObject.*
                          FROM MovementItemLinkObject
                          WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                            AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                                  )
                          )                             
      , tmpMIFloat_Child AS (SELECT MovementItemFloat.*
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                               AND MovementItemFloat.DescId IN (zc_MIFloat_Summ()
                                                              , zc_MIFloat_SummPromo()
                                                              , zc_MIFloat_SummNoPromo()
                                                              , zc_MIFloat_AmountPromo() 
                                                              , zc_MIFloat_AmountNoPromo()
                                                              , zc_MIFloat_Bonus()
                                                              , zc_MIFloat_Price()
                                                               )
                             )

      , tmpParams_Goods AS (SELECT Object_Goods.Id                             AS GoodsId
                                 , Object_Goods.ObjectCode                     AS GoodsCode
                                 , Object_Goods.ValueData                      AS GoodsName
                     
                                 , Object_Measure.Id                           AS MeasureId
                                 , Object_Measure.ValueData                    AS MeasureName
                                 , ObjectFloat_Weight.ValueData                AS Weight
                                 , Object_TradeMark.ValueData                  AS TradeMarkName           
                                 , Object_GoodsGroup.ValueData                 AS GoodsGroupName
                                 , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                                 , Object_GoodsGroupProperty.ValueData         AS GoodsGroupPropertyName
                                 , Object_GoodsGroupPropertyParent.ValueData   AS GoodsGroupPropertyName_Parent
                            FROM (SELECT DISTINCT tmpMI_Child.ObjectId FROM tmpMI_Child) AS tmp
                                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.ObjectId
                                 --
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                      ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                     AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                     
                                 LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                        ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                                       AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                     
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                      ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                     AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                 LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                     
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                      ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                                     AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                 LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                     
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                                      ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                                                     AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                                 LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId
                     
                                 LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                                      ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                                     AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                                 LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                       ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                                      AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                            )
        --
        SELECT
             MovementItem.Id                      AS Id
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ObjectCode           AS ContractCode
           , Object_Contract.ValueData            AS ContractName

           , Object_Branch.Id                     AS BranchId
           , Object_Branch.ObjectCode             AS BranchCode
           , Object_Branch.ValueData              AS BranchName

           , Object_Partner.PartnerId             AS PartnerId
           , Object_Partner.PartnerCode           AS PartnerCode
           , Object_Partner.PartnerName           AS PartnerName
           
           , Object_Partner.JuridicalName         AS JuridicalName
           , Object_Partner.RetailName            AS RetailName
           , Object_Partner.SectionName           AS SectionName

           , Object_PaidKind.Id                   AS PaidKindId
           , Object_PaidKind.ValueData            AS PaidKindName

           , MovementItem.isErased                AS isErased_master
           --
           , tmpMI_Child.Id                       AS Id_Child
           , Object_Goods.GoodsId                 AS GoodsId
           , Object_Goods.GoodsCode               AS GoodsCode
           , Object_Goods.GoodsName               AS GoodsName
           , Object_GoodsKind.Id                  AS GoodsKindId
           , Object_GoodsKind.ValueData           AS GoodsKindName 

           , Object_Goods.MeasureName             AS MeasureName
           , Object_Goods.TradeMarkName           AS TradeMarkName           
           , Object_Goods.GoodsGroupName          AS GoodsGroupName
           , Object_Goods.GoodsGroupNameFull      AS GoodsGroupNameFull
           , Object_Goods.GoodsGroupPropertyName  AS GoodsGroupPropertyName
           , Object_Goods.GoodsGroupPropertyName_Parent AS GoodsGroupPropertyName_Parent

            -- CASE WHEN tmpParams_Goods.MeasureId = zc_Measure_Sh() THEN COALESCE (tmpParams_Goods.Weight,1) ELSE 1 END
           , tmpMI_Child.Amount                                                                           ::TFloat AS Amount
           , CASE WHEN Object_Goods.MeasureId = zc_Measure_Sh() THEN tmpMI_Child.Amount ELSE 0 END        ::TFloat AS Amount_sh
           , (tmpMI_Child.Amount 
              * CASE WHEN Object_Goods.MeasureId = zc_Measure_Sh() THEN COALESCE (Object_Goods.Weight,1) ELSE 1 END)       ::TFloat AS Amount_weight
           , COALESCE (MIFloat_Summ.ValueData, 0)                                                         ::TFloat AS Summ
           , (COALESCE (tmpMI_Child.Amount,0) * COALESCE (MIFloat_Price.ValueData, 0))                    ::TFloat AS Summ_Basis               --Собівартість відвантаження, грн
           , (COALESCE (MIFloat_Summ.ValueData, 0) * COALESCE (MIFloat_Bonus.ValueData, 0) / 100)         ::TFloat AS Summ_Bonus               --Бонуси, грн  - % бонусу * Відвантаження, грн

           , (COALESCE (MIFloat_Summ.ValueData, 0) 
             - (COALESCE (MIFloat_Summ.ValueData, 0) * COALESCE (MIFloat_Bonus.ValueData, 0) / 100)
             - (COALESCE (tmpMI_Child.Amount,0) * COALESCE (MIFloat_Price.ValueData, 0)))                 ::TFloat AS Summ_diff --націнка, грн

           , COALESCE (MIFloat_AmountPromo.ValueData, 0)                                                  ::TFloat AS AmountPromo
           , CASE WHEN Object_Goods.MeasureId = zc_Measure_Sh() THEN COALESCE (MIFloat_AmountPromo.ValueData, 0) ELSE 0 END   ::TFloat AS AmountPromo_sh
           , (COALESCE (MIFloat_AmountPromo.ValueData, 0) 
              * CASE WHEN Object_Goods.MeasureId = zc_Measure_Sh() THEN COALESCE (Object_Goods.Weight,1) ELSE 1 END)       ::TFloat AS AmountPromo_weight
           , COALESCE (MIFloat_SummPromo.ValueData, 0)                                                    ::TFloat AS SummPromo
           , (COALESCE (MIFloat_AmountPromo.ValueData, 0) * COALESCE (MIFloat_Price.ValueData, 0))        ::TFloat AS SummPromo_Basis          --Собівартість відвантаження, грн
           , (COALESCE (MIFloat_SummPromo.ValueData, 0) * COALESCE (MIFloat_Bonus.ValueData, 0) / 100)    ::TFloat AS SummPromo_Bonus          --Бонуси, грн  - % бонусу * Відвантаження, грн

           , (COALESCE (MIFloat_SummPromo.ValueData, 0) 
             - (COALESCE (MIFloat_SummPromo.ValueData, 0) * COALESCE (MIFloat_Bonus.ValueData, 0) / 100)
             - (COALESCE (MIFloat_AmountPromo.ValueData,0) * COALESCE (MIFloat_Price.ValueData, 0)))      ::TFloat AS SummPromo_diff --націнка, грн

           , COALESCE (MIFloat_AmountNoPromo.ValueData, 0)                                                ::TFloat AS AmountNoPromo
           , CASE WHEN Object_Goods.MeasureId = zc_Measure_Sh() THEN COALESCE (MIFloat_AmountNoPromo.ValueData, 0) ELSE 0 END ::TFloat AS AmountNoPromo_sh
           , (COALESCE (MIFloat_AmountNoPromo.ValueData, 0)
              * CASE WHEN Object_Goods.MeasureId = zc_Measure_Sh() THEN COALESCE (Object_Goods.Weight,1) ELSE 1 END)       ::TFloat AS AmountNoPromo_weight
           , COALESCE (MIFloat_SummNoPromo.ValueData, 0)                                                  ::TFloat AS SummNoPromo
           , (COALESCE (MIFloat_AmountNoPromo.ValueData, 0) * COALESCE (MIFloat_Price.ValueData, 0))      ::TFloat AS SummNoPromo_Basis        --Собівартість відвантаження, грн 
           , (COALESCE (MIFloat_SummNoPromo.ValueData, 0) * COALESCE (MIFloat_Bonus.ValueData, 0) / 100)  ::TFloat AS SummNoPromo_Bonus        --Бонуси, грн  - % бонусу * Відвантаження, грн
           
           , (COALESCE (MIFloat_SummNoPromo.ValueData, 0) 
             - (COALESCE (MIFloat_SummNoPromo.ValueData, 0) * COALESCE (MIFloat_Bonus.ValueData, 0) / 100)
             - (COALESCE (MIFloat_AmountNoPromo.ValueData,0) * COALESCE (MIFloat_Price.ValueData, 0)))    ::TFloat AS SummNoPromo_diff --націнка, грн

           , COALESCE (MIFloat_Bonus.ValueData, 0)         ::TFloat AS Bonus
           , COALESCE (MIFloat_Price.ValueData, 0)         ::TFloat AS Price
                                                  
           , tmpMI_Child.isErased                                                                           AS isErased_child
           , CASE WHEN MovementItem.isErased = TRUE OR tmpMI_Child.isErased = TRUE THEN TRUE ELSE FALSE END AS isErased

           , 12582911 ::Integer AS Color_yellow --желтый
           , 16777166 ::Integer AS Color_blue   --голубой
           , 11053311 ::Integer AS Color_rose   --розовый 
           , 14614223 ::Integer AS Color_green  --зеленый
            
       FROM tmpMI_Master AS MovementItem
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementItem.ObjectId

            LEFT JOIN tmpMILO_Master AS MILinkObject_Partner
                                     ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                    AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
            LEFT JOIN tmpParams_Partner AS Object_Partner ON Object_Partner.PartnerId = MILinkObject_Partner.ObjectId

            LEFT JOIN tmpMILO_Master AS MILinkObject_Branch
                                     ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                    AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

            LEFT JOIN tmpMILO_Master AS MILinkObject_PaidKind
                                     ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                    AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            --child
            INNER JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
            LEFT JOIN tmpParams_Goods AS Object_Goods ON Object_Goods.GoodsId = tmpMI_Child.ObjectId
            
            LEFT JOIN tmpMILO_Child AS MILinkObject_GoodsKind
                                    ON MILinkObject_GoodsKind.MovementItemId = tmpMI_Child.Id
                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN tmpMIFloat_Child AS MIFloat_Summ
                                       ON MIFloat_Summ.MovementItemId = tmpMI_Child.Id
                                      AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
            LEFT JOIN tmpMIFloat_Child AS MIFloat_AmountPromo
                                       ON MIFloat_AmountPromo.MovementItemId = tmpMI_Child.Id
                                      AND MIFloat_AmountPromo.DescId = zc_MIFloat_AmountPromo()
            LEFT JOIN tmpMIFloat_Child AS MIFloat_SummPromo
                                       ON MIFloat_SummPromo.MovementItemId = tmpMI_Child.Id
                                      AND MIFloat_SummPromo.DescId = zc_MIFloat_SummPromo()
            LEFT JOIN tmpMIFloat_Child AS MIFloat_AmountNoPromo
                                       ON MIFloat_AmountNoPromo.MovementItemId = tmpMI_Child.Id
                                      AND MIFloat_AmountNoPromo.DescId = zc_MIFloat_AmountNoPromo()
            LEFT JOIN tmpMIFloat_Child AS MIFloat_SummNoPromo
                                       ON MIFloat_SummNoPromo.MovementItemId = tmpMI_Child.Id
                                      AND MIFloat_SummNoPromo.DescId = zc_MIFloat_SummNoPromo()
            LEFT JOIN tmpMIFloat_Child AS MIFloat_Bonus
                                       ON MIFloat_Bonus.MovementItemId = tmpMI_Child.Id
                                      AND MIFloat_Bonus.DescId = zc_MIFloat_Bonus()
            LEFT JOIN tmpMIFloat_Child AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = tmpMI_Child.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
          ; 

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 22.07.26         * 
*/

-- тест
--  SELECT * FROM gpSelect_MI_SaleCommerc (34853167, FALSE, zfCalc_UserAdmin());

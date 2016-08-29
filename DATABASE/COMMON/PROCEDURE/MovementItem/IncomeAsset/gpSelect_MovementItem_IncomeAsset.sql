-- Function: gpSelect_MovementItem_IncomeAsset()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_IncomeAsset (Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_IncomeAsset(
    IN inMovementId       Integer      , -- ключ Документа
    IN inInvoiceId        Integer      ,
    IN inShowAll          Boolean      , -- 
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AssetId Integer, AssetName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Amount TFloat, Price TFloat
             , Amount_parent TFloat, Price_parent TFloat
             , CountForPrice TFloat
             , AmountSumm TFloat
             , AmountRemains TFloat
             , isErased Boolean
             , MIId_Invoice Integer, InvNumber_Invoice TVarChar

              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbPriceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется
     vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To());
     IF vbUnitId IN (SELECT lfSelect_Object_Unit_byGroup.UnitId FROM lfSelect_Object_Unit_byGroup (8433) AS lfSelect_Object_Unit_byGroup) -- Производство
     THEN vbUnitId:= NULL;
     END IF;

     -- определяется - Пав-ны приход
     vbPriceListId:= (SELECT 140208 WHERE EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (80548))); -- Бухгалтер ПАВИЛЬОНЫ

     -- Результат
     IF inShowAll THEN 

     -- Результат такой
     RETURN QUERY 
       WITH tmpRemains AS (SELECT Container.ObjectId                          AS GoodsId
                                , Container.Amount                            AS Amount
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                          )

          ,  tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                           , COALESCE (MILinkObject_Unit.ObjectId, 0)        AS UnitId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice 
                           , MIFloat_Invoice.ValueData :: Integer            AS MIId_Invoice
                          
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                            LEFT JOIN MovementItemFloat AS MIFloat_Invoice
                                                        ON MIFloat_Invoice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Invoice.DescId = zc_MIFloat_MovementItemId()
                      )

   , tmpMI_parent AS (SELECT   MovementItem.Id                                 AS MovementItemId
                             , MovementItem.MovementId                         AS MovementId
                             , COALESCE (MILinkObject_Goods.ObjectId,0)        AS GoodsId
                             , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                             , COALESCE (MILinkObject_Unit.ObjectId, 0)        AS UnitId
                             , MovementItem.Amount                             AS Amount
                             , COALESCE (MIFloat_Price.ValueData, 0)           AS Price
                             , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                      FROM MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()    
                                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice() 
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                   ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()                                                                  
                      WHERE MovementItem.MovementId = inInvoiceId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )


   , tmpResult AS (SELECT tmpMI.Id                                                         AS Id
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , COALESCE (tmpMI.UnitId, tmpMI_parent.UnitId)                     AS UnitId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.MIId_Invoice, tmpMI_parent.MovementItemId)       AS MIId_Invoice

                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.UnitId        AS UnitId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        FULL JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_Invoice
                   WHERE inShowAll = TRUE
                  UNION ALL
                   SELECT tmpMI.Id                                                         AS Id
                        , COALESCE (tmpMI.GoodsId, tmpMI_parent.GoodsId)                   AS GoodsId
                        , COALESCE (tmpMI.AssetId, tmpMI_parent.AssetId)                   AS AssetId
                        , COALESCE (tmpMI.UnitId, tmpMI_parent.UnitId)                     AS UnitId
                        , tmpMI.Amount                                                     AS Amount
                        , COALESCE (tmpMI.Price, tmpMI_parent.Price)                       AS Price
                        , COALESCE (tmpMI.CountForPrice, tmpMI_parent.CountForPrice)       AS CountForPrice
                        , COALESCE (tmpMI.MIId_Invoice, tmpMI_parent.MovementItemId)       AS MIId_Invoice
                     
                        , tmpMI_parent.GoodsId       AS GoodsId_parent
                        , tmpMI_parent.UnitId        AS UnitId_parent
                        , tmpMI_parent.Amount        AS Amount_parent
                        , tmpMI_parent.Price         AS Price_parent
                        , tmpMI_parent.CountForPrice AS CountForPrice_parent
                   FROM tmpMI
                        LEFT JOIN tmpMI_parent ON tmpMI_parent.MovementItemId = tmpMI.MIId_Invoice
                   WHERE inShowAll = FALSE
                  )


         SELECT
             MovementItem.Id

           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName

           , Object_Asset.Id             AS AssetId
           , Object_Asset.ValueData      AS AssetName

           , Object_Unit.Id             AS UnitId
           , Object_Unit.ValueData      AS UnitName

           , MovementItem.Amount
           , tmpMI.Price           ::TFloat
           , tmpMI.Amount_parent   ::TFloat
           , tmpMI.Price_parent    ::TFloat
           , tmpMI.CountForPrice   ::TFloat

           , CAST (CASE WHEN tmpMI.CountForPrice > 0
                           THEN CAST ( COALESCE (MovementItem.Amount, 0) * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (MovementItem.Amount, 0) * tmpMI.Price AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm
           , tmpRemains.Amount          AS AmountRemains
           , MovementItem.isErased
     
           , MI_Invoice.Id              AS MIId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice

       FROM tmpResult AS tmpMI
            LEFT JOIN MovementItem ON MovementItem.Id = tmpMI.Id
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId 
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId 
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId 
            -- это док. "Счет"
            LEFT JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id = tmpMI.MIId_Invoice  
                                                AND MI_Invoice.isErased = FALSE
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId  
       ;

     ELSE
  
       -- Результат другой
       RETURN QUERY 
       WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , COALESCE (MILinkObject_Asset.ObjectId, 0)     AS AssetId
                                 , MovementItem.Amount                           AS Amount
                                 , COALESCE (MILinkObject_Unit.ObjectId, 0)      AS UnitId
                                 , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                 , CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                        ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset() 
                          )
          , tmpRemains AS (SELECT tmpMI_Goods.MovementItemId
                                , Container.Amount                            AS Amount
                           FROM tmpMI_Goods
                                INNER JOIN Container ON Container.ObjectId = tmpMI_Goods.GoodsId
                                                    AND Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId = vbUnitId
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = Container.Id
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                           WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                          )
        
       SELECT
             tmpMI_Goods.MovementItemId         AS Id
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName

           , Object_Asset.Id            AS AssetId
           , Object_Asset.ValueData     AS AssetName

           , Object_Unit.Id             AS UnitId
           , Object_Unit.ValueData      AS UnitName
           
           , tmpMI_Goods.Amount         :: TFloat
           , tmpMI_Goods.Price         :: TFloat

           , MI_Invoice.Amount                           ::TFloat AS Amount_parent
           , COALESCE(MIFloat_Price_Invoice.ValueData,0) ::TFloat AS Price_parent

           , tmpMI_Goods.CountForPrice :: TFloat AS CountForPrice

           
           , CAST ((tmpMI_Goods.Amount) * tmpMI_Goods.Price / tmpMI_Goods.CountForPrice AS NUMERIC (16, 2)) :: TFloat AS AmountSumm
           , tmpRemains.Amount                  AS AmountRemains

           , tmpMI_Goods.isErased               AS isErased

           , MI_Invoice.Id                      AS MIId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner_Invoice.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
  
       FROM tmpMI_Goods
            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId
            -- это док. "Счет"
            LEFT JOIN MovementItemFloat AS MIFloat_Invoice
                                        ON MIFloat_Invoice.MovementItemId = tmpMI_Goods.MovementItemId
                                       AND MIFloat_Invoice.DescId = zc_MIFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_Invoice ON MI_Invoice.Id = MIFloat_Invoice.ValueData :: Integer
                                                AND MI_Invoice.isErased = FALSE
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MI_Invoice.MovementId
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_Invoice
                                     ON MovementString_InvNumberPartner_Invoice.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner_Invoice.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_Price_Invoice
                                        ON MIFloat_Price_Invoice.MovementItemId = MI_Invoice.Id
                                       AND MIFloat_Price_Invoice.DescId = zc_MIFloat_Price() 
            --
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI_Goods.UnitId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI_Goods.AssetId 
       ;
 
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.08.16         *
 29.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_IncomeAsset (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_IncomeAsset (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())

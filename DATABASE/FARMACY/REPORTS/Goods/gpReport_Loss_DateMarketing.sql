-- Function: gpReport_Loss_DateMarketing()

DROP FUNCTION IF EXISTS gpReport_Loss_DateMarketing (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Loss_DateMarketing(
    IN inStartDate     TDateTime , --
    IN inMakerId       Integer ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UnitId Integer, UnitName TVarChar
             , MakerId Integer, MakerName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, ExpirationDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     RETURN QUERY
       WITH tmpUnit AS (SELECT Object_Unit_View.Id      AS UnitId
                        FROM Object_Unit_View
                        WHERE Object_Unit_View.iserased = False 
                          AND COALESCE (Object_Unit_View.ParentId, 0) <> 377612
                          AND Object_Unit_View.Id <> 389328
                          AND Object_Unit_View.Name NOT ILIKE 'Зачинена%'
                          AND COALESCE (Object_Unit_View.ParentId, 0) IN 
                              (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0) 
                        )
          , tmpMIPromo AS (SELECT DISTINCT MI_Goods.Id                        AS MI_Id
                                         , MI_Goods.ObjectId                  AS GoodsId
                                         , Movement.InvNumber                 AS InvNumber
                                         , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                         , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                                         , MIFloat_Price.ValueData            AS Price
                                         , MovementLinkObject_Maker.ObjectId  AS MakerId
                                    FROM Movement
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                                    ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                                   AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                                   AND (MovementLinkObject_Maker.ObjectId = inMakerId OR inMakerId = 0)

                                      INNER JOIN MovementDate AS MovementDate_StartPromo
                                                              ON MovementDate_StartPromo.MovementId = Movement.Id
                                                             AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                      INNER JOIN MovementDate AS MovementDate_EndPromo
                                                              ON MovementDate_EndPromo.MovementId = Movement.Id
                                                             AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                                      INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                         AND MI_Goods.DescId = zc_MI_Master()
                                                                         AND MI_Goods.isErased = FALSE
                                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                  ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                    WHERE Movement.StatusId = zc_Enum_Status_Complete()
                                      AND Movement.DescId = zc_Movement_Promo()
                                    )    
          , tmpMovementAll AS (SELECT Movement.Id
                                 , Movement.OperDate
                                 , MovementLinkObject_Unit.ObjectId                      AS UnitId
                            FROM Movement

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId

                                 INNER JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                               ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                              AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                                                              AND MovementLinkObject_ArticleLoss.ObjectId = 10977676 

                             WHERE Movement.DescId = zc_Movement_Loss()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.OperDate >= '01.11.2023'::TDateTime 
                             )
          , tmpProtocol As (SELECT MovementProtocol.MovementId
                                 , Min(MovementProtocol.OperDate)::TDateTime     AS OperDate
                            FROM tmpMovementAll
                             
                                 INNER JOIN MovementProtocol ON MovementProtocol.MovementId = tmpMovementAll.Id
                                                            AND MovementProtocol.ProtocolData ILIKE '%Статус" FieldValue = "Проведен%'
                                                             
                            GROUP BY MovementProtocol.MovementId
                            )                             
          , tmpMovement AS (SELECT Movement.Id
                                 , Movement.OperDate
                                 , Movement.UnitId
                            FROM tmpMovementAll AS Movement

                                 INNER JOIN tmpProtocol ON tmpProtocol.MovementId = Movement.Id

                            WHERE tmpProtocol.OperDate >= CASE WHEN '01.01.2024'::TDateTime = date_trunc('month', inStartDate) THEN '01.11.2023'::TDateTime ELSE inStartDate END
                              AND tmpProtocol.OperDate < inStartDate + INTERVAL '1 MONTH'
                            )
          , tmpMICPD AS (SELECT Container.ParentId
                              , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd())::TDateTime    AS ExpirationDate
                              , (- MIC.Amount)::TFloat  AS Amount
                         FROM tmpMovement AS Movement

                              INNER JOIN MovementItemContainer  AS MIC
                                                                ON MIC.MovementId = Movement.Id
                                                               AND MIC.DescId = zc_MIContainer_CountPartionDate()
                                                               
                              INNER JOIN Container ON Container.Id = MIC.ContainerId

                              INNER JOIN tmpMIPromo ON tmpMIPromo.GoodsId = Container.ObjectId
                                                   AND MIC.OperDate >= StartDate_Promo
                                                   AND MIC.OperDate <= EndDate_Promo

                              LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                           AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                              LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                   ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                  AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                         )
          , tmpMIC AS (SELECT Container.Id
                            , Container.WhereObjectId AS UnitId
                            , Container.ObjectId      AS GoodsId
                            , Movement.Id             AS MovementId
                            , Movement.OperDate       AS OperDate
                            , tmpMIPromo.MakerId
                            , COALESCE(tmpMICPD.Amount , (- MIC.Amount))::TFloat  AS Amount
                            , MIFloat_PriceWithVAT.ValueData                     AS PriceWithVAT
                            , COALESCE (tmpMICPD.ExpirationDate, MIDate_PartionGoods.ValueData, zc_DateEnd())::TDateTime  AS ExpirationDate
                       FROM tmpMovement AS Movement

                            INNER JOIN MovementItemContainer  AS MIC
                                                              ON MIC.MovementId = Movement.Id
                                                             AND MIC.DescId = zc_MIContainer_Count()
                                                             
                            INNER JOIN Container ON Container.Id = MIC.ContainerId
                            
                            INNER JOIN tmpMIPromo ON tmpMIPromo.GoodsId = Container.ObjectId
                                                 AND MIC.OperDate >= StartDate_Promo
                                                 AND MIC.OperDate <= EndDate_Promo

                            LEFT JOIN tmpMICPD ON tmpMICPD.ParentId = Container.Id

                            LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                            LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                            -- элемент прихода
                            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                              
                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                        ON MIFloat_PriceWithVAT.MovementItemId = COALESCE(MI_Income_find.Id,MI_Income.Id)
                                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

                            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                       ON MIDate_PartionGoods.MovementItemId = COALESCE(MI_Income_find.Id,MI_Income.Id)
                                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                       )


    SELECT tmpMIC.OperDate                                        AS OperDate
         , tmpMIC.UnitId                                          AS UnitId
         , Object_Unit.ValueData                                  AS UnitName
         , tmpMIC.MakerId                                         AS MakerId
         , Object_Maker.ValueData                                 AS MakerName
         , tmpMIC.GoodsId                                         AS GoodsId
         , Object_Goods_Main.ObjectCode                           AS GoodsCode
         , Object_Goods_Main.Name                                 AS GoodsName
         , tmpMIC.Amount                                          AS AmountCheck
         , tmpMIC.ExpirationDate                                  AS ExpirationDate
    FROM tmpMIC

         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMIC.UnitId

         LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = tmpMIC.MakerId

         LEFT JOIN Object_Goods_Retail AS Object_Goods
                                       ON Object_Goods.Id = tmpMIC.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
         
    ORDER BY tmpMIC.OperDate, tmpMIC.UnitId 
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.21                                                       *
*/

-- тест
--
select * from gpReport_Loss_DateMarketing(inStartDate:= '04.01.2024', inMakerId := 2336611, inSession := '3');
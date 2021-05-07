-- Function:  gpReport_ClientDebt()

DROP FUNCTION IF EXISTS gpReport_PartnerDebt (Integer,TVarChar);
DROP FUNCTION IF EXISTS gpReport_ClientDebt (Integer,TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_ClientDebt (
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId_Partion   Integer
             , DescName_Partion     TVarChar
             , OperDate_Partion     TDateTime
             , Invnumber_Partion    TVarChar
             , InvNumberAll_Partion TVarChar
             , MovementId_Sale      Integer
             , MovementItemId_Sale  Integer
             , DescName_Sale        TVarChar
             , OperDate_Sale        TDateTime
             , Invnumber_Sale       TVarChar
             , ClientId             Integer
             , ClientName           TVarChar
             , PartionId            Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, NameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName      TVarChar
             , CompositionName  TVarChar
             , GoodsInfoName    TVarChar
             , LineFabricaName  TVarChar
             , LabelName        TVarChar
             , GoodsSizeId Integer, GoodsSizeName    TVarChar
             , BrandName        TVarChar
             , PeriodName       TVarChar
             , PeriodYear       Integer
             , ChangePercent    TFloat
             , OperPriceList    TFloat
             , Amount           TFloat
             , TotalSummPriceList     TFloat
             , SummChangePercent      TFloat
             , TotalChangePercent     TFloat
             , TotalChangePercentPay  TFloat
             , TotalPay               TFloat
             , TotalPayOth            TFloat
             , TotalCountReturn       TFloat
             , TotalReturn            TFloat
             , TotalPayReturn         TFloat
             , CountDebt              TFloat
             , SummDebt               TFloat
             , SummDebt_profit        TFloat
             , SummToPay              TFloat
             , SummTotalPay           TFloat

             , OperPriceList_curr      TFloat
             , SummChangePercent_curr  TFloat
             , TotalChangePercent_curr TFloat
             , TotalChangePercentPay_curr TFloat
             , TotalPay_curr           TFloat
             , TotalPayOth_curr        TFloat
             , TotalReturn_curr        TFloat
             , TotalPayReturn_curr     TFloat
             , TotalSummDebt_curr      TFloat
             , TotalSummToPay_curr     TFloat

             , InsertName             TVarChar
             , isOffer                Boolean
  )
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbIsOperPrice Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- проверка может ли смотреть любой магазин, или только свой
    PERFORM lpCheckUnit_byUser (inUnitId_by:= inUnitId, inUserId:= vbUserId);

    -- Получили - показывать цену ВХ.
    vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId);


    -- Результат
    RETURN QUERY
    WITH
     tmpContainer AS (SELECT tmp.UnitId
                           , tmp.ClientId
                           , tmp.PartionId
                           , tmp.PartionMI_Id
                           , SUM (tmp.Amount)           AS CountDebt
                           , SUM (tmp.AmountSum)        AS SummDebt
                           , SUM (tmp.AmountSum_profit) AS SummDebt_profit
                      FROM
                          (SELECT Container.WhereObjectId     AS UnitId
                                , CLO_Client.ObjectId         AS ClientId
                                , Container.PartionId         AS PartionId
                                , CLO_PartionMI.ObjectId      AS PartionMI_Id
                                , SUM (CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount ELSE 0 END )  AS Amount
                                , SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND Container.ObjectId <> zc_Enum_Account_20102() THEN Container.Amount ELSE 0 END ) AS AmountSum
                                  --  продавцам в магазинах ограничиваем инфу
                                , SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND Container.ObjectId =  zc_Enum_Account_20102() AND vbIsOperPrice = TRUE THEN Container.Amount ELSE 0 END ) AS AmountSum_profit
                           FROM Container
                                INNER JOIN ContainerLinkObject AS CLO_Client
                                                               ON CLO_Client.ContainerId = Container.Id
                                                              AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionMI
                                                              ON CLO_PartionMI.ContainerId = Container.Id
                                                             AND CLO_PartionMI.DescId = zc_ContainerLinkObject_PartionMI()
                           WHERE Container.WhereObjectId = inUnitId
                             -- AND Container.ObjectId <> zc_Enum_Account_20102()
                           GROUP BY Container.WhereObjectId
                                  , CLO_Client.ObjectId
                                  , Container.PartionId
                                  , CLO_PartionMI.ObjectId
                                  , Container.Amount
                           HAVING SUM (Container.Amount) <> 0
                           ) AS tmp
                      GROUP BY tmp.UnitId
                             , tmp.ClientId
                             , tmp.PartionId
                             , tmp.PartionMI_Id
                      )

   , tmpDataPartion AS (SELECT Movement.Id              AS MovementId_Sale
                             , Movement.DescId          AS MovementDescId_Sale
                             , Movement.OperDate        AS OperDate_Sale
                             , Movement.Invnumber       AS Invnumber_Sale

                             , MovementItem.Id          AS MovementItemId_Sale

                             , tmpContainer.ClientId
                             , tmpContainer.PartionId
                             , MovementItem.Amount

                             , tmpContainer.CountDebt
                             , tmpContainer.SummDebt
                             , tmpContainer.SummDebt_profit

                        FROM tmpContainer
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = tmpContainer.PartionMI_Id
                             LEFT JOIN MovementItem               ON MovementItem.Id     = Object_PartionMI.ObjectCode
                             LEFT JOIN Movement                   ON Movement.Id         = MovementItem.MovementId
                        )

   , tmpData_All AS (SELECT tmpData.*
                          , COALESCE (MIFloat_ChangePercent.ValueData, 0)                           AS ChangePercent
                          , COALESCE (MIFloat_OperPriceList.ValueData, 0)                           AS OperPriceList
                          , zfCalc_SummPriceList (tmpData.Amount, MIFloat_OperPriceList.ValueData ) AS TotalSummPriceList
                          , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                            -- !!!заменили!!!
                          , COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_SummChangePercent.ValueData, 0) AS TotalChangePercent
                          , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0) AS TotalChangePercentPay
                          , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                          , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                          , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn
                          , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn
                          , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn

                            -- Цена по прайсу, без скидки - в валюте
                          , COALESCE (MIFloat_OperPriceList_curr.ValueData, 0)         AS OperPriceList_curr
                          , COALESCE (MIFloat_SummChangePercent_curr.ValueData, 0)     AS SummChangePercent_curr
                          , COALESCE (MIFloat_TotalChangePercent_curr.ValueData, 0)    AS TotalChangePercent_curr
                          , COALESCE (MIFloat_TotalChangePercentPay_curr.ValueData, 0) AS TotalChangePercentPay_curr
                          , COALESCE (MIFloat_TotalPay_curr.ValueData, 0)              AS TotalPay_curr
                          , COALESCE (MIFloat_TotalPayOth_curr.ValueData, 0)           AS TotalPayOth_curr
                          , COALESCE (MIFloat_TotalReturn_curr.ValueData, 0)           AS TotalReturn_curr
                          , COALESCE (MIFloat_TotalPayReturn_curr.ValueData, 0)        AS TotalPayReturn_curr
                     FROM tmpDataPartion AS tmpData
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                      ON MIFloat_OperPriceList.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                      ON MIFloat_ChangePercent.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                      ON MIFloat_SummChangePercent.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                      ON MIFloat_TotalChangePercent.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                      ON MIFloat_TotalChangePercentPay.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay_curr
                                                      ON MIFloat_TotalChangePercentPay_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalChangePercentPay_curr.DescId         = zc_MIFloat_TotalChangePercentPay_curr()
                                                       
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                      ON MIFloat_TotalPay.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                      ON MIFloat_TotalPayOth.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                      ON MIFloat_TotalCountReturn.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                      ON MIFloat_TotalReturn.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                      ON MIFloat_TotalPayReturn.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                          --
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                      ON MIFloat_OperPriceList_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()

                          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                      ON MIFloat_SummChangePercent_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent_curr
                                                      ON MIFloat_TotalChangePercent_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalChangePercent_curr.DescId         = zc_MIFloat_TotalChangePercent_curr()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_curr
                                                      ON MIFloat_TotalPay_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPay_curr.DescId         = zc_MIFloat_TotalPay_curr()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_curr
                                                      ON MIFloat_TotalPayOth_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPayOth_curr.DescId         = zc_MIFloat_TotalPayOth_curr()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn_curr
                                                      ON MIFloat_TotalReturn_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalReturn_curr.DescId         = zc_MIFloat_TotalReturn_curr()
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn_curr
                                                      ON MIFloat_TotalPayReturn_curr.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPayReturn_curr.DescId         = zc_MIFloat_TotalPayReturn_curr()
                    )

     , tmpData  AS  (SELECT tmp.MovementId_Sale
                          , tmp.MovementItemId_Sale
                          , tmp.MovementDescId_Sale
                          , tmp.OperDate_Sale
                          , tmp.Invnumber_Sale
                          , tmp.ClientId
                          , tmp.PartionId
                          , tmp.ChangePercent
                          , tmp.OperPriceList
                          , tmp.Amount
                          , tmp.TotalSummPriceList
                          , tmp.SummChangePercent
                          , tmp.TotalChangePercent
                          , tmp.TotalChangePercentPay
                          , tmp.TotalPay
                          , tmp.TotalPayOth
                          , tmp.TotalCountReturn
                          , tmp.TotalReturn
                          , tmp.TotalPayReturn
                          , tmp.CountDebt
                          , tmp.SummDebt
                          , tmp.SummDebt_profit

                          , tmp.OperPriceList_curr
                          , tmp.SummChangePercent_curr
                          , tmp.TotalChangePercent_curr
                          , tmp.TotalChangePercentPay_curr
                          , tmp.TotalPay_curr
                          , tmp.TotalPayOth_curr
                          , tmp.TotalReturn_curr
                          , tmp.TotalPayReturn_curr
                     FROM tmpData_All AS tmp
                     WHERE tmp.CountDebt <> 0 OR tmp.SummDebt <> 0 OR tmp.SummDebt_profit <> 0
                    )


        SELECT Object_PartionGoods.MovementId AS MovementId_Partion
             , MovementDesc.ItemName          AS DescName_Partion
             , Movement.OperDate              AS OperDate_Partion
             , Movement.InvNumber             AS InvNumber_Partion
             , zfCalc_PartionMovementName (0, '', Movement.InvNumber, Movement.OperDate) AS InvNumberAll_Partion

             , tmpData.MovementId_Sale
             , tmpData.MovementItemId_Sale
             , MovementDesc_Sale.ItemName     AS DescName_Sale
             , tmpData.OperDate_Sale
             , tmpData.Invnumber_Sale

             , Object_Client.Id               AS ClientId
             , Object_Client.ValueData        AS ClientName
             , tmpData.PartionId
             , Object_Goods.Id                AS GoodsId
             , Object_Goods.ObjectCode        AS GoodsCode
             , Object_Goods.ValueData         AS GoodsName
             , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , (COALESCE (ObjectString_GoodsGroupFull.ValueData, '') || ' - ' || COALESCE (Object_GoodsInfo.ValueData, '')) :: TVarChar AS NameFull
             , Object_GoodsGroup.ValueData    AS GoodsGroupName
             , Object_Measure.ValueData       AS MeasureName
             , Object_Composition.ValueData   AS CompositionName
             , Object_GoodsInfo.ValueData     AS GoodsInfoName
             , Object_LineFabrica.ValueData   AS LineFabricaName
             , Object_Label.ValueData         AS LabelName
             , Object_GoodsSize.Id            AS GoodsSizeId
             , Object_GoodsSize.ValueData     AS GoodsSizeName
             , Object_Brand.ValueData         AS BrandName
             , Object_Period.ValueData        AS PeriodName
             , Object_PartionGoods.PeriodYear ::Integer

             , tmpData.ChangePercent            ::TFloat
             , tmpData.OperPriceList            ::TFloat
             , tmpData.Amount                   ::TFloat
             , tmpData.TotalSummPriceList       ::TFloat
             , tmpData.SummChangePercent        ::TFloat
             , tmpData.TotalChangePercent       ::TFloat
             , tmpData.TotalChangePercentPay    ::TFloat
             , tmpData.TotalPay                 ::TFloat
             , tmpData.TotalPayOth              ::TFloat
             , tmpData.TotalCountReturn         ::TFloat
             , tmpData.TotalReturn              ::TFloat
             , tmpData.TotalPayReturn           ::TFloat

             , tmpData.CountDebt                ::TFloat
             , tmpData.SummDebt                 ::TFloat
             , tmpData.SummDebt_profit          ::TFloat
             -- сумма к оплате  = сумма по прайсу -скидка - возврат
             , (tmpData.TotalSummPriceList 
               - COALESCE (tmpData.SummChangePercent,0) 
               - COALESCE (tmpData.TotalChangePercent,0) 
               - COALESCE (tmpData.TotalReturn ,0)
               - COALESCE (tmpData.TotalChangePercentPay,0)) ::TFloat AS SummToPay

             --сумма оплаты итого
             , (COALESCE (tmpData.TotalPay,0)
               + COALESCE (tmpData.TotalPayOth,0)
               - COALESCE (tmpData.TotalPayReturn,0)) ::TFloat AS SummTotalPay

             , tmpData.OperPriceList_curr       ::TFloat
             , tmpData.SummChangePercent_curr   ::TFloat
             , tmpData.TotalChangePercent_curr  ::TFloat
             , tmpData.TotalChangePercentPay_curr ::TFloat
             , tmpData.TotalPay_curr            ::TFloat
             , tmpData.TotalPayOth_curr         ::TFloat
             , tmpData.TotalReturn_curr         ::TFloat
             , tmpData.TotalPayReturn_curr      ::TFloat
             , (zfCalc_SummPriceList (tmpData.Amount, tmpData.OperPriceList_curr) - tmpData.TotalChangePercent_curr - tmpData.TotalPay_curr) :: TFloat AS TotalSummDebt_curr

             , (zfCalc_SummPriceList (tmpData.Amount, tmpData.OperPriceList_curr)
               - COALESCE (tmpData.SummChangePercent_curr,0) 
               - COALESCE (tmpData.TotalChangePercent_curr,0) 
               - COALESCE (tmpData.TotalReturn_curr,0)
               - COALESCE (tmpData.TotalChangePercentPay_curr,0)) ::TFloat AS TotalSummToPay_curr

             , Object_Insert.ValueData   AS InsertName
             , COALESCE (MovementBoolean_Offer.ValueData, FALSE)  ::Boolean AS isOffer   -- примерка

        FROM tmpData
            LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId

            LEFT JOIN Movement ON Movement.Id = Object_PartionGoods.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN MovementDesc AS MovementDesc_Sale ON MovementDesc_Sale.Id = tmpData.MovementDescId_Sale

            LEFT JOIN Object AS Object_Client ON Object_Client.Id = tmpData.ClientId

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = Object_PartionGoods.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = tmpData.MovementId_Sale
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_Offer
                                      ON MovementBoolean_Offer.MovementId = tmpData.MovementId_Sale
                                     AND MovementBoolean_Offer.DescId = zc_MovementBoolean_Offer()
          ;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 30.04.21         *
 21.08.17         * на проводках
 04.07.17         *
*/

-- тест
-- SELECT * FROM gpReport_ClientDebt (inUnitId:= 506, inSession:= zfCalc_UserAdmin());

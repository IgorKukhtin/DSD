-- Function:  gpReport_MotionByPartner()

DROP FUNCTION IF EXISTS gpReport_MotionByPartner (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MotionByPartner (
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inUnitId           Integer  ,  -- �������������
    IN inPartnerId        Integer  ,  -- ����������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId            Integer
             , DescName              TVarChar
             , OperDate              TDateTime
             , Invnumber             TVarChar
             , MovementId_Sale       Integer
             , DescName_Sale         TVarChar
             , OperDate_Sale         TDateTime
             , Invnumber_Sale        TVarChar             
             , PartnerName           TVarChar
             , PartionId             Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName      TVarChar
             , JuridicalName    TVarChar
             , CompositionGroupName TVarChar
             , CompositionName  TVarChar
             , GoodsInfoName    TVarChar
             , LineFabricaName  TVarChar
             , LabelName        TVarChar
             , GoodsSizeId Integer, GoodsSizeName    TVarChar
             , CurrencyName     TVarChar
             , BrandName        TVarChar
             , FabrikaName      TVarChar
             , PeriodName       TVarChar
             , PeriodYear       Integer
             , ChangePercent    TFloat
             , OperPriceList    TFloat
             , Amount           TFloat
             , TotalSummPriceList TFloat
             , SummChangePercent  TFloat
             , TotalChangePercent TFloat
             , TotalPay           TFloat
             , TotalPayOth        TFloat
             , CountDebt_Start    TFloat
             , SummDebt_Start     TFloat
             , CountDebt_End      TFloat
             , SummDebt_End       TFloat
             , AmountSale         TFloat
             , SumPay             TFloat
             , SumSale            TFloat 
             , SumPayReturnIn     TFloat
             , AmountReturnIn     TFloat
             , SumReturnIn        TFloat 
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
    WITH
    tmpContainer_All AS (SELECT Container.WhereObjectId          AS UnitId
                              , CLO_Client.ObjectId              AS PartnerId
                              , Container.PartionId              AS PartionId
                              , CLO_PartionMI.ObjectId           AS PartionMI_Id
                              
                              , (CASE WHEN Container.DescId = zc_Container_count() 
                                          THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END)                                                            AS StartAmount
                              , (CASE WHEN Container.DescId = zc_Container_count() 
                                          THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) AS EndAmount
                              , (CASE WHEN Container.DescId = zc_Container_Summ() 
                                          THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END)                                                            AS StartSum
                              , (CASE WHEN Container.DescId = zc_Container_Summ() 
                                          THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) AS EndSum
                           -- ������� ���
                              , SUM (CASE WHEN Container.DescId = zc_Container_count() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_Sale() 
                                           THEN  COALESCE (MIContainer.Amount, 0) 
                                           ELSE 0 
                                     END)                                                  AS AmountSale
                           -- ���-�� ��������
                              , SUM (CASE WHEN Container.DescId = zc_Container_count() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ReturnIn()
                                           THEN  COALESCE (MIContainer.Amount, 0) 
                                           ELSE 0 
                                      END)                                                 AS AmountReturnIn
                           -- ����� ������ � �������
                              , SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            AND MIContainer.isActive = FALSE AND MIContainer.MovementDescId = zc_Movement_Sale() 
                                           THEN (-1) * COALESCE (MIContainer.Amount, 0) 
                                           ELSE 0 
                                      END)                                                 AS SumPay
                           -- ����� �������
                              , SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                            AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_Sale()
                                           THEN COALESCE (MIContainer.Amount, 0) 
                                           ELSE 0
                                     END)  AS SumSale

                              -- ����� ������ ��������
                              , 0 AS SumPayReturnIn
                              -- ����� ��������
                              , 0 AS SumReturnIn
                         FROM Container
                              INNER JOIN ContainerLinkObject AS CLO_Client
                                                             ON CLO_Client.ContainerId = Container.Id
                                                            AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                            AND CLO_Client.ObjectId    = inPartnerId
                              LEFT JOIN ContainerLinkObject AS CLO_PartionMI
                                                            ON CLO_PartionMI.ContainerId = Container.Id
                                                           AND CLO_PartionMI.DescId = zc_ContainerLinkObject_PartionMI()
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.Containerid = Container.Id
                                                             AND MIContainer.OperDate >= inStartDate
                         WHERE (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                           AND Container.ObjectId <> zc_Enum_Account_20102()
                         GROUP BY Container.WhereObjectId 
                                , CLO_Client.ObjectId
                                , Container.PartionId
                                , CLO_PartionMI.ObjectId
                                , Container.Amount 
                                , Container.DescId
                         HAVING  (CASE WHEN Container.DescId = zc_Container_count() 
                                          THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END) <> 0
                             OR  (CASE WHEN Container.DescId = zc_Container_count() 
                                          THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) <> 0
                             OR  (CASE WHEN Container.DescId = zc_Container_Summ() 
                                          THEN Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) ELSE 0 END) <> 0
                             OR  (CASE WHEN Container.DescId = zc_Container_Summ() 
                                          THEN Container.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) ELSE 0 END) <> 0
                             OR SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND COALESCE (MIContainer.Amount, 0) > 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN  COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                             OR SUM (CASE WHEN Container.DescId = zc_Container_Summ() AND COALESCE (MIContainer.Amount, 0) < 0 AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate THEN (-1) * COALESCE (MIContainer.Amount, 0) ELSE 0 END) <> 0
                         ) 
                      
   , tmpContainer AS (SELECT tmp.UnitId
                           , tmp.PartnerId
                           , tmp.PartionId
                           , tmp.PartionMI_Id
                           , SUM (COALESCE (tmp.StartAmount,0))    AS CountDebt_Start
                           , SUM (COALESCE (tmp.StartSum,0))       AS SummDebt_Start
                           , SUM (COALESCE (tmp.EndAmount,0))      AS CountDebt_End
                           , SUM (COALESCE (tmp.EndSum,0))         AS SummDebt_End
                           , SUM (COALESCE (tmp.AmountSale,0))     AS AmountSale
                           , SUM (COALESCE (tmp.SumPay,0))         AS SumPay
                           , SUM (COALESCE (tmp.SumSale,0))        AS SumSale
                           , SUM (COALESCE (tmp.AmountReturnIn,0)) AS AmountReturnIn
                           , SUM (COALESCE (tmp.SumPayReturnIn,0)) AS SumPayReturnIn
                           , SUM (COALESCE (tmp.SumReturnIn,0))    AS SumReturnIn
                      FROM tmpContainer_All AS tmp 
                      GROUP BY tmp.UnitId
                             , tmp.PartnerId
                             , tmp.PartionId
                             , tmp.PartionMI_Id
                      )
                         
   , tmpDataPartion AS (SELECT Movement.Id              AS MovementId
                             , Movement.DescId          AS MovementDescId
                             , Movement.OperDate
                             , Movement.Invnumber
                             
                             , Movement_Sale.Id         AS MovementId_Sale
                             , Movement_Sale.DescId     AS MovementDescId_Sale
                             , Movement_Sale.OperDate   AS OperDate_Sale
                             , Movement_Sale.Invnumber  AS Invnumber_Sale
                             
                             , MovementItem.Id          AS MovementItemId
                             , MI_Sale.Id               AS MovementItemId_Sale
                             
                             , tmpContainer.PartnerId
                             , tmpContainer.PartionId
                             , MovementItem.Amount

                             , tmpContainer.CountDebt_Start
                             , tmpContainer.SummDebt_Start
                             , tmpContainer.CountDebt_End
                             , tmpContainer.SummDebt_End
                             , tmpContainer.AmountSale
                             , tmpContainer.AmountReturnIn
                             , tmpContainer.SumPay
                             , tmpContainer.SumSale
                             , tmpContainer.SumPayReturnIn
                             , tmpContainer.SumReturnIn
                        FROM tmpContainer
                         LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = tmpContainer.PartionMI_Id
                         LEFT JOIN MovementItem               ON MovementItem.Id     = Object_PartionMI.ObjectCode
                         LEFT JOIN Movement                   ON Movement.Id         = MovementItem.MovementId
                         
                         -- �������� ������ ������� ���� � ���������� ���� ������ ��������
                         LEFT JOIN MovementItemLinkObject AS MILO_PartionMI_Sale
                                                          ON MILO_PartionMI_Sale.MovementItemId = MovementItem.Id
                                                         AND MILO_PartionMI_Sale.DescId         = zc_MILinkObject_PartionMI()
                         LEFT JOIN Object AS Object_PartionMI_Sale   ON Object_PartionMI_Sale.Id = MILO_PartionMI_Sale.ObjectId
                         LEFT JOIN MovementItem AS MI_Sale           ON MI_Sale.Id               = Object_PartionMI_Sale.ObjectCode
                         LEFT JOIN Movement     AS Movement_Sale     ON Movement_Sale.Id         = MI_Sale.MovementId
                        )
                        
   , tmpData_All AS (SELECT tmpData.*
                          , COALESCE (MIFloat_ChangePercent.ValueData, 0)                                            AS ChangePercent
                          , COALESCE (MIFloat_OperPriceList.ValueData, 0)                                            AS OperPriceList
                          , CAST (tmpData.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 2)) AS TotalSummPriceList
                          , COALESCE (MIFloat_SummChangePercent.ValueData, 0)     AS SummChangePercent
                          , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)    AS TotalChangePercent
                          , COALESCE (MIFloat_TotalPay.ValueData, 0)              AS TotalPay
                          , COALESCE (MIFloat_TotalPayOth.ValueData, 0)           AS TotalPayOth
                          , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)      AS TotalCountReturn
                          , COALESCE (MIFloat_TotalReturn.ValueData, 0)           AS TotalReturn
                          , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)        AS TotalPayReturn
                          
                     FROM tmpDataPartion AS tmpData
                          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                      ON MIFloat_OperPriceList.MovementItemId = COALESCE (tmpData.MovementItemId_Sale, tmpData.MovementItemId)
                                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
     
                          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                      ON MIFloat_ChangePercent.MovementItemId = COALESCE (tmpData.MovementItemId_Sale, tmpData.MovementItemId)
                                                     AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()  
                          LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                      ON MIFloat_SummChangePercent.MovementItemId = COALESCE (tmpData.MovementItemId_Sale, tmpData.MovementItemId)
                                                     AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()         
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                      ON MIFloat_TotalChangePercent.MovementItemId = COALESCE (tmpData.MovementItemId_Sale, tmpData.MovementItemId)
                                                     AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
 
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                      ON MIFloat_TotalPay.MovementItemId = tmpData.MovementItemId
                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                      ON MIFloat_TotalPayOth.MovementItemId = tmpData.MovementItemId
                                                     AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                      ON MIFloat_TotalCountReturn.MovementItemId = tmpData.MovementItemId
                                                     AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()    
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                      ON MIFloat_TotalReturn.MovementItemId = tmpData.MovementItemId
                                                     AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()    
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                      ON MIFloat_TotalPayReturn.MovementItemId = tmpData.MovementItemId
                                                     AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay_Sale
                                                      ON MIFloat_TotalPay_Sale.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPay_Sale.DescId         = zc_MIFloat_TotalPay()    
                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth_Sale
                                                      ON MIFloat_TotalPayOth_Sale.MovementItemId = tmpData.MovementItemId_Sale
                                                     AND MIFloat_TotalPayOth_Sale.DescId         = zc_MIFloat_TotalPayOth()
                    )
                    
    
        SELECT tmpData.MovementId
             , MovementDesc.ItemName          AS DescName
             , tmpData.OperDate
             , tmpData.Invnumber
             
             , tmpData.MovementId_Sale
             , MovementDesc_Sale.ItemName     AS DescName_Sale
             , tmpData.OperDate_Sale
             , tmpData.Invnumber_Sale

             , Object_Partner.ValueData       AS PartnerName
             , tmpData.PartionId
             , Object_Goods.Id                AS GoodsId
             , Object_Goods.ObjectCode        AS GoodsCode
             , Object_Goods.ValueData         AS GoodsName
             , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_GoodsGroup.ValueData    AS GoodsGroupName
             , Object_Measure.ValueData       AS MeasureName
             , Object_Juridical.ValueData     AS JuridicalName
             , Object_CompositionGroup.ValueData   AS CompositionGroupName
             , Object_Composition.ValueData   AS CompositionName
             , Object_GoodsInfo.ValueData     AS GoodsInfoName
             , Object_LineFabrica.ValueData   AS LineFabricaName
             , Object_Label.ValueData         AS LabelName
             , Object_GoodsSize.Id            AS GoodsSizeId
             , Object_GoodsSize.ValueData     AS GoodsSizeName
             , Object_Currency.ValueData      AS CurrencyName
             , Object_Brand.ValueData         AS BrandName
             , Object_Fabrika.ValueData       AS FabrikaName
             , Object_Period.ValueData        AS PeriodName
             , Object_PartionGoods.PeriodYear ::Integer
               
             , tmpData.ChangePercent            ::TFloat
             , tmpData.OperPriceList            ::TFloat
             , tmpData.Amount                   ::TFloat
             , tmpData.TotalSummPriceList       ::TFloat
             , tmpData.SummChangePercent        ::TFloat
             , tmpData.TotalChangePercent       ::TFloat
             , tmpData.TotalPay                 ::TFloat
             , tmpData.TotalPayOth              ::TFloat

             , tmpData.CountDebt_Start          ::TFloat
             , tmpData.SummDebt_Start           ::TFloat
             , tmpData.CountDebt_End            ::TFloat
             , tmpData.SummDebt_End             ::TFloat
             , tmpData.AmountSale               ::TFloat
             , tmpData.SumPay                   ::TFloat
             , tmpData.SumSale                  ::TFloat 
             , tmpData.SumPayReturnIn           ::TFloat
             , tmpData.AmountReturnIn           ::TFloat
             , tmpData.SumReturnIn              ::TFloat 

        FROM tmpData_All AS tmpData
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
            LEFT JOIN MovementDesc AS MovementDesc_Sale ON MovementDesc_Sale.Id = tmpData.MovementDescId_Sale
            
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            
            LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId
            
            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = Object_PartionGoods.GoodsId 
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = Object_PartionGoods.JuridicalId
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId
            
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id 
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 22.08.17         *
*/

-- ����
--select * from gpReport_MotionByPartner(inStartDate := ('01.03.2017')::TDateTime , inEndDate := ('31.03.2017')::TDateTime , inUnitId := 4195 , inPartnerId := 9765 ,  inSession := '2');
-- Function:  gpReport_GoodsMI_Account()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_Account (TDateTime,TDateTime,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpReport_GoodsMI_Account (TDateTime,TDateTime,Integer,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_GoodsMI_Account(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inIsShowAll        Boolean  ,  -- Показывать все документы / только проведенные
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , StatusCode            Integer
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
             , SummChangePercent  TFloat
             , Amount           TFloat
             , TotalSummPriceList TFloat
             , TotalPay_Grn     TFloat
             , TotalPay_USD     TFloat
             , TotalPay_EUR     TFloat
             , TotalPay_Card    TFloat
             , TotalPay         TFloat
             , InsertDate       TDateTime
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- определяем магазин по принадлежности пользователя к сотруднику
    vbUnitId:= lpGetUnitBySession (inSession);
     
    -- если у пользователя = 0, тогда может смотреть любой магазин, иначе только свой
    IF COALESCE (vbUnitId, 0 ) <> 0 AND COALESCE (vbUnitId) <> inUnitId
    THEN
        RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав просмотра данных по подразделению <%> .', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (inUnitId);
    END IF;
     
    -- Результат
    RETURN QUERY
    WITH
    tmpStatus AS (SELECT tmp.StatusId              AS StatusId
                       , Object_Status.ObjectCode  AS StatusCode
                  FROM (SELECT zc_Enum_Status_Complete()   AS StatusId
                        UNION SELECT zc_Enum_Status_UnComplete() AS StatusId WHERE inIsShowAll = TRUE
                        ) AS tmp
                        LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmp.StatusId
                 )
  , tmpSale AS (SELECT Movement_Sale.Id                    AS MovementId
                     , zc_Movement_Sale()                  AS MovementDescId
                     , tmpStatus.StatusCode                AS StatusCode
                     , Movement_Sale.OperDate              AS OperDate
                     , Movement_Sale.Invnumber             AS Invnumber
                     , Movement_Sale.Id                    AS MovementId_Sale
                     , Movement_Sale.DescId                AS MovementDescId_Sale
                     , Movement_Sale.OperDate              AS OperDate_Sale
                     , Movement_Sale.Invnumber             AS Invnumber_Sale
                     , MovementLinkObject_To.ObjectId      AS PartnerId
                     , MI_Master.ObjectId                  AS GoodsId
                     , MI_Master.PartionId
                     , MI_Master.Id                        AS MI_Id
                     , COALESCE (MIFloat_ChangePercent.ValueData, 0)      AS ChangePercent
                     , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                     , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  AS SummChangePercent
                     , SUM (MI_Master.Amount)                             AS Amount
                     
                     , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_Grn
                     , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_USD
                     , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_EUR
                     , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_Card
                     , COALESCE (MIFloat_TotalPay.ValueData, 0)           AS TotalPay
                FROM Movement AS Movement_Sale
                     INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_Sale.StatusId
                     INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                  AND MovementLinkObject_From.ObjectId = inUnitId
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                     INNER JOIN MovementItem AS MI_Child
                                             ON MI_Child.MovementId = Movement_Sale.Id
                                            AND MI_Child.DescId     = zc_MI_Child()
                                            AND MI_Child.isErased   = FALSE
                                            AND MI_Child.Amount    <> 0
                     LEFT JOIN Object ON Object.Id = MI_Child.ObjectId
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                      ON MILinkObject_Currency.MovementItemId = MI_Child.Id
                                                     AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()    
                     LEFT JOIN MovementItem AS MI_Master
                                            ON MI_Master.Id         = MI_Child.ParentId
                                           AND MI_Master.DescId     = zc_MI_Master()
                                           AND MI_Master.isErased   = FALSE
                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                 ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                                 AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent() 
                     LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                 ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList() 
                     LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                 ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                     LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                 ON MIFloat_SummChangePercent.MovementItemId = MI_Master.Id
                                                AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()                                                  
                WHERE Movement_Sale.DescId = zc_Movement_Sale()
                  AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
                GROUP BY Movement_Sale.Id
                       , Movement_Sale.OperDate
                       , Movement_Sale.Invnumber 
                       , Movement_Sale.DescId
                       , tmpStatus.StatusCode
                       , MovementLinkObject_To.ObjectId
                       , MI_Master.ObjectId 
                       , MI_Master.PartionId
                       , MI_Master.Id
                       , COALESCE (MIFloat_ChangePercent.ValueData, 0)
                       , COALESCE (MIFloat_OperPriceList.ValueData, 0)
                       , COALESCE (MIFloat_TotalPay.ValueData, 0)
                       , COALESCE (MIFloat_SummChangePercent.ValueData, 0)
              )     

  , tmpReturnIn AS (SELECT Movement_ReturnIn.Id                AS MovementId
                         , zc_Movement_ReturnIn()              AS MovementDescId
                         , tmpStatus.StatusCode                AS StatusCode
                         , Movement_ReturnIn.OperDate          AS OperDate
                         , Movement_ReturnIn.Invnumber         AS Invnumber
                         , Movement_Sale.Id                    AS MovementId_Sale
                         , Movement_Sale.DescId                AS MovementDescId_Sale
                         , Movement_Sale.OperDate              AS OperDate_Sale
                         , Movement_Sale.Invnumber             AS Invnumber_Sale
                         , MovementLinkObject_From.ObjectId    AS PartnerId
                         , MI_Master.ObjectId                  AS GoodsId
                         , MI_Master.PartionId
                         , MI_Master.Id                        AS MI_Id
                         , COALESCE (MIFloat_ChangePercent.ValueData, 0)      AS ChangePercent
                         , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                         , COALESCE (MIFloat_SummChangePercent.ValueData, 0) * (-1)  AS SummChangePercent
                         
                         , SUM (MI_Master.Amount) * (-1)                      AS Amount
                         , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN (-1) * MI_Child.Amount ELSE 0 END) AS TotalPay_Grn
                         , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN (-1) * MI_Child.Amount ELSE 0 END) AS TotalPay_USD
                         , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN (-1) * MI_Child.Amount ELSE 0 END) AS TotalPay_EUR
                         , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN (-1) * MI_Child.Amount ELSE 0 END) AS TotalPay_Card
                         , (COALESCE (MIFloat_TotalPay.ValueData, 0)) * (-1)  AS TotalPay
                    FROM Movement AS Movement_ReturnIn
                         INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_ReturnIn.StatusId

                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement_ReturnIn.Id
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                      AND MovementLinkObject_To.ObjectId = inUnitId
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement_ReturnIn.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         INNER JOIN MovementItem AS MI_Child
                                                 ON MI_Child.MovementId = Movement_ReturnIn.Id
                                                AND MI_Child.DescId     = zc_MI_Child()
                                                AND MI_Child.isErased   = FALSE
                                                AND MI_Child.Amount    <> 0
                         LEFT JOIN Object ON Object.Id = MI_Child.ObjectId
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                          ON MILinkObject_Currency.MovementItemId = MI_Child.Id
                                                         AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()    
                         LEFT JOIN MovementItem AS MI_Master
                                                ON MI_Master.Id         = MI_Child.ParentId
                                               AND MI_Master.MovementId = Movement_ReturnIn.Id
                                               AND MI_Master.DescId     = zc_MI_Master()
                                               AND MI_Master.isErased   = FALSE   

                         LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                     ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                    AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList() 
                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                     ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                     
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                          ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                         AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI() 
                         LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                         LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                         LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId
                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                     ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                         LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                     ON MIFloat_SummChangePercent.MovementItemId = MI_Sale.Id
                                                    AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent() 
                    WHERE Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
                      AND Movement_ReturnIn.OperDate BETWEEN inStartDate AND inEndDate
                    GROUP BY Movement_ReturnIn.Id 
                           , Movement_ReturnIn.OperDate 
                           , Movement_ReturnIn.Invnumber 
                           , Movement_Sale.Id 
                           , Movement_Sale.DescId
                           , Movement_Sale.OperDate
                           , Movement_Sale.Invnumber
                           , tmpStatus.StatusCode
                           , MovementLinkObject_From.ObjectId
                           , MI_Master.ObjectId
                           , MI_Master.PartionId
                           , MI_Master.Id
                           , COALESCE (MIFloat_ChangePercent.ValueData, 0)
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)
                           , COALESCE (MIFloat_TotalPay.ValueData, 0)
                           , COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                  )
  , tmpGoodsAccount AS (SELECT Movement_GoodsAccount.Id            AS MovementId
                             , zc_Movement_GoodsAccount()          AS MovementDescId
                             , tmpStatus.StatusCode                AS StatusCode
                             , Movement_GoodsAccount.OperDate      AS OperDate
                             , Movement_GoodsAccount.Invnumber     AS Invnumber
                             , Movement_Sale.Id                    AS MovementId_Sale
                             , Movement_Sale.DescId                AS MovementDescId_Sale
                             , Movement_Sale.OperDate              AS OperDate_Sale
                             , Movement_Sale.Invnumber             AS Invnumber_Sale
                             , MovementLinkObject_From.ObjectId    AS PartnerId
                             , MI_Sale.ObjectId                    AS GoodsId
                             , MI_Sale.PartionId
                             , MI_Master.Id                        AS MI_Id
                             , COALESCE (MIFloat_ChangePercent.ValueData, 0)      AS ChangePercent
                             , COALESCE (MIFloat_OperPriceList.ValueData, 0)      AS OperPriceList
                             , COALESCE (MIFloat_SummChangePercent.ValueData, 0)  AS SummChangePercent
                             , SUM (MI_Master.Amount)                             AS Amount
                             , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_GRN() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_Grn
                             , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_USD() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_USD
                             , SUM (CASE WHEN Object.DescId = zc_Object_Cash() AND MILinkObject_Currency.ObjectId = zc_Currency_EUR() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_EUR
                             , SUM (CASE WHEN Object.DescId = zc_Object_BankAccount() THEN MI_Child.Amount ELSE 0 END) AS TotalPay_Card
                             , (COALESCE (MIFloat_TotalPay.ValueData, 0))         AS TotalPay
                        FROM Movement AS Movement_GoodsAccount
                             INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_GoodsAccount.StatusId

                             LEFT JOIN MovementItem AS MI_Master
                                                    ON MI_Master.MovementId = Movement_GoodsAccount.Id
                                                   AND MI_Master.DescId     = zc_MI_Master()
                                                   AND MI_Master.isErased = FALSE
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                              ON MILinkObject_PartionMI.MovementItemId = MI_Master.Id
                                                             AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI() 
                             LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                             LEFT JOIN MovementItem AS MI_Sale ON MI_Sale.Id = Object_PartionMI.ObjectCode
                             LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MI_Sale.MovementId
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From_Sale
                                                           ON MovementLinkObject_From_Sale.MovementId = Movement_Sale.Id
                                                          AND MovementLinkObject_From_Sale.DescId = CASE WHEN Movement_Sale.DescId = zc_Movement_Sale()
                                                                                                         THEN zc_MovementLinkObject_From()
                                                                                                         ELSE zc_MovementLinkObject_To()
                                                                                                    END 
                                                          AND MovementLinkObject_From_Sale.ObjectId = inUnitId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement_GoodsAccount.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                         ON MIFloat_OperPriceList.MovementItemId = MI_Sale.Id
                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList() 
                             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                         ON MIFloat_ChangePercent.MovementItemId = MI_Sale.Id
                                                         AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                         ON MIFloat_SummChangePercent.MovementItemId = MI_Sale.Id
                                                        AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()     
                                                                                                              
                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                         ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()    
                                                                                                             
                             INNER JOIN MovementItem AS MI_Child
                                                     ON MI_Child.MovementId = Movement_GoodsAccount.Id
                                                    AND MI_Child.DescId     = zc_MI_Child()
                                                    AND MI_Child.isErased   = FALSE
                                                    AND MI_Child.Amount    <> 0
                             LEFT JOIN Object ON Object.Id = MI_Child.ObjectId
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                              ON MILinkObject_Currency.MovementItemId = MI_Child.Id
                                                             AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()    

                        WHERE Movement_GoodsAccount.DescId = zc_Movement_GoodsAccount()
                          AND Movement_GoodsAccount.OperDate BETWEEN inStartDate AND inEndDate
                        GROUP BY Movement_GoodsAccount.Id 
                               , Movement_GoodsAccount.OperDate
                               , Movement_GoodsAccount.Invnumber
                               , Movement_Sale.Id
                               , Movement_Sale.DescId 
                               , Movement_Sale.OperDate
                               , Movement_Sale.Invnumber
                               , tmpStatus.StatusCode 
                               , MovementLinkObject_From.ObjectId
                               , MI_Sale.ObjectId
                               , MI_Sale.PartionId
                               , MI_Master.Id
                               , COALESCE (MIFloat_ChangePercent.ValueData, 0)
                               , COALESCE (MIFloat_OperPriceList.ValueData, 0)
                               , COALESCE (MIFloat_TotalPay.ValueData, 0)
                               , COALESCE (MIFloat_SummChangePercent.ValueData, 0)
                      )

     , tmpData  AS  (SELECT tmp.MovementId
                          , tmp.MovementDescId
                          , tmp.StatusCode
                          , tmp.OperDate
                          , tmp.Invnumber
                          , tmp.MovementId_Sale
                          , tmp.MovementDescId_Sale
                          , tmp.OperDate_Sale
                          , tmp.Invnumber_Sale
                          , tmp.PartnerId
                          , tmp.GoodsId
                          , tmp.PartionId
                          , tmp.ChangePercent
                          , tmp.OperPriceList
                          , SUM (tmp.SummChangePercent) AS SummChangePercent
                          , SUM (tmp.Amount)            AS Amount
                          , SUM (tmp.TotalPay_Grn)      AS TotalPay_Grn
                          , SUM (tmp.TotalPay_USD)      AS TotalPay_USD
                          , SUM (tmp.TotalPay_EUR)      AS TotalPay_EUR
                          , SUM (tmp.TotalPay_Card)     AS TotalPay_Card
                          , SUM (tmp.TotalPay)          AS TotalPay
                     FROM tmpSale AS tmp
                     GROUP BY tmp.MovementId
                            , tmp.MovementDescId
                            , tmp.StatusCode
                            , tmp.OperDate
                            , tmp.Invnumber
                            , tmp.MovementId_Sale
                            , tmp.MovementDescId_Sale
                            , tmp.OperDate_Sale
                            , tmp.Invnumber_Sale
                            , tmp.PartnerId
                            , tmp.GoodsId
                            , tmp.PartionId
                            , tmp.ChangePercent
                            , tmp.OperPriceList
                   UNION ALL
                     SELECT tmp.MovementId
                          , tmp.MovementDescId
                          , tmp.StatusCode
                          , tmp.OperDate
                          , tmp.Invnumber
                          , tmp.MovementId_Sale
                          , tmp.MovementDescId_Sale
                          , tmp.OperDate_Sale
                          , tmp.Invnumber_Sale
                          , tmp.PartnerId
                          , tmp.GoodsId
                          , tmp.PartionId
                          , tmp.ChangePercent
                          , tmp.OperPriceList
                          , SUM (tmp.SummChangePercent) AS SummChangePercent
                          , SUM (tmp.Amount)            AS Amount
                          , SUM (tmp.TotalPay_Grn)      AS TotalPay_Grn
                          , SUM (tmp.TotalPay_USD)      AS TotalPay_USD
                          , SUM (tmp.TotalPay_EUR)      AS TotalPay_EUR
                          , SUM (tmp.TotalPay_Card)     AS TotalPay_Card
                          , SUM (tmp.TotalPay)          AS TotalPay
                     FROM tmpReturnIn AS tmp
                     GROUP BY tmp.MovementId
                            , tmp.MovementDescId
                            , tmp.StatusCode
                            , tmp.OperDate
                            , tmp.Invnumber
                            , tmp.MovementId_Sale
                            , tmp.MovementDescId_Sale
                            , tmp.OperDate_Sale
                            , tmp.Invnumber_Sale
                            , tmp.PartnerId
                            , tmp.GoodsId
                            , tmp.PartionId
                            , tmp.ChangePercent
                            , tmp.OperPriceList
                   UNION ALL
                     SELECT tmp.MovementId
                          , tmp.MovementDescId
                          , tmp.StatusCode
                          , tmp.OperDate
                          , tmp.Invnumber
                          , tmp.MovementId_Sale
                          , tmp.MovementDescId_Sale
                          , tmp.OperDate_Sale
                          , tmp.Invnumber_Sale
                          , tmp.PartnerId
                          , tmp.GoodsId
                          , tmp.PartionId
                          , tmp.ChangePercent
                          , tmp.OperPriceList
                          , SUM (tmp.SummChangePercent) AS SummChangePercent
                          , SUM (tmp.Amount)            AS Amount
                          , SUM (tmp.TotalPay_Grn)      AS TotalPay_Grn
                          , SUM (tmp.TotalPay_USD)      AS TotalPay_USD
                          , SUM (tmp.TotalPay_EUR)      AS TotalPay_EUR
                          , SUM (tmp.TotalPay_Card)     AS TotalPay_Card
                          , SUM (tmp.TotalPay)          AS TotalPay
                     FROM tmpGoodsAccount AS tmp
                     GROUP BY tmp.MovementId
                            , tmp.MovementDescId
                            , tmp.StatusCode
                            , tmp.OperDate
                            , tmp.Invnumber
                            , tmp.MovementId_Sale
                            , tmp.MovementDescId_Sale
                            , tmp.OperDate_Sale
                            , tmp.Invnumber_Sale
                            , tmp.PartnerId
                            , tmp.GoodsId
                            , tmp.PartionId
                            , tmp.ChangePercent
                            , tmp.OperPriceList
                    )
            

        SELECT tmpData.MovementId
             , tmpData.StatusCode             AS StatusCode
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
               
             , tmpData.ChangePercent       ::TFloat
             , tmpData.OperPriceList       ::TFloat
             , tmpData.SummChangePercent   ::TFloat
             , tmpData.Amount              ::TFloat
             , (tmpData.OperPriceList * tmpData.Amount) ::TFloat AS TotalSummPriceList
             , tmpData.TotalPay_Grn        ::TFloat
             , tmpData.TotalPay_USD        ::TFloat
             , tmpData.TotalPay_EUR        ::TFloat
             , tmpData.TotalPay_Card       ::TFloat
             , tmpData.TotalPay            ::TFloat
             , MovementDate_Insert.ValueData        AS InsertDate
        FROM tmpData
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData.MovementDescId
            LEFT JOIN MovementDesc AS MovementDesc_Sale ON MovementDesc_Sale.Id = tmpData.MovementDescId_Sale
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpData.GoodsId
            
            LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId  
             
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
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = tmpData.MovementId
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 04.07.17         *
*/

-- тест
-- select * from gpReport_GoodsMI_Account(inStartDate := ('01.01.2017')::TDateTime , inEndDate := ('13.07.2017')::TDateTime , inUnitId := 506 , inIsShowAll:= 'TRUE'::Boolean, inSession := '2');
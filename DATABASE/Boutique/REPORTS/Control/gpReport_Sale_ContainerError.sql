-- Function:  gpReport_Sale_ContainerError()

DROP FUNCTION IF EXISTS gpReport_Sale_ContainerError (TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Sale_ContainerError (
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , OperDate              TDateTime
             , Invnumber             TVarChar
             , PartionId             Integer
             , OperDate_Partion      TDateTime
             , Invnumber_Partion     TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar
             , LabelName        TVarChar
             , GoodsSizeName    TVarChar
             , SummDebt_Sale       TFloat
             , SummDebt_Container  TFloat
             , CountDebt_Sale      TFloat
             , CountDebt_Container TFloat           

             , Amount                TFloat
             , ChangePercent         TFloat
             , ChangePercentNext     TFloat
             , OperPriceList         TFloat
             , TotalSummPriceList    TFloat
             , SummChangePercent     TFloat
             , TotalChangePercent    TFloat
             , TotalChangePercentPay TFloat
             , TotalPay              TFloat
             , TotalPayOth           TFloat
             , TotalCountReturn      TFloat
             , TotalReturn           TFloat
             , TotalPayReturn        TFloat

  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
    -- товары по которым есть долги
    tmpSaleMI AS (SELECT MI_Master.ObjectId                  AS GoodsId
                       , MI_Master.PartionId                 AS PartionId
                       , MI_Master.Id                        AS MI_Id

                       , SUM (MI_Master.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData, 0) ) AS CountDebt
                       , SUM (zfCalc_SummPriceList (MI_Master.Amount - COALESCE(MIFloat_TotalCountReturn.ValueData,0), MIFloat_OperPriceList.ValueData)
                                 - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                 - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                 - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                 - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                   -- Возврат
                                 + COALESCE (MIFloat_TotalReturn.ValueData, 0)
                                 + COALESCE (MIFloat_TotalPayReturn.ValueData, 0))   AS SummDebt
                       
                  FROM Movement AS Movement_Sale
  
                       INNER JOIN MovementItem AS MI_Master
                                               ON MI_Master.MovementId = Movement_Sale.Id
                                              AND MI_Master.DescId     = zc_MI_Master()
                                              AND MI_Master.isErased   = FALSE
                                              AND MI_Master.Amount    <> 0

                       LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                   ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                                  AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList() 
                       LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                   ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                                  AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
  
                       LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                   ON MIFloat_SummChangePercent.MovementItemId = MI_Master.Id
                                                  AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()         
                       LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                   ON MIFloat_TotalChangePercent.MovementItemId = MI_Master.Id
                                                  AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
                       LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                   ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Master.Id
                                                  AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()    
                       LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                   ON MIFloat_TotalPayOth.MovementItemId = MI_Master.Id
                                                  AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
                       LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                   ON MIFloat_TotalCountReturn.MovementItemId = MI_Master.Id
                                                  AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()    
                       LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                   ON MIFloat_TotalReturn.MovementItemId = MI_Master.Id
                                                  AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()    
                       LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                   ON MIFloat_TotalPayReturn.MovementItemId = MI_Master.Id
                                                  AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()  
                  WHERE Movement_Sale.DescId = zc_Movement_Sale()
                    AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                  GROUP BY MI_Master.ObjectId
                         , MI_Master.Id
                         , MI_Master.PartionId
                  HAVING 0 <> SUM (zfCalc_SummPriceList (MI_Master.Amount - COALESCE(MIFloat_TotalCountReturn.ValueData,0), MIFloat_OperPriceList.ValueData)
                                 - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                 - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                 - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                 - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                   -- Возврат
                                 + COALESCE (MIFloat_TotalReturn.ValueData, 0)
                                 + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)) 
                  )     
  -- долги из проводок
  , tmpContainer AS (SELECT  Object_PartionMI.ObjectCode ::Integer AS MI_Id
                              , Container.PartionId
                              , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.GoodsId ELSE CLO_Goods.ObjectId END  AS GoodsId

                               , SUM (CASE WHEN Container.DescId = zc_Container_Count() THEN Container.Amount ELSE 0 END )  AS CountDebt
                               , SUM (CASE WHEN Container.DescId = zc_Container_Summ()  THEN Container.Amount ELSE 0 END )  AS SummDebt
                         FROM 
                             (SELECT Container.Id
                                   , Container.PartionId 
                                   , Container.ObjectId     AS GoodsId
                                   , Container.DescId
                                   , SUM (Container.Amount) AS Amount
                              FROM Container
                              WHERE Container.ObjectId <> zc_Enum_Account_20102()
                              GROUP BY Container.Id
                                     , Container.PartionId 
                                     , Container.ObjectId 
                                     , Container.DescId
                              HAVING SUM (Container.Amount)<> 0
                              ) AS Container
 
                              INNER JOIN ContainerLinkObject AS CLO_PartionMI
                                                             ON CLO_PartionMI.ContainerId = Container.Id
                                                            AND CLO_PartionMI.DescId = zc_ContainerLinkObject_PartionMI() 

                              LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                            ON CLO_Goods.ContainerId = Container.Id
                                                           AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()

                              LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = CLO_PartionMI.ObjectId 
                         GROUP BY Object_PartionMI.ObjectCode
                                , Container.PartionId
                                , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.GoodsId ELSE CLO_Goods.ObjectId END
                     )
  -- определяем документы, товары, по которым долги исходя из данных документа отличаются от долгов по проводкам
  , tmpData AS (SELECT COALESCE (tmpContainer.MI_Id, tmpSaleMI.MI_Id)           AS MI_Id
                     , COALESCE (tmpContainer.PartionId, tmpSaleMI.PartionId)   AS PartionId
                     , COALESCE (tmpContainer.GoodsId, tmpSaleMI.PartionId)     AS GoodsId
                     , SUM (COALESCE (tmpSaleMI.SummDebt,0))                    AS SummDebt_Sale
                     , SUM (COALESCE (tmpContainer.SummDebt,0))                 AS SummDebt_Container
                     , SUM (COALESCE (tmpSaleMI.CountDebt,0))                   AS CountDebt_Sale
                     , SUM (COALESCE (tmpContainer.CountDebt,0))                AS CountDebt_Container
                FROM tmpContainer
                     FULL JOIN tmpSaleMI ON tmpSaleMI.MI_Id      = tmpContainer.MI_Id
                                        AND tmpSaleMI.PartionId  = tmpContainer.PartionId
                                        AND tmpSaleMI.GoodsId    = tmpContainer.GoodsId
                GROUP BY COALESCE (tmpContainer.MI_Id, tmpSaleMI.MI_Id)
                       , COALESCE (tmpContainer.PartionId, tmpSaleMI.PartionId)
                       , COALESCE (tmpContainer.GoodsId, tmpSaleMI.PartionId)
                HAVING SUM(COALESCE (tmpSaleMI.SummDebt,0))  <> SUM(COALESCE (tmpContainer.SummDebt,0))
                    OR SUM(COALESCE (tmpSaleMI.CountDebt,0)) <> SUM(COALESCE (tmpContainer.CountDebt,0))
               )

  , tmpMI_Float AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData.MI_Id FROM tmpData)
                   )

        SELECT Movement.Id
             , Movement.OperDate
             , Movement.Invnumber
             
             , tmpData.PartionId
             , Object_PartionGoods.OperDate   AS OperDate_Partion
             , Movement_Partion.Invnumber     AS Invnumber_Partion
             , Object_Goods.Id                AS GoodsId
             , Object_Goods.ObjectCode        AS GoodsCode
             , Object_Goods.ValueData         AS GoodsName
             
             , Object_GoodsGroup.ValueData    AS GoodsGroupName
             , Object_Label.ValueData         AS LabelName
             , Object_GoodsSize.ValueData     AS GoodsSizeName
               
               
             , tmpData.SummDebt_Sale       ::TFloat
             , tmpData.SummDebt_Container  ::TFloat
             , tmpData.CountDebt_Sale      ::TFloat
             , tmpData.CountDebt_Container ::TFloat

             , MI_Master.Amount                                     ::TFloat AS Amount
             , COALESCE (MIFloat_ChangePercent.ValueData, 0)        ::TFloat AS ChangePercent
             , COALESCE (MIFloat_ChangePercentNext.ValueData, 0)    ::TFloat AS ChangePercentNext
             , COALESCE (MIFloat_OperPriceList.ValueData, 0)        ::TFloat AS OperPriceList
             , (MI_Master.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0)) ::TFloat AS TotalSummPriceList
             , COALESCE (MIFloat_SummChangePercent.ValueData, 0)    ::TFloat AS SummChangePercent
             , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)   ::TFloat AS TotalChangePercent
             , COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)::TFloat AS TotalChangePercentPay
             , COALESCE (MIFloat_TotalPay.ValueData, 0)             ::TFloat AS TotalPay
             , COALESCE (MIFloat_TotalPayOth.ValueData, 0)          ::TFloat AS TotalPayOth
             , COALESCE (MIFloat_TotalCountReturn.ValueData, 0)     ::TFloat AS TotalCountReturn
             , COALESCE (MIFloat_TotalReturn.ValueData, 0)          ::TFloat AS TotalReturn
             , COALESCE (MIFloat_TotalPayReturn.ValueData, 0)       ::TFloat AS TotalPayReturn
                                                                    
        FROM tmpData
            LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id = tmpData.MI_Id
            LEFT JOIN Movement ON Movement.Id = MI_Master.MovementId
            
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpData.GoodsId

            LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId  
            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = Object_PartionGoods.MovementId
             
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId

            -- свойства строки документа
            -- все float
            LEFT JOIN tmpMI_Float AS MIFloat_ChangePercent
                                  ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                 AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
            LEFT JOIN tmpMI_Float AS MIFloat_ChangePercentNext
                                  ON MIFloat_ChangePercentNext.MovementItemId = MI_Master.Id
                                 AND MIFloat_ChangePercentNext.DescId         = zc_MIFloat_ChangePercentNext() 
            LEFT JOIN tmpMI_Float AS MIFloat_OperPriceList
                                  ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                 AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList() 
            LEFT JOIN tmpMI_Float AS MIFloat_TotalPay
                                  ON MIFloat_TotalPay.MovementItemId = MI_Master.Id
                                 AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

            LEFT JOIN tmpMI_Float AS MIFloat_SummChangePercent
                                  ON MIFloat_SummChangePercent.MovementItemId = MI_Master.Id
                                 AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()         
            LEFT JOIN tmpMI_Float AS MIFloat_TotalChangePercent
                                  ON MIFloat_TotalChangePercent.MovementItemId = MI_Master.Id
                                 AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()    
            LEFT JOIN tmpMI_Float AS MIFloat_TotalChangePercentPay
                                  ON MIFloat_TotalChangePercentPay.MovementItemId = MI_Master.Id
                                 AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()    
            LEFT JOIN tmpMI_Float AS MIFloat_TotalPayOth
                                  ON MIFloat_TotalPayOth.MovementItemId = MI_Master.Id
                                 AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()    
            LEFT JOIN tmpMI_Float AS MIFloat_TotalCountReturn
                                  ON MIFloat_TotalCountReturn.MovementItemId = MI_Master.Id
                                 AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()    
            LEFT JOIN tmpMI_Float AS MIFloat_TotalReturn
                                  ON MIFloat_TotalReturn.MovementItemId = MI_Master.Id
                                 AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()    
            LEFT JOIN tmpMI_Float AS MIFloat_TotalPayReturn
                                  ON MIFloat_TotalPayReturn.MovementItemId = MI_Master.Id
                                 AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
--limit 10
--where 1=0
;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.01.18         *
*/

-- тест
-- select * from gpReport_Sale_ContainerError (inSession := '2');
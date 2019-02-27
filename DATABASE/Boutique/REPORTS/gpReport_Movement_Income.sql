-- Function:  gpReport_Movement_Income()

DROP FUNCTION IF EXISTS gpReport_Movement_Income (TDateTime, TDateTime, Integer,Integer,Integer,Boolean, Boolean,Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Income (TDateTime, TDateTime, Integer,Integer,Integer, Integer,Integer,Integer,Boolean, Boolean,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Income(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inUnitId           Integer  ,  -- �������������
    IN inBrandId          Integer  ,  -- �����
    IN inPartnerId        Integer  ,  -- ���������

    IN inPeriodId         Integer  ,  --
    IN inStartYear        Integer  ,  --
    IN inEndYear          Integer  ,  --

    IN inisPartion        Boolean,    --
    IN inisSize           Boolean,    --
    IN inisPartner        Boolean,    --
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId     Integer,
               InvNumber      TVarChar,
               OperDate       TDateTime,
               DescName       TVarChar,
               FromName       TVarChar,
               ToName         TVarChar,
               BrandName      TVarChar,
               FabrikaName    TVarChar,
               PeriodName     TVarChar,
               PeriodYear     Integer,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar,
               JuridicalName TVarChar,
               CompositionGroupName TVarChar,
               CompositionName TVarChar,
               GoodsInfoName TVarChar,
               LineFabricaName TVarChar,
               LabelName TVarChar,
               GoodsSizeId Integer, GoodsSizeName TVarChar,
               GoodsSizeName_real TVarChar,
               CurrencyName  TVarChar,

               OperPrice              TFloat,
               CountForPrice          TFloat, -- 
               OperPriceBalance       TFloat, -- ���� ��. (���)
               PriceJur               TFloat, -- ���� ��. ��� ��.
               OperPriceList          TFloat, -- ���� �� ������ � ���������
               OperPriceListLast      TFloat, -- ���� �� ������ �� ������� !!!��!!! zc_DateEnd
               Amount                 TFloat, -- ���-�� ������ �� ����������

               TotalSumm              TFloat, -- ����� �� ������� ����� � ������
               TotalSummBalance       TFloat, -- ����� �� ������� ����� � ���
               TotalSummPriceJur      TFloat, -- ����� ��. ��� ������
               TotalSummPriceList     TFloat, -- ����� �� ������ � ���������
               TotalSummPriceListLast TFloat, -- ����� �� ������ �� ������� !!!��!!! zc_DateEnd

               Remains                TFloat, -- ���-�� - ������� � ��������
               RemainsDebt            TFloat, -- ���-�� - ����� �� ��������
               RemainsAll             TFloat, -- ����� ������� ���-�� �� �������� � ������ �����
                                      
               RemainsTotal           TFloat, -- ���-�� - ������� �� ���� ���������
               RemainsDebtTotal       TFloat, -- ���-�� - ����� �� ���� ���������
               RemainsAllTotal        TFloat, -- ����� ������� ���-�� �� ���� ��������� � ������ �����
                                      
               SummRemainsIn          TFloat, -- ����� �� ������� ����� � ������ - ������� �� �������� � ������ �����
               SummRemains            TFloat, -- ����� �� ������ - ������� �� �������� � ������ �����
               CurrencyValue          TFloat, -- ���� �� ��������� <������ �� ����������>
               ParValue               TFloat, -- ������� �� ��������� <������ �� ����������>

               PriceTax               TFloat,  -- 1) % ������� ��� ���� ������ �� ��� 
               PriceTaxLast           TFloat,  -- 2) % ������� ��� ���� ������ �������

               ChangePercent          TFloat,
               Comment                TVarChar


  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!������!!!
    IF inIsPartion = TRUE THEN
       inIsPartner:= TRUE;
       -- inIsSize   := TRUE;
    END IF;
    -- !!!������!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;


    -- ���������
    RETURN QUERY
    WITH
     tmpMovementIncome AS ( SELECT Movement_Income.Id AS MovementId
                                 , CASE WHEN inIsPartion = TRUE THEN MovementDesc_Income.ItemName ELSE CAST (NULL AS TVarChar)  END    AS DescName
                                 , CASE WHEN inIsPartion = TRUE THEN Movement_Income.InvNumber    ELSE CAST (NULL AS TVarChar)  END    AS InvNumber
                                 , CASE WHEN inIsPartion = TRUE THEN Movement_Income.OperDate     ELSE CAST (NULL AS TDateTime) END    AS OperDate
                                 , CASE WHEN inisPartner = TRUE THEN MovementLinkObject_From.ObjectId ELSE 0 END                       AS FromId
                                 , MovementLinkObject_To.ObjectId                                                                      AS ToId
                                 , ObjectLink_Partner_Brand.ChildObjectId                                                              AS BrandId
                                 , ObjectLink_Partner_Fabrika.ChildObjectId                                                            AS FabrikaId
                                 , ObjectLink_Partner_Period.ChildObjectId                                                             AS PeriodId

                                 , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                                                 AS CurrencyValue
                                 , COALESCE (MovementFloat_ParValue.ValueData, 0)                                                      AS ParValue

                                 , MS_Comment.ValueData                        AS Comment
                                 , COALESCE (MF_ChangePercent.ValueData, 0)    AS ChangePercent
                            FROM Movement AS Movement_Income
                                 -- ���� ��� ������
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                 -- �� ���� ������    ���������
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                 -- �����
                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Brand
                                                       ON ObjectLink_Partner_Brand.ObjectId = MovementLinkObject_From.ObjectId
                                                      AND ObjectLink_Partner_Brand.DescId = zc_ObjectLink_Partner_Brand()

                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                                      ON ObjectLink_Partner_Fabrika.ObjectId = MovementLinkObject_From.ObjectId
                                                     AND ObjectLink_Partner_Fabrika.DescId = zc_ObjectLink_Partner_Fabrika()

                                 LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                                      ON ObjectLink_Partner_Period.ObjectId = MovementLinkObject_From.ObjectId
                                                     AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()

                                 LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                                         ON MovementFloat_ParValue.MovementId = Movement_Income.Id
                                                        AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                                 LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                                         ON MovementFloat_CurrencyValue.MovementId = Movement_Income.Id
                                                        AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

                                 LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId

                                 LEFT JOIN MovementString AS MS_Comment 
                                                          ON MS_Comment.MovementId = Movement_Income.Id
                                                         AND MS_Comment.DescId = zc_MovementString_Comment()
                                                         AND inisPartion = TRUE
                                 LEFT JOIN MovementFloat AS MF_ChangePercent
                                                         ON MF_ChangePercent.MovementId = Movement_Income.Id
                                                        AND MF_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                                        AND inisPartion = TRUE

                            WHERE Movement_Income.DescId = zc_Movement_Income()
                              AND Movement_Income.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                              AND (MovementLinkObject_From.ObjectId        = inPartnerId OR inPartnerId = 0)
                              AND (MovementLinkObject_To.ObjectId          = inUnitId    OR inUnitId    = 0)
                              AND (ObjectLink_Partner_Brand.ChildObjectId  = inBrandId   OR inBrandId   = 0)
                              AND (ObjectLink_Partner_Period.ChildObjectId = inPeriodId  OR inPeriodId  = 0)
                          )

   , tmpData_Partion  AS  (SELECT CASE WHEN inIsPartion = TRUE THEN tmpMovementIncome.MovementId ELSE -1 END  AS MovementId
                                , tmpMovementIncome.InvNumber
                                , tmpMovementIncome.OperDate
                                , tmpMovementIncome.DescName
                                , tmpMovementIncome.FromId
                                , tmpMovementIncome.ToId
                                , tmpMovementIncome.BrandId
                                , tmpMovementIncome.FabrikaId
                                , tmpMovementIncome.PeriodId
                                , MI_Income.PartionId
                                , MI_Income.ObjectId             AS GoodsId
                                , Object_PartionGoods.GoodsSizeId
                                , Object_PartionGoods.MeasureId
                                , Object_PartionGoods.GoodsGroupId
                                , Object_PartionGoods.CompositionId
                                , Object_PartionGoods.CompositionGroupId
                                , Object_PartionGoods.GoodsInfoId
                                , Object_PartionGoods.LineFabricaId
                                , Object_PartionGoods.LabelId
                                , Object_PartionGoods.JuridicalId
                                , Object_PartionGoods.CurrencyId
                                , Object_PartionGoods.PeriodYear
        
                                , tmpMovementIncome.Comment
                                , tmpMovementIncome.ChangePercent

                                , tmpMovementIncome.CurrencyValue
                                , tmpMovementIncome.ParValue
        
                                , COALESCE (MIFloat_CountForPrice.ValueData, 1)       AS CountForPrice
                                , SUM (COALESCE (MI_Income.Amount, 0))                AS Amount
                                , SUM (zfCalc_SummIn (MI_Income.Amount, MIFloat_OperPrice.ValueData, MIFloat_CountForPrice.ValueData)) AS TotalSumm
                                , SUM (zfCalc_SummIn (MI_Income.Amount, MIFloat_PriceJur.ValueData, MIFloat_CountForPrice.ValueData))  AS TotalSummPriceJur
                                , SUM (zfCalc_SummPriceList (MI_Income.Amount, MIFloat_OperPriceList.ValueData))                       AS TotalSummPriceList
                                , SUM (zfCalc_SummPriceList (MI_Income.Amount, Object_PartionGoods.OperPriceList))                     AS TotalSummPriceListLast
        
                           FROM tmpMovementIncome
                                INNER JOIN MovementItem AS MI_Income
                                                        ON MI_Income.MovementId = tmpMovementIncome.MovementId
                                                       AND MI_Income.isErased   = False
                                INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MI_Income.PartionId
        
                                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                            ON MIFloat_CountForPrice.MovementItemId = MI_Income.Id
                                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                            ON MIFloat_OperPrice.MovementItemId = MI_Income.Id
                                                           AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MI_Income.Id
                                                           AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceJur
                                                            ON MIFloat_PriceJur.MovementItemId = MI_Income.Id
                                                           AND MIFloat_PriceJur.DescId         = zc_MIFloat_PriceJur()
                           WHERE (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                           GROUP BY tmpMovementIncome.MovementId
                                  , tmpMovementIncome.InvNumber
                                  , tmpMovementIncome.OperDate
                                  , tmpMovementIncome.DescName
                                  , tmpMovementIncome.FromId
                                  , tmpMovementIncome.ToId
                                  , tmpMovementIncome.CurrencyValue
                                  , tmpMovementIncome.ParValue
                                  , MI_Income.ObjectId
                                  , Object_PartionGoods.GoodsSizeId
                                  , Object_PartionGoods.MeasureId
                                  , Object_PartionGoods.GoodsGroupId
                                  , Object_PartionGoods.CompositionId
                                  , Object_PartionGoods.CompositionGroupId
                                  , Object_PartionGoods.GoodsInfoId
                                  , Object_PartionGoods.LineFabricaId
                                  , Object_PartionGoods.LabelId
                                  , Object_PartionGoods.JuridicalId
                                  , COALESCE (MIFloat_CountForPrice.ValueData, 1)
                                  , tmpMovementIncome.BrandId
                                  , tmpMovementIncome.FabrikaId
                                  , tmpMovementIncome.PeriodId
                                  , Object_PartionGoods.CurrencyId
                                  , Object_PartionGoods.PeriodYear
                                  , MI_Income.PartionId
                                  , tmpMovementIncome.Comment
                                  , tmpMovementIncome.ChangePercent
                    )
 
   , tmpContainer AS (SELECT Container.PartionId              AS PartionId
                           , Container.ObjectId               AS GoodsId
                           , Container.WhereObjectId          AS UnitId
                           , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN Container.Amount ELSE 0 END) AS Remains
                           , SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN Container.Amount ELSE 0 END) AS RemainsDebt
                           , SUM (Container.Amount)                                                          AS RemainsAll

                      FROM Container
                           INNER JOIN (SELECT DISTINCT tmpData_Partion.GoodsId, tmpData_Partion.PartionId
                                       FROM tmpData_Partion
                                       ) AS tmp ON tmp.PartionId = Container.PartionId
                                               AND tmp.GoodsId   = Container.ObjectId

                           LEFT JOIN ContainerLinkObject AS CLO_Client
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()

                      WHERE Container.DescId = zc_Container_Count()
                      --  AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                        AND (Container.Amount <> 0)
                      GROUP BY Container.PartionId
                             , Container.ObjectId
                             , Container.WhereObjectId
                     )
,tmpContainer_sum AS (SELECT tmpContainer.PartionId
                           , tmpContainer.GoodsId
                           , SUM (tmpContainer.Remains)       AS Remains
                           , SUM (tmpContainer.RemainsDebt)   AS RemainsDebt
                           , SUM (tmpContainer.RemainsAll)    AS RemainsAll
                      FROM tmpContainer
                      GROUP BY tmpContainer.PartionId
                             , tmpContainer.GoodsId
                     )

    , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmp.MovementId ELSE -1 END  AS MovementId 
                       , tmp.InvNumber
                       , tmp.OperDate
                       , tmp.DescName
                       , tmp.FromId
                       , tmp.ToId
                       , tmp.BrandId
                       , tmp.FabrikaId
                       , tmp.PeriodId
                       , tmp.GoodsId
                       , CASE WHEN inisSize = TRUE THEN tmp.GoodsSizeId ELSE 0 END              AS GoodsSizeId
                       , CASE WHEN inIsSize  = TRUE THEN Object_GoodsSize.ValueData ELSE '' END AS GoodsSizeName_real
                       , STRING_AGG (Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData)  AS GoodsSizeName
                       , tmp.MeasureId
                       , tmp.GoodsGroupId
                       , tmp.CompositionId
                       , tmp.CompositionGroupId
                       , tmp.GoodsInfoId
                       , tmp.LineFabricaId
                       , tmp.LabelId
                       , tmp.JuridicalId
                       , tmp.CurrencyId
                       , tmp.PeriodYear
                       , tmp.CurrencyValue
                       , tmp.ParValue
                       , tmp.CountForPrice
                       , tmp.Comment
                       , tmp.ChangePercent
                       , SUM (tmp.Amount)                  AS Amount
                       , SUM (tmp.TotalSumm)               AS TotalSumm
                       , SUM (tmp.TotalSummPriceJur)       AS TotalSummPriceJur
                       , SUM (tmp.TotalSummPriceList)      AS TotalSummPriceList
                       , SUM (tmp.TotalSummPriceListLast)  AS TotalSummPriceListLast

                       , SUM (COALESCE (tmpContainer.Remains, 0))         AS Remains
                       , SUM (COALESCE (tmpContainer.RemainsDebt, 0))     AS RemainsDebt
                       , SUM (COALESCE (tmpContainer.RemainsAll, 0))      AS RemainsAll

                       , SUM (COALESCE (tmpContainer_sum.Remains, 0))     AS RemainsTotal
                       , SUM (COALESCE (tmpContainer_sum.RemainsDebt, 0)) AS RemainsDebtTotal
                       , SUM (COALESCE (tmpContainer_sum.RemainsAll, 0))  AS RemainsAllTotal

                  FROM tmpData_Partion AS tmp
                       LEFT JOIN tmpContainer ON tmpContainer.GoodsId    = tmp.GoodsId
                                             AND tmpContainer.PartionId  = tmp.PartionId
                                             AND tmpContainer.UnitId     = tmp.ToId
                       LEFT JOIN tmpContainer_sum ON tmpContainer_sum.GoodsId    = tmp.GoodsId
                                                 AND tmpContainer_sum.PartionId  = tmp.PartionId

                       LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmp.GoodsSizeId

                  GROUP BY CASE WHEN inIsPartion = TRUE THEN tmp.MovementId ELSE -1 END
                         , tmp.InvNumber
                         , tmp.OperDate
                         , tmp.DescName
                         , tmp.FromId
                         , tmp.ToId
                         , tmp.BrandId
                         , tmp.FabrikaId
                         , tmp.PeriodId
                         , tmp.GoodsId
                         , CASE WHEN inisSize = TRUE THEN tmp.GoodsSizeId ELSE 0 END
                         , CASE WHEN inIsSize  = TRUE THEN Object_GoodsSize.ValueData ELSE '' END
                         , tmp.MeasureId
                         , tmp.GoodsGroupId
                         , tmp.CompositionId
                         , tmp.CompositionGroupId
                         , tmp.GoodsInfoId
                         , tmp.LineFabricaId
                         , tmp.LabelId
                         , tmp.JuridicalId
                         , tmp.CurrencyId
                         , tmp.PeriodYear
                         , tmp.CurrencyValue
                         , tmp.ParValue
                         , tmp.CountForPrice
                         , tmp.Comment
                         , tmp.ChangePercent
                  )

        SELECT
             tmpData.MovementId
           , tmpData.InvNumber
           , tmpData.OperDate
           , tmpData.DescName
           , Object_From.ValueData          AS FromName
           , Object_To.ValueData            AS ToName

           , Object_Brand.ValueData         AS BrandName
           , Object_Fabrika.ValueData       AS FabrikaName
           , Object_Period.ValueData        AS PeriodName
           , tmpData.PeriodYear

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
           , tmpData.GoodsSizeId            AS GoodsSizeId
           , tmpData.GoodsSizeName       ::TVarChar  AS GoodsSizeName
           , tmpData.GoodsSizeName_real  ::TVarChar  AS GoodsSizeName_real
           , Object_Currency.ValueData      AS CurrencyName

           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm  / tmpData.Amount ELSE 0 END             ::TFloat AS OperPrice
           , tmpData.CountForPrice           ::TFloat
           , (CAST ( (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm / tmpData.Amount ELSE 0 END)
                      * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END  AS NUMERIC (16, 2))) :: TFloat  AS OperPriceBalance
           
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSummPriceJur / tmpData.Amount ELSE 0 END      ::TFloat AS PriceJur

           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSummPriceList     / tmpData.Amount ELSE 0 END :: TFloat AS OperPriceList
           , CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSummPriceListLast / tmpData.Amount ELSE 0 END :: TFloat AS OperPriceListLast
           , tmpData.Amount                  :: TFloat
           , tmpData.TotalSumm               :: TFloat
           , (CAST (tmpData.TotalSumm * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS TotalSummBalance
           , tmpData.TotalSummPriceJur       :: TFloat
           , tmpData.TotalSummPriceList      :: TFloat  AS TotalSummPriceList
           , tmpData.TotalSummPriceListLast  :: TFloat  AS TotalSummPriceListLast

           , tmpData.Remains          :: TFloat AS Remains
           , tmpData.RemainsDebt      :: TFloat AS RemainsDebt
           , tmpData.RemainsAll       :: TFloat AS RemainsAll

           , tmpData.RemainsTotal     :: TFloat AS RemainsTotal
           , tmpData.RemainsDebtTotal :: TFloat AS RemainsDebtTotal
           , tmpData.RemainsAllTotal  :: TFloat AS RemainsAllTotal

           , (tmpData.RemainsAll * (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm/ tmpData.Amount ELSE 0 END ))         :: TFloat AS SummRemainsIn  -- ����� ���.����� � ������
           , (tmpData.RemainsAll * (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSummPriceList/ tmpData.Amount ELSE 0 END)) :: TFloat AS SummRemains    -- ����� ���.����� � ���
           
           , tmpData.CurrencyValue  :: TFloat
           , tmpData.ParValue       :: TFloat
           
           , CAST (CASE WHEN tmpData.Amount <> 0 THEN ((tmpData.TotalSummPriceList/tmpData.Amount) 
                                                     - (CAST ( (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm / tmpData.Amount ELSE 0 END)
                                                        * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END  AS NUMERIC (16, 2)))
                                                      ) * 100 
                                                      / (CAST ( (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm / tmpData.Amount ELSE 0 END)
                                                         * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END  AS NUMERIC (16, 2)))
                  ELSE 0 END AS NUMERIC (16, 0))  :: TFloat  AS PriceTax

           , CAST (CASE WHEN tmpData.Amount <> 0 THEN ((tmpData.TotalSummPriceListLast/tmpData.Amount) 
                                                     - (CAST ( (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm / tmpData.Amount ELSE 0 END)
                                                        * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END  AS NUMERIC (16, 2)))
                                                      ) * 100 
                                                      / (CAST ( (CASE WHEN tmpData.Amount <> 0 THEN tmpData.TotalSumm / tmpData.Amount ELSE 0 END)
                                                         * tmpData.CurrencyValue / CASE WHEN tmpData.ParValue <> 0 THEN tmpData.ParValue ELSE 1 END  AS NUMERIC (16, 2)))
                  ELSE 0 END AS NUMERIC (16, 0))  :: TFloat  AS PriceTaxLast

           , tmpData.ChangePercent  :: TFloat
           , tmpData.Comment        :: TVarChar

        FROM tmpData
            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpData.ToId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpData.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            --LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = tmpData.JuridicalId
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId

            LEFT JOIN Object AS Object_Brand   ON Object_Brand.Id   = tmpData.BrandId
            LEFT JOIN Object AS Object_Fabrika ON Object_Fabrika.Id = tmpData.FabrikaId
            LEFT JOIN Object AS Object_Period  ON Object_Period.Id  = tmpData.PeriodId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
           ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.02.19         *
 30.05.17         *
*/

-- ����
-- SELECT * FROM gpReport_Movement_Income (inStartDate := ('01.11.2016')::TDateTime , inEndDate := ('01.07.2018')::TDateTime , inUnitId := 506 , inBrandId := 0 , inPartnerId := 0 , inPeriodId := 0 , inStartYear := 0 , inEndYear := 2017 , inisPartion := 'False' , inisSize := 'False' , inisPartner := 'False' ,  inSession := '2');

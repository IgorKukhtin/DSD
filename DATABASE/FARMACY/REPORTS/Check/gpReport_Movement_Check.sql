-- Function:  gpReport_Movement_Check()

DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Check(
    IN inUnitId           Integer  ,  -- �������������
    IN inDateStart        TDateTime,  -- ���� ������
    IN inDateFinal        TDateTime,  -- ���� ���������
    IN inIsPartion        Boolean,    -- 
    IN inisPartionPrice   Boolean,    -- 
    IN inisJuridical      Boolean,    -- 
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
  JuridicalCode  Integer, 
  JuridicalName  TVarChar,
  GoodsId        Integer, 
  GoodsCode      Integer, 
  GoodsName      TVarChar,
  GoodsGroupName TVarChar, 
  NDSKindName    TVarChar,
  ConditionsKeepName    TVarChar,
  Amount                TFloat,
  Price                 TFloat,
  PriceSale             TFloat,
  PriceWithVAT          Tfloat,      --���� ���������� � ������ ��� (��� % ����.)
  PriceWithOutVAT       Tfloat, 
  Summa                 TFloat,
  SummaSale             TFloat,
  SummaWithVAT          Tfloat,      --����� ���������� � ������ ��� (��� % ����.)
  SummaWithOutVAT       Tfloat,
  SummaMargin           TFloat,
  SummaMarginWithVAT    TFloat,

  AmountPromo           TFloat,
  AmountPromoPlanMax    TFloat,

  PersentPlan           TFloat,   -- ������� ����������
  SummaBonus            TFloat,   -- ����� ������
  SummaPenalty          TFloat,   -- ����� ������
  SummaPay              TFloat,   -- ���� ��� ����� - ������ ����� ����� ����� ������� 

  isPromoUnit           Boolean,
  isPromoPlanMax        Boolean,

  PartionDescName       TVarChar,
  PartionInvNumber      TVarChar,
  PartionOperDate       TDateTime,
  PartionPriceDescName  TVarChar,
  PartionPriceInvNumber TVarChar,
  PartionPriceOperDate  TDateTime,
  UnitName              TVarChar,
  OurJuridicalName      TVarChar

)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDateStartPromo TDateTime;
   DECLARE vbDatEndPromo TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    vbDateStartPromo := date_trunc('month', inDateStart);
    vbDatEndPromo := date_trunc('month', inDateFinal) + interval '1 month'; 
    
    -- ���������
    RETURN QUERY
          WITH
   tmpData_Container AS (SELECT COALESCE (MIContainer.AnalyzerId,0)  AS MovementItemId_Income
                              , MIContainer.ObjectId_analyzer AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                         FROM MovementItemContainer AS MIContainer
                         WHERE MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.MovementDescId = zc_Movement_Check()
                           AND MIContainer.OperDate >= inDateStart AND MIContainer.OperDate < inDateFinal + INTERVAL '1 DAY'
                           AND MIContainer.WhereObjectId_analyzer = inUnitId
                          -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                         GROUP BY COALESCE (MIContainer.AnalyzerId,0)
                                , MIContainer.ObjectId_analyzer 
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0

                        )
       , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                              , MI_Income_find.MovementId AS MovementId_find
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , tmpData_Container.GoodsId
                              , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                              , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
                         FROM tmpData_Container
                               -- ������� �������
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId_Income

                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                        GROUP BY COALESCE (MI_Income_find.Id,         MI_Income.Id)
                               , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) 
                               , MI_Income.MovementId
                               , MI_Income_find.MovementId  
                               , tmpData_Container.GoodsId
                        )

           , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                              , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END  AS JuridicalId_Income
                              , MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                              , tmpData_all.GoodsId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                                -- ����� ������� ������� ���� = 0 (��� � �� �������� ������� �/�)
                              , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END AS isPrice
                              --
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END AS OurJuridicalId_Income
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END               AS ToId_Income
                         FROM tmpData_all
                              -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- ���� � ������ ���, ��� �������� ������� �� ���������� ��� % �������������  (��� NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                          ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              -- ���� ��� ����� ���, ��� �������� ������� �� ���������� ��� % �������������  (��� NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                          ON MIFloat_PriceWithOutVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                              -- ���������, ��� �������� ������� �� ���������� (��� NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                              -- ��� ���, ��� �������� ������� �� ���������� (��� NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                              -- ���� ��� ������ �� ���������� (����� ��� ������)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              -- �� ����� ���� �� ���� ��� ������
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical_Income
                                                           ON MovementLinkObject_Juridical_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()

                         GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END
                                , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END
                                , MovementLinkObject_NDSKind_Income.ObjectId
                                , tmpData_all.GoodsId
                                , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END    
                        )

        -- ������� ���-�� ���� ��� ������� ����������  ����� �� ����������
      , tmpDateList AS (SELECT generate_series(inDateStart, inDateFinal, '1 day'::interval) as OperDate)

      , tmpKoef AS (SELECT tmp.OperDate
                         , CAST (CountDays / date_part ('day', ((tmp.OperDate + interval '1 month') - tmp.OperDate)) AS NUMERIC (15,4)) AS Amount
                    FROM
                        (SELECT date_trunc('month', tmpDateList.OperDate) AS OperDate
                              , count (date_trunc('month', tmpDateList.OperDate)) AS CountDays
                         FROM tmpDateList
                         GROUP BY date_trunc('month', tmpDateList.OperDate)
                        ) AS tmp
                    )
    --  ������ �� "���� �� ���������� ��� �����"
   , tmpMovPromoUnit AS (SELECT DATE_TRUNC ('month', Movement.OperDate) AS OperDate
                              , MovementItem.ObjectId                 AS GoodsId
                              , SUM (MovementItem.Amount)             AS Amount
                              , SUM (MIFloat_AmountPlanMax.ValueData) AS AmountPlanMax 
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitId

                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE 
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                          ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

                         WHERE Movement.DescId = zc_Movement_PromoUnit()
                           AND Movement.OperDate >= vbDateStartPromo AND Movement.OperDate < vbDatEndPromo
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         GROUP BY DATE_TRUNC ('month', Movement.OperDate)
                                , MovementItem.ObjectId    
                         )
      , tmpPromoUnit AS (SELECT tmpMovPromoUnit.GoodsId
                              , SUM (tmpMovPromoUnit.Amount * tmpKoef.Amount)        AS Amount
                              , SUM (tmpMovPromoUnit.AmountPlanMax * tmpKoef.Amount) AS AmountPlanMax 
                         FROM tmpMovPromoUnit
                              LEFT JOIN tmpKoef ON tmpKoef.OperDate = tmpMovPromoUnit.OperDate
                         GROUP BY tmpMovPromoUnit.GoodsId
                         )

   , tmpDataRez AS (SELECT tmpData.MovementId_Income
                         , tmpData.MovementId_find
                         , tmpData.JuridicalId_Income
                         , tmpData.NDSKindId_Income
                         , tmpData.GoodsId
                         , tmpData.Summa
                         , tmpData.SummaWithOutVAT
                         , tmpData.SummaWithVAT
                         , tmpData.Amount
                         , tmpData.SummaSale
                         , tmpData.isPrice
                         , tmpData.OurJuridicalId_Income
                         , tmpData.ToId_Income
                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT
                    FROM tmpData
                    )

     , tmpPrice AS ( SELECT tmp.GoodsId
                          , COALESCE (ObjectHistoryFloat_Price.ValueData, 0) AS Price
                     FROM (SELECT DISTINCT tmpPromoUnit.GoodsId FROM tmpPromoUnit) AS tmp
                          LEFT JOIN Object_Price_View AS Object_Price
                                                      ON Object_Price.GoodsId  = tmp.GoodsId
                                                     AND Object_Price.UnitId = inUnitId 
                          -- �������� �������� ���� �� ������� �������� �� ���.����
                          LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                  ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                                 AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                 AND inDateFinal >= ObjectHistory_Price.StartDate AND inDateFinal < ObjectHistory_Price.EndDate
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                            ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                           AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                    )

        -- ���������
        SELECT
            Object_From_Income.ObjectCode                                      AS JuridicalCode
           ,Object_From_Income.ValueData                                       AS JuridicalName

           ,Object_Goods_View.Id                                                AS GoodsId
           ,Object_Goods_View.GoodsCodeInt  ::Integer                           AS GoodsCode
           ,Object_Goods_View.GoodsName                                         AS GoodsName
           ,Object_Goods_View.GoodsGroupName                                    AS GoodsGroupName
           -- ,Object_Goods_View.NDSKindName                                       AS NDSKindName
           ,Object_NDSKind_Income.ValueData                                     AS NDSKindName
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar           AS ConditionsKeepName           

           , tmpData.Amount :: TFloat AS Amount
           , tmpData.Price
           , COALESCE(tmpData.PriceSale,tmpPrice.Price) ::TFloat  AS PriceSale
           , tmpData.PriceWithVAT
           , tmpData.PriceWithOutVAT

           , tmpData.Summa           :: TFloat AS Summa
           , tmpData.SummaSale       :: TFloat AS SummaSale
           , tmpData.SummaWithVAT    :: TFloat AS SummaWithVAT
           , tmpData.SummaWithOutVAT :: TFloat AS SummaWithOutVAT

           , (tmpData.SummaSale - tmpData.Summa)        :: TFloat AS SummaMargin
           , (tmpData.SummaSale - tmpData.SummaWithVAT) :: TFloat AS SummaMarginWithVAT

           , tmpPromoUnit.Amount        :: TFloat AS AmountPromo
           , tmpPromoUnit.AmountPlanMax :: TFloat AS AmountPromoPlanMax

           , CAST ( (CASE WHEN COALESCE (tmpPromoUnit.Amount,0) <> 0 THEN tmpData.Amount*100 /tmpPromoUnit.Amount ELSE 0 END) AS NUMERIC (16,0) )  ::TFloat AS PersentPlan  -- ������� ����������
           , CAST ( (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpPromoUnit.AmountPlanMax) >= 0 THEN tmpData.SummaSale/100 * 3 ELSE 0 END) AS NUMERIC (16,2) )   ::TFloat AS SummaBonus               -- ����� ������
           , CAST ( (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpPromoUnit.Amount) < 0 
                          THEN (tmpPromoUnit.Amount - COALESCE(tmpData.Amount,0)) * COALESCE(tmpData.PriceSale,tmpPrice.Price) / 100 * 10
                          ELSE 0 END) AS NUMERIC (16,2) )   ::TFloat AS SummaPenalty             -- ����� ������
           , CAST (CASE WHEN (CASE WHEN COALESCE (tmpPromoUnit.Amount,0) <> 0 THEN COALESCE(tmpData.Amount,0) * 100 /tmpPromoUnit.Amount ELSE 0 END)  >= 90
                        THEN
                            ( (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpPromoUnit.AmountPlanMax) >= 0 THEN tmpData.SummaSale/100 * 3 ELSE 0 END)
                             - 
                              (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpPromoUnit.Amount) < 0 
                                    THEN (tmpPromoUnit.Amount - COALESCE(tmpData.Amount,0)) * COALESCE(tmpData.PriceSale,tmpPrice.Price) / 100 * 10
                                    ELSE 0 END)
                             )
                        ELSE (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpPromoUnit.Amount) < 0 
                                    THEN (tmpPromoUnit.Amount - COALESCE(tmpData.Amount,0)) * COALESCE(tmpData.PriceSale,tmpPrice.Price) / 100 * 10
                                    ELSE 0 END) * (-1)
                    END  AS NUMERIC (16,2) )   ::TFloat AS SummaPay                                  -- ���� ��� ����� - ������ ����� ����� ����� ������� 

           , CASE WHEN (COALESCE(tmpData.Amount,0) - tmpPromoUnit.Amount) >= 0 THEN TRUE ELSE FALSE END  AS isPromoUnit
           , CASE WHEN (COALESCE(tmpData.Amount,0) - tmpPromoUnit.AmountPlanMax) >= 0 THEN TRUE ELSE FALSE END  AS isPromoPlanMax

           , MovementDesc_Income.ItemName AS PartionDescName
           , Movement_Income.InvNumber    AS PartionInvNumber
           , Movement_Income.OperDate     AS PartionOperDate
           , COALESCE (MovementDesc_Price.ItemName, MovementDesc_Income.ItemName) AS PartionPriceDescName
           , COALESCE (Movement_Price.InvNumber, Movement_Income.InvNumber)       AS PartionPriceInvNumber
           , COALESCE (Movement_Price.OperDate, Movement_Income.OperDate)         AS PartionPriceOperDate

           , Object_To_Income.ValueData              AS UnitName
           , Object_OurJuridical_Income.ValueData    AS OurJuridicalName
        FROM tmpDataRez AS tmpData
             LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
             LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income

             FUll JOIN tmpPromoUnit ON tmpPromoUnit.GoodsId = tmpData.GoodsId
          
             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = COALESCE (tmpData.GoodsId,tmpPromoUnit.GoodsId)

             LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
             LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
             LEFT JOIN Movement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

             LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
             LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId
             -- ������� ��������
             LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                  ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
                                 AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
 
             LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpPromoUnit.GoodsId
        --     FUll JOIN tmpPromoUnit ON tmpPromoUnit.GoodsId = tmpData.GoodsId
        ORDER BY
            GoodsGroupName, GoodsName;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 17.02.17         *
 12.01.17         *
 14.03.16                                        * ALL
 28.01.16         * 
 11.08.15                                                                       *
*/

-- ����
-- SELECT * FROM gpReport_Movement_Check(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateFinal := ('29.02.2016')::TDateTime , inIsPartion := 'False' ,  inSession := '3');
-- SELECT * FROM gpReport_Movement_Check (inUnitId:= 0, inDateStart:= '20150801'::TDateTime, inDateFinal:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
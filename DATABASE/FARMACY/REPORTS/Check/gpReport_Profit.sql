-- Function:  gpReport_Profit()

DROP FUNCTION IF EXISTS gpReport_Profit (TDateTime, TDateTime, Integer, Integer, TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Profit (TDateTime, TDateTime, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Profit(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inJuridical1Id     Integer,    -- ��������� ������ 
    IN inJuridical2Id     Integer,    -- ��������� �����������
 --   IN inTax1             TFloat ,
 --   IN inTax2             TFloat ,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   
   DECLARE vbStartDate TDateTime;  
   DECLARE vbEndDate   TDateTime;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������������ <�������� ����>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    vbStartDate:= DATE_TRUNC('month', inStartDate) -  Interval '5 MONTH';
    vbEndDate:= DATE_TRUNC('month', inStartDate);                         --  Interval '1 Day';

    -- ���������
    OPEN Cursor1 FOR
          
    WITH
          tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId =  vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       )
        -- ������ �� ��������
        , tmpData_ContainerAll AS (SELECT MIContainer.MovementItemId AS MI_Id
                                     , COALESCE (MIContainer.AnalyzerId,0) :: Integer  AS MovementItemId
                                     , MIContainer.MovementId        AS MovementId
                                     , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                                     , MIContainer.ObjectId_analyzer                   AS GoodsId
                                     , SUM (COALESCE (-1 * MIContainer.Amount, 0))     AS Amount
                                     , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                                FROM MovementItemContainer AS MIContainer
                                WHERE MIContainer.DescId = zc_MIContainer_Count()
                                  AND MIContainer.MovementDescId = zc_Movement_Check()
                                  AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                               -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                                GROUP BY COALESCE (MIContainer.WhereObjectId_analyzer,0)
                                       , MIContainer.ObjectId_analyzer    
                                       , COALESCE (MIContainer.AnalyzerId,0)
                                       , MIContainer.MovementItemId
                                       , MIContainer.MovementId
                                HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                               )
        , tmpData_Container AS (SELECT tmpData_ContainerAll.*
                                FROM tmpData_ContainerAll
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = tmpData_ContainerAll.UnitId
                               )
        -- ���. ��� �������, ���� �������� � �������
        , tmpMS_InvNumberSP AS (SELECT tmp.MovementId
                                FROM (SELECT DISTINCT tmpData_Container.MovementId
                                      FROM tmpData_Container
                                      ) AS tmp
                                      INNER JOIN MovementString AS MovementString_InvNumberSP
                                                                ON MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                                               AND MovementString_InvNumberSP.MovementId = tmp.MovementId
                                                               AND MovementString_InvNumberSP.ValueData <> ''
                                )
                                           
        , tmpMIF_SummChangePercent AS (SELECT MIFloat_SummChangePercent.*
                                       FROM MovementItemFloat AS MIFloat_SummChangePercent
                                       WHERE MIFloat_SummChangePercent.DescId =  zc_MIFloat_SummChangePercent()
                                         AND MIFloat_SummChangePercent.MovementItemId IN (SELECT DISTINCT tmpData_Container.MI_Id FROM tmpData_Container)
                                      )
        , tmpSP AS (SELECT tmpData_Container.UnitId
                         , SUM (COALESCE (MovementFloat_SummChangePercent.ValueData, 0)) AS SummChangePercent_SP
                    FROM (SELECT DISTINCT tmpData_Container.MI_ID, tmpData_Container.UnitId 
                          FROM tmpData_Container
                               INNER JOIN tmpMS_InvNumberSP ON tmpMS_InvNumberSP.MovementId = tmpData_Container.MovementId
                          ) AS tmpData_Container
                            -- ����� ������ SP
                            LEFT JOIN tmpMIF_SummChangePercent AS MovementFloat_SummChangePercent
                                                               ON MovementFloat_SummChangePercent.MovementItemId = tmpData_Container.MI_Id
                    GROUP BY tmpData_Container.UnitId
                    )
                    
        -- �������� ������� �� ������� ���.������� 1303
        , tmpMovement_Sale AS (SELECT MovementLinkObject_Unit.ObjectId             AS UnitId
                                    , Movement_Sale.Id                             AS Id
                               FROM Movement AS Movement_Sale
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                    
                                    INNER JOIN MovementString AS MovementString_InvNumberSP
                                           ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                          AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                          AND COALESCE (MovementString_InvNumberSP.ValueData,'') <> ''

                               WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                 AND Movement_Sale.OperDate >= inStartDate AND Movement_Sale.OperDate < inEndDate + INTERVAL '1 DAY'
                                 AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                               )
        , tmpMF_TotalSummPrimeCost AS (SELECT MovementFloat_TotalSummPrimeCost.*
                                       FROM MovementFloat AS MovementFloat_TotalSummPrimeCost
                                       WHERE MovementFloat_TotalSummPrimeCost.DescId = zc_MovementFloat_TotalSummPrimeCost()
                                         AND MovementFloat_TotalSummPrimeCost.MovementId IN (SELECT DISTINCT tmpMovement_Sale.Id FROM tmpMovement_Sale)
                                      )
        , tmpSummPrimeCost AS (SELECT Movement_Sale.UnitId
                                    , SUM (COALESCE (tmpMF_TotalSummPrimeCost.ValueData, 0)) AS TotalSummPrimeCost
                               FROM tmpMovement_Sale AS Movement_Sale
                                    LEFT JOIN tmpMF_TotalSummPrimeCost ON tmpMF_TotalSummPrimeCost.MovementId = Movement_Sale.Id
                               GROUP BY Movement_Sale.UnitId
                               )

        , tmpSale_1303 AS (SELECT Movement_Sale.UnitId                    AS UnitId
                                , tmpSummPrimeCost.TotalSummPrimeCost
                                , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                           FROM tmpMovement_Sale AS Movement_Sale
                                LEFT JOIN tmpSummPrimeCost ON tmpSummPrimeCost.UnitId = Movement_Sale.UnitId
                                
                                INNER JOIN MovementItem AS MI_Sale
                                                        ON MI_Sale.MovementId = Movement_Sale.Id
                                                       AND MI_Sale.DescId = zc_MI_Master()
                                                       AND MI_Sale.isErased = FALSE
                           
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                            ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                                           AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
  
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.MovementItemId = MI_Sale.Id
                                                               AND MIContainer.DescId = zc_MIContainer_Count() 
                           GROUP BY Movement_Sale.UnitId, tmpSummPrimeCost.TotalSummPrimeCost
                           ) 

       -- ������� �� ���.�������
       , tmpData_all AS (SELECT COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
 
                              , tmpData_Container.GoodsId
                              , tmpData_Container.UnitId
                              , SUM (COALESCE (tmpData_Container.Amount, 0))        AS Amount
                              , SUM (COALESCE (tmpData_Container.SummaSale, 0))     AS SummaSale

                         FROM tmpData_Container
                              -- ������� �������
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId

                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                         GROUP BY COALESCE (MI_Income_find.Id,         MI_Income.Id)
                                , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)  
                                , tmpData_Container.GoodsId
                                , tmpData_Container.UnitId
                         )

       , tmpData AS (SELECT MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income  -- ���������
                          , tmpData_all.GoodsId
                          , tmpData_all.UnitId
                          , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))         AS Summa
                          , SUM (tmpData_all.Amount * COALESCE (MIFloat_Income_Price.ValueData, 0))           AS Summa_original
                          , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPriceWithVAT.ValueData, 0))  AS SummaWithVAT
                  
                          , SUM (tmpData_all.Amount)    AS Amount
                          , SUM (tmpData_all.SummaSale) AS SummaSale

                     FROM tmpData_all
                          -- ���� � ������ ���, ��� �������� ������� �� ���������� (� % ������������� ������� zc_Object_Juridical) (��� NULL)
                          LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                      ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                     AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                          -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� % �������������)(��� NULL)
                          LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceWithVAT
                                                      ON MIFloat_JuridicalPriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                     AND MIFloat_JuridicalPriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                          -- ���� "��������", ��� �������� ������� �� ���������� (��� NULL)
                          LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                      ON MIFloat_Income_Price.MovementItemId = tmpData_all.MovementItemId
                                                     AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 

                          -- ���������, ��� �������� ������� �� ���������� (��� NULL)
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                       ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                      AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                          -- ��� ���, ��� �������� ������� �� ���������� (��� NULL)
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                       ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                      AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()

                     GROUP BY MovementLinkObject_From_Income.ObjectId
                            , tmpData_all.GoodsId
                            , tmpData_all.UnitId
                    )
                        
       , tmpData_Case AS (SELECT tmpData.UnitId
                                     , SUM(tmpData.Summa)        AS Summa
                                     , SUM(tmpData.SummaSale)    AS SummaSale
                                     , SUM(tmpData.SummaWithVAT) AS SummaWithVAT
                                     
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id OR tmpData.JuridicalId_Income = inJuridical2Id THEN 0 ELSE tmpData.Summa END)     AS SummaFree
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id OR tmpData.JuridicalId_Income = inJuridical2Id THEN 0 ELSE tmpData.SummaSale END) AS SummaSaleFree
                                     
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.Summa ELSE 0 END)     AS Summa1
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaSale ELSE 0 END) AS SummaSale1
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaSale-tmpData.Summa ELSE 0 END) AS SummaProfit1
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaWithVAT ELSE 0 END)     AS SummaWithVAT1
                                     
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.Summa ELSE 0 END)     AS Summa2
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaSale ELSE 0 END) AS SummaSale2
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaSale-tmpData.Summa ELSE 0 END) AS SummaProfit2
                                     , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaWithVAT ELSE 0 END)     AS SummaWithVAT2
                                 
                                     , COALESCE (tmpSP.SummChangePercent_SP, 0)               AS SummSale_SP
                                     , COALESCE (tmpSale_1303.SummSale_1303, 0)               AS SummSale_1303
                                     , COALESCE (tmpSale_1303.TotalSummPrimeCost, 0)          AS SummPrimeCost_1303
                   
                                FROM tmpData
                                     LEFT JOIN tmpSale_1303 ON tmpSale_1303.UnitId = tmpData.UnitId
                                     LEFT JOIN tmpSP        ON tmpSP.UnitId        = tmpData.UnitId
                                GROUP BY tmpData.UnitId
                                       , COALESCE (tmpSP.SummChangePercent_SP, 0)
                                       , COALESCE (tmpSale_1303.SummSale_1303, 0)
                                       , COALESCE (tmpSale_1303.TotalSummPrimeCost, 0)
                               )

       , tmpData_Full AS (SELECT tmpData.UnitId
                               , tmpData.Summa
                               , tmpData.SummaSale
                               , tmpData.SummaWithVAT
                               
                               , tmpData.SummaFree
                               , tmpData.SummaSaleFree
                               
                               , tmpData.Summa1
                               , tmpData.SummaSale1
                               , tmpData.SummaProfit1
                               , tmpData.SummaWithVAT1
                               
                               , tmpData.Summa2
                               , tmpData.SummaSale2
                               , tmpData.SummaProfit2
                               , tmpData.SummaWithVAT2
                           
                               , tmpData.SummSale_SP
                               , tmpData.SummSale_1303
                               , tmpData.SummPrimeCost_1303
                               
                               , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0))                  AS SummaSaleWithSP
                               , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) - tmpData.Summa)  AS SummaProfitWithSP
                    
                               , CASE WHEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) <> 0
                                      THEN ((tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) - tmpData.Summa) / (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) *100)
                                      ELSE 0 
                                 END                                                                      AS PersentProfitWithSP
                               
                               , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0))        AS SummaSaleAll
                               , (COALESCE (tmpData.Summa, 0) + COALESCE (tmpData.SummPrimeCost_1303, 0))                             AS SummaAll
                               , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0) - tmpData.Summa - COALESCE (tmpData.SummPrimeCost_1303, 0))  AS SummaProfitAll
                               , CASE WHEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0)) <> 0 
                                      THEN ( (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0) - tmpData.Summa - COALESCE (tmpData.SummPrimeCost_1303, 0)) 
                                           / (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0)) ) * 100 
                                      ELSE 0
                                 END                                                                                                   AS PersentProfitAll
                          FROM tmpData_Case AS tmpData
                          )

       -- ���������� ������ � ������ ������ �� ��.����
       , tmpBestBad AS (SELECT DISTINCT tmp.UnitId
                             , tmp.Ord_Best
                             , tmp.Ord_Bad 
                         FROM (SELECT tmp.*
                                    , Row_Number() OVER (ORDER BY tmp.PersentProfitAll Asc)  AS Ord_Bad
                                    , Row_Number() OVER (ORDER BY tmp.PersentProfitAll DESC) AS Ord_Best
                               FROM tmpData_Full as tmp
                               ) as tmp
                         WHERE tmp.Ord_Best IN (1,2,3) OR tmp.Ord_Bad IN (1,2,3)
                         ) 
                         
     -- ���������  
        SELECT
             Object_JuridicalMain.ObjectCode         AS JuridicalMainCode
           , Object_JuridicalMain.ValueData          AS JuridicalMainName
           , Object_Unit.ObjectCode                  AS UnitCode
           , Object_Unit.ValueData                   AS UnitName

           , tmp.Summa                               :: TFloat AS Summa
           , tmp.SummaWithVAT                        :: TFloat AS SummaWithVAT
           , tmp.SummaSale                           :: TFloat AS SummaSale
           , (tmp.SummaSale - tmp.Summa)             :: TFloat AS SummaProfit
           , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.Summa/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))   :: TFloat AS PersentProfit

           , (tmp.SummaSale - tmp.SummaWithVAT)      :: TFloat AS SummaProfitWithVAT   --����� ������ ��� ��.�������������
           , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.SummaWithVAT/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))  :: TFloat AS PersentProfitWithVAT
         
           , tmp.SummaFree                           :: TFloat AS SummaFree
           , tmp.SummaSaleFree                       :: TFloat AS SummaSaleFree
           , (tmp.SummaSaleFree - tmp.SummaFree)     :: TFloat AS SummaProfitFree

           , tmp.Summa1                              :: TFloat AS Summa1
           , tmp.SummaWithVAT1                       :: TFloat AS SummaWithVAT1
           , tmp.SummaSale1                          :: TFloat AS SummaSale1
           , tmp.SummaProfit1                        :: TFloat AS SummaProfit1
           , CAST (CASE WHEN tmp.Summa1 <> 0 THEN ((tmp.SummaWithVAT1-tmp.Summa1)*100 / tmp.Summa1) ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS Tax1

           , tmp.Summa2                              :: TFloat AS Summa2
           , tmp.SummaWithVAT2                       :: TFloat AS SummaWithVAT2
           , tmp.SummaSale2                          :: TFloat AS SummaSale2
           , tmp.SummaProfit2                        :: TFloat AS SummaProfit2
           , CAST (CASE WHEN tmp.Summa2 <> 0 THEN ((tmp.SummaWithVAT2-tmp.Summa2)*100 / tmp.Summa2) ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS Tax2
           
           , tmp.SummSale_SP           :: TFloat
           , tmp.SummSale_1303         :: TFloat
           , tmp.SummPrimeCost_1303    :: TFloat

           , tmp.SummaSaleWithSP       :: TFloat
           , tmp.SummaProfitWithSP     :: TFloat

           , tmp.PersentProfitWithSP   :: TFloat
           
           , tmp.SummaSaleAll          :: TFloat
           , tmp.SummaAll              :: TFloat
           , tmp.SummaProfitAll        :: TFloat
           , tmp.PersentProfitAll      :: TFloat
           
           , CASE WHEN tmpBestBad.Ord_Best IN (1,2,3) THEN 8716164 
                  WHEN tmpBestBad.Ord_Bad  IN (1,2,3) THEN 10917116 
                  ELSE zc_Color_White()
             END                         AS Color_Best        -- ������� ������   -- ������� ������

       FROM tmpData_Full AS tmp
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN Object AS Object_JuridicalMain ON Object_JuridicalMain.Id = ObjectLink_Unit_Juridical.ChildObjectId
                
                LEFT JOIN tmpBestBad ON tmpBestBad.UnitId = tmp.UnitId
       ORDER BY Object_JuridicalMain.ValueData 
              , Object_Unit.ValueData;
              
    RETURN NEXT Cursor1;
    
    -- ��������� 2
    OPEN Cursor2 FOR
    WITH
          tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       )
        -- ������ �� ��������
        , tmpData_ContainerAll AS (SELECT MIContainer.MovementItemId                      AS MI_Id
                                        , DATE_TRUNC('Month', MIContainer.OperDate)       AS OperDate
                                        , MIContainer.MovementId                          AS MovementId
                                        , COALESCE (MIContainer.AnalyzerId,0) :: Integer  AS MovementItemId
                                        , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                                        , MIContainer.ObjectId_analyzer                   AS GoodsId
                                        , SUM (COALESCE (-1 * MIContainer.Amount, 0))     AS Amount
                                        , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                                   FROM MovementItemContainer AS MIContainer
                                   WHERE MIContainer.DescId = zc_MIContainer_Count()
                                     AND MIContainer.MovementDescId = zc_Movement_Check()
                                     AND MIContainer.OperDate >= vbStartDate AND MIContainer.OperDate < vbEndDate
                                   GROUP BY DATE_TRUNC('Month', MIContainer.OperDate)
                                          , MIContainer.ObjectId_analyzer
                                          , COALESCE (MIContainer.AnalyzerId,0)
                                          , MIContainer.MovementItemId
                                          , COALESCE (MIContainer.WhereObjectId_analyzer,0)
                                          , MIContainer.MovementId
                                   HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                  )
        , tmpData_Container AS (SELECT tmpData_ContainerAll.*
                                FROM tmpData_ContainerAll
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = tmpData_ContainerAll.UnitId
                               )

        , tmpMIF_SummChangePercent AS (SELECT MIFloat_SummChangePercent.*
                                       FROM MovementItemFloat AS MIFloat_SummChangePercent
                                       WHERE MIFloat_SummChangePercent.DescId =  zc_MIFloat_SummChangePercent()
                                         AND MIFloat_SummChangePercent.MovementItemId IN (SELECT DISTINCT tmpData_Container.MI_Id FROM tmpData_Container)
                                      )
        -- ���. ��� �������, ���� �������� � �������
        , tmpMS_InvNumberSP AS (SELECT MovementString_InvNumberSP.MovementId
                                FROM MovementString AS MovementString_InvNumberSP
                                WHERE MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                  AND MovementString_InvNumberSP.ValueData <> ''
                                  AND MovementString_InvNumberSP.MovementId IN (SELECT DISTINCT tmpData_Container.MovementId FROM tmpData_Container) 
                                )
                                
        , tmpSP AS (SELECT tmpData_Container.OperDate
                         , SUM (COALESCE (MovementFloat_SummChangePercent.ValueData, 0)) AS SummChangePercent_SP
                    FROM (SELECT DISTINCT tmpData_Container.MI_ID, tmpData_Container.OperDate 
                          FROM tmpData_Container
                               INNER JOIN tmpMS_InvNumberSP ON tmpMS_InvNumberSP.MovementId = tmpData_Container.MovementId
                          ) AS tmpData_Container
                         -- ����� ������ SP
                         LEFT JOIN tmpMIF_SummChangePercent AS MovementFloat_SummChangePercent
                                                            ON MovementFloat_SummChangePercent.MovementItemId = tmpData_Container.MI_Id
                    GROUP BY tmpData_Container.OperDate
                    )
                    
        -- �������� ������� �� ������� ���.������� 1303
        , tmpMovement_Sale AS (SELECT MovementLinkObject_Unit.ObjectId             AS UnitId
                                    , Movement_Sale.Id                             AS Id
                                    , DATE_TRUNC('Month', Movement_Sale.OperDate)  AS OperDate
                               FROM Movement AS Movement_Sale
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                    
                                    INNER JOIN MovementString AS MovementString_InvNumberSP
                                           ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                          AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                                          AND COALESCE (MovementString_InvNumberSP.ValueData,'') <> ''

                               WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                 AND Movement_Sale.OperDate >= vbStartDate AND Movement_Sale.OperDate < vbEndDate
                                 AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                               )
        , tmpMF_TotalSummPrimeCost AS (SELECT MovementFloat_TotalSummPrimeCost.*
                                       FROM MovementFloat AS MovementFloat_TotalSummPrimeCost
                                       WHERE MovementFloat_TotalSummPrimeCost.DescId = zc_MovementFloat_TotalSummPrimeCost()
                                         AND MovementFloat_TotalSummPrimeCost.MovementId IN (SELECT DISTINCT tmpMovement_Sale.Id FROM tmpMovement_Sale)
                                      )
        , tmpSummPrimeCost AS (SELECT Movement_Sale.OperDate
                                    , SUM (COALESCE (tmpMF_TotalSummPrimeCost.ValueData, 0)) AS TotalSummPrimeCost
                               FROM tmpMovement_Sale AS Movement_Sale
                                    LEFT JOIN tmpMF_TotalSummPrimeCost ON tmpMF_TotalSummPrimeCost.MovementId = Movement_Sale.Id
                               GROUP BY Movement_Sale.OperDate
                               )

        , tmpSale_1303 AS (SELECT Movement_Sale.OperDate                    AS OperDate
                                , tmpSummPrimeCost.TotalSummPrimeCost
                                , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                           FROM tmpMovement_Sale AS Movement_Sale
                                LEFT JOIN tmpSummPrimeCost ON tmpSummPrimeCost.OperDate = Movement_Sale.OperDate
                                
                                INNER JOIN MovementItem AS MI_Sale
                                                        ON MI_Sale.MovementId = Movement_Sale.Id
                                                       AND MI_Sale.DescId = zc_MI_Master()
                                                       AND MI_Sale.isErased = FALSE
                           
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                            ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                                           AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
  
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.MovementItemId = MI_Sale.Id
                                                               AND MIContainer.DescId = zc_MIContainer_Count() 
                           GROUP BY Movement_Sale.OperDate, tmpSummPrimeCost.TotalSummPrimeCost
                           ) 

       -- ������� �� ���.�������
       , tmpData_all AS (SELECT COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , tmpData_Container.OperDate
                              , tmpData_Container.GoodsId
                              , SUM (COALESCE (tmpData_Container.Amount, 0))        AS Amount
                              , SUM (COALESCE (tmpData_Container.SummaSale, 0))     AS SummaSale

                         FROM tmpData_Container
                              -- ������� �������
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId

                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                         GROUP BY COALESCE (MI_Income_find.Id,         MI_Income.Id)
                                , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)  
                                , tmpData_Container.GoodsId
                                , tmpData_Container.OperDate
                         )

       , tmpData AS (SELECT MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income  -- ���������
                          , tmpData_all.GoodsId
                          , tmpData_all.OperDate
                          , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))         AS Summa
                          , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPriceWithVAT.ValueData, 0))  AS SummaWithVAT
                  
                          , SUM (tmpData_all.Amount)    AS Amount
                          , SUM (tmpData_all.SummaSale) AS SummaSale

                     FROM tmpData_all
                          -- ���� � ������ ���, ��� �������� ������� �� ���������� (� % ������������� ������� zc_Object_Juridical) (��� NULL)
                          LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                      ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                     AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                          -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� % �������������)(��� NULL)
                          LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceWithVAT
                                                      ON MIFloat_JuridicalPriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                     AND MIFloat_JuridicalPriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                          -- ���������, ��� �������� ������� �� ���������� (��� NULL)
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                       ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                      AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                          -- ��� ���, ��� �������� ������� �� ���������� (��� NULL)
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                       ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                      AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()

                     GROUP BY MovementLinkObject_From_Income.ObjectId
                            , tmpData_all.GoodsId
                            , tmpData_all.OperDate
                    )
                        
       , tmpData_Full AS (SELECT tmpData.OperDate
                               , SUM(tmpData.Summa)        AS Summa
                               , SUM(tmpData.SummaSale)    AS SummaSale
                               , SUM(tmpData.SummaWithVAT) AS SummaWithVAT
                               
                               , tmpSP.SummChangePercent_SP  AS SummSale_SP
                               , tmpSale_1303.SummSale_1303
                               , tmpSale_1303.TotalSummPrimeCost
             
                          FROM tmpData
                               LEFT JOIN tmpSale_1303 ON tmpSale_1303.OperDate = tmpData.OperDate
                               LEFT JOIN tmpSP        ON tmpSP.OperDate        = tmpData.OperDate
                          GROUP BY tmpData.OperDate
                               , tmpSale_1303.SummSale_1303
                               , tmpSale_1303.TotalSummPrimeCost
                               , tmpSP.SummChangePercent_SP
                          )

     -- ���������  
        SELECT
             tmp.OperDate                          ::TDateTime AS OperDate

           , tmp.Summa                               :: TFloat AS Summa
           , tmp.SummaWithVAT                        :: TFloat AS SummaWithVAT
           , tmp.SummaSale                           :: TFloat AS SummaSale
           , (tmp.SummaSale - tmp.Summa)             :: TFloat AS SummaProfit
           , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.Summa/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))   :: TFloat AS PersentProfit

           , (tmp.SummaSale - tmp.SummaWithVAT)      :: TFloat AS SummaProfitWithVAT   --����� ������ ��� ��.�������������
           , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.SummaWithVAT/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))  :: TFloat AS PersentProfitWithVAT
         
           , tmp.SummSale_SP           :: TFloat AS SummSale_SP
           , tmp.SummSale_1303         :: TFloat
           , tmp.TotalSummPrimeCost    :: TFloat AS SummPrimeCost_1303

           , (tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0))               :: TFloat AS SummaSaleWithSP
           , (tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0) - tmp.Summa)   :: TFloat AS SummaProfitWithSP

           , CASE WHEN (tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0)) <> 0 THEN ((tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0) - tmp.Summa) / (tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0)) *100) ELSE 0 END :: TFloat AS PersentProfitWithSP
           
           , ((tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0)) + COALESCE (tmp.SummSale_1303, 0))        :: TFloat AS SummaSaleAll
           , (tmp.Summa + COALESCE (tmp.TotalSummPrimeCost, 0))             :: TFloat AS SummaAll
           , ((tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0)) + COALESCE (tmp.SummSale_1303, 0) - tmp.Summa - COALESCE (tmp.TotalSummPrimeCost, 0))        :: TFloat AS SummaProfitAll
           , CASE WHEN ((tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0)) + COALESCE (tmp.SummSale_1303, 0)) <> 0 
                  THEN (((tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0)) + COALESCE (tmp.SummSale_1303, 0) - tmp.Summa - COALESCE (tmp.TotalSummPrimeCost, 0)) 
                     / ((tmp.SummaSale + COALESCE (tmp.SummSale_SP, 0)) + COALESCE (tmp.SummSale_1303, 0))) * 100 
                  ELSE 0
             END :: TFloat AS PersentProfitAll

       FROM tmpData_Full AS tmp
       ORDER BY tmp.OperDate;
              
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 04.09.17         *
 25.01.17         * ����������� �� �������� ����
                    �����������, ������ ����� �� ���������
 20.03.16         *
*/
-- ����
-- SELECT * FROM gpReport_Profit (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
-- SELECT * from gpReport_Profit(inStartDate := ('01.11.2016')::TDateTime , inEndDate := ('05.11.2016')::TDateTime , inJuridical1Id := 59610 ::Integer , inJuridical2Id := 59612  ::Integer,  inSession := '3'::TVarChar);
-- FETCH ALL "<unnamed portal 10>";
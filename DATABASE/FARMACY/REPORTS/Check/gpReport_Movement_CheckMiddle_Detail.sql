-- Function:  gpReport_CheckMiddle_Detail()

DROP FUNCTION IF EXISTS gpReport_CheckMiddle_Detail (Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_CheckMiddle_Detail(
    IN inUnitId           Integer,
    IN inDateStart        TDateTime,  -- ���� ������
    IN inDateEnd          TDateTime,  -- ���� ���������
    IN inisDay            Boolean,    -- �� ����
    IN inisMonth          Boolean,    -- �� ����
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbDateStart TDateTime;  
   DECLARE vbDateEnd   TDateTime;
   DECLARE vbDays Integer;
      
   DECLARE Cursor1 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������������ <�������� ����>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- ���-�� ���� �������
    vbDays := (SELECT DATE_PART('DAY', (inDateEnd - inDateStart )) + 1);

    OPEN Cursor1 FOR
     
          WITH
          -- ��� ������������� �������� ����
          tmpUnit  AS  (SELECT inUnitId AS UnitId
                        WHERE inUnitId <> 0
                       UNION
                        SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          AND inUnitId = 0
                       )
        , tmpMovementCheck AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                         , Movement_Check.Id
                         , CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement_Check.OperDate) 
                                WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement_Check.OperDate) 
                                ELSE NULL END              ::TDateTime  AS OperDate
                        FROM Movement AS Movement_Check
                         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         -- ���� ������������ ������ ������������� ������ ����.����
                         -- ��� inUnitId=0,
                         -- ������ ���.����������� ��������������� ������� ����.����
                         INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                    WHERE Movement_Check.DescId = zc_Movement_Check()
                      AND DATE_TRUNC('day', Movement_Check.OperDate) BETWEEN inDateStart AND inDateEnd
                      AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                    GROUP BY Movement_Check.Id
                           , MovementLinkObject_Unit.ObjectId
                           , CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Check.OperDate) 
                                  WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement_Check.OperDate)
                                  ELSE NULL END
                   )
                   
        -- ���. ��� �������, ���� �������� � �������
        , tmpMovSP AS (SELECT DISTINCT MovementString_InvNumberSP.MovementId
                       FROM MovementString AS MovementString_InvNumberSP
                       WHERE MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                         AND MovementString_InvNumberSP.ValueData <> ''
                         AND MovementString_InvNumberSP.MovementId IN (SELECT DISTINCT tmpMovementCheck.Id FROM tmpMovementCheck)
                       )
                                
        , tmpMLO_SPKind AS (SELECT MovementLinkObject_SPKind.*
                            FROM MovementLinkObject AS MovementLinkObject_SPKind
                            WHERE MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                              AND MovementLinkObject_SPKind.MovementId IN (SELECT tmpMovementCheck.Id FROM tmpMovementCheck)
                           )
        
        , tmpMF_TotalSummChangePercent AS (SELECT MovementFloat_TotalSummChangePercent.*
                                           FROM  MovementFloat AS MovementFloat_TotalSummChangePercent
                                           WHERE MovementFloat_TotalSummChangePercent.DescId =  zc_MovementFloat_TotalSummChangePercent()
                                             AND MovementFloat_TotalSummChangePercent.MovementId IN (SELECT tmpMovementCheck.Id FROM tmpMovementCheck)
                                          )

        , tmpCheck AS (SELECT Movement_Check.UnitId
                            , Movement_Check.Id
                            , Movement_Check.OperDate
                            , SUM (CASE WHEN COALESCE (tmpMovSP.MovementId, 0) <> 0 THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE 0 END) AS SummChangePercent_SP
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() 
                                        THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) 
                                        ELSE 0 
                                   END)                                                                                    AS SummSale_1303
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN 1 ELSE 0 END) AS Count_1303
                       FROM tmpMovementCheck AS Movement_Check
                            LEFT JOIN tmpMLO_SPKind AS MovementLinkObject_SPKind
                                                    ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                            -- ���. ���. �������                        
                            LEFT JOIN tmpMovSP ON tmpMovSP.MovementId = Movement_Check.Id
                            -- ����� ����� ������
                            LEFT JOIN tmpMF_TotalSummChangePercent AS MovementFloat_TotalSummChangePercent
                                                                   ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                     
                       GROUP BY Movement_Check.Id
                              , Movement_Check.UnitId
                              , Movement_Check.OperDate
                      )
                   
        , tmpMI_All AS (SELECT Movement_Check.UnitId
                             , Movement_Check.OperDate
                             , Movement_Check.Id
                             , (COALESCE (Movement_Check.SummChangePercent_SP, 0))   AS SummChangePercent_SP
                             , (COALESCE (Movement_Check.SummSale_1303, 0))          AS SummSale_1303
                             , (COALESCE (Movement_Check.Count_1303, 0))             AS Count_1303
                             , MI_Check.Id             AS MI_Id
                             , MI_Check.Amount
                        FROM tmpCheck AS Movement_Check
                             INNER JOIN MovementItem AS MI_Check
                                                     ON MI_Check.MovementId = Movement_Check.Id
                                                    AND MI_Check.DescId = zc_MI_Master()
                                                    AND MI_Check.isErased = FALSE
                       )
        , tmpMIF_Price AS (SELECT MIFloat_Price.*
                           FROM MovementItemFloat AS MIFloat_Price
                           WHERE MIFloat_Price.DescId = zc_MIFloat_Price()
                             AND MIFloat_Price.MovementItemId IN (SELECT tmpMI_All.MI_Id FROM tmpMI_All)
                           )
        , tmpMIContainer AS (SELECT MIContainer.*
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.DescId = zc_MIContainer_Count() 
                               AND MIContainer.MovementItemId IN (SELECT tmpMI_All.MI_Id FROM tmpMI_All)
                             )
                                    
        , tmpMI AS (SELECT MI_Check.UnitId
                         , MI_Check.OperDate
                         , COALESCE (MI_Check.SummChangePercent_SP, 0)    AS SummChangePercent_SP
                         , COALESCE (MI_Check.SummSale_1303, 0)           AS SummSale_1303
                         , COALESCE (MI_Check.Count_1303, 0)              AS Count_1303
                         , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0))   AS SummaSale
                    FROM tmpMI_All AS MI_Check
                         LEFT JOIN tmpMIF_Price AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MI_Check.MI_Id
                                  
                         LEFT JOIN tmpMIContainer AS MIContainer
                                                  ON MIContainer.MovementItemId = MI_Check.MI_Id
                    GROUP BY MI_Check.UnitId
                           , MI_Check.OperDate
                           , MI_Check.Id
                           , (COALESCE (MI_Check.SummChangePercent_SP, 0))
                           , (COALESCE (MI_Check.SummSale_1303, 0))
                           , (COALESCE (MI_Check.Count_1303, 0))
                    HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0 
                   )                                                               
        -- �������� ������� �� ������� ���.������� 1303
        
        
        , tmpMovement_Sale AS (SELECT CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Sale.OperDate)
                                           WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement_Sale.OperDate)
                                           ELSE NULL END ::TDateTime  AS OperDate
                                    , MovementLinkObject_Unit.ObjectId             AS UnitId
                                    , Movement_Sale.Id                             AS Id
                                    , 1                                            AS Count_1303
                               FROM Movement AS Movement_Sale
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                    
                                    LEFT JOIN MovementString AS MovementString_InvNumberSP
                                           ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                          AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
      
                               WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                 AND Movement_Sale.OperDate >= inDateStart AND Movement_Sale.OperDate < inDateEnd + INTERVAL '1 DAY'
                                 AND ( COALESCE (MovementString_InvNumberSP.ValueData,'') <> ''
                                     )
                                 AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                               )

        , tmpSale_1303 AS (SELECT Movement_Sale.OperDate      AS OperDate
                                , Movement_Sale.UnitId        AS UnitId
                                , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                               -- , SUM (Movement_Sale.Count_1303)  AS Count_1303
                                , Count (DISTINCT Movement_Sale.Id)          AS Count_1303
                           FROM tmpMovement_Sale AS Movement_Sale
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
                           GROUP BY Movement_Sale.OperDate
                                  , Movement_Sale.UnitId
                           ) 
                       
        , tmpPeriod AS (SELECT tmpMI.Unitid
                             , tmpMI.OperDate
                             , COUNT(*)  AS AmountPeriod    -- ����� ���������� �� ���� ������
                             , SUM (tmpMI.SummaSale)  AS SummaSalePeriod-- ����� ����� �� ���� ������
                        FROM  tmpMI
                        GROUP BY tmpMI.Unitid
                               , tmpMI.OperDate
                        )
                          
        , tmpData AS (SELECT tmpMI.Unitid
                           , tmpMI.OperDate

                           , SUM (1 ) AS Amount
                           , SUM (tmpMI.SummaSale) AS SummaSale
                           
                           , SUM (tmpMI.SummChangePercent_SP) AS SummSale_SP
                           , SUM (tmpMI.SummSale_1303)        AS SummSale_1303
                           , SUM (tmpMI.Count_1303)           AS Count_1303
                           
                      FROM (SELECT COALESCE (tmpMI.Unitid, tmpSale_1303.Unitid)     AS UnitId
                                   , COALESCE (tmpMI.OperDate, tmpSale_1303.OperDate) AS OperDate
                                   , COALESCE (tmpMI.SummChangePercent_SP, 0)         AS SummChangePercent_SP
                                   , COALESCE (tmpMI.SummaSale,0)                     AS SummaSale
                                   , COALESCE (tmpMI.SummSale_1303, 0) + COALESCE (tmpSale_1303.SummSale_1303, 0)  AS SummSale_1303
                                   , COALESCE (tmpSale_1303.Count_1303, 0)            AS Count_1303        -- COALESCE (tmpMI.Count_1303, 0) +
                              FROM tmpMI
                                   FULL JOIN tmpSale_1303 ON tmpSale_1303.Unitid = tmpMI.Unitid
                                                         AND COALESCE (tmpSale_1303.OperDate, Null) = COALESCE (tmpMI.OperDate, Null)
                              ) AS tmpMI
                        GROUP BY tmpMI.Unitid
                               , tmpMI.OperDate     
                       )
    
        , DataResult AS(SELECT tmpData.OperDate
                             , tmpData.UnitId
                             
                             , CASE WHEN inisDay = FALSE AND vbDays <> 0 THEN tmpPeriod.AmountPeriod / vbDays ELSE tmpData.Amount END             :: TFloat AS Amount
                             --, tmpData.Amount                :: TFloat AS Amount
                             , tmpPeriod.AmountPeriod        :: TFloat AS AmountPeriod
                             
                             , CASE WHEN inisDay = FALSE AND vbDays <> 0 THEN tmpPeriod.SummaSalePeriod / vbDays ELSE tmpData.SummaSale END       :: TFloat AS SummaSale
                             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddle
                 
                             , tmpPeriod.SummaSalePeriod     :: TFloat AS SummaSalePeriod
                             , CASE WHEN tmpPeriod.AmountPeriod <> 0 THEN tmpPeriod.SummaSalePeriod / tmpPeriod.AmountPeriod ELSE 0 END   :: TFloat AS SummaMiddlePeriod
                 
                             , tmpData.SummSale_SP           :: TFloat AS SummSale_SP
                             , tmpData.SummSale_1303         :: TFloat AS SummSale_1303
                             , tmpData.Count_1303            :: TFloat AS Count_1303
                             
                             , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0))                                                                  :: TFloat AS SummaSaleWithSP
                             , CASE WHEN tmpData.Amount <> 0 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddleWithSP
                             , (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))                                                              :: TFloat AS AmountWith_1303 
                             , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0))                            :: TFloat AS SummaSaleAll
                             , CASE WHEN (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0)) <> 0 
                                    THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0)) / (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))
                                    ELSE 0 
                               END       :: TFloat   AS SummaMiddleAll
                             
                        FROM  tmpData
                              LEFT JOIN tmpPeriod ON tmpPeriod.UnitId = tmpData.UnitId 
                                                 AND ((COALESCE(tmpPeriod.OperDate, NULL) = COALESCE(tmpData.OperDate, NULL)) 
                                                   OR (inisMonth = FALSE AND inisDay = FALSE))
                    )

        -- ���������      
        SELECT tmpData.OperDate            ::TDateTime AS OperDate
             , Object_Unit.ValueData                   AS UnitName
             
             , tmpData.Amount                :: TFloat AS Amount
             , tmpData.AmountPeriod          :: TFloat AS AmountPeriod
             
             , tmpData.SummaSale             :: TFloat AS SummaSale
             , tmpData.SummaMiddle           :: TFloat AS SummaMiddle
 
             , tmpData.SummaSalePeriod       :: TFloat AS SummaSalePeriod
             , tmpData.SummaMiddlePeriod     :: TFloat AS SummaMiddlePeriod
 
             , tmpData.SummSale_SP           :: TFloat AS SummSale_SP
             , tmpData.SummSale_1303         :: TFloat AS SummSale_1303
             , tmpData.Count_1303            :: TFloat AS Count_1303
             
             , tmpData.SummaSaleWithSP       :: TFloat AS SummaSaleWithSP
             , tmpData.SummaMiddleWithSP     :: TFloat AS SummaMiddleWithSP
             , tmpData.AmountWith_1303       :: TFloat AS AmountWith_1303 
             , tmpData.SummaSaleAll          :: TFloat AS SummaSaleAll
             , tmpData.SummaMiddleAll        :: TFloat AS SummaMiddleAll
 
             , COALESCE (CAST (CASE WHEN tmpData.SummaMiddleAll <> 0 THEN (tmpData.SummaMiddleAll * 100 / DataResult.SummaMiddleAll) - 100  ELSE 0 END  AS NUMERIC (16,2)), 0) :: TFloat AS PersentMiddle
             
        FROM DataResult AS tmpData
             LEFT JOIN DataResult ON DataResult.UnitId = tmpData.UnitId
                                 AND ((DataResult.OperDate + interval '1 month' = tmpData.OperDate AND inisMonth = TRUE) 
                                   OR (DataResult.OperDate + interval '1 day' = tmpData.OperDate AND inisDay = TRUE)
                                   OR (inisMonth = FALSE AND inisDay = FALSE))

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 

        ORDER BY 2, 1 ;

    RETURN NEXT Cursor1;
             
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

   
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 09.10.17         *
*/

-- ����
--select * from gpReport_CheckMiddle_Detail(inUnitId := 183292, inDateStart := ('01.01.2016')::TDateTime , inDateEnd := ('31.03.2016')::TDateTime , inisDay := 'FALSE' ::boolean , inisMonth:= 'TRUE' ::boolean , inSession := '3' ::TVarChar);
-- FETCH ALL "<unnamed portal 18>";

--183292
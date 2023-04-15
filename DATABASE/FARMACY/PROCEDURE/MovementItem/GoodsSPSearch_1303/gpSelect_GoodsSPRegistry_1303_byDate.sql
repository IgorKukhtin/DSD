 -- Function: gpSelect_GoodsSPRegistry_1303_byDate()

DROP FUNCTION IF EXISTS gpSelect_GoodsSPRegistry_1303_byDate (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSPRegistry_1303_byDate(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (GoodsId        Integer
             , DateStart      TDateTime
             , DateEnd        TDateTime
             , PriceOptSP     TFloat
             , PriceSale      TFloat
             , MovementItemId Integer
             , isOrder408     Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;  
    DECLARE vbDateEnd TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP_1303());
    vbUserId:= lpGetUserBySession (inSession);

    
    vbDateEnd := (SELECT MovementDate_OperDateStart.ValueData - INTERVAL '1 DAY'
                  FROM Movement 
                       LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                              ON MovementDate_OperDateStart.MovementId = Movement.Id
                                             AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                  WHERE Movement.Id = 28678810
                  );

    -- ���������
    RETURN QUERY
    WITH
        tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                             , ObjectFloat_NDSKind_NDS.ValueData
                        FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                        WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS())
      , tmpMovGoodsSP_1303 AS (SELECT Movement.Id                           AS Id
                                    , Movement.OperDate                     AS OperDate
                                    , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC) AS ord
                               FROM Movement 
                               WHERE Movement.DescId = zc_Movement_GoodsSP_1303()
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 AND Movement.OperDate <= inEndDate
                                 AND vbDateEnd > inStartDate
                               )
     , tmpMIGoodsSP_1303All AS (SELECT MovementItem.Id
                                     , MovementItem.ObjectId
                                     , MovementItem.MovementId
                                     , MovementItem.Amount  
                                FROM MovementItem 
                                WHERE MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.MovementId in (SELECT tmpMovGoodsSP_1303.ID FROM tmpMovGoodsSP_1303)
                                  AND MovementItem.isErased = False
                                )
     , tmpMIFGoodsSP_1303 AS (SELECT * FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIGoodsSP_1303All.Id FROM tmpMIGoodsSP_1303All))
     , tmpMIGoodsSP_1303 AS (SELECT Movement.OperDate                              AS DateStart
                                  , COALESCE (MovementNext.OperDate, vbDateEnd)    AS DateEnd
                                  , MovementItem.ObjectId                          AS GoodsId
                                  , MovementItem.Amount                            AS PriceSale
                                  , MIFloat_PriceOptSP.ValueData                   AS PriceOptSP
                             FROM tmpMovGoodsSP_1303 AS Movement
                            
                                  INNER JOIN tmpMIGoodsSP_1303All AS MovementItem 
                                                                  ON MovementItem.MovementId = Movement.Id
                                                       
                                  LEFT JOIN tmpMIFGoodsSP_1303 AS MIFloat_PriceOptSP
                                                               ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()

                                  LEFT JOIN tmpMovGoodsSP_1303 AS MovementNext
                                                               ON MovementNext.Ord =  Movement.Ord + 1
                                                       
                             )
     , tmpGoodsSPRegistry_1303 AS (select * from gpSelect_GoodsSPRegistry_1303_All(inSession := inSession))
     
     , tmpMovGoodsSPSearch_1303 AS (SELECT Movement.Id                           AS Id
                                         , Movement.InvNumber                    AS InvNumber
                                         , Movement.OperDate                     AS OperDate
                                         , MovementDate_OperDateStart.ValueData  AS OperDateStart
                                         , MovementDate_OperDateEnd.ValueData    AS OperDateEnd
                                         , ROW_NUMBER() OVER (ORDER BY MovementDate_OperDateStart.ValueData) AS Ord

                                    FROM Movement 

                                         LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

                                         LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                                    WHERE Movement.DescId = zc_Movement_GoodsSPSearch_1303()
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                      AND Movement.Id >= 28678810
                                      AND MovementDate_OperDateStart.ValueData <= inEndDate 
                                      AND MovementDate_OperDateEnd.ValueData >= inStartDate
                                    )
     , tmpMIGoodsSPSearch_1303All AS (SELECT MovementItem.Id
                                           , MovementItem.MovementId
                                           , MovementItem.ObjectId                                         AS GoodsId
                                           , MIFloat_PriceOptSP.ValueData                                  AS PriceOptSP
                                           , ROUND(MIFloat_PriceOptSP.ValueData  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale

                                                                            -- � �/� - �� ������ ������
                                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.MovementId, MovementItem.ObjectId ORDER BY MIDate_OrderDateSP.ValueData DESC) AS Ord
                                      FROM MovementItem

                                           LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                                       ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                           LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                                       ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                           LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                                      ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                                     AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                                           LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                                           LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

                                      WHERE MovementItem.MovementId in (SELECT tmpMovGoodsSPSearch_1303.ID FROM tmpMovGoodsSPSearch_1303)
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                        AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                     )
     , tmpMovGoodsSPSearch_408 AS (SELECT Movement.Id                           AS Id
                                         , Movement.InvNumber                    AS InvNumber
                                         , Movement.OperDate                     AS OperDate
                                         , MovementDate_OperDateStart.ValueData  AS OperDateStart
                                         , MovementDate_OperDateEnd.ValueData    AS OperDateEnd
                                         , ROW_NUMBER() OVER (ORDER BY MovementDate_OperDateStart.ValueData) AS Ord

                                    FROM Movement 

                                         LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

                                         LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                                    WHERE Movement.DescId = zc_Movement_GoodsSP408_1303()
                                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                                      AND Movement.Id >= 28678810
                                      AND MovementDate_OperDateStart.ValueData <= inEndDate 
                                      AND MovementDate_OperDateEnd.ValueData >= inStartDate
                                    )
     , tmpMIGoodsSPSearch_408All AS (SELECT MovementItem.Id
                                           , MovementItem.MovementId
                                           , MovementItem.ObjectId                                         AS GoodsId
                                           , MIFloat_PriceOptSP.ValueData                                  AS PriceOptSP
                                           , ROUND(MIFloat_PriceOptSP.ValueData  *  1.1 * 1.1 * (1.0 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2)::TFloat AS PriceSale

                                                                            -- � �/� - �� ������ ������
                                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.MovementId, MovementItem.ObjectId ORDER BY MIDate_OrderDateSP.ValueData DESC) AS Ord
                                      FROM MovementItem

                                           LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                                                       ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
                                           LEFT JOIN MovementItemFloat AS MIFloat_OrderNumberSP
                                                                       ON MIFloat_OrderNumberSP.MovementItemId = MovementItem.Id
                                                                      AND MIFloat_OrderNumberSP.DescId = zc_MIFloat_OrderNumberSP()  
                                           LEFT JOIN MovementItemDate AS MIDate_OrderDateSP
                                                                      ON MIDate_OrderDateSP.MovementItemId = MovementItem.Id
                                                                     AND MIDate_OrderDateSP.DescId = zc_MIDate_OrderDateSP()

                                           LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
                                           LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

                                      WHERE MovementItem.MovementId in (SELECT tmpMovGoodsSPSearch_408.ID FROM tmpMovGoodsSPSearch_408)
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                                        AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                        AND COALESCE (MIFloat_PriceOptSP.ValueData, 0) > 0
                                        AND COALESCE (MovementItem.ObjectId, 0) NOT IN (SELECT DISTINCT tmpMIGoodsSPSearch_1303All.GoodsId FROM tmpMIGoodsSPSearch_1303All)
                                     )


                                      
    SELECT tmpMIGoodsSPSearch_1303All.GoodsId
         , tmpMovGoodsSPSearch_1303.OperDateStart            AS DateStart
         , CASE WHEN tmpMovGoodsSPSearch_1303Next.OperDateStart IS NULL
                  OR tmpMovGoodsSPSearch_1303.OperDateEnd > tmpMovGoodsSPSearch_1303Next.OperDateStart
           THEN tmpMovGoodsSPSearch_1303.OperDateEnd  
           ELSE tmpMovGoodsSPSearch_1303Next.OperDateStart - INTERVAL '1 DAY' END :: TDateTime  AS DateEnd
         , tmpMIGoodsSPSearch_1303All.PriceOptSP
         , tmpMIGoodsSPSearch_1303All.PriceSale
         , tmpMIGoodsSPSearch_1303All.Id                     AS MovementItemId
         , False                                             AS isOrder408
    FROM tmpMovGoodsSPSearch_1303

         INNER JOIN tmpMIGoodsSPSearch_1303All ON tmpMIGoodsSPSearch_1303All.MovementId = tmpMovGoodsSPSearch_1303.Id
                                              AND tmpMIGoodsSPSearch_1303All.Ord = 1

         LEFT JOIN tmpMovGoodsSPSearch_1303 AS tmpMovGoodsSPSearch_1303Next
                                            ON tmpMovGoodsSPSearch_1303Next.Ord =  tmpMovGoodsSPSearch_1303.Ord + 1
    UNION ALL
    SELECT tmpMIGoodsSPSearch_408All.GoodsId
         , tmpMovGoodsSPSearch_408.OperDateStart            AS DateStart
         , CASE WHEN tmpMovGoodsSPSearch_408Next.OperDateStart IS NULL
                  OR tmpMovGoodsSPSearch_408.OperDateEnd > tmpMovGoodsSPSearch_408Next.OperDateStart
           THEN tmpMovGoodsSPSearch_408.OperDateEnd  
           ELSE tmpMovGoodsSPSearch_408Next.OperDateStart - INTERVAL '1 DAY' END :: TDateTime  AS DateEnd
         , tmpMIGoodsSPSearch_408All.PriceOptSP
         , tmpMIGoodsSPSearch_408All.PriceSale
         , tmpMIGoodsSPSearch_408All.Id                     AS MovementItemId
         , True                                             AS isOrder408
    FROM tmpMovGoodsSPSearch_408

         INNER JOIN tmpMIGoodsSPSearch_408All ON tmpMIGoodsSPSearch_408All.MovementId = tmpMovGoodsSPSearch_408.Id
                                             AND tmpMIGoodsSPSearch_408All.Ord = 1

         LEFT JOIN tmpMovGoodsSPSearch_408 AS tmpMovGoodsSPSearch_408Next
                                           ON tmpMovGoodsSPSearch_408Next.Ord =  tmpMovGoodsSPSearch_408.Ord + 1
    UNION ALL
    SELECT tmpMIGoodsSP_1303.GoodsId
         , tmpMIGoodsSP_1303.DateStart
         , tmpMIGoodsSP_1303.DateEnd
         , tmpMIGoodsSP_1303.PriceOptSP
         , tmpMIGoodsSP_1303.PriceSale
         , tmpGoodsSPRegistry_1303.MovementItemId
         , False                                             AS isOrder408
    FROM tmpMIGoodsSP_1303

         LEFT JOIN tmpGoodsSPRegistry_1303 ON tmpGoodsSPRegistry_1303.GoodsMainId = tmpMIGoodsSP_1303.GoodsId
            
    ;
                 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.05.22                                                       *
*/

-- ����
-- 


select * from gpSelect_GoodsSPRegistry_1303_byDate(inStartDate := '01.04.2023', inEndDate  := '30.04.2023', inSession := '3')
-- Function:  gpReport_Movement_Check_UnLiquid()

DROP FUNCTION IF EXISTS gpReport_Movement_Check_UnLiquid (Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Movement_Check_UnLiquid(
    IN inUnitId           Integer  ,  -- �������������
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (
  GoodsId        Integer, 
  GoodsCode      Integer, 
  GoodsName      TVarChar,
  GoodsGroupName TVarChar, 
  NDSKindName TVarChar, 
  
  RemainsStart      TFloat,
  Price_Sale        Tfloat,    
  Amount_Sale       TFloat,
  Summa_Sale        TFloat,
  Amount_Sale1      TFloat,
  Summa_Sale1       TFloat,
  Amount_Sale3      Tfloat,     
  Summa_Sale3       Tfloat,
  Amount_Sale6      TFloat,
  Summa_Sale6       TFloat,
  TotalAmount       TFloat,
  TotalSumma        TFloat

)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- ����������� �� �������� ��������� �����������
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    -- ��������� �����
    inStartDate:= DATE_TRUNC ('DAY', inStartDate);
    inEndDate  := DATE_TRUNC ('DAY', inEndDate);


    -- ���������
    RETURN QUERY
      WITH 
              tmpRemains AS ( SELECT tmp.GoodsId
                                   , SUM(tmp.RemainsStart) AS RemainsStart
                              FROM ( SELECT Container.ObjectId      AS GoodsId
                                          , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                          , Container.Id  AS ContainerId
                                     FROM Container
                                          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                                ON ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId
                                                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                               AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                                          LEFT JOIN MovementItemContainer AS MIContainer
                                                                          ON MIContainer.ContainerId = Container.Id
                                                                         AND MIContainer.OperDate >= inStartDate
                                     WHERE Container.DescId = zc_Container_Count()
                                       AND Container.WhereObjectId = inUnitId
                                     GROUP BY Container.Id, Container.ObjectId, Container.Amount
                                     HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                    ) AS tmp
                              GROUP BY tmp.GoodsId
                             )
             
     , tmpCheck_ALL AS ( SELECT MI_Check.ObjectId AS GoodsId
                              -- , MIContainer.ContainerId

                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale
                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale

                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '1 Month' AND Movement_Check.OperDate < inStartDate THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale1
                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '1 Month' AND Movement_Check.OperDate < inStartDate THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale1

                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '3 Month' AND Movement_Check.OperDate < inStartDate - INTERVAL '1 Month' THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale3
                              , SUM (CASE WHEN Movement_Check.OperDate >= inStartDate - INTERVAL '3 Month' AND Movement_Check.OperDate < inStartDate - INTERVAL '1 Month' THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale3

                              , SUM (CASE WHEN Movement_Check.OperDate < inStartDate - INTERVAL '3 Month' THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) ELSE 0 END) AS Amount_Sale6
                              , SUM (CASE WHEN Movement_Check.OperDate < inStartDate - INTERVAL '3 Month' THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS Summa_Sale6

                              , SUM (CASE WHEN Movement_Check.OperDate < inStartDate THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) ELSE 0 END) AS TotalAmount
                              , SUM (CASE WHEN Movement_Check.OperDate < inStartDate THEN COALESCE (/*-1 * MIContainer.Amount,*/ MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0) ELSE 0 END) AS TotalSumma

                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE
                              -- INNER JOIN tmpRemains ON tmpRemains.GoodsId = MI_Check.ObjectId

                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              /*LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = NULL -- MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count()*/
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate - INTERVAL '6 Month' AND Movement_Check.OperDate < inEndDate + INTERVAL '1 Day'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MI_Check.ObjectId
                               -- , MIContainer.ContainerId
                         -- HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )

         , tmpCheck AS ( SELECT tmp.* 
                         FROM (SELECT tmpCheck_ALL.GoodsId
                                    , SUM (tmpCheck_ALL.Amount_Sale) AS Amount_Sale
                                    , SUM (tmpCheck_ALL.Summa_Sale) AS Summa_Sale
      
                                    , SUM (tmpCheck_ALL.Amount_Sale1) AS Amount_Sale1
                                    , SUM (tmpCheck_ALL.Summa_Sale1) AS Summa_Sale1
      
                                    , SUM (tmpCheck_ALL.Amount_Sale3) AS Amount_Sale3
                                    , SUM (tmpCheck_ALL.Summa_Sale3) AS Summa_Sale3

                                    , SUM (tmpCheck_ALL.Amount_Sale6) AS Amount_Sale6
                                    , SUM (tmpCheck_ALL.Summa_Sale6) AS Summa_Sale6

                                    , SUM (tmpCheck_ALL.TotalAmount) AS TotalAmount
                                    , SUM (tmpCheck_ALL.TotalSumma)  AS TotalSumma

                               FROM tmpCheck_ALL
                               GROUP BY tmpCheck_ALL.GoodsId
                               ) AS tmp
                         -- WHERE tmp.Amount_Sale1=0 OR tmp.Amount_Sale3=0 OR tmp.Amount_Sale6=0
                         )
       
        SELECT
            Object_Goods_View.Id                                                AS GoodsId
           ,Object_Goods_View.GoodsCodeInt  ::Integer                           AS GoodsCode
           ,Object_Goods_View.GoodsName                                         AS GoodsName
           ,Object_Goods_View.GoodsGroupName                                    AS GoodsGroupName
           ,Object_Goods_View.NDSKindName
           , tmpRemains.RemainsStart :: TFloat AS RemainsStart
           
           , CASE WHEN tmpCheck.Amount_Sale <> 0 THEN tmpCheck.Summa_Sale / tmpCheck.Amount_Sale ELSE 0 END :: TFloat AS Price_Sale
 
           , tmpCheck.Amount_Sale      :: TFloat AS Amount_Sale
           , tmpCheck.Summa_Sale       :: TFloat AS Summa_Sale

           , tmpCheck.Amount_Sale1      :: TFloat AS Amount_Sale1
           , tmpCheck.Summa_Sale1       :: TFloat AS Summa_Sale1
           , tmpCheck.Amount_Sale3      :: TFloat AS Amount_Sale3
           , tmpCheck.Summa_Sale3       :: TFloat AS Summa_Sale3
           , tmpCheck.Amount_Sale6      :: TFloat AS Amount_Sale6
           , tmpCheck.Summa_Sale6       :: TFloat AS Summa_Sale6

           , tmpCheck.TotalAmount      :: TFloat AS TotalAmount
           , tmpCheck.TotalSumma       :: TFloat AS TotalSumma

        FROM tmpRemains
             LEFT JOIN tmpCheck ON tmpCheck.GoodsId = tmpRemains.GoodsId

             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpRemains.GoodsId

        WHERE COALESCE (tmpCheck.Amount_Sale1, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale3, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale6, 0) =0
        ORDER BY
            GoodsGroupName, GoodsName;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 05.09.16         *
*/

-- ����
-- SELECT * FROM gpReport_Movement_Check_UnLiquid(inUnitId := 183292 , inStartDate := ('01.02.2016')::TDateTime , inEndDate := ('29.02.2016')::TDateTime , inSession := '3');
-- SELECT * FROM gpReport_Movement_Check_UnLiquid (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')

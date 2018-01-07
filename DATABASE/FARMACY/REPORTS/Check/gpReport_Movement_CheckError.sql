-- Function:  gpReport_Movement_CheckError()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckError (Integer, TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Movement_CheckError(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate        TDateTime,  -- Дата окончания
    IN inIsError          Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  OoperDate        TDateTime, 
  InvNumber        TVarChar,
  UnitName         TVarChar,
  OurJuridicalName TVarChar,
  GoodsCode        Integer, 
  GoodsName        TVarChar,
  GoodsGroupName   TVarChar, 
  NDSKindName      TVarChar,
  NDS              TFloat,
  Amount_Movement  TFloat,
  Amount_Container TFloat,
  Price            TFloat,
  Summa_Movement   TFloat,
  Summa_Container  TFloat,
  Amount_Diff      Tfloat,   
  Summa_Diff       Tfloat,      
  isError          Boolean 
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
          WITH
        tmpMovement AS (SELECT Movement_Check.Operdate
                              , Movement_Check.InvNumber
                              , MI_Check.Id                                 AS MovementItemId
                              , MovementLinkObject_Unit.ObjectId            AS UnitId
                              , MI_Check.ObjectId                           AS GoodsId
                              , COALESCE (MIFloat_Price.ValueData, 0)       AS Price
                              , SUM (COALESCE (MI_Check.Amount,0))          AS Amount_Movement
                              , SUM (COALESCE (MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0))         AS Summa_Movement
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            /*  LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() */
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY Movement_Check.Operdate
                                , Movement_Check.InvNumber               
                                , MovementLinkObject_Unit.ObjectId
                                , MI_Check.ObjectId
                                , MI_Check.Id 
                                , COALESCE (MIFloat_Price.ValueData, 0) 
--                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )

      , tmpContainer AS (SELECT tmpMovement.MovementItemId                      AS MovementItemId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount_Container
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * tmpMovement.Price) AS Summa_Container
                         FROM tmpMovement
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = tmpMovement.MovementItemId
                                                             AND MIContainer.DescId = zc_MIContainer_Count()
                         GROUP BY tmpMovement.MovementItemId  
                 )
      
  , tmpALL AS (SELECT tmp.Operdate
                    , tmp.InvNumber
                    , tmp.UnitId
                    , tmp.GoodsId
                    , SUM(tmp.Amount_Movement)  AS Amount_Movement
                    , SUM(tmp.Summa_Movement)   AS Summa_Movement
                    , SUM(tmp.Amount_Container) AS Amount_Container
                    , SUM(tmp.Summa_Container)  AS Summa_Container
               FROM (SELECT tmpMovement.Operdate
                          , tmpMovement.InvNumber
                          , tmpMovement.UnitId
                          , CASE WHEN inIsError = TRUE THEN tmpMovement.GoodsId ELSE 0 END AS GoodsId
                          , tmpMovement.Amount_Movement
                          , tmpMovement.Summa_Movement
                          , tmpContainer.Amount_Container
                          , tmpContainer.Summa_Container
                     FROM tmpMovement
                        LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpMovement.MovementItemId
                     ) AS tmp
                GROUP BY tmp.Operdate
                       , tmp.InvNumber
                       , tmp.UnitId
                       , tmp.GoodsId
               )

        SELECT tmpALL.Operdate
             , tmpALL.InvNumber
             , Object_Unit.ValueData        AS UnitName
             , Object_Juridical.ValueData   AS OurJuridicalName
             , Object_Goods_View.GoodsCodeInt  ::Integer   AS GoodsCode
             , Object_Goods_View.GoodsName                 AS GoodsName
             , Object_Goods_View.GoodsGroupName            AS GoodsGroupName
             , Object_Goods_View.NDSKindName               AS NDSKindName
             , Object_Goods_View.NDS                       AS NDS

             , tmpALL.Amount_Movement  :: TFloat
             , tmpALL.Amount_Container :: TFloat
             , CASE WHEN tmpALL.Amount_Movement <> 0 THEN tmpALL.Summa_Movement / tmpALL.Amount_Movement ELSE 0 END :: TFloat AS Price

             , tmpALL.Summa_Movement  :: TFloat
             , tmpALL.Summa_Container :: TFloat
        
             , (tmpALL.Amount_Movement - tmpALL.Amount_Container) :: TFloat AS Amount_Diff
             , (tmpALL.Summa_Movement - tmpALL.Summa_Container)   :: TFloat AS Summa_Diff
             , CASE WHEN (tmpALL.Amount_Movement - tmpALL.Amount_Container) <> 0 THEN TRUE ELSE FALSE END AS isError
  
        FROM tmpALL
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpALL.UnitId 
             LEFT JOIN ObjectLink AS ObjectLink_Juridical ON ObjectLink_Juridical.ObjectId = Object_Unit.Id 
                                                         AND ObjectLink_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpALL.GoodsId
        WHERE (tmpALL.Amount_Movement - tmpALL.Amount_Container) <> 0

       ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.01.18         *
 10.09.16         *
*/

-- тест
-- select * from gpReport_Movement_CheckError(inUnitId := 183293 , inStartDate := ('24.10.2016')::TDateTime , inEndDate := ('01.11.2016')::TDateTime , inisError := 'False' ,  inSession := '3');
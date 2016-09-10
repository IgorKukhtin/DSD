-- Function:  gpReport_Movement_CheckError()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckError (Integer, TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Movement_CheckError(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
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
  Amount_Movement  TFloat,
  Amount_Conteiner TFloat,
  Price            TFloat,
  Summa_Movement   TFloat,
  Summa_Conteiner  TFloat,
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
             tmpData AS (SELECT Movement_Check.Id                           AS MovementId
                              , MovementLinkObject_Unit.ObjectId            AS UnitId
                              , CASE WHEN inIsError = TRUE THEN MI_Check.ObjectId ELSE 0 END                        AS GoodsId
                              , SUM (COALESCE (MI_Check.Amount,0))          AS Amount_Movement
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount_Conteiner
                              , SUM (COALESCE (MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0))         AS Summa_Movement
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0)) AS Summa_Conteiner
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
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inDateStart AND Movement_Check.OperDate < inDateFinal + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY Movement_Check.Id               
                                , MovementLinkObject_Unit.ObjectId
                                , CASE WHEN inIsError = TRUE THEN MI_Check.ObjectId ELSE 0 END
--                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )
      
        SELECT Movement_Check.Operdate
             , Movement_Check.InvNumber
             , Object_Unit.ValueData        AS UnitName
             , Object_Juridical.ValueData   AS OurJuridicalName
             , Object_Goods_View.Id                        AS GoodsId
             , Object_Goods_View.GoodsCodeInt  ::Integer   AS GoodsCode
             , Object_Goods_View.GoodsName                 AS GoodsName
             , Object_Goods_View.GoodsGroupName            AS GoodsGroupName
             , Object_Goods_View.NDSKindName               AS NDSKindName
           
             , tmpData.Amount_Movement  :: TFloat
             , tmpData.Amount_Conteiner :: TFloat
             , CASE WHEN tmpData.Amount_Movement <> 0 THEN tmpData.Summa_Movement / tmpData.Amount_Movement ELSE 0 END :: TFloat AS Price

             , tmpData.Summa_Movement  :: TFloat
             , tmpData.Summa_Conteiner :: TFloat
        
             , (tmpData.tmpData.Amount_Movement - tmpData.Amount_Conteiner) :: TFloat AS Amount_Diff
             , (tmpData.tmpData.Summa_Movement - tmpData.Summa_Conteiner)   :: TFloat AS Summa_Diff
             , CASE WHEN (tmpData.tmpData.Amount_Movement - tmpData.Amount_Conteiner) <> 0 THEN TRUE ELSE FALSE END AS isError
  
        FROM tmpData
             LEFT JOIN Movement AS Movement_Check ON Movement_Check = tmpData.MovementId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 
             LEFT JOIN ObjectLink AS ObjectLink_Juridical ON ObjectLink_Juridical.ObjectId = Object_Unit.Id 
                                                         AND ObjectLink_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId

       ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 14.03.16         *
*/

-- тест
-- 
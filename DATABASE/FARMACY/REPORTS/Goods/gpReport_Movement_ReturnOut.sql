 -- Function: gpReport_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpReport_Movement_ReturnOut (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_ReturnOut(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- на торг.сеть
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inisUnitList       Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, BranchDate TDateTime
             , InvNumber TVarChar
             , InvNumberPartner TVarChar
             , IncomeOperDate TDateTime
             , IncomeInvNumber TVarChar
             , NDSKindName TVarChar
             , NDS TFloat
             , StatusCode Integer
             , ReturnTypeName TVarChar
             , FromName TVarChar
             , ToName TVarChar
             , JuridicalName TVarChar
             , GoodsCode Integer
             , GoodsName TVarChar
             , GoodsGroupName TVarChar
             , Amount TFloat
             , PriceWithVAT TFloat
             , SummaWithVAT TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;
    
    -- список подразделений
    INSERT INTO tmpUnit (UnitId)
                SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0 
                  AND inisUnitList = FALSE
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                  AND inisUnitList = FALSE
               UNION
                SELECT ObjectBoolean_Report.ObjectId          AS UnitId
                FROM ObjectBoolean AS ObjectBoolean_Report
                WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                  AND ObjectBoolean_Report.ValueData = TRUE
                  AND inisUnitList = TRUE;
            
    -- Результат
    RETURN QUERY
    WITH 
     tmpMovement AS (SELECT Movement_ReturnOut_View.Id
                          , Movement_ReturnOut_View.InvNumber
                          , Movement_ReturnOut_View.InvNumberPartner
                          , Movement_ReturnOut_View.OperDate
                          , Movement_ReturnOut_View.OperDatePartner
                          , MovementDate_Branch.ValueData          AS BranchDate
                          , Movement_ReturnOut_View.StatusCode
                          , Movement_ReturnOut_View.StatusName
                          , Movement_ReturnOut_View.TotalCount
                          , Movement_ReturnOut_View.TotalSummMVAT
                          , Movement_ReturnOut_View.TotalSumm
                          , Movement_ReturnOut_View.PriceWithVAT
                          , Movement_ReturnOut_View.FromId
                          , Movement_ReturnOut_View.FromName
                          , Movement_ReturnOut_View.ToId
                          , Movement_ReturnOut_View.ToName
                          , Movement_ReturnOut_View.NDSKindId
                          , Movement_ReturnOut_View.NDSKindName
                          , ObjectFloat_NDSKind_NDS.ValueData  AS NDS
                          , Movement_ReturnOut_View.MovementIncomeId
                          , Movement_ReturnOut_View.IncomeOperDate
                          , Movement_ReturnOut_View.IncomeInvNumber
                          , Movement_ReturnOut_View.JuridicalName
                          , Movement_ReturnOut_View.ReturnTypeName
                          , Movement_ReturnOut_View.AdjustingOurDate
                          --, COALESCE (MovementString_Comment.ValueData,'')        :: TVarChar AS Comment
                     FROM tmpUnit
                          LEFT JOIN Movement_ReturnOut_View ON Movement_ReturnOut_View.FromId = tmpUnit.UnitId
                                                           AND Movement_ReturnOut_View.OperDate BETWEEN inStartDate AND inEndDate
                                                          -- AND Movement_ReturnOut_View.StatusId = zc_Enum_Status_Complete()
               
                          LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                ON ObjectFloat_NDSKind_NDS.ObjectId = Movement_ReturnOut_View.NDSKindId 
                                               AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                          LEFT JOIN MovementDate AS MovementDate_Branch
                                                 ON MovementDate_Branch.MovementId = Movement_ReturnOut_View.Id
                                                AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                     )

   , tmpMI AS (SELECT MovementItem.*
                    --, ROW_NUMBER() OVER (Partition BY MovementItem.MovementId ORDER BY MovementItem.Id) AS ord
               FROM tmpMovement AS Movement
                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = FALSE
               )

   , tmpMIFloat_Price AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat
                          WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                            AND MovementItemFloat.DescId = zc_MIFloat_Price()
                         )

      --
      SELECT Movement.OperDate
           , Movement.BranchDate
           , Movement.InvNumber
           , Movement.InvNumberPartner
           , Movement.IncomeOperDate
           , Movement.IncomeInvNumber
           , Movement.NDSKindName
           , Movement.NDS
           , Movement.StatusCode
           , Movement.ReturnTypeName

           , Movement.FromName
           , Movement.ToName
           , Movement.JuridicalName

           , Object_Goods.ObjectCode           :: Integer   AS GoodsCode
           , Object_Goods.ValueData                         AS GoodsName
           , Object_GoodsGroup.ValueData                    AS GoodsGroupName

           , MovementItem.Amount                            AS Amount

           , ((CASE WHEN Movement.PriceWithVAT THEN MIFloat_Price.ValueData ELSE (MIFloat_Price.ValueData * (1 + Movement.NDS/100)) END )  ::NUMERIC (16, 2)) ::TFloat AS PriceWithVAT                                        --ELSE (MIFloat_Price.ValueData * (1 + Movement.NDS/100))::TFloat END AS PriceWithVAT
           --, (COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData) :: TFloat AS  SummaWithVAT ---
           , (COALESCE (MovementItem.Amount, 0) * (CASE WHEN Movement.PriceWithVAT THEN MIFloat_Price.ValueData ELSE (MIFloat_Price.ValueData * (1 + Movement.NDS/100)) END ) ::NUMERIC (16, 2)) ::TFloat AS SummaWithVAT
      FROM tmpMI AS MovementItem 
           LEFT JOIN tmpMovement AS Movement ON Movement.Id = MovementItem.MovementId

           LEFT JOIN tmpMIFloat_Price AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id

           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = MovementItem.ObjectId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
     ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.11.19         *
*/

-- тест
--
-- select * from gpReport_Movement_ReturnOut(inStartDate := ('15.11.2019')::TDateTime, inEndDate := ('15.11.2019')::TDateTime,  inUnitId := 0 , inRetailId := 0, inJuridicalId := 0, inisUnitList := 'False' ,  inSession := '3');


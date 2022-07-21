-- Function:  gpReport_IncomeDubly()

DROP FUNCTION IF EXISTS gpReport_IncomeDubly (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_IncomeDubly(
    IN inDateStart              TDateTime,  -- Дата начала
    IN inDateFinal              TDateTime,  -- Двта конца
    IN inUnitID                 Integer,    -- Подразделение
    IN inisShowAll              Boolean,    -- Показать все
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (ORD           Integer
             , ToId          Integer
             , ToName        TVarChar
             , FromId        Integer
             , FromName      TVarChar
             , OperDate      TDateTime
             , InvNumber     TVarChar
             , StatusId      Integer
             , StatusName    TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     inDateStart := DATE_TRUNC ('day', inDateStart);
     inDateFinal   := DATE_TRUNC ('day', inDateFinal) + interval '1 day';
      
     -- Результат
     RETURN QUERY
     WITH Movement_Income AS ( SELECT Movement_Income.Id
                                    , Movement_Income.InvNumber
                                    , Movement_Income.OperDate
                                    , Movement_Income.StatusId
                                    , MovementLinkObject_To.ObjectId        AS ToId
                                    , MovementLinkObject_From.ObjectId      AS FromId
                                    , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                               FROM Movement AS Movement_Income 
                               
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()                

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

                               WHERE Movement_Income.OperDate >= inDateStart 
                                 AND Movement_Income.OperDate < inDateFinal
                                 AND Movement_Income.DescId = zc_Movement_Income()
                                 AND (MovementLinkObject_To.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                                 AND (Movement_Income.StatusId <> zc_Enum_Status_Erased() OR inisShowAll = True)
                               )
        , MI_Income AS (SELECT MovementItem.MovementId
                             , Movement_Income.OperDate
                             , Movement_Income.ToId
                             , Movement_Income.FromId
                             , Movement_Income.StatusId
                             , MovementItem.ObjectId                        AS GoodsId
                             , SUM(MovementItem.Amount)::TFloat             AS Amount
                        FROM Movement_Income
 
                             JOIN MovementItem ON MovementItem.MovementId = Movement_Income.Id
                                              AND MovementItem.DescId     = zc_MI_Master()

                        GROUP BY MovementItem.MovementId
                               , Movement_Income.OperDate
                               , Movement_Income.ToId
                               , Movement_Income.FromId
                               , Movement_Income.StatusId
                               , MovementItem.ObjectId  
                         )
        , MI_IncomeGroup AS (SELECT MovementItem.MovementId
                                  , MovementItem.OperDate
                                  , MovementItem.ToId
                                  , MovementItem.FromId
                                  , Min(MovementItem.StatusId)  AS StatusMinId
                                  , Max(MovementItem.StatusId)  AS StatusMaxId
                                  , string_agg(MovementItem.GoodsId::Text||','||MovementItem.Amount::Text, ',' ORDER BY MovementItem.GoodsId, MovementItem.Amount) AS List
                             FROM MI_Income AS MovementItem
                             GROUP BY MovementItem.MovementId
                                    , MovementItem.OperDate
                                    , MovementItem.ToId
                                    , MovementItem.FromId
                             )
        , tmpCountIncome AS (SELECT Movement_Income.OperDate
                                  , Movement_Income.ToId
                                  , Movement_Income.FromId
                                  , MI_IncomeGroup.StatusMinId
                                  , MI_IncomeGroup.StatusMaxId
                                  , MI_IncomeGroup.List
                                  , count(*)                  AS CountIncome 
                             FROM Movement_Income 
                              
                                  INNER JOIN MI_IncomeGroup ON MI_IncomeGroup.MovementId = Movement_Income.Id
                                   
                             GROUP BY Movement_Income.OperDate
                                    , Movement_Income.ToId
                                    , Movement_Income.FromId
                                    , MI_IncomeGroup.StatusMinId
                                    , MI_IncomeGroup.StatusMaxId
                                    , MI_IncomeGroup.List
                             HAVING count(*) > 1
                             )
        , tmpCountIncomeOrd AS (SELECT Movement_Income.OperDate
                                     , Movement_Income.ToId
                                     , Movement_Income.FromId
                                     , Movement_Income.List
                                     , Movement_Income.StatusMinId
                                     , Movement_Income.StatusMaxId
                                     , ROW_NUMBER()OVER(ORDER BY Movement_Income.List) as ORD
                                FROM tmpCountIncome AS Movement_Income 
                                )

                               
                               
                               
    SELECT tmpCountIncomeOrd.ORD::Integer
         , tmpCountIncomeOrd.ToId
         , Object_To.ValueData               AS ToName
         , tmpCountIncomeOrd.FromId
         , Object_From.ValueData             AS ToFrom
         , tmpCountIncomeOrd.OperDate
         , Movement_Income.InvNumber
         , Movement_Income.StatusId
         , Object_Status.ValueData           AS StatusName
    FROM tmpCountIncomeOrd     
    
         INNER JOIN MI_IncomeGroup ON MI_IncomeGroup.ToId = tmpCountIncomeOrd.ToId
                                  AND MI_IncomeGroup.FromId = tmpCountIncomeOrd.FromId 
                                  AND MI_IncomeGroup.OperDate = tmpCountIncomeOrd.OperDate
                                  AND MI_IncomeGroup.List = tmpCountIncomeOrd.List                                  
                                  
         INNER JOIN Movement_Income ON Movement_Income.ID = MI_IncomeGroup.MovementId
         
         LEFT JOIN Object AS Object_To ON Object_To.Id = tmpCountIncomeOrd.ToId
         LEFT JOIN Object AS Object_From ON Object_From.Id = tmpCountIncomeOrd.FromId
         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId
                  
    WHERE (tmpCountIncomeOrd.StatusMinId = zc_Enum_Status_UnComplete() OR tmpCountIncomeOrd.StatusMaxId = zc_Enum_Status_UnComplete() OR inisShowAll = True)
    ORDER BY tmpCountIncomeOrd.ORD;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.11.19                                                       *

*/

-- тест
-- select * from gpReport_IncomeDubly(inDateStart := ('01.07.2022')::TDateTime , inDateFinal := ('31.07.2022')::TDateTime , inUnitId := 0 , inisShowAll := 'TRUE' ,  inSession := '3');   

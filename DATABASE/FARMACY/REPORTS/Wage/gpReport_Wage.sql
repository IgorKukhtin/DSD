-- Function:  gpReport_Wage()

DROP FUNCTION IF EXISTS gpReport_Wage (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Wage (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Wage(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateEnd          TDateTime,  -- Дата окончания
    IN inIsDay            Boolean  ,  -- группировать по дням
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Operdate            TDateTime, 
  DayOfWeekName       TVarChar, 
  UnitName            TVarChar, 
  PersonalName        TVarChar, 
  PositionName        TVarChar,

  TaxService          TFloat,
  TaxServicePosition  TFloat,
  TaxServicePersonal  TFloat,
  SummaSale           TFloat,
  SummaWage           TFloat,
  SummaPersonal       TFloat
 
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTmpDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- % от выручки подразделения
    --vbTaxService:= (SELECT COALESCE(ObjectFloat.ValueData,0)::TFloat AS TaxService FROM ObjectFloat WHERE ObjectFloat.ObjectId = inUnitId  AND ObjectFloat.DescId = zc_ObjectFloat_Unit_TaxService());

    CREATE TEMP TABLE tmpListDate(OperDate  TDateTime) ON COMMIT DROP;
    
    --Заполняем днями пусографку
    vbTmpDate := inDateStart;
    WHILE vbTmpDate <= inDateEnd
    LOOP
        INSERT INTO tmpListDate(OperDate)
        VALUES(vbTmpDate);
        vbTmpDate := vbTmpDate + INTERVAL '1 DAY';
    END LOOP;  
                        
    -- Результат
    RETURN QUERY
    WITH
   tmpUnit AS (SELECT ObjectLink_Unit_Parent.ObjectId                      AS UnitId 
                    , COALESCE(ObjectFloat_TaxService.ValueData,0)::TFloat AS TaxService 
               FROM ObjectLink AS ObjectLink_Unit_Parent
                   LEFT JOIN ObjectFloat AS ObjectFloat_TaxService
                                         ON ObjectFloat_TaxService.ObjectId = ObjectLink_Unit_Parent.ObjectId 
                                        AND ObjectFloat_TaxService.DescId = zc_ObjectFloat_Unit_TaxService() 
               WHERE ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                 AND (ObjectLink_Unit_Parent.ObjectId = inUnitId  OR ObjectLink_Unit_Parent.ChildObjectId = inUnitId )
               )
               
 , tmpPosition AS (SELECT ObjectFloat_TaxService.ObjectId    AS PositionId
                       , ObjectFloat_TaxService.ValueData   AS TaxService
                  FROM ObjectFloat AS ObjectFloat_TaxService
                  
                  WHERE ObjectFloat_TaxService.DescId = zc_ObjectFloat_Position_TaxService()
                 )
 , tmpmanager AS (SELECT  tmpUnit.UnitId
                        , ObjectLink_Personal_Unit.ObjectId       AS PersonalId
                      --, Object_Personal.ValueData               AS PersonalName
                        , Object_Position.Id         AS PositionId
                        , Object_Position.ValueData  AS PositionName
                  FROM tmpUnit
                      INNER JOIN ObjectLink AS ObjectLink_Personal_Unit 
                                            ON ObjectLink_Personal_Unit.ChildObjectId = tmpUnit.UnitId
                                           AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit() 
                                          
                      LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                           ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Unit.ObjectId
                                          AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                      LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
 
                  WHERE Object_Position.ValueData Like '%Менеджер%' OR Object_Position.ValueData Like '%менеджер%' 
                  ) 
 , tmpMovementCheck AS (SELECT date_trunc('day', Movement_Check.OperDate) ::TDateTime       AS OperDate
                             , SUM(-MIContainer.Amount*MIFloat_Price.ValueData)::TFloat     AS SummaSale
                             , MovementLinkObject_Unit.ObjectId                             AS UnitId  
                        FROM Movement AS Movement_Check
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        --AND MovementLinkObject_Unit.ObjectId = inUnitId+
                           INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                           
                           INNER JOIN MovementItem AS MI_Check
                                    ON MI_Check.MovementId = Movement_Check.Id
                                   AND MI_Check.DescId = zc_MI_Master()
                                   AND MI_Check.isErased = FALSE
                           LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.MovementItemId = MI_Check.Id
                                                 AND MIContainer.DescId = zc_MIContainer_Count() 
     
                        WHERE Movement_Check.DescId = zc_Movement_Check()
                          AND date_trunc('day', Movement_Check.OperDate) between inDateStart AND inDateEnd
                          AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                        GROUP BY date_trunc('day', Movement_Check.OperDate) , MovementLinkObject_Unit.ObjectId  
                        HAVING SUM(MI_Check.Amount) <> 0 
                       )
                       
 , tmpListPersonal AS (
                   SELECT date_trunc('day',Movement.OperDate) AS OperDate
                        , tmpUnit.UnitId
                        , MI_SheetWorkTime.ObjectId           AS PersonalId
                        , MIObject_Position.ObjectId          AS PositionId
                 
                   FROM Movement
                      INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                            -- AND MovementLinkObject_Unit.ObjectId = inUnitId
                      INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                      
                      INNER JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                      INNER JOIN Object AS Object_Personal ON Object_Personal.Id = MI_SheetWorkTime.ObjectId
                      LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                       ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                      AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                      INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                        ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                                       AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                                       AND MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Work()
                                                                               
                   WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                     AND date_trunc('day',Movement.OperDate) between inDateStart AND inDateEnd
                   --  AND COALESCE(MI_SheetWorkTime.Amount,0)>0
                   GROUP BY date_trunc('day',Movement.OperDate)
                        , MI_SheetWorkTime.ObjectId 
                        , MIObject_Position.ObjectId 
                        , tmpUnit.UnitId
          
                UNION
                   SELECT tmpListDate.OperDate
                        , tmpmanager.UnitId
                        , tmpmanager.PersonalId
                        , tmpmanager.PositionId
                   FROM tmpListDate, tmpmanager 
                      )
                       
   --% выплат должностей
 , tmpList1 AS (SELECT DISTINCT tmpListPersonal.OperDate
                     , tmpListPersonal.UnitId
                     , tmpListPersonal.PositionId
                     , tmpPosition.TaxService
                FROM tmpListPersonal
                   LEFT JOIN tmpPosition ON tmpPosition.PositionId = tmpListPersonal.PositionId
                WHERE tmpPosition.TaxService<>0
               )
--% выплат для всех у кого % выплат = 0
 , tmpList2 AS (SELECT tmpListPersonal.OperDate
                     , tmpUnit.UnitId
                    -- , tmpPosition.PositionId
                     , (tmpUnit.TaxService - COALESCE(tmp.TaxService,0))::TFloat AS TaxService
                FROM tmpUnit
                   LEFT JOIN tmpListPersonal ON tmpListPersonal.UnitId = tmpUnit.UnitId
                   LEFT JOIN tmpPosition ON tmpPosition.PositionId = tmpListPersonal.PositionId
                   LEFT JOIN (SELECT SUM (tmpList1.TaxService) AS TaxService , tmpList1.OperDate, tmpList1.UnitId
                              FROM tmpList1
                              GROUP BY tmpList1.OperDate, tmpList1.UnitId
                              ) AS tmp ON tmp.UnitId   = tmpListPersonal.UnitId 
                                      AND tmp.OperDate = tmpListPersonal.OperDate
                Where tmpPosition.TaxService = 0
                GROUP BY tmpListPersonal.OperDate
                       , tmpUnit.UnitId
                   --    , tmpPosition.PositionId
                       , tmpUnit.TaxService
                       ,  COALESCE(tmp.TaxService,0)
               )
-- теперь все должности подразделения с % выплат
 , tmplist3 AS (SELECT tmpList1.OperDate
                 , tmpList1.UnitId
                 , tmpList1.PositionId
                 , tmpList1.TaxService
                FROM tmpList1
             UNION 
               /* SELECT tmpList2.OperDate
                 , tmpList2.UnitId
                 , tmpList2.PositionId
                 , tmpList2.TaxService
                FROM tmpList2
*/
                SELECT DISTINCT tmpListPersonal.OperDate
                     , tmpListPersonal.UnitId
                     , tmpListPersonal.PositionId
                     , tmpList2.TaxService
                FROM tmpListPersonal
                   LEFT JOIN tmpList2 ON tmpList2.UnitId   = tmpListPersonal.UnitId 
                                     AND tmpList2.OperDate = tmpListPersonal.OperDate
                   LEFT JOIN tmpPosition ON tmpPosition.PositionId = tmpListPersonal.PositionId
                WHERE tmpPosition.TaxService = 0
              )
-- считаем сколько сотр. с одинаковыми должнотсями и % выплат
 , tmpList4 AS (SELECT tmp.OperDate
                   , tmp.UnitId
                   --, tmp.PositionId
                   , tmp.TaxService
                   , COUNT (*) AS PersonalCount
                FROM ( SELECT tmpListPersonal.OperDate
                           , tmpListPersonal.UnitId
                           , tmpListPersonal.PositionId
                           , tmpListPersonal.PersonalId
                           , tmplist3.TaxService
                       FROM tmpListPersonal
                          LEFT JOIN tmplist3 ON tmplist3.OperDate = tmpListPersonal.OperDate
                                            AND tmplist3.UnitId   = tmpListPersonal.UnitId
                                            AND tmplist3.PositionId = tmpListPersonal.PositionId
                      ) AS tmp
                GROUP BY tmp.OperDate
                       , tmp.UnitId
                      -- , tmp.PositionId
                       , tmp.TaxService
              )
              
 , tmpListPersonalAll AS (SELECT tmpListPersonal.OperDate
                               , tmpListPersonal.UnitId
                               , tmpListPersonal.PositionId
                               , tmpListPersonal.PersonalId
                               , tmplist3.TaxService
                               , tmplist4.PersonalCount
                      FROM tmpListPersonal
                          LEFT JOIN tmplist3 ON tmplist3.OperDate = tmpListPersonal.OperDate
                                            AND tmplist3.UnitId   = tmpListPersonal.UnitId
                                            AND tmplist3.PositionId = tmpListPersonal.PositionId
                          LEFT JOIN tmplist4 ON tmplist4.OperDate = tmpListPersonal.OperDate
                                            AND tmplist4.UnitId   = tmpListPersonal.UnitId 
                                            AND tmplist4.TaxService   = tmplist3.TaxService  
                    --                        AND tmplist4.PositionId   = tmpListPersonal.PositionId  
                   )
                   
    SELECT tmpALL.Operdate
         , tmpALL.DayOfWeekName
         , tmpALL.UnitName
         , tmpALL.PersonalName
         , tmpALL.PositionName
         , tmpALL.TaxService
         , CASE WHEN inIsDay = TRUE THEN tmpALL.TaxServicePosition ELSE (tmpALL.SummaWage*100/tmpALL.SummaSale)*tmpAll.PersonalCount  END ::Tfloat  AS TaxServicePosition
         , CASE WHEN inIsDay = TRUE THEN tmpALL.TaxServicePersonal ELSE tmpALL.SummaWage*100/tmpALL.SummaSale  END ::Tfloat  AS TaxServicePersonal
         , tmpALL.SummaSale
         , tmpALL.SummaWage
         , tmpALL.SummaPersonal
     
    FROM (
           SELECT CASE WHEN inIsDay = TRUE THEN tmpMovementCheck.Operdate ELSE Null END ::TDateTime AS Operdate
                , CASE WHEN inIsDay = TRUE THEN tmpWeekDay.DayOfWeekName_Full ELSE '' END ::TVarChar AS DayOfWeekName  
                , Object_Unit.ValueData         AS UnitName
                , Object_Personal.ValueData     AS PersonalName
                , Object_Position.ValueData     AS PositionName

                , tmpUnit.TaxService :: Tfloat  AS TaxService
                , SUM(CASE WHEN inIsDay = TRUE 
                           THEN tmpListPersonalAll.TaxService 
                           ELSE 0
                      END) :: Tfloat AS TaxServicePosition
                , SUM(CASE WHEN inIsDay = TRUE THEN (tmpListPersonalAll.TaxService/tmpListPersonalAll.PersonalCount) ELSE 0 END) :: Tfloat AS TaxServicePersonal
                
                , SUM( tmpMovementCheck.SummaSale ) :: Tfloat  AS SummaSale
                , SUM( ((tmpMovementCheck.SummaSale * tmpListPersonalAll.TaxService / 100)/tmpListPersonalAll.PersonalCount) )   :: Tfloat AS SummaWage
                , SUM( CASE WHEN tmpUnit.TaxService<>0 THEN ((tmpMovementCheck.SummaSale * tmpListPersonalAll.TaxService /tmpUnit.TaxService)/tmpListPersonalAll.PersonalCount) ELSE 0 END )  :: Tfloat AS SummaPersonal
                , tmpListPersonalAll.PersonalCount
           FROM tmpUnit
             LEFT JOIN tmpMovementCheck ON tmpMovementCheck.UnitId = tmpUnit.UnitId
             LEFT JOIN tmpListPersonalAll ON tmpListPersonalAll.OperDate = tmpMovementCheck.OperDate
                                         AND tmpListPersonalAll.UnitId = tmpMovementCheck.UnitId
                                          
             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpListPersonalAll.PersonalId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpListPersonalAll.PositionId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovementCheck.UnitId

             LEFT JOIN zfCalc_DayOfWeekName (tmpMovementCheck.Operdate) AS tmpWeekDay ON 1=1
             
           WHERE tmpMovementCheck.SummaSale<>0
           GROUP BY CASE WHEN inIsDay = TRUE THEN tmpMovementCheck.Operdate ELSE Null END 
                , CASE WHEN inIsDay = TRUE THEN tmpWeekDay.DayOfWeekName_Full ELSE '' END
                , Object_Unit.ValueData    
                , Object_Personal.ValueData  
                , Object_Position.ValueData    
                , tmpUnit.TaxService
               -- , tmpListPersonalAll.TaxService
               -- , CASE WHEN inIsDay = TRUE THEN (tmpListPersonalAll.TaxService/tmpListPersonalAll.PersonalCount) ELSE 0 END
               , tmpListPersonalAll.PersonalCount
           ORDER BY 1, Object_Unit.ValueData ) AS tmpALL
           
  ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 23.02.16         *
 14.02.16         * 
*/

-- тест
--select * from gpReport_Wage(inUnitId := 375627 , inDateStart := ('01.09.2015')::TDateTime , inDateFinal := ('30.09.2015')::TDateTime ,  inSession := '3');


--select * from gpReport_Wage(inUnitId := 377605 , inDateStart := ('01.01.2016')::TDateTime , inDateEnd := ('31.01.2016')::TDateTime , inIsDay := 'False' ,  inSession := '3')
--where PersonalName like '%Блино%';
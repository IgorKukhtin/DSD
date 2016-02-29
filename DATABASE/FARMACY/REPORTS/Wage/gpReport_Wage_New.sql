-- Function:  gpReport_Wage()

--DROP FUNCTION IF EXISTS gpReport_Wage (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Wage (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Wage(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateEnd          TDateTime,  -- Дата окончания
    IN inIsDay            Boolean  ,  -- группировать по дням
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Operdate1           TDateTime, 
  OperDate2           TDateTime, 
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

    CREATE TEMP TABLE tmpDate(OperDate  TDateTime, OperDate2  TDateTime) ON COMMIT DROP;

    --::date + interval '10 hour 59 minute 59 second');
    
    --Заполняем днями пусографку с 00.00 до 11.59
    vbTmpDate := inDateStart;
    WHILE vbTmpDate <= inDateEnd
    LOOP
        INSERT INTO tmpDate(OperDate, OperDate2)
        VALUES(vbTmpDate :: Date, vbTmpDate::date + interval  '24 hour');
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
 , tmpAdmin AS (SELECT tmpUnit.UnitId
                     , 3       AS PersonalId   -- сотрудник админ 
                     , 1672498 AS PositionId   -- должность фармацевт - для выпадающих периодов
                FROM tmpUnit
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
-- данные из табеля учета рабочего времени
  , tmp1 AS    (   SELECT MIDate_OperDate.Valuedata AS OperDate1
                        , CASE WHEN MI_SheetWorkTime.amount<>0
                               THEN MIDate_OperDate.Valuedata + (((trunc(MI_SheetWorkTime.amount)*60+(MI_SheetWorkTime.amount-trunc(MI_SheetWorkTime.amount))*100):: TVarChar || ' minute') :: INTERVAL)
                               ELSE MIDate_OperDate.Valuedata::Date+ interval '24 hour' 
                          END AS OperDate2
                        , MovementLinkObject_Unit.ObjectId    AS UnitId
                        , MI_SheetWorkTime.ObjectId           AS PersonalId
                        , MIObject_Position.ObjectId          AS PositionId
                   FROM  Movement 
                      INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                      INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                      
                      INNER JOIN MovementItem AS MI_SheetWorkTime 
                                              ON MI_SheetWorkTime.MovementId = Movement.Id
                                             AND MI_SheetWorkTime.DescId = zc_MI_Master()
                      INNER JOIN Object AS Object_Personal ON Object_Personal.Id = MI_SheetWorkTime.ObjectId
                      INNER JOIN MovementItemLinkObject AS MIObject_Position
                                                       ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                      AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                      INNER JOIN MovementItemLinkObject AS MIObject_WorkTimeKind
                                                        ON MIObject_WorkTimeKind.MovementItemId = MI_SheetWorkTime.Id 
                                                       AND MIObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
                                                       AND (MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_Work() OR MIObject_WorkTimeKind.ObjectId = zc_Enum_WorkTimeKind_WorkTime())
                                                                                        
                      INNER JOIN MovementItem AS MI_SheetWorkTime_Child 
                                              ON MI_SheetWorkTime_Child.ParentId = MI_SheetWorkTime.Id
                                             AND MI_SheetWorkTime_Child.DescId = zc_MI_Child()
                      LEFT JOIN MovementItemDate AS MIDate_OperDate 
                                                 ON MIDate_OperDate.MovementItemId = MI_SheetWorkTime_Child.Id  
                                                AND MIDate_OperDate.DescId = zc_MIDate_OperDate() 
                   WHERE Movement.DescId = zc_Movement_SheetWorkTime()
                     AND Movement.OperDate between inDateStart AND inDateEnd
                )
   -- начало интервалов           
   , tmp2 AS (SELECT tmp1.OperDate1 AS OperDate
               FROM tmp1
             UNION ALL 
               SELECT tmp1.OperDate2 AS OperDate
               FROM tmp1
             union 
               SELECT tmpDate.OperDate
               FROM tmpDate
             union 
               SELECT tmpDate.OperDate2 AS OperDate
               FROM tmpDate
              )
   -- таблица всех интервалов  =  tmp3         
 , tmpListDate AS (SELECT tmp.OperDate1, tmp.OperDate2 -interval  '1 minute' AS OperDate2
                   FROM 
                        (SELECT tmp2.OperDate AS OperDate1
                              , (SELECT min(tmp.OperDate) FROM tmp2 AS tmp WHERE tmp.OperDate > tmp2.OperDate )::TDateTime AS OperDate2
                         FROM tmp2
                        ) AS tmp
                   WHERE Coalesce (tmp.OperDate2,tmp.OperDate1)<>tmp.OperDate1
                   ORDER BY 1
                   )
            
 , tmpListPersonal_1 AS (SELECT DISTINCT
                                tmp3.OperDate1, tmp3.OperDate2
                              , COALESCE (tmp1.UnitId,tmpAdmin.UnitId)          AS UnitId  
                              , COALESCE (tmp1.PersonalId,tmpAdmin.PersonalId)  AS PersonalId
                              , COALESCE (tmp1.PositionId, tmpAdmin.PositionId) AS PositionId
                         FROM tmpListDate AS tmp3 
                            LEFT JOIN tmp1 ON (tmp1.OperDate1 >= tmp3.OperDate1 and tmp1.OperDate1 <  tmp3.OperDate2)
                                           OR (tmp1.OperDate2 >  tmp3.OperDate1 and tmp1.OperDate2 <= tmp3.OperDate2)
                                           OR (tmp1.OperDate1 <  tmp3.OperDate1 and tmp1.OperDate2 >  tmp3.OperDate2)
                            LEFT JOIN tmpAdmin on 1=1                        -- если в промежуток времени никто не работал, вешаем продажи на админа)))
                       UNION
                         SELECT tmpListDate.OperDate1 ,tmpListDate.OperDate2
                              , tmpmanager.UnitId
                              , tmpmanager.PersonalId
                              , tmpmanager.PositionId
                         FROM tmpListDate, tmpmanager 
                       )

-- в промежутки, где нет фармацевта (0%) добавляем админа 
 , tmpListPersonal_2 AS (SELECT tmpListDate.OperDate1, tmpListDate.OperDate2
                              , COALESCE (tmpListPersonal.UnitId,tmpAdmin.UnitId) AS UnitId
                              , COALESCE (tmpListPersonal.PersonalId,tmpAdmin.PersonalId) AS PersonalId
                              , COALESCE (tmpListPersonal.PositionId,tmpAdmin.PositionId) AS PositionId
                              , COALESCE (tmpListPersonal.TaxService,0) AS TaxService
                         FROM tmpListDate
                           LEFT JOIN (SELECT DISTINCT tmpListPersonal.OperDate1, tmpListPersonal.OperDate2
                                           , tmpListPersonal.UnitId
                                           , tmpListPersonal.PersonalId
                                           , tmpListPersonal.PositionId
                                           , tmpPosition.TaxService
                                      FROM tmpListPersonal_1 AS tmpListPersonal
                                         LEFT JOIN tmpPosition ON tmpPosition.PositionId = tmpListPersonal.PositionId
                                      WHERE tmpPosition.TaxService=0) AS tmpListPersonal on tmpListPersonal.OperDate1 =tmpListDate.OperDate1
                                                                                        and tmpListPersonal.OperDate2 =tmpListDate.OperDate2
                                      LEFT JOIN tmpAdmin on 1=1                        -- если в промежуток времени никто не работал, вешаем продажи на админа)))
                         WHERE COALESCE(tmpListPersonal.PersonalId,0) = 0            
                        )

, tmpListPersonal AS (SELECT DISTINCT tmpListPersonal_1.OperDate1, tmpListPersonal_1.OperDate2
                                    , tmpListPersonal_1.UnitId
                                    , tmpListPersonal_1.PersonalId
                                    , tmpListPersonal_1.PositionId
                      FROM tmpListPersonal_1
                    UNION   
                      SELECT DISTINCT tmpListPersonal_2.OperDate1, tmpListPersonal_2.OperDate2
                                    , tmpListPersonal_2.UnitId
                                    , tmpListPersonal_2.PersonalId
                                    , tmpListPersonal_2.PositionId
                      FROM tmpListPersonal_2
                      )


   --% выплат должностей
 , tmpList1 AS (SELECT DISTINCT tmpListPersonal.OperDate1, tmpListPersonal.OperDate2
                     , tmpListPersonal.UnitId
                     , tmpListPersonal.PositionId
                     , tmpPosition.TaxService
                FROM tmpListPersonal
                   LEFT JOIN tmpPosition ON tmpPosition.PositionId = tmpListPersonal.PositionId
                WHERE tmpPosition.TaxService<>0
               )
--% выплат для всех у кого % выплат = 0
 , tmpList2 AS (SELECT tmpListPersonal.OperDate1, tmpListPersonal.OperDate2
                     , tmpUnit.UnitId
                    -- , tmpPosition.PositionId
                     , (tmpUnit.TaxService - COALESCE(tmp.TaxService,0))::TFloat AS TaxService
                FROM tmpUnit
                   LEFT JOIN tmpListPersonal ON tmpListPersonal.UnitId = tmpUnit.UnitId
                   LEFT JOIN tmpPosition ON tmpPosition.PositionId = tmpListPersonal.PositionId
                   LEFT JOIN (SELECT SUM (tmpList1.TaxService) AS TaxService , tmpList1.OperDate1, tmpList1.UnitId
                              FROM tmpList1
                              GROUP BY tmpList1.OperDate1, tmpList1.UnitId
                              ) AS tmp ON tmp.UnitId   = tmpListPersonal.UnitId 
                                      AND tmp.OperDate1 = tmpListPersonal.OperDate1
                Where tmpPosition.TaxService = 0
                GROUP BY tmpListPersonal.OperDate1, tmpListPersonal.OperDate2
                       , tmpUnit.UnitId
                       , tmpUnit.TaxService
                       ,  COALESCE(tmp.TaxService,0)
               )
-- теперь все должности подразделения с % выплат
 , tmplist3 AS (SELECT tmpList1.OperDate1, tmpList1.OperDate2
                 , tmpList1.UnitId
                 , tmpList1.PositionId
                 , tmpList1.TaxService
                FROM tmpList1
             UNION 
              
                SELECT DISTINCT tmpListPersonal.OperDate1, tmpListPersonal.OperDate2
                     , tmpListPersonal.UnitId
                     , tmpListPersonal.PositionId
                     , tmpList2.TaxService
                FROM tmpListPersonal
                   LEFT JOIN tmpList2 ON tmpList2.UnitId   = tmpListPersonal.UnitId 
                                     AND tmpList2.OperDate1 = tmpListPersonal.OperDate1
                   LEFT JOIN tmpPosition ON tmpPosition.PositionId = tmpListPersonal.PositionId
                WHERE tmpPosition.TaxService = 0
              )
-- считаем сколько сотр. с одинаковыми должнотсями и % выплат
 , tmpList4 AS (SELECT tmp.OperDate1, tmp.OperDate2
                   , tmp.UnitId
                   --, tmp.PositionId
                   , tmp.TaxService
                   , COUNT (*) AS PersonalCount
                FROM ( SELECT tmpListPersonal.OperDate1,tmpListPersonal.OperDate2
                           , tmpListPersonal.UnitId
                           , tmpListPersonal.PositionId
                           , tmpListPersonal.PersonalId
                           , tmplist3.TaxService
                       FROM tmpListPersonal
                          LEFT JOIN tmplist3 ON tmplist3.OperDate1 = tmpListPersonal.OperDate1
                                            AND tmplist3.OperDate2 = tmpListPersonal.OperDate2
                                            AND tmplist3.UnitId    = tmpListPersonal.UnitId
                                            AND tmplist3.PositionId = tmpListPersonal.PositionId
                      ) AS tmp
                GROUP BY tmp.OperDate1, tmp.OperDate2
                       , tmp.UnitId
                      -- , tmp.PositionId
                       , tmp.TaxService
              )
              
 , tmpListPersonalAll AS (SELECT tmpListPersonal.OperDate1, tmpListPersonal.OperDate2
                               , tmpListPersonal.UnitId
                               , tmpListPersonal.PositionId
                               , tmpListPersonal.PersonalId
                               , tmplist3.TaxService
                               , tmplist4.PersonalCount
                      FROM tmpListPersonal
                          LEFT JOIN tmplist3 ON tmplist3.OperDate1 = tmpListPersonal.OperDate1
                                            AND tmplist3.OperDate2 = tmpListPersonal.OperDate2
                                            AND tmplist3.UnitId   = tmpListPersonal.UnitId
                                            AND tmplist3.PositionId = tmpListPersonal.PositionId
                          LEFT JOIN tmplist4 ON tmplist4.OperDate1 = tmpListPersonal.OperDate1
                                            AND tmplist4.OperDate2 = tmpListPersonal.OperDate2
                                            AND tmplist4.UnitId   = tmpListPersonal.UnitId 
                                            AND tmplist4.TaxService   = tmplist3.TaxService  
                    --                        AND tmplist4.PositionId   = tmpListPersonal.PositionId  
                   )
                  
 , tmpMovementCheck AS (SELECT tmpListDate.OperDate1                                        AS OperDate1
                             , tmpListDate.OperDate2                                        AS OperDate2
                             , SUM(-MIContainer.Amount*MIFloat_Price.ValueData)::TFloat     AS SummaSale
                             , MovementLinkObject_Unit.ObjectId                             AS UnitId  
                        FROM tmpListDate
                           LEFT JOIN Movement AS Movement_Check
                                              ON Movement_Check.DescId = zc_Movement_Check()
                                             --AND Movement_Check.OperDate between tmpListDate.OperDate1 AND tmpListDate.OperDate2
                                             AND Movement_Check.OperDate >= tmpListDate.OperDate1 AND Movement_Check.OperDate  < tmpListDate.OperDate2 + interval '1 minute'
                                             AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
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
                        
                        GROUP BY tmpListDate.OperDate1, tmpListDate.OperDate2 , MovementLinkObject_Unit.ObjectId  
                        HAVING SUM(MI_Check.Amount) <> 0 
                       )
                       
 
                   
    SELECT tmpALL.Operdate1, tmpALL.OperDate2
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
           SELECT CASE WHEN inIsDay = TRUE THEN tmpMovementCheck.Operdate1 ELSE Null END ::TDateTime AS Operdate1
                , CASE WHEN inIsDay = TRUE THEN tmpMovementCheck.OperDate2 ELSE Null END ::TDateTime AS OperDate2
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
             LEFT JOIN tmpListPersonalAll ON tmpListPersonalAll.OperDate1 = tmpMovementCheck.OperDate1
                                         AND tmpListPersonalAll.OperDate2 = tmpMovementCheck.OperDate2
                                         AND tmpListPersonalAll.UnitId = tmpMovementCheck.UnitId
                                          
             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpListPersonalAll.PersonalId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpListPersonalAll.PositionId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovementCheck.UnitId

             LEFT JOIN zfCalc_DayOfWeekName (tmpMovementCheck.Operdate1) AS tmpWeekDay ON 1=1
             
           WHERE tmpMovementCheck.SummaSale<>0
           GROUP BY CASE WHEN inIsDay = TRUE THEN tmpMovementCheck.Operdate1  ELSE Null END 
                  , CASE WHEN inIsDay = TRUE THEN tmpMovementCheck.OperDate2 ELSE Null END
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
                                                                *

*/

-- тест
--select * from gpReport_Wage(inUnitId := 375627 , inDateStart := ('01.09.2015')::TDateTime , inDateFinal := ('30.09.2015')::TDateTime ,  inSession := '3');


--select * from gpReport_Wage(inUnitId := 377605 , inDateStart := ('01.01.2016')::TDateTime , inDateEnd := ('31.01.2016')::TDateTime , inIsDay := 'False' ,  inSession := '3')
--where PersonalName like '%Блино%';
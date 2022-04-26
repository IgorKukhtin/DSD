-- Function: gpReport_UnitBalance()

DROP FUNCTION IF EXISTS gpReport_UnitBalance_Map (TDateTime, TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_UnitBalance_Map (TDateTime, TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_UnitBalance_Map (TDateTime, TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_UnitBalance_Map(
    IN inStartDate    TDateTime , -- 
    IN inEndDate      TDateTime , -- месяц начислений
    IN inServiceDate  TDateTime , -- месяц начислений
    IN inUnitGroupId  Integer,
    IN inInfoMoneyId  Integer,
    IN inIsAll        Boolean,
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (              
              Id Integer, Code Integer, Name TVarChar
             --, Phone TVarChar, GroupNameFull TVarChar
             --, Comment TVarChar
             , ParentId Integer, ParentName TVarChar
             --, InsertName TVarChar, InsertDate TDateTime
             --, UpdateName TVarChar, UpdateDate TDateTime
             , isPositionFixed Boolean, Left Integer, Top Integer, Width Integer, Height Integer
             , isRootTree Boolean, isLetterTree Boolean
	         , Color Integer, Color_Text Integer 
             --, isErased boolean
             )


AS
$BODY$
   DECLARE vbUserId Integer; 
   DECLARE vbId Integer;
   DECLARE vbStartId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     vbStartId := (SELECT tmp.ID FROM gpGet_Object_Unit_Start (0, inSession) AS tmp);

IF inUnitGroupId = 2 THEN inUnitGroupId:= 0; END IF;

     IF EXISTS(SELECT * FROM ObjectLink AS ObjectLink_Unit_Parent
               WHERE ObjectLink_Unit_Parent.ChildObjectId = inUnitGroupId
                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent())
     THEN
       vbId := 0;
     ELSE
       vbId := inUnitGroupId;
     END IF;
  
  
     -- Результат
     RETURN QUERY
     WITH    
     --все отделы
     tmpUnitAll AS (SELECT Object_Unit.Id                  AS Id
                         , COALESCE (Object_Parent.Id,0)   AS ParentId
                    FROM Object AS Object_Unit

                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                              ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                             AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                         LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

                    WHERE Object_Unit.DescId = zc_Object_Unit()
                    )
     --отделы не группы
   , tmpUnitLast AS (SELECT tmpUnitAll.Id                  AS Id
                     FROM tmpUnitAll
                     WHERE tmpUnitAll.ID not in (SELECT tmpUnitAll.ParentId FROM tmpUnitAll)
                     )
     --отделы нужного уровня и их свойства
   , tmpUnitGroup AS (SELECT tmp.Id 
                           , tmp.ParentId 
                           , COALESCE(ObjectBoolean_PositionFixed.ValueData, FALSE) AS isPositionFixed
                           , ObjectFloat_Left.ValueData::Integer   AS Left
                           , ObjectFloat_Top.ValueData::Integer    AS Top
                           , ObjectFloat_Width.ValueData::Integer  AS Width
                           , ObjectFloat_Height.ValueData::Integer AS Height
                      FROM (SELECT tmpUnitAll.Id 
                                 , tmpUnitAll.ParentId
                            FROM tmpUnitAll   
                            WHERE (COALESCE (tmpUnitAll.ParentId, 0) = COALESCE (inUnitGroupId, 0) OR tmpUnitAll.Id = vbId)
                            ) AS tmp
                                   
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionFixed
                                                  ON ObjectBoolean_PositionFixed.ObjectId = tmp.Id
                                                 AND ObjectBoolean_PositionFixed.DescId = zc_ObjectBoolean_Unit_PositionFixed()
              
                          LEFT JOIN ObjectFloat AS ObjectFloat_Left
                                                ON ObjectFloat_Left.ObjectId = tmp.Id
                                               AND ObjectFloat_Left.DescId = zc_ObjectFloat_Unit_Left()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Top
                                                ON ObjectFloat_Top.ObjectId = tmp.Id
                                               AND ObjectFloat_Top.DescId = zc_ObjectFloat_Unit_Top()
                          LEFT JOIN ObjectFloat AS ObjectFloat_Width
                                                ON ObjectFloat_Width.ObjectId = tmp.Id
                                               AND ObjectFloat_Width.DescId = zc_ObjectFloat_Unit_Width() 
                          LEFT JOIN ObjectFloat AS ObjectFloat_Height
                                                ON ObjectFloat_Height.ObjectId = tmp.Id
                                               AND ObjectFloat_Height.DescId = zc_ObjectFloat_Unit_Height()
                      )
     --данные отчета
   , tmpReport AS (SELECT tmp.UnitId
                        , SUM (COALESCE (tmp.AmountDebet,0))     AS AmountDebet                                
                        , SUM (COALESCE (tmp.AmountKredit,0))    AS AmountKredit                             
                        , SUM (COALESCE (tmp.AmountDebetEnd,0))  AS AmountDebetEnd
                        , SUM (COALESCE (tmp.AmountKreditEnd,0)) AS AmountKreditEnd                        
                   FROM gpReport_UnitBalance ( inStartDate   := inStartDate   
                                             , inEndDate     := inEndDate    
                                             , inServiceDate := inServiceDate
                                             , inUnitGroupId := inUnitGroupId
                                             , inInfoMoneyId := inInfoMoneyId
                                             , inIsAll       := inIsAll
                                             , inSession     := inSession) AS tmp  
                   GROUP BY tmp.UnitId 
                   )    
       
     --определяем к какому отделу нужного уровня соответствует какой отдел, чтоб вывести данные по нужной группировке  
   , tmpGroup AS (SELECT tmp.UnitId
                       , tmp.UnitGroupId
                  FROM (SELECT tmpReport.UnitId
                             , CASE WHEN tmpReport.UnitId IN (SELECT tmp.UnitId 
                                                              FROM lfSelect_Object_Unit_byGroup (tmpUnitGroup.Id) AS tmp) THEN tmpUnitGroup.Id END AS UnitGroupId
                        FROM tmpReport 
                             LEFT JOIN tmpUnitGroup ON 1=1  
                        ) AS tmp
	              WHERE tmp.UnitGroupId is not null
                  )

     --Результат
     SELECT
        Object_Unit.Id                   AS Id
      , Object_Unit. ObjectCode          AS Code
      , (Object_Unit.ValueData||chr(13)||'Н: ' || zfConvert_FloatToString (SUM (COALESCE (tmpReport.AmountDebet, 0)))
                              ||chr(13)||'О: ' || zfConvert_FloatToString (SUM (COALESCE (tmpReport.AmountKredit, 0)))
                              ||chr(13)||'Д: ' || zfConvert_FloatToString (SUM (COALESCE (tmpReport.AmountDebetEnd, 0) - COALESCE (tmpReport.AmountKreditEnd, 0)))
		)::TVarChar AS Name  -- Н-начислено;  О - оплачено; Д-ДОЛГ

      , COALESCE (Object_Parent.Id,0)   AS ParentId
      , Object_Parent.ValueData         AS ParentName
          
      , tmpUnitGroup.isPositionFixed
      , tmpUnitGroup.Left
      , tmpUnitGroup.Top
      , tmpUnitGroup.Width
      , tmpUnitGroup.Height
      
      , COALESCE (Object_Parent.Id,0) = vbStartId AS isRootTree 
      , COALESCE (tmpUnitLast.Id, 0) > 0          AS isLetterTree 

      , zc_Color_Yelow()                          AS Color       
      , zc_Color_Blue()                           AS Color_Text 
     FROM tmpUnitGroup
            LEFT JOIN tmpGroup ON tmpGroup.UnitGroupId = tmpUnitGroup.Id
            LEFT JOIN tmpReport ON tmpReport.UnitId = tmpGroup.UnitId
            
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnitGroup.Id
                   
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = tmpUnitGroup.ParentId

            LEFT JOIN tmpUnitLast ON tmpUnitLast.Id = Object_Unit.Id 
     WHERE (Object_Unit.Id = 52460 AND inUnitGroupId = 0) OR inUnitGroupId <> 0
     GROUP BY Object_Unit.Id
            , Object_Unit. ObjectCode
            , Object_Unit.ValueData
            , COALESCE (Object_Parent.Id,0)
            , Object_Parent.ValueData
            , tmpUnitGroup.isPositionFixed
            , tmpUnitGroup.Left
            , tmpUnitGroup.Top
            , tmpUnitGroup.Width
            , tmpUnitGroup.Height
            , COALESCE (tmpUnitLast.Id, 0)             

     HAVING SUM (COALESCE (tmpReport.AmountDebet, 0))  <> 0
         OR SUM (COALESCE (tmpReport.AmountKredit, 0)) <> 0
         OR SUM (COALESCE (tmpReport.AmountDebetEnd, 0) - COALESCE (tmpReport.AmountKreditEnd, 0)) <> 0
         OR Object_Unit.isErased = FALSE
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.04.22         *
*/

-- тест
-- SELECT * FROM gpReport_UnitBalance_Map (inStartDate := '01.12.2021', inEndDate:= '01.02.2022', inServiceDate:= '01.12.2021', inUnitGroupId:= 52460,inIsAll:=true, inInfoMoneyId:=0 ,inSession:= zfCalc_UserAdmin())

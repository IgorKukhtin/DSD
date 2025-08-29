-- По документу Штатное расписание изменение
-- Function: gpReport_StaffListMovement ()

DROP FUNCTION IF EXISTS gpReport_StaffListMovement (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_StaffListMovement (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListMovement(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inUnitId         Integer,   --подразделение
    IN inDepartmentId   Integer,   --Департамент
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
              DepartmentId                   Integer
            , DepartmentName                 TVarChar
            , UnitId                         Integer
            , UnitName                       TVarChar
            , PositionId                     Integer
            , PositionName                   TVarChar
            , PositionLevelId                Integer
            , PositionLevelName              TVarChar
            , PositionPropertyName           TVarChar  --Классификатор должности 
            , PersonalId                     Integer   --Менеджер по персоналу 
            , PersonalName                   TVarChar  -- 
            , StaffHoursDayName              TVarChar  -- График работы
            , StaffHoursName                 TVarChar  --Години роботи
            , AmountPlan                     TFloat    --План ШР (по классификатору)
            , AmountFact                     TFloat    --Факт ШР
            , Amount_diff                    TFloat    --Дельта 
            , Persent_diff                   TFloat    -- % комлектації
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY

      
  -- результат                      
    SELECT 0  ::Integer   AS DepartmentId                
         , '' ::TVarChar  AS DepartmentName      
         , 0  ::Integer   AS UnitId              
         , '' ::TVarChar  AS UnitName            
         , 0  ::Integer   AS PositionId          
         , '' ::TVarChar  AS PositionName        
         , 0  ::Integer   AS PositionLevelId     
         , '' ::TVarChar  AS PositionLevelName   
         , '' ::TVarChar  AS PositionPropertyName
         , 0  ::Integer   AS PersonalId          
         , '' ::TVarChar  AS PersonalName        
         , '' ::TVarChar  AS StaffHoursDayName   
         , '' ::TVarChar  AS StaffHoursName      
         , 0  ::TFloat    AS AmountPlan              
         , 0  ::TFloat    AS AmountFact          
         , 0  ::TFloat    AS Amount_diff
         , 0  ::TFloat    AS Persent_diff         
    
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.25         *
*/
-- тест
-- select * from gpReport_StaffListMovement (inStartDate:= '26.08.2025'::TDateTime, inEndDate:= '26.08.2025'::TDateTime, inUnitId := 8395 , inDepartmentId := 0 , inSession := '5');
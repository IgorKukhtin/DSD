-- По документу Штатное расписание 
-- Function: gpReport_StaffListRanking ()

DROP FUNCTION IF EXISTS gpReport_StaffListRanking (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StaffListRanking(
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
            , AmountPlan                     TFloat    --План ШР (по классификатору)
            , Amount                         TFloat    --План ШР 
            , AmountFact                     TFloat    --Факт ШР
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
         , 0  ::TFloat    AS AmountPlan
         , 0  ::TFloat    AS Amount              
         , 0  ::TFloat    AS AmountFact          

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
-- select * from gpReport_StaffListRanking (inStartDate:= '26.08.2025'::TDateTime, inEndDate:= '26.08.2025'::TDateTime, inUnitId := 8395 , inDepartmentId := 0 , inSession := '5');
-- Function: gpReport_WageWarehouseBranch()
DROP FUNCTION IF EXISTS gpReport_WageWarehouseBranch (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION gpReport_WageWarehouseBranch(
    IN inStartDate   TDateTime ,              --
    IN inEndDate     TDateTime ,              --
    IN inPersonalId  Integer   ,              -- сотудник
    IN inPositionId  Integer   ,              -- должность
    IN inBranchId    Integer   ,              -- филиал
    --
    IN inKoef_11     TFloat    ,
    IN inKoef_12     TFloat    ,
    IN inKoef_13     TFloat    ,

    IN inKoef_22     TFloat    ,

    IN inKoef_31     TFloat    ,
    IN inKoef_32     TFloat    ,
    IN inKoef_33     TFloat    ,

    IN inKoef_41     TFloat    ,
    IN inKoef_42     TFloat    ,
    IN inKoef_43     TFloat    ,
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , BranchName  TVarChar

             , CountMovement_1  TFloat
             , CountMI_1        TFloat
             , TotalCountKg_1   TFloat

             , CountMovement_1_koef    TFloat
             , CountMI_1_koef          TFloat
             , TotalCountKg_1_koef     TFloat
              -- Стикеровка
             , TotalCountStick_2       TFloat
             , TotalCountStick_2_koef  TFloat
              -- Взвешивание+документация
             , CountMovement1_3 TFloat
             , CountMI1_3       TFloat
             , TotalCountKg1_3  TFloat

             , CountMovement1_3_koef TFloat
             , CountMI1_3_koef       TFloat
             , TotalCountKg1_3_koef  TFloat
              -- Возвраты на филиал
             , CountMovement1_4  TFloat
             , TotalCountKg1_4   TFloat

             , CountMovement1_4_koef TFloat
             , TotalCountKg1_4_koef  TFloat
               -- Возвраты в Днепр
             , TotalCountKg1_5      TFloat
             , TotalCountKg1_5_koef TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalComplete());
     vbUserId:= lpGetUserBySession (inSession);


     IF inSession = '-123'
     THEN
         RETURN;
     ELSE
         -- Результат
         RETURN QUERY
            WITH
            -- сотрудники
            tmpReport AS (SELECT tmp.*
                          FROM gpReport_PersonalComplete (inStartDate := inStartDate
                                                        , inEndDate   := inEndDate
                                                        , inPersonalId:= inPersonalId
                                                        , inPositionId:= inPositionId
                                                        , inBranchId  := inBranchId
                                                        , inIsDay     := FALSE
                                                        , inIsMonth   := FALSE
                                                        , inIsDetail  := True
                                                        , inisMovement:= True
                                                        , inSession   := inSession) AS tmp
                          )

          , tmpData AS (SELECT tmpReport.UnitId
                             , tmpReport.UnitCode
                             , tmpReport.UnitName
                             , tmpReport.PersonalId
                             , tmpReport.PersonalCode
                             , tmpReport.PersonalName
                             , tmpReport.PositionId
                             , tmpReport.PositionCode
                             , tmpReport.PositionName
                             , tmpReport.BranchName
                              --Комплектация
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_Sale() THEN COALESCE (tmpReport.CountMovement,0) ELSE 0 END) AS CountMovement_1
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_Sale() THEN COALESCE (tmpReport.CountMI,0) ELSE 0 END)       AS CountMI_1
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_Sale() THEN COALESCE (tmpReport.TotalCountKg,0) ELSE 0 END)  AS TotalCountKg_1
                              --Стикеровка
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_Sale() THEN COALESCE (tmpReport.TotalCountStick,0) ELSE 0 END) AS TotalCountStick_2
                              --Взвешивание+документация
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_Sale() THEN COALESCE (tmpReport.CountMovement1,0) ELSE 0 END)  AS CountMovement1_3
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_Sale() THEN COALESCE (tmpReport.CountMI1,0) ELSE 0 END)        AS CountMI1_3
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_Sale() THEN COALESCE (tmpReport.TotalCountKg1,0) ELSE 0 END)   AS TotalCountKg1_3
                              --Возвраты в Запорожье
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (tmpReport.CountMovement1,0) ELSE 0 END)    AS CountMovement1_4
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (tmpReport.TotalCountKg1,0) ELSE 0 END)     AS TotalCountKg1_4
                             --Возвраты в Днепр
                             , SUM (CASE WHEN tmpReport.MovementDescId = zc_Movement_SendOnPrice() AND COALESCE (ObjectLink_Unit_Branch.ChildObjectId,0) <> inBranchId
                                         THEN COALESCE (tmpReport.TotalCountKg1,0) ELSE 0 END)  AS TotalCountKg1_5
                        FROM tmpReport
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                    ON ObjectLink_Unit_Branch.ObjectId = tmpReport.ToId
                                   AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                        GROUP BY tmpReport.UnitId
                               , tmpReport.UnitCode
                               , tmpReport.UnitName
                               , tmpReport.PersonalId
                               , tmpReport.PersonalCode
                               , tmpReport.PersonalName
                               , tmpReport.PositionId
                               , tmpReport.PositionCode
                               , tmpReport.PositionName
                               , tmpReport.BranchName
                        )

            -- Результат
            SELECT tmpData.UnitId
                 , tmpData.UnitCode
                 , tmpData.UnitName
                 , tmpData.PersonalId
                 , tmpData.PersonalCode
                 , tmpData.PersonalName
                 , tmpData.PositionId
                 , tmpData.PositionCode
                 , tmpData.PositionName
                 , tmpData.BranchName
                  --Комплектация
                 , tmpData.CountMovement_1                 ::TFloat
                 , tmpData.CountMI_1                       ::TFloat
                 , tmpData.TotalCountKg_1                  ::TFloat

                 , (inKoef_11 * tmpData.CountMovement_1)   ::TFloat AS CountMovement_1_koef
                 , (inKoef_12 * tmpData.CountMI_1)         ::TFloat AS CountMI_1_koef
                 , (inKoef_13 * tmpData.TotalCountKg_1)    ::TFloat AS TotalCountKg_1_koef
                  --Стикеровка
                 , tmpData.TotalCountStick_2               ::TFloat
                 , (inKoef_22 * tmpData.TotalCountStick_2) ::TFloat AS TotalCountStick_2_koef
                  --Взвешивание+документация
                 , tmpData.CountMovement1_3                ::TFloat
                 , tmpData.CountMI1_3                      ::TFloat
                 , tmpData.TotalCountKg1_3                 ::TFloat

                 , (inKoef_31 * tmpData.CountMovement1_3)  ::TFloat AS CountMovement1_3_koef
                 , (inKoef_32 * tmpData.CountMI1_3)        ::TFloat AS CountMI1_3_koef
                 , (inKoef_33 * tmpData.TotalCountKg1_3)   ::TFloat AS TotalCountKg1_3_koef
                  --Возвраты в Запорожье
                 , tmpData.CountMovement1_4                ::TFloat
                 , tmpData.TotalCountKg1_4                 ::TFloat

                 , (inKoef_41 * tmpData.CountMovement1_4)  ::TFloat AS CountMovement1_4_koef
                 , (inKoef_42 * tmpData.TotalCountKg1_4)   ::TFloat AS TotalCountKg1_4_koef
                 --Возвраты в Днепр
                 , tmpData.TotalCountKg1_5                 ::TFloat
                 , (inKoef_43 * tmpData.TotalCountKg1_5)   ::TFloat AS TotalCountKg1_5_koef
            FROM tmpData
            ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.12.23         *
*/

-- тест
/*
SELECT * FROM gpReport_WageWarehouseBranch (inStartDate := ('01.09.2023')::TDateTime , inEndDate := ('30.09.2023')::TDateTime, inPersonalId:= 0, inPositionId:= 0, inBranchId:= 301310
, inKoef_11:= 0.1, inKoef_12:= 0.3, inKoef_13:= 0.15, inKoef_22:= 0.1, inKoef_31:= 0.4, inKoef_32:= 0.3, inKoef_33:= 0.22, inKoef_41:= 0.4, inKoef_42:= 0.2, inKoef_43:= 0.2, inSession:= zfCalc_UserAdmin())
*/
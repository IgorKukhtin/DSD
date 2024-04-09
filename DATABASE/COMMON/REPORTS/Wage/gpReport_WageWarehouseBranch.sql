-- Function: gpreport_wagewarehousebranch()

DROP FUNCTION IF EXISTS gpreport_wagewarehousebranch (tdatetime, tdatetime, integer, integer, integer, boolean, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tfloat, tvarchar);

CREATE OR REPLACE FUNCTION gpreport_wagewarehousebranch(
    IN inStartDate tdatetime,
    IN inEndDate tdatetime,
    IN inPersonalId integer,
    IN inPositionId integer,
    IN inBranchId integer,
    IN inIsDay boolean,
    IN inKoef_11 tfloat,
    IN inKoef_12 tfloat,
    IN inKoef_13 tfloat,
    IN inKoef_22 tfloat,
    IN inKoef_31 tfloat,
    IN inKoef_32 tfloat,
    IN inKoef_33 tfloat,
    IN inKoef_41 tfloat,
    IN inKoef_42 tfloat,
    IN inKoef_43 tfloat,
    IN inSession tvarchar)
  RETURNS TABLE(operdate tdatetime, unitid integer, unitcode integer, unitname tvarchar
              , personalid integer, personalcode integer, personalname tvarchar
              , positionid integer, positioncode integer, positionname tvarchar
              , PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar
              , branchname tvarchar
              , countmovement_1 tfloat
              , countmi_1 tfloat
              , totalcountkg_1 tfloat
              , countmovement_1_koef tfloat
              , countmi_1_koef tfloat
              , totalcountkg_1_koef tfloat
              , totalcountstick_2 tfloat
              , totalcountstick_2_koef tfloat
              , countmovement1_3 tfloat
              , countmi1_3 tfloat
              , totalcountkg1_3 tfloat
              , countmovement1_3_koef tfloat
              , countmi1_3_koef tfloat
              , totalcountkg1_3_koef tfloat
              , countmovement1_4 tfloat
              , totalcountkg1_4 tfloat
              , countmovement1_4_koef tfloat
              , totalcountkg1_4_koef tfloat
              , totalcountkg1_5 tfloat
              , totalcountkg1_5_koef tfloat
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalComplete());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

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
                                                        , inIsDay     := inIsDay
                                                        , inIsMonth   := FALSE
                                                        , inIsDetail  := True
                                                        , inisMovement:= True
                                                        , inSession   := inSession) AS tmp
                          )

          , tmpData AS (SELECT CASE WHEN inIsDay = TRUE THEN tmpReport.OperDate 
                                    ELSE inEndDate
                               END ::TDateTime AS OperDate 
                             , tmpReport.UnitId
                             , tmpReport.UnitCode
                             , tmpReport.UnitName
                             , tmpReport.PersonalId
                             , tmpReport.PersonalCode
                             , tmpReport.PersonalName
                             , tmpReport.PositionId
                             , tmpReport.PositionCode
                             , tmpReport.PositionName
                             , tmpReport.PositionLevelId, tmpReport.PositionLevelCode, tmpReport.PositionLevelName
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
                        GROUP BY CASE WHEN inIsDay = TRUE THEN tmpReport.OperDate 
                                      ELSE inEndDate
                                 END 
                               , tmpReport.UnitId
                               , tmpReport.UnitCode
                               , tmpReport.UnitName
                               , tmpReport.PersonalId
                               , tmpReport.PersonalCode
                               , tmpReport.PersonalName
                               , tmpReport.PositionId
                               , tmpReport.PositionCode
                               , tmpReport.PositionName
                               , tmpReport.PositionLevelId, tmpReport.PositionLevelCode, tmpReport.PositionLevelName
                               , tmpReport.BranchName
                        )

            -- Результат
            SELECT tmpData.OperDate
                 , tmpData.UnitId
                 , tmpData.UnitCode
                 , tmpData.UnitName
                 , tmpData.PersonalId
                 , tmpData.PersonalCode
                 , tmpData.PersonalName
                 , tmpData.PositionId
                 , tmpData.PositionCode
                 , tmpData.PositionName
                 , tmpData.PositionLevelId, tmpData.PositionLevelCode, tmpData.PositionLevelName
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
                           
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.23          *
*/

-- тест
/*
SELECT * FROM gpReport_WageWarehouseBranch (inStartDate := ('01.09.2023')::TDateTime , inEndDate := ('30.09.2023')::TDateTime, inPersonalId:= 0, inPositionId:= 0, inBranchId:= 301310, inisday := FALSE
, inKoef_11:= 0.1, inKoef_12:= 0.3, inKoef_13:= 0.15, inKoef_22:= 0.1, inKoef_31:= 0.4, inKoef_32:= 0.3, inKoef_33:= 0.22, inKoef_41:= 0.4, inKoef_42:= 0.2, inKoef_43:= 0.2, inSession:= zfCalc_UserAdmin())
*/
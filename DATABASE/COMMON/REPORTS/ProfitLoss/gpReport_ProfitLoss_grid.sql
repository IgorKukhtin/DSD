 -- Function: gpReport_ProfitLoss_grid()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss_grid (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss_grid(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inisDirectionDesc     Boolean,
    IN inisDestinationDesc   Boolean,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ProfitLossGroupName TVarChar, ProfitLossDirectionName TVarChar, ProfitLossName  TVarChar
             , PL_GroupName_original TVarChar, PL_DirectionName_original TVarChar, PL_Name_original  TVarChar
             , OnComplete Boolean
             , BusinessName TVarChar, JuridicalName_Basis TVarChar, BranchName_ProfitLoss TVarChar, UnitName_ProfitLoss TVarChar, UnitDescName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyDestinationCode Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , InfoMoneyGroupCode_Detail Integer, InfoMoneyDestinationCode_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar
             , DirectionObjectCode Integer, DirectionObjectName TVarChar, DirectionDescName TVarChar
             , DestinationObjectCode Integer, DestinationObjectName TVarChar, DestinationDescName TVarChar
             , MovementDescName TVarChar
             , Amount TFloat

             , Amount_Dn  TFloat    -- Днепр
             , Amount_Kh  TFloat    -- Харьков
             , Amount_Od  TFloat    -- Одесса
             , Amount_Zp  TFloat    -- Запорожье
             , Amount_Kv  TFloat    -- Киев
             , Amount_Kr  TFloat    -- Кр.Рог
             , Amount_Nik TFloat    -- Николаев
             , Amount_Ch  TFloat    -- Черкассы
             , Amount_Lv  TFloat    -- Львов
             , Amount_0   TFloat    -- без филиала

             , ProfitLossGroup_dop Integer   -- дополнительная группировка
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);

     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

     -- Результат
     RETURN QUERY
      WITH 
      tmpReport AS (SELECT tmp.*
                    FROM gpReport_ProfitLoss (inStartDate, inEndDate, inSession) AS tmp
                    )

      SELECT
             tmpReport.ProfitLossGroupName
           , tmpReport.ProfitLossDirectionName
           , tmpReport.ProfitLossName
           --для печатной формы без кода
           , tmpReport.PL_GroupName_original
           , tmpReport.PL_DirectionName_original
           , tmpReport.PL_Name_original

           , tmpReport.onComplete

           , tmpReport.BusinessName
           , tmpReport.JuridicalName_Basis
           , tmpReport.BranchName_ProfitLoss
           , tmpReport.UnitName_ProfitLoss
           , tmpReport.UnitDescName

           , tmpReport.InfoMoneyGroupCode
           , tmpReport.InfoMoneyDestinationCode
           , tmpReport.InfoMoneyCode
           , tmpReport.InfoMoneyGroupName
           , tmpReport.InfoMoneyDestinationName
           , tmpReport.InfoMoneyName

           , tmpReport.InfoMoneyGroupCode_Detail
           , tmpReport.InfoMoneyDestinationCode_Detail
           , tmpReport.InfoMoneyCode_Detail
           , tmpReport.InfoMoneyGroupName_Detail
           , tmpReport.InfoMoneyDestinationName_Detail
           , tmpReport.InfoMoneyName_Detail

           , CASE WHEN inisDirectionDesc = TRUE THEN tmpReport.DirectionObjectCode ELSE 0  END ::Integer  AS DirectionObjectCode
           , CASE WHEN inisDirectionDesc = TRUE THEN tmpReport.DirectionObjectName ELSE '' END ::TVarChar AS DirectionObjectName
           , tmpReport.DirectionDescName   AS DirectionDescName
           , CASE WHEN inisDestinationDesc = TRUE THEN tmpReport.DestinationObjectCode ELSE 0  END ::Integer  AS DestinationObjectCode
           , CASE WHEN inisDestinationDesc = TRUE THEN tmpReport.DestinationObjectName ELSE '' END ::TVarChar AS DestinationObjectName
           , tmpReport.DestinationDescName AS DestinationDescName

           , tmpReport.MovementDescName

           , tmpReport.Amount :: TFloat AS Amount

           , tmpReport.Amount_Dn  :: TFloat
           , tmpReport.Amount_Kh  :: TFloat
           , tmpReport.Amount_Od  :: TFloat
           , tmpReport.Amount_Zp  :: TFloat
           , tmpReport.Amount_Kv  :: TFloat
           , tmpReport.Amount_Kr  :: TFloat
           , tmpReport.Amount_Nik :: TFloat
           , tmpReport.Amount_Ch  :: TFloat
           , tmpReport.Amount_Lv  :: TFloat
           , tmpReport.Amount_0   :: TFloat

           -- доп.группа для промежуточного итога   "итого сумма у покупателя"
           ,  tmpReport.ProfitLossGroup_dop
      FROM tmpReport
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.21         *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLoss_grid (inStartDate:= '31.05.2021', inEndDate:= '31.05.2021',  inisDirectionDesc:=FAlse, inisDestinationDesc:= True, inSession:= '2') WHERE Amount <> 0 ORDER BY 5

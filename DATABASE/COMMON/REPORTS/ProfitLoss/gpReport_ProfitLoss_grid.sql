 -- Function: gpReport_ProfitLoss_grid()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss_grid (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss_grid(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inisDirectionDesc     Boolean,
    IN inisDestinationDesc   Boolean,
    IN inSession             TVarChar    -- ������ ������������
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

             , Amount_Dn  TFloat    -- �����
             , Amount_Kh  TFloat    -- �������
             , Amount_Od  TFloat    -- ������
             , Amount_Zp  TFloat    -- ���������
             , Amount_Kv  TFloat    -- ����
             , Amount_Kr  TFloat    -- ��.���
             , Amount_Nik TFloat    -- ��������
             , Amount_Ch  TFloat    -- ��������
             , Amount_Lv  TFloat    -- �����
             , Amount_0   TFloat    -- ��� �������

             , ProfitLossGroup_dop Integer   -- �������������� �����������
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ��� ��������
     IF vbUserId = 9457 -- ���������� �.�.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

     -- ���������
     RETURN QUERY
      WITH 
      tmpReport AS (SELECT tmp.*
                    FROM gpReport_ProfitLoss (inStartDate, inEndDate, inSession) AS tmp
                    )

      SELECT
             tmpReport.ProfitLossGroupName
           , tmpReport.ProfitLossDirectionName
           , tmpReport.ProfitLossName
           --��� �������� ����� ��� ����
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

           -- ���.������ ��� �������������� �����   "����� ����� � ����������"
           ,  tmpReport.ProfitLossGroup_dop
      FROM tmpReport
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.07.21         *
*/

-- ����
-- SELECT * FROM gpReport_ProfitLoss_grid (inStartDate:= '31.05.2021', inEndDate:= '31.05.2021',  inisDirectionDesc:=FAlse, inisDestinationDesc:= True, inSession:= '2') WHERE Amount <> 0 ORDER BY 5

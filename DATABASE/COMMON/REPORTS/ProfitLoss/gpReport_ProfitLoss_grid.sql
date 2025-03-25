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
             , GoodsGroupName TVarChar
             , GoodsGroupNameFull TVarChar
             , LocationName  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUserRole_8813637 Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- ������������ - ��� ������� � ����
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657330)
     THEN
         RAISE EXCEPTION '������.��� ���� � ������ ����.';
     END IF;

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
           
           --, CASE WHEN inisDestinationDesc = TRUE THEN tmpReport.DestinationObjectCode ELSE 0  END ::Integer  AS DestinationObjectCode
           , CASE WHEN inisDestinationDesc = TRUE 
                  THEN CASE WHEN tmpReport.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Inventory(), zc_Movement_Transport())
                             AND tmpReport.DestinationDescId = zc_Object_Goods()
                            THEN 0
                            ELSE tmpReport.DestinationObjectCode
                       END
                  ELSE 0
             END ::Integer  AS DestinationObjectCode
           --, CASE WHEN inisDestinationDesc = TRUE THEN tmpReport.DestinationObjectName ELSE '' END ::TVarChar AS DestinationObjectName
           , CASE WHEN inisDestinationDesc = TRUE 
                  THEN CASE WHEN tmpReport.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Inventory(), zc_Movement_Transport())
                             AND tmpReport.DestinationDescId = zc_Object_Goods()
                            THEN ''
                            ELSE tmpReport.DestinationObjectName
                       END
                  ELSE ''
             END ::TVarChar  AS DestinationObjectName

           , tmpReport.DestinationDescName AS DestinationDescName
           , tmpReport.MovementDescName

           , SUM (tmpReport.Amount) :: TFloat AS Amount

           , SUM (tmpReport.Amount_Dn)  :: TFloat
           , SUM (tmpReport.Amount_Kh)  :: TFloat
           , SUM (tmpReport.Amount_Od)  :: TFloat
           , SUM (tmpReport.Amount_Zp)  :: TFloat
           , SUM (tmpReport.Amount_Kv)  :: TFloat
           , SUM (tmpReport.Amount_Kr)  :: TFloat
           , SUM (tmpReport.Amount_Nik) :: TFloat
           , SUM (tmpReport.Amount_Ch)  :: TFloat
           , SUM (tmpReport.Amount_Lv)  :: TFloat
           , SUM (tmpReport.Amount_0)   :: TFloat

           -- ���.������ ��� �������������� �����   "����� ����� � ����������"
           , tmpReport.ProfitLossGroup_dop

           , Object_GoodsGroup.ValueData AS GoodsGroupName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           
           , tmpReport.LocationName ::TVarChar AS LocationName

      FROM tmpReport

           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpReport.DestinationObjectId
                                 AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpReport.DestinationObjectId
                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

      GROUP BY tmpReport.ProfitLossGroupName
             , tmpReport.ProfitLossDirectionName
             , tmpReport.ProfitLossName
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
             , CASE WHEN inisDirectionDesc = TRUE THEN tmpReport.DirectionObjectCode ELSE 0  END
             , CASE WHEN inisDirectionDesc = TRUE THEN tmpReport.DirectionObjectName ELSE '' END
             , tmpReport.DirectionDescName
             , CASE WHEN inisDestinationDesc = TRUE 
                    THEN CASE WHEN tmpReport.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Inventory(), zc_Movement_Transport())
                               AND tmpReport.DestinationDescId = zc_Object_Goods()
                              THEN 0
                              ELSE tmpReport.DestinationObjectCode
                         END
                    ELSE 0
               END
             , CASE WHEN inisDestinationDesc = TRUE 
                    THEN CASE WHEN tmpReport.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Inventory(), zc_Movement_Transport())
                               AND tmpReport.DestinationDescId = zc_Object_Goods()
                              THEN ''
                              ELSE tmpReport.DestinationObjectName
                         END
                    ELSE ''
               END
             , tmpReport.DestinationDescName
             , tmpReport.MovementDescName
             , tmpReport.ProfitLossGroup_dop
             , Object_GoodsGroup.ValueData
             , ObjectString_Goods_GoodsGroupFull.ValueData
             , tmpReport.LocationName
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
-- SELECT * FROM gpReport_ProfitLoss_grid (inStartDate:= '04.05.2024', inEndDate:= '04.05.2024',  inisDirectionDesc:=FAlse, inisDestinationDesc:= True, inSession:= '2') WHERE Amount <> 0 ORDER BY 5

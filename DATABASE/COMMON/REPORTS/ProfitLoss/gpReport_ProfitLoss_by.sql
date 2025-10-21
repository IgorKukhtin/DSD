-- Function: gpReport_ProfitLoss_by()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss_by (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss_by(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate           TDateTime
            , MovementId          Integer
            , MovementDesName     TVarChar
            , InvNumber           Integer
            , Comment             TVarChar
            , ProfitLossId        Integer
            , ProfitLossGroupName     TVarChar
            , ProfitLossDirectionName TVarChar
            , ProfitLossName          TVarChar
            , BusinessId          Integer
            , BusinessName        TVarChar
            , BranchId_pl         Integer
            , BranchName_pl       TVarChar
            , UnitId_pl           Integer
            , UnitName_pl         TVarChar
            , InfoMoneyId               Integer     
            , InfoMoneyGroupCode        Integer
            , InfoMoneyDestinationCode  Integer
            , InfoMoneyCode             Integer
            , InfoMoneyGroupName        TVarChar
            , InfoMoneyDestinationName  TVarChar
            , InfoMoneyName             TVarChar
            , UnitId              Integer 
            , UnitName            TVarChar
            , AssetId             Integer 
            , AssetName           TVarChar
            , CarId               Integer 
            , CarName             TVarChar
            , MemberId            Integer 
            , MemberCode          Integer 
            , MemberName          TVarChar
            , ArticleLossId       Integer 
            , ArticleLossName     TVarChar
            , DirectionId         Integer
            , DirectionName       TVarChar
            , DirectionDescName   TVarChar
            , DestinationId       Integer 
            , DestinationName     TVarChar
            , DestinationDescName TVarChar
            , FromId              Integer
            , FromName            TVarChar
            , FromDescName        TVarChar
            , ToId                Integer
            , ToName              TVarChar
            , ToDescName          TVarChar
            , GoodsId             Integer
            , GoodsCode           Integer
            , GoodsName           TVarChar
            , GoodsKindId         Integer
            , GoodsKindName       TVarChar
            , GoodsKindId_gp      Integer
            , GoodsKindName_gp    TVarChar
            , OperCount           TFloat
            , OperCount_sh        TFloat
            , OperSumm            TFloat
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

     -- !!!�������� ���� ���� - ����������� - ��� ������ ������� � ��������� ������ ��!!!
     vbIsUserRole_8813637:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 8813637)
                         -- ��� ���� ����������� - ��� ������� � ��������� ��������� ����� ��
                         OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
                           ;

     -- ������������ - ��� ������� � ����
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657330)
     THEN
         RAISE EXCEPTION '������.��� ���� � ������ ����.';
     END IF;
     /*
     -- ��������� ��� ��������
     IF vbUserId = 9457 -- ���������� �.�.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF; */


     -- ���������
     RETURN QUERY
     WITH
     tmpData AS (
                 SELECT                   
                       -- Id ������        
                         tmp.ContainerId_pl      ::Integer
                       -- ����             
                       , tmp.OperDate            ::TDateTime
                       -- Id ���������
                       , tmp.MovementId          ::Integer
                       -- ��� ���������
                       , tmp.MovementDescId      ::Integer
                       -- � ���������      
                       , tmp.InvNumber           ::Integer
                       -- ���������� ��������
                       , tmp.MovementId_comment  ::Integer
                       -- ������ ����      
                       , tmp.ProfitLossId        ::Integer
                       -- ������
                       , tmp.BusinessId         ::Integer
                       -- ������ ������ (Գ��)
                       , tmp.BranchId_pl         ::Integer
                       -- ������������� ������ (ϳ������)
                       , tmp.UnitId_pl           ::Integer
                       -- ������ ��        
                       , tmp.InfoMoneyId         ::Integer
                       -- ������������� ����� (̳��� �����)
                       , tmp.UnitId              ::Integer
                       -- ������������ (����������� ������)
                       , tmp.AssetId             ::Integer
                       -- ���������� (����������� ������, ����� �����)
                       , tmp.CarId               ::Integer
                       -- ��� ����
                       , tmp.MemberId            ::Integer
                       -- ������ �������� (������ ��������, ����������� ������)
                       , tmp.ArticleLossId       ::Integer
                       -- ��'��� �����������
                       , tmp.DirectionId         ::Integer
                       -- ��'��� �����������
                       , tmp.DestinationId       ::Integer
                       -- �� ���� (����� �����) - ������������
                       , tmp.FromId              ::Integer
                       -- ���� (����� �����, ����������� ������) - ������������
                       , tmp.ToId                ::Integer
                       -- �����
                       , tmp.GoodsId             ::Integer
                       -- ��� ������
                       , tmp.GoodsKindId         ::Integer
                       -- ��� ������ (������ ��� ������������ ����� ��)
                       , tmp.GoodsKindId_gp      ::Integer
                       -- ���-�� (���)
                       , tmp.OperCount           ::TFloat
                       -- ���-�� (��.)
                       , tmp.OperCount_sh        ::TFloat
                       -- �����
                       , tmp.OperSumm            ::TFloat
                 FROM _bi_Table_ProfitLoss AS tmp
                 WHERE tmp.OperDate BETWEEN inStartDate AND inEndDate
                 )
   , tmpMovementString AS (SELECT MovementString.*
                           FROM MovementString
                           WHERE MovementString.DescId = zc_MovementString_Comment()
                             AND MovementString.MovementId IN (SELECT DISTINCT tmpData.MovementId_comment FROM tmpData)
                           )

       SELECT -- ����             
              tmp.OperDate            ::TDateTime
            -- Id ���������
            , tmp.MovementId          ::Integer
            -- ��� ���������
            , MovementDesc.ItemName    ::TVarChar AS MovementDesName
            -- � ���������      
            , tmp.InvNumber           ::Integer
            -- ���������� ��������
            , MovementString_Commet.ValueData  ::TVarChar AS Comment
            -- ������ ����      
            , tmp.ProfitLossId            ::Integer  AS ProfitLossId
            , View_ProfitLoss.ProfitLossGroupName     ::TVarChar
            , View_ProfitLoss.ProfitLossDirectionName ::TVarChar
            , View_ProfitLoss.ProfitLossName          ::TVarChar
            -- ������
            , tmp.BusinessId            ::Integer  AS BusinessId
            , Object_Business.ValueData ::TVarChar AS BusinessName
            -- ������ ������ (Գ��)
            , tmp.BranchId_pl            ::Integer  AS BranchId_pl
            , Object_Branch_pl.ValueData ::TVarChar AS BranchName_pl
            -- ������������� ������ (ϳ������)
            , tmp.UnitId_pl            ::Integer  AS UnitId_pl
            , Object_Unit_pl.ValueData ::TVarChar AS UnitName_pl
            -- ������ ��        
            , tmp.InfoMoneyId                          ::Integer     
            , View_InfoMoney.InfoMoneyGroupCode        ::Integer
            , View_InfoMoney.InfoMoneyDestinationCode  ::Integer
            , View_InfoMoney.InfoMoneyCode             ::Integer
            , View_InfoMoney.InfoMoneyGroupName        ::TVarChar
            , View_InfoMoney.InfoMoneyDestinationName  ::TVarChar
            , View_InfoMoney.InfoMoneyName             ::TVarChar
            -- ������������� ����� (̳��� �����)
            , tmp.UnitId              ::Integer  AS UnitId
            , Object_Unit.ValueData   ::TVarChar AS UnitName
            -- ������������ (����������� ������)
            , tmp.AssetId             ::Integer  AS AssetId
            , Object_Asset.ValueData  ::TVarChar AS AssetName
            -- ���������� (����������� ������, ����� �����)
            , tmp.CarId               ::Integer  AS CarId
            , Object_Car.ValueData    ::TVarChar AS CarName
            -- ��� ����
            , tmp.MemberId             ::Integer  AS MemberId
            , Object_Member.ObjectCode ::Integer  AS MemberCode
            , Object_Member.ValueData  ::TVarChar AS MemberName
            -- ������ �������� (������ ��������, ����������� ������)
            , tmp.ArticleLossId            ::Integer  AS ArticleLossId
            , Object_ArticleLoss.ValueData ::TVarChar AS ArticleLossName
            -- ��'��� �����������
            , tmp.DirectionId               ::Integer  AS DirectionId
            , Object_Direction.ValueData    ::TVarChar AS DirectionName
            , ObjectDesc_Direction.ItemName ::TVarChar AS DirectionDescName
            -- ��'��� �����������
            , tmp.DestinationId               ::Integer  AS DestinationId
            , Object_Destination.ValueData    ::TVarChar AS DestinationName
            , ObjectDesc_Destination.ItemName ::TVarChar AS DestinationDescName
            -- �� ���� (����� �����) - ������������
            , tmp.FromId               ::Integer  AS FromId
            , Object_From.ValueData    ::TVarChar AS FromName 
            , ObjectDesc_From.ItemName ::TVarChar AS DescName_From
            -- ���� (����� �����, ����������� ������) - ������������
            , tmp.ToId               ::Integer  AS ToId
            , Object_To.ValueData    ::TVarChar AS ToName
            , ObjectDesc_To.ItemName ::TVarChar AS DescName_To
            -- �����
            , tmp.GoodsId             ::Integer  AS GoodsId
            , Object_Goods.ObjectCode ::Integer  AS GoodsCode
            , Object_Goods.ValueData  ::TVarChar AS GoodsName
            -- ��� ������
            , tmp.GoodsKindId            ::Integer  AS GoodsKindId
            , Object_GoodsKind.ValueData ::TVarChar AS GoodsKindName
            -- ��� ������ (������ ��� ������������ ����� ��)
            , tmp.GoodsKindId_gp            ::Integer  AS GoodsKindId_gp
            , Object_GoodsKind_gp.ValueData ::TVarChar AS GoodsKindName_gp
            -- ���-�� (���)
            , tmp.OperCount           ::TFloat
            -- ���-�� (��.)
            , tmp.OperCount_sh        ::TFloat
            -- �����
            , tmp.OperSumm            ::TFloat
       FROM tmpData AS tmp
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.MovementDescId
            LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = tmp.ProfitLossId
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmp.BusinessId
            LEFT JOIN Object AS Object_Branch_pl ON Object_Branch_pl.Id = tmp.BranchId_pl
            LEFT JOIN Object AS Object_Unit_pl ON Object_Unit_pl.Id = tmp.UnitId_pl
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmp.InfoMoneyId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmp.AssetId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmp.CarId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = tmp.ArticleLossId

            LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmp.DirectionId
            LEFT JOIN ObjectDesc AS ObjectDesc_Direction ON ObjectDesc_Direction.Id = Object_Direction.DescId

            LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmp.DestinationId
            LEFT JOIN ObjectDesc AS ObjectDesc_Destination ON ObjectDesc_Destination.Id = Object_Destination.DescId

            LEFT JOIN Object AS Object_From ON Object_From.Id = tmp.FromId
            LEFT JOIN ObjectDesc AS ObjectDesc_From ON ObjectDesc_From.Id = Object_From.DescId

            LEFT JOIN Object AS Object_To ON Object_To.Id = tmp.ToId
            LEFT JOIN ObjectDesc AS ObjectDesc_To ON ObjectDesc_To.Id = Object_To.DescId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_gp ON Object_GoodsKind_gp.Id = tmp.GoodsKindId_gp
            
            LEFT JOIN tmpMovementString AS MovementString_Commet
                                        ON MovementString_Commet.MovementId = tmp.MovementId_comment
                                       AND MovementString_Commet.DescId = zc_MovementString_Comment()
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.10.25         *
*/

-- ����
-- SELECT * FROM gpReport_ProfitLoss_by (inStartDate:= '04.09.2025', inEndDate:= '04.09.2025', inSession:= '5') 
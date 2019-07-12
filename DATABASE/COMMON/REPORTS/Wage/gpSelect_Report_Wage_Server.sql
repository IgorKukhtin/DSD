-- Function: gpSelect_Report_Wage_Server ()

DROP FUNCTION IF EXISTS gpSelect_Report_Wage_Server (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage_Server(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inUnitId         Integer,   --�������������
    IN inModelServiceId Integer,   --������ ����������
    IN inMemberId       Integer,   --���������
    IN inPositionId     Integer,   --���������
    IN inDetailDay      Boolean,   --�������������� �� ����
    IN inDetailModelService Boolean,   --�������������� �� �������
    IN inDetailModelServiceItemMaster Boolean,   --�������������� �� ����� ���������� � ������
    IN inDetailModelServiceItemChild  Boolean,   --�������������� �� ������� � ����� ����������
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     StaffListId                    Integer
    ,StaffListCode                  Integer
    ,StaffListName                  TVarChar
    ,DocumentKindId                 Integer
    ,DocumentKindName               TVarChar
    ,PriceName                      TVarChar
    ,HoursPlan_StaffList            TFloat
    ,HoursDay_StaffList             TFloat
    ,Count_Member_StaffList         Integer    -- ���-�� ������� (��� - ������� ����������)
    ,Count_Member                   Integer    -- ���-�� ������� (���)
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,PersonalGroupId                Integer
    ,PersonalGroupName              TVarChar
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SUM_MemberHours                TFloat  -- ����� ����� ���� ����������� (� ���� ����������+...)
    ,SheetWorkTime_Amount           TFloat  -- ����� ����� ����������
    ,ServiceModelCode               Integer
    ,ServiceModelName               TVarChar
    ,Price                          TFloat
    ,FromName                       TVarChar
    ,ToName                         TVarChar
    ,MovementDescName               TVarChar
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToName   TVarChar
    ,StorageLineName_From           TVarChar
    ,StorageLineName_To             TVarChar
    ,GoodsKind_FromName             TVarChar
    ,GoodsKindComplete_FromName     TVarChar
    ,GoodsKind_ToName               TVarChar
    ,GoodsKindComplete_ToName       TVarChar
    ,OperDate                       TDateTime
    ,Count_Day                      Integer   -- �����. ��. 1 ��� (���.)
    ,Count_MemberInDay              Integer   -- ���-�� ������� (�� 1 �.)
    ,Gross                          TFloat
    ,GrossOnOneMember               TFloat
    ,Amount                         TFloat
    ,AmountOnOneMember              TFloat
    ,PersonalServiceListId          Integer
    ,PersonalServiceListName        TVarChar
    ,Ord                            Integer
    ,ServiceModelName_1             TVarChar
    ,ServiceModelName_2             TVarChar
    ,ServiceModelName_3             TVarChar
    ,ServiceModelName_4             TVarChar

    ,ModelServiceId                 Integer
    ,StaffListSummKindId            Integer
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;

    -- ������� - ������ ���������
    CREATE TEMP TABLE Res(
          StaffListId                    Integer
        , DocumentKindId                 Integer
        , UnitId                         Integer
        , UnitName                       TVarChar
        , PositionId                     Integer
        , PositionName                   TVarChar
        , PositionLevelId                Integer
        , PositionLevelName              TVarChar
        , Count_Member                  Integer
        , HoursPlan                      TFloat
        , HoursDay                       TFloat
        , PersonalGroupId                Integer
        , PersonalGroupName              TVarChar
        , MemberId                       Integer
        , MemberName                     TVarChar
        , SheetWorkTime_Date             TDateTime
        , SUM_MemberHours                TFloat
        , SheetWorkTime_Amount           TFloat
        , ServiceModelCode               Integer
        , ServiceModelName               TVarChar
        , Price                          TFloat
        , FromId                         Integer
        , FromName                       TVarChar
        , ToId                           Integer
        , ToName                         TVarChar
        , MovementDescId                 Integer
        , MovementDescName               TVarChar
        , SelectKindId                   Integer
        , SelectKindName                 TVarChar
        , Ratio                          TFloat
        , ModelServiceItemChild_FromId       Integer
        , ModelServiceItemChild_FromDescId   Integer
        , ModelServiceItemChild_FromName     TVarChar
        , ModelServiceItemChild_ToId         Integer
        , ModelServiceItemChild_ToDescId     Integer
        , ModelServiceItemChild_ToName       TVarChar
        , StorageLineId_From                 Integer
        , StorageLineName_From               TVarChar
        , StorageLineId_To                   Integer
        , StorageLineName_To                 TVarChar
        , GoodsKind_FromId                   Integer
        , GoodsKind_FromName                 TVarChar
        , GoodsKindComplete_FromId           Integer
        , GoodsKindComplete_FromName         TVarChar
        , GoodsKind_ToId                     Integer
        , GoodsKind_ToName                   TVarChar
        , GoodsKindComplete_ToId             Integer
        , GoodsKindComplete_ToName           TVarChar
        , OperDate                       TDateTime
        , Count_Day                      Integer
        , Count_MemberInDay              Integer
        , Gross                          TFloat
        , GrossOnOneMember               TFloat
        , Amount                         TFloat
        , AmountOnOneMember              TFloat
        , PersonalServiceListId          Integer
        , PersonalServiceListName        TVarChar

        , ModelServiceId                 Integer
        , StaffListSummKindId            Integer

         ) ON COMMIT DROP;

    -- ������� - ������ �������
    CREATE TEMP TABLE tmpListServiceModel (
          ServiceModelCode Integer
        , ServiceModelName  TVarChar
        , Ord Integer
         ) ON COMMIT DROP;


    -- Report_1 - �� �������� ���������� - �� ������ + �� ������ - �� ��������� ���-��
    Insert Into Res (StaffListId, DocumentKindId, UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,Count_Member,HoursPlan,HoursDay, PersonalGroupId, PersonalGroupName, MemberId, MemberName, SheetWorkTime_Date, SUM_MemberHours, SheetWorkTime_Amount
                   , ServiceModelCode,ServiceModelName,Price,FromId,FromName,ToId,ToName,MovementDescId,MovementDescName,SelectKindId,SelectKindName,Ratio
                   , ModelServiceItemChild_FromId,ModelServiceItemChild_FromDescId,ModelServiceItemChild_FromName,ModelServiceItemChild_ToId,ModelServiceItemChild_ToDescId,ModelServiceItemChild_ToName
                   , StorageLineId_From, StorageLineName_From, StorageLineId_To, StorageLineName_To
                   , GoodsKind_FromId, GoodsKind_FromName, GoodsKindComplete_FromId, GoodsKindComplete_FromName, GoodsKind_ToId, GoodsKind_ToName, GoodsKindComplete_ToId, GoodsKindComplete_ToName
                   , OperDate, Count_Day, Count_MemberInDay,Gross,GrossOnOneMember,Amount,AmountOnOneMember
                   , ModelServiceId, StaffListSummKindId
                    )
    SELECT Report_1.StaffListId, Report_1.DocumentKindId, Report_1.UnitId, Report_1.UnitName,Report_1.PositionId,Report_1.PositionName,Report_1.PositionLevelId,Report_1.PositionLevelName,Report_1.Count_Member,Report_1.HoursPlan,Report_1.HoursDay
         , Report_1.PersonalGroupId, Report_1.PersonalGroupName, Report_1.MemberId,Report_1.MemberName,Report_1.SheetWorkTime_Date
           -- ����� ����� ���� ����������� (� ���� ����������+...)
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.SUM_MemberHours      ELSE 0 END AS SUM_MemberHours
           -- ����� ����� ����������
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.SheetWorkTime_Amount ELSE 0 END AS SheetWorkTime_Amount
           --
         , Report_1.ServiceModelCode, Report_1.ServiceModelName, Report_1.Price
         , Report_1.FromId,Report_1.FromName,Report_1.ToId,Report_1.ToName,Report_1.MovementDescId,Report_1.MovementDescName,Report_1.SelectKindId,Report_1.SelectKindName,Report_1.Ratio
         , Report_1.ModelServiceItemChild_FromId,Report_1.ModelServiceItemChild_FromDescId,Report_1.ModelServiceItemChild_FromName,Report_1.ModelServiceItemChild_ToId
         , Report_1.ModelServiceItemChild_ToDescId,Report_1.ModelServiceItemChild_ToName
         , Report_1.StorageLineId_From, Report_1.StorageLineName_From, Report_1.StorageLineId_To, Report_1.StorageLineName_To
         , Report_1.GoodsKind_FromId, Report_1.GoodsKind_FromName, Report_1.GoodsKindComplete_FromId, Report_1.GoodsKindComplete_FromName
         , Report_1.GoodsKind_ToId, Report_1.GoodsKind_ToName, Report_1.GoodsKindComplete_ToId, Report_1.GoodsKindComplete_ToName
         , Report_1.OperDate
           -- �����. ��. 1 ��� (���.)
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.Count_Day         ELSE 0 END AS Count_Day
           -- ���-�� ������� (�� 1 �.)
         , CASE WHEN Report_1.Ord_SheetWorkTime = 1 THEN Report_1.Count_MemberInDay ELSE 0 END AS Count_MemberInDay
           --
         , Report_1.Gross
         , Report_1.GrossOnOneMember
         , Report_1.Amount,Report_1.AmountOnOneMember
         , Report_1.ServiceModelId AS ModelServiceId, 0 AS StaffListSummKindId
    FROM gpSelect_Report_Wage_Model_Server (inStartDate      := inStartDate,
                                     inEndDate        := inEndDate, --���� ��������� �������
                                     inUnitId         := inUnitId,   --�������������
                                     inModelServiceId := inModelServiceId,   --������ ����������
                                     inMemberId       := inMemberId,   --���������
                                     inPositionId     := inPositionId,   --���������
                                     inSession        := inSession
                                    ) AS Report_1;


    -- Report_2 - �� �������� ���������� - ��� ����� ��� �� ����� - �� ������
    INSERT INTO Res (StaffListId, UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,Count_Member,HoursPlan,HoursDay, PersonalGroupId, PersonalGroupName, MemberId, MemberName
                   , SUM_MemberHours, SheetWorkTime_Amount, ServiceModelCode, ServiceModelName, Price, AmountOnOneMember
                   , Count_Day
                   , ModelServiceId, StaffListSummKindId
                    )
    SELECT
        Report_2.StaffListId
       ,Report_2.UnitId
       ,Report_2.UnitName
       ,Report_2.PositionId
       ,Report_2.PositionName
       ,Report_2.PositionLevelId
       ,Report_2.PositionLevelName
       ,Report_2.Count_Member
       ,Report_2.HoursPlan
       ,Report_2.HoursDay
       ,Report_2.PersonalGroupId
       ,Report_2.PersonalGroupName
       ,Report_2.MemberId
       ,Report_2.MemberName
       ,Report_2.SUM_MemberHours
       ,Report_2.SheetWorkTime_Amount
       ,Report_2.StaffListSummKindId   AS ServiceModelCode
       ,Report_2.StaffListSummKindName AS ServiceModelName
       ,Report_2.StaffListSumm_Value   AS Price
       ,Report_2.Summ
       ,Report_2.Count_Day
       ,0 AS ModelServiceId, Report_2.StaffListSummKindId
    FROM gpSelect_Report_Wage_Sum_Server (inStartDate      := CASE WHEN inModelServiceId > 0 THEN NULL ELSE inStartDate END
                                        , inEndDate        := CASE WHEN inModelServiceId > 0 THEN NULL ELSE inEndDate   END
                                        , inUnitId         := CASE WHEN inModelServiceId > 0 THEN NULL ELSE inUnitId    END
                                        , inMemberId       := inMemberId
                                        , inPositionId     := inPositionId
                                        , inSession        := inSession
                                         ) AS Report_2
    WHERE COALESCE (inModelServiceId, 0) = 0
    ;

    --
    INSERT INTO tmpListServiceModel (ServiceModelCode, ServiceModelName, Ord)
    SELECT tmp.ServiceModelCode
         , tmp.ServiceModelName
         , (ROW_NUMBER() OVER (ORDER BY tmp.ServiceModelCode)) :: Integer AS Ord
    FROM (SELECT DISTINCT
                 Res.ServiceModelCode
               , Res.ServiceModelName
          FROM Res
          WHERE Res.ServiceModelCode IS NOT NULL
         ) AS tmp;

    -- ���������
    RETURN QUERY
        WITH tmpPersonal AS (SELECT *
                                  , ROW_NUMBER(*) OVER (PARTITION BY Object_Personal.MemberId
                                                                   , COALESCE (Object_Personal.PositionId, 0)
                                                                   , COALESCE (Object_Personal.PositionLevelId, 0)
                                                                   , COALESCE (Object_Personal.UnitId, 0)
                                                        ) AS Ord
                             FROM Object_Personal_View AS Object_Personal
                            )
        , tmpPersonalServiceList AS (SELECT lfSelect.MemberId
                                          , lfSelect.PersonalId
                                          , lfSelect.UnitId
                                          , lfSelect.PositionId
                                          , lfSelect.BranchId
                                          , lfSelect.PersonalServiceListId
                                          , lfSelect.Ord
                                     FROM lfSelect_Object_Member_findPersonal(zfCalc_UserAdmin()) AS lfSelect
                                    )
           , tmpRes AS (
            SELECT
                Res.StaffListId

               ,CASE WHEN inDetailModelService = TRUE OR inDetailModelServiceItemMaster = TRUE
                          THEN Res.DocumentKindId
                     ELSE NULL
                END AS DocumentKindId

               ,Res.UnitId
               ,Res.UnitName
               ,Res.PositionId
               ,Res.PositionName
               ,Res.PositionLevelId
               ,Res.PositionLevelName
               ,Res.Count_Member             -- ���-�� ������� (���)
               ,Res.HoursPlan
               ,Res.HoursDay
              , Res.PersonalGroupId
              , Res.PersonalGroupName
               ,Res.MemberId
               ,Res.MemberName
               ,Res.SUM_MemberHours                            AS SUM_MemberHours      -- ����� ����� ���� ����������� (� ���� ����������+...)
              , SUM (Res.SheetWorkTime_Amount) :: TFloat       AS SheetWorkTime_Amount -- ����� ����� ����������
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelCode
                ELSE NULL::Integer END                         AS ServiceModelCode
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelName
                ELSE NULL::TVarChar END                        AS ServiceModelName
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.Price
                ELSE NULL::TFloat END                          AS Price
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.FromName
                ELSE NULL::TVarChar END                         AS FromName
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.ToName
                ELSE NULL::TVarChar END                         AS ToName
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.MovementDescName
                ELSE NULL::TVarChar END                         AS MovementDescName

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_FromName
                ELSE NULL::TVarChar END                         AS ModelServiceItemChild_FromName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_ToName
                ELSE NULL::TVarChar END                         AS ModelServiceItemChild_ToName

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_From
                ELSE NULL::TVarChar END                         AS StorageLineName_From
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_To
                ELSE NULL::TVarChar END                         AS StorageLineName_To

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_FromName
                ELSE NULL::TVarChar END                         AS GoodsKind_FromName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_FromName
                ELSE NULL::TVarChar END                         AS GoodsKindComplete_FromName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_ToName
                ELSE NULL::TVarChar END                         AS GoodsKind_ToName
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_ToName
                ELSE NULL::TVarChar END                         AS GoodsKindComplete_ToName

               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.OperDate
                ELSE NULL::TDateTime END                  AS OperDate

               , MAX (Res.Count_Day) :: Integer           AS Count_Day         -- �����. ��. 1 ��� (���.)

               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Count_MemberInDay
                ELSE NULL::Integer END                    AS Count_MemberInDay -- ���-�� ������� (�� 1 �.)
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Gross
                ELSE NULL::TFloat END                     AS Gross
               ,SUM(Res.GrossOnOneMember)::TFloat         AS GrossOnOneMember
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Amount
                ELSE NULL::TFloat END                     AS Amount
               ,SUM(Res.AmountOnOneMember)::TFloat        AS AmountOnOneMember

               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ModelServiceId
                END AS ModelServiceId
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.StaffListSummKindId
                END AS StaffListSummKindId

            FROM Res
            WHERE Res.MemberId > 0
            GROUP BY
                Res.StaffListId
               ,CASE WHEN inDetailModelService = TRUE OR inDetailModelServiceItemMaster = TRUE
                          THEN Res.DocumentKindId
                     ELSE NULL
                END
               ,Res.UnitId
               ,Res.UnitName
               ,Res.PositionId
               ,Res.PositionName
               ,Res.PositionLevelId
               ,Res.PositionLevelName
               ,Res.Count_Member
               ,Res.HoursPlan
               ,Res.HoursDay
               , Res.PersonalGroupId
               , Res.PersonalGroupName
               ,Res.MemberId
               ,Res.MemberName
               ,Res.SUM_MemberHours
               /*,CASE WHEN inDetailDay = TRUE
                     THEN Res.SheetWorkTime_Amount
                ELSE NULL::TFloat END*/
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelCode
                ELSE NULL::Integer END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ServiceModelName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.Price
                ELSE NULL::TFloat END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.ToName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemMaster = TRUE
                     THEN Res.MovementDescName
                ELSE NULL::TVarChar END

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.ModelServiceItemChild_ToName
                ELSE NULL::TVarChar END

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_From
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.StorageLineName_To
                ELSE NULL::TVarChar END

               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_FromName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKind_ToName
                ELSE NULL::TVarChar END
               ,CASE WHEN inDetailModelServiceItemChild = TRUE
                     THEN Res.GoodsKindComplete_ToName
                ELSE NULL::TVarChar END

               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.OperDate
                ELSE NULL::TDateTime END
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Count_MemberInDay
                ELSE NULL::Integer END
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Gross
                ELSE NULL::TFloat END
               ,CASE WHEN inDetailDay = TRUE
                     THEN Res.Amount
                ELSE NULL::TFloat END

               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.ModelServiceId
                END
               ,CASE WHEN inDetailModelService = TRUE
                     THEN Res.StaffListSummKindId
                END
        )
        SELECT
            tmpRes.StaffListId
          , Object_StaffList.ObjectCode AS StaffListCode
          , ('(' || COALESCE (Object_Unit_StaffList.ObjectCode, 0) :: TVarChar || ') ' || COALESCE (Object_Unit_StaffList.ValueData, '')
          || CASE WHEN Object_PositionLevel_StaffList.ValueData      <> '' THEN ' - ' || Object_PositionLevel_StaffList.ValueData ELSE '' END
          || CASE WHEN Object_Position_StaffList.ValueData           <> '' THEN ' - ' || Object_Position_StaffList.ValueData      ELSE '' END
          || CASE WHEN ObjectFloat_PersonalCount.ValueData           <> 0  THEN ' - ' || zfConvert_FloatToString (ObjectFloat_PersonalCount.ValueData) ELSE ' - ???' END ||  ' ���.'
            ) :: TVarChar AS StaffListName

          , Object_DocumentKind.Id        AS DocumentKindId
          , Object_DocumentKind.ValueData AS DocumentKindName

          , (CASE
                  WHEN inDetailModelService = FALSE            THEN ''
                  WHEN tmpRes.ModelServiceId <> 0 THEN '1 ��.'
                  WHEN tmpRes.HoursDay       <> 0 THEN zfConvert_FloatToString (tmpRes.HoursDay) || ' ���.'
                  WHEN tmpRes.HoursPlan      <> 0 THEN zfConvert_FloatToString (tmpRes.HoursPlan) || ' ���.'
                  WHEN ObjectFloat_PersonalCount.ValueData <> 0 THEN zfConvert_FloatToString (ObjectFloat_PersonalCount.ValueData) || ' ���.'
                  ELSE ''
             END) :: TVarChar AS PriceName

          , tmpRes.HoursPlan                AS HoursPlan_StaffList
          , tmpRes.HoursDay                 AS HoursDay_StaffList
          , ObjectFloat_PersonalCount.ValueData :: Integer AS Count_Member_StaffList

           ,tmpRes.Count_Member

           ,tmpRes.UnitId
           ,tmpRes.UnitName
           ,tmpRes.PositionId
           ,tmpRes.PositionName
           ,tmpRes.PositionLevelId
           ,tmpRes.PositionLevelName

          , tmpRes.PersonalGroupId
          , tmpRes.PersonalGroupName
           ,tmpRes.MemberId
           ,tmpRes.MemberName
           ,tmpRes.SUM_MemberHours
           ,tmpRes.SheetWorkTime_Amount
           ,tmpRes.ServiceModelCode
           ,tmpRes.ServiceModelName
           ,tmpRes.Price
           ,tmpRes.FromName
           ,tmpRes.ToName
           ,tmpRes.MovementDescName
           ,tmpRes.ModelServiceItemChild_FromName
           ,tmpRes.ModelServiceItemChild_ToName

           ,tmpRes.StorageLineName_From
           ,tmpRes.StorageLineName_To

           ,tmpRes.GoodsKind_FromName
           ,tmpRes.GoodsKindComplete_FromName
           ,tmpRes.GoodsKind_ToName
           ,tmpRes.GoodsKindComplete_ToName

           ,tmpRes.OperDate
           ,tmpRes.Count_Day                             -- �����. ��. 1 ��� (���.)
           ,tmpRes.Count_MemberInDay
           ,tmpRes.Gross
           ,tmpRes.GrossOnOneMember
           ,ROUND (tmpRes.Amount, 2) :: TFloat            AS Amount
           ,ROUND (tmpRes.AmountOnOneMember, 2) :: TFloat AS AmountOnOneMember
           ,Object_PersonalServiceList.Id                 AS PersonalServiceListId
           ,Object_PersonalServiceList.ValueData          AS PersonalServiceListName
           ,tmpListServiceModel.Ord
           ,tmpListServiceModel_1.ServiceModelName as ServiceModelName_1
           ,tmpListServiceModel_2.ServiceModelName as ServiceModelName_2
           ,tmpListServiceModel_3.ServiceModelName as ServiceModelName_3
           ,tmpListServiceModel_4.ServiceModelName as ServiceModelName_4

           ,tmpRes.ModelServiceId      :: Integer AS ModelServiceId
           ,tmpRes.StaffListSummKindId :: Integer AS StaffListSummKindId

        FROM
            tmpRes
            LEFT JOIN tmpPersonal AS Object_Personal
                                                 ON Object_Personal.MemberId                      = tmpRes.MemberId
                                                AND COALESCE (Object_Personal.PositionId, 0)      = COALESCE (tmpRes.PositionId, 0)
                                                AND COALESCE (Object_Personal.PositionLevelId, 0) = COALESCE (tmpRes.PositionLevelId, 0)
                                                AND COALESCE (Object_Personal.UnitId, 0)          = COALESCE (tmpRes.UnitId, 0)
                                                AND Object_Personal.ORD                           = 1
            /*LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList_two
                                 ON ObjectLink_Personal_PersonalServiceList_two.ObjectId = tmpRes.MemberId
                                AND ObjectLink_Personal_PersonalServiceList_two.DescId   = zc_ObjectLink_Personal_PersonalServiceList()
            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                       ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.PersonalId
                                      AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()*/

            -- ����� ����� PersonalId
            LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_find
                                 ON ObjectLink_Personal_Member_find.ObjectId = tmpRes.MemberId
                                AND ObjectLink_Personal_Member_find.DescId   = zc_ObjectLink_Personal_Member()
            LEFT JOIN tmpPersonalServiceList AS tmpPersonalServiceList_find ON tmpPersonalServiceList_find.MemberId = ObjectLink_Personal_Member_find.ChildObjectId

            LEFT JOIN tmpPersonalServiceList ON tmpPersonalServiceList.MemberId = tmpRes.MemberId
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = COALESCE (tmpPersonalServiceList.PersonalServiceListId, tmpPersonalServiceList_find.PersonalServiceListId) -- COALESCE (ObjectLink_Personal_PersonalServiceList_two.ChildObjectId, COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId, tmpPersonalServiceList.PersonalServiceListId))


            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = tmpRes.DocumentKindId

            LEFT JOIN Object AS Object_StaffList ON Object_StaffList.Id = tmpRes.StaffListId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                 ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
            LEFT JOIN Object AS Object_Unit_StaffList ON Object_Unit_StaffList.Id = ObjectLink_StaffList_Unit.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                                 ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
            LEFT JOIN Object AS Object_Position_StaffList ON Object_Position_StaffList.Id = ObjectLink_StaffList_Position.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                 ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel_StaffList ON Object_PositionLevel_StaffList.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount
                                  ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id
                                 AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()

            LEFT JOIN tmpListServiceModel ON tmpListServiceModel.ServiceModelCode = tmpRes.ServiceModelCode
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_1 ON tmpListServiceModel_1.Ord = 1
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_2 ON tmpListServiceModel_2.Ord = 2
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_3 ON tmpListServiceModel_3.Ord = 3
            LEFT JOIN tmpListServiceModel AS tmpListServiceModel_4 ON tmpListServiceModel_4.Ord = 4
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- ����
-- SELECT * FROM gpSelect_Report_Wage_Server (inStartDate:= '01.04.2017', inEndDate:= '02.04.2017', inUnitId:= 8439, inModelServiceId:= 633116, inMemberId:= 0, inPositionId:= 0, inDetailDay:= TRUE, inDetailModelService:= TRUE, inDetailModelServiceItemMaster:= TRUE, inDetailModelServiceItemChild:= TRUE, inSession:= '5');
-- SELECT * FROM gpSelect_Report_Wage_Server (inStartDate:= '01.10.2017', inEndDate:= '31.10.2017', inUnitId:= 0, inModelServiceId:= 1342334, inMemberId:= 0, inPositionId:= 0, inDetailDay:= TRUE, inDetailModelService:= TRUE, inDetailModelServiceItemMaster:= TRUE, inDetailModelServiceItemChild:= TRUE, inSession:= '5');

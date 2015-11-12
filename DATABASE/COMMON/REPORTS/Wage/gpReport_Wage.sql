DROP FUNCTION IF EXISTS gpSelect_Report_Wage(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    Integer,   --модель начисления
    Integer,   --сотрудник
    Integer,   --должность
    Boolean,   --детализировать по дням
    Boolean,   --детализировать по моделям
    Boolean,   --детализировать по типам документов в модели
    Boolean,   --детализировать по товарам в типах документов
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Wage(
    IN inDateStart      TDateTime, --дата начала периода
    IN inDateFinal      TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение 
    IN inModelServiceId Integer,   --модель начисления
    IN inMemberId       Integer,   --сотрудник
    IN inPositionId     Integer,   --должность
    IN inDetailDay      Boolean,   --детализировать по дням
    IN inDetailModelService Boolean,   --детализировать по моделям
    IN inDetailModelServiceItemMaster Boolean,   --детализировать по типам документов в модели
    IN inDetailModelServiceItemChild  Boolean,   --детализировать по товарам в типах документов
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     StaffList                      Integer
    ,UnitId                         Integer
    ,UnitName                       TVarChar
    ,PositionId                     Integer
    ,PositionName                   TVarChar
    ,PositionLevelId                Integer
    ,PositionLevelName              TVarChar
    ,PersonalCount                  Integer
    ,MemberId                       Integer
    ,MemberName                     TVarChar
    ,SheetWorkTime_Amount           TFloat
    ,ServiceModelCode               Integer
    ,ServiceModelName               TVarChar
    ,Price                          TFloat
    ,FromName                       TVarChar
    ,ToName                         TVarChar
    ,MovementDescName               TVarChar
    ,ModelServiceItemChild_FromName TVarChar
    ,ModelServiceItemChild_ToName   TVarChar
    ,OperDate                       TDateTime
    ,Count_MemberInDay              Integer
    ,Gross                          TFloat
    ,GrossOnOneMember               TFloat
    ,Amount                         TFloat
    ,AmountOnOneMember              TFloat
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;
    CREATE TEMP TABLE Res(
         StaffList                      Integer
        ,UnitId                         Integer
        ,UnitName                       TVarChar
        ,PositionId                     Integer
        ,PositionName                   TVarChar
        ,PositionLevelId                Integer
        ,PositionLevelName              TVarChar
        ,PersonalCount                  Integer
        ,MemberId                       Integer
        ,MemberName                     TVarChar
        ,SheetWorkTime_Date             TDateTime
        ,SheetWorkTime_Amount           TFloat
        ,ServiceModelId                 Integer
        ,ServiceModelCode               Integer
        ,ServiceModelName               TVarChar
        ,Price                          TFloat
        ,FromId                         Integer
        ,FromName                       TVarChar
        ,ToId                           Integer
        ,ToName                         TVarChar
        ,MovementDescId                 Integer
        ,MovementDescName               TVarChar
        ,SelectKindId                   Integer
        ,SelectKindName                 TVarChar
        ,Ratio                          TFloat
        ,ModelServiceItemChild_FromId   Integer
        ,ModelServiceItemChild_FromDescId   Integer
        ,ModelServiceItemChild_FromName TVarChar
        ,ModelServiceItemChild_ToId     Integer
        ,ModelServiceItemChild_ToDescId     Integer
        ,ModelServiceItemChild_ToName   TVarChar
        ,OperDate                       TDateTime
        ,Count_MemberInDay              Integer
        ,Gross                          TFloat
        ,GrossOnOneMember               TFloat
        ,Amount                         TFloat
        ,AmountOnOneMember              TFloat
    ) ON COMMIT DROP;
    Insert Into Res(StaffList,UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,PersonalCount,MemberId,MemberName,SheetWorkTime_Date,SheetWorkTime_Amount
                   ,ServiceModelId,ServiceModelCode,ServiceModelName,Price,FromId,FromName,ToId,ToName,MovementDescId,MovementDescName,SelectKindId,SelectKindName,Ratio
                   ,ModelServiceItemChild_FromId,ModelServiceItemChild_FromDescId,ModelServiceItemChild_FromName,ModelServiceItemChild_ToId,ModelServiceItemChild_ToDescId,ModelServiceItemChild_ToName
                   ,OperDate,Count_MemberInDay,Gross,GrossOnOneMember,Amount,AmountOnOneMember)
    Select Report_1.StaffList,Report_1.UnitId,Report_1.UnitName,Report_1.PositionId,Report_1.PositionName,Report_1.PositionLevelId,Report_1.PositionLevelName,Report_1.PersonalCount,
           Report_1.MemberId,Report_1.MemberName,Report_1.SheetWorkTime_Date,Report_1.SheetWorkTime_Amount,Report_1.ServiceModelId,Report_1.ServiceModelCode,Report_1.ServiceModelName,Report_1.Price,
           Report_1.FromId,Report_1.FromName,Report_1.ToId,Report_1.ToName,Report_1.MovementDescId,Report_1.MovementDescName,Report_1.SelectKindId,Report_1.SelectKindName,Report_1.Ratio,
           Report_1.ModelServiceItemChild_FromId,Report_1.ModelServiceItemChild_FromDescId,Report_1.ModelServiceItemChild_FromName,Report_1.ModelServiceItemChild_ToId,
           Report_1.ModelServiceItemChild_ToDescId,Report_1.ModelServiceItemChild_ToName,Report_1.OperDate,Report_1.Count_MemberInDay,Report_1.Gross,Report_1.GrossOnOneMember,
           Report_1.Amount,Report_1.AmountOnOneMember
    from gpSelect_Report_Wage_1(inDateStart      := inDateStart,
                                inDateFinal      := inDateFinal, --дата окончания периода
                                inUnitId         := inUnitId,   --подразделение 
                                inModelServiceId := inModelServiceId,   --модель начисления
                                inMemberId       := inMemberId,   --сотрудник
                                inPositionId     := inPositionId,   --должность
                                inSession        := inSession) as Report_1;
    INSERT INTO Res(StaffList,UnitId,UnitName,PositionId,PositionName,PositionLevelId,PositionLevelName,PersonalCount,MemberId,MemberName
                   ,SheetWorkTime_Amount,ServiceModelId,ServiceModelCode,ServiceModelName,Price,AmountOnOneMember)
    Select 
        Report_2.StaffList
       ,Report_2.UnitId
       ,Report_2.UnitName
       ,Report_2.PositionId
       ,Report_2.PositionName
       ,Report_2.PositionLevelId
       ,Report_2.PositionLevelName
       ,Report_2.PersonalCount
       ,Report_2.MemberId
       ,Report_2.MemberName
       ,Report_2.SheetWorkTime_Amount
       ,Report_2.StaffListSummKindId
       ,-1
       ,Report_2.StaffListSummKindName
       ,Report_2.StaffListSumm_Value
       ,Report_2.Summ 
    FROM 
        gpSelect_Report_Wage_2(inDateStart      := inDateStart,
                                inDateFinal      := inDateFinal, --дата окончания периода
                                inUnitId         := inUnitId,   --подразделение 
                                inMemberId       := inMemberId,   --сотрудник
                                inPositionId     := inPositionId,   --должность
                                inSession        := inSession) as Report_2;
    RETURN QUERY
    SELECT
        Res.StaffList
       ,Res.UnitId
       ,Res.UnitName
       ,Res.PositionId
       ,Res.PositionName
       ,Res.PositionLevelId
       ,Res.PositionLevelName
       ,Res.PersonalCount
       ,Res.MemberId
       ,Res.MemberName
       ,CASE WHEN inDetailDay = TRUE
             THEN Res.SheetWorkTime_Amount
        ELSE NULL::TFloat END                          AS SheetWorkTime_Amount
       ,CASE WHEN inDetailModelService = TRUE
             THEN Res.ServiceModelCode
        ELSE NULL::Integer END                        AS ServiceModelCode
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
        ELSE NULL::TVarCHar END                         AS MovementDescName
       ,CASE WHEN inDetailModelServiceItemChild = TRUE
             THEN Res.ModelServiceItemChild_FromName
        ELSE NULL::TVarChar END                         AS ModelServiceItemChild_FromName
       ,CASE WHEN inDetailModelServiceItemChild = TRUE
             THEN Res.ModelServiceItemChild_ToName
        ELSE NULL::TVarChar END                         AS ModelServiceItemChild_ToName
       ,CASE WHEN inDetailDay = TRUE 
             THEN Res.OperDate 
        ELSE NULL::TDateTime END                  AS OperDate
       ,CASE WHEN inDetailDay = TRUE 
             THEN Res.Count_MemberInDay
        ELSE NULL::Integer END                    AS Count_MemberInDay
       ,CASE WHEN inDetailDay = TRUE 
             THEN Res.Gross
        ELSE NULL::TFloat END                     AS Gross
       ,SUM(Res.GrossOnOneMember)::TFloat         AS GrossOnOneMember
       ,CASE WHEN inDetailDay = TRUE 
             THEN Res.Amount
        ELSE NULL::TFloat END                     AS Amount
       ,SUM(Res.AmountOnOneMember)::TFloat        AS AmountOnOneMember
    FROM Res
    WHERE
        Res.MemberId is not null
    GROUP BY
        Res.StaffList
       ,Res.UnitId
       ,Res.UnitName
       ,Res.PositionId
       ,Res.PositionName
       ,Res.PositionLevelId
       ,Res.PositionLevelName
       ,Res.PersonalCount
       ,Res.MemberId
       ,Res.MemberName
       ,CASE WHEN inDetailDay = TRUE
             THEN Res.SheetWorkTime_Amount
        ELSE NULL::TFloat END
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
        ELSE NULL::TVarCHar END
       ,CASE WHEN inDetailModelServiceItemChild = TRUE
             THEN Res.ModelServiceItemChild_FromName
        ELSE NULL::TVarChar END
       ,CASE WHEN inDetailModelServiceItemChild = TRUE
             THEN Res.ModelServiceItemChild_ToName
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
        ELSE NULL::TFloat END;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Wage (TDateTime,TDateTime,Integer,Integer,Integer,Integer,Boolean,Boolean,Boolean,Boolean,TVarChar) OWNER TO postgres;

/*
Select * from gpSelect_Report_Wage(
    inDateStart      := '20150701'::TDateTime, --дата начала периода
    inDateFinal      := '20150731'::TDateTime, --дата окончания периода
    inUnitId         := 8448::Integer,   --подразделение 
    inModelServiceId := 0::Integer,   --модель начисления
    inMemberId       := 0::Integer,   --сотрудник
    inPositionId     := 0::Integer,   --должность
    inDetailDay      := TRUE,   --детализировать по дням
    inDetailModelService           := TRUE,   --детализировать по моделям
    inDetailModelServiceItemMaster := TRUE,   --детализировать по типам документов в модели
    inDetailModelServiceItemChild  := TRUE,
    inSession        := '5');
*/    
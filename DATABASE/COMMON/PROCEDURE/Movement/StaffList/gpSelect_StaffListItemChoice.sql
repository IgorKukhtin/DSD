-- �� ��������� ������� ���������� ��������� ��� ������ � �� ����������
-- Function: gpSelect_StaffListItemChoice ()

DROP FUNCTION IF EXISTS gpSelect_StaffListItemChoice (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_StaffListItemChoice(
    IN inStartDate      TDateTime , --
    IN inUnitId         Integer,   --�������������
    IN inDepartmentId   Integer,   --�����������
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
            , DepartmentId                   Integer
            , DepartmentName                 TVarChar
            , UnitId                         Integer
            , UnitName                       TVarChar
            , PositionId                     Integer
            , PositionName                   TVarChar
            , PositionLevelId                Integer
            , PositionLevelName              TVarChar
            , PositionPropertyName           TVarChar  --������������� ��������� 
            , PersonalId                     Integer   --�������� �� ��������� 
            , PersonalName                   TVarChar  -- 
            , StaffHoursDayName              TVarChar  --������ ������
            , StaffHoursName                 TVarChar  --������ ������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY

    WITH
    tmpMovement AS (SELECT tmp.*
                    FROM (SELECT Movement.* 
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                               , ObjectLink_Unit_Department.ChildObjectId AS DepartmentId
                               , ROW_NUMBER() OVER (PARTITION BY MovementLinkObject_Unit.ObjectId, MovementLinkObject_Unit.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Department
                                                    ON ObjectLink_Unit_Department.ObjectId = MovementLinkObject_Unit.ObjectId
                                                   AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
                          WHERE Movement.DescId = zc_Movement_StaffList()
                            AND Movement.OperDate <= inStartDate --AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.StatusId <> zc_Enum_Status_Erased() 
                            AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                            AND (ObjectLink_Unit_Department.ChildObjectId = inDepartmentId OR inDepartmentId = 0)
                         ) AS tmp
                    WHERE tmp.Ord = 1
                    )
  , tmpMI AS (SELECT MovementItem.*
              FROM MovementItem
              WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = FALSE
              )  

  , tmpMILinkObject AS (SELECT MovementItemLinkObject.*
                        FROM MovementItemLinkObject
                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PositionLevel()
                                                              , zc_MILinkObject_Personal()
                                                              , zc_MILinkObject_StaffHours()
                                                              , zc_MILinkObject_StaffHoursDay()
                                                              )
                       )

  , tmpMIFloat AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                      AND MovementItemFloat.DescId = zc_MIFloat_AmountReport()
                   )

  , tmpData AS (SELECT Movement.DepartmentId
                     , Movement.UnitId 
                     , Movement.Id
                     , MovementItem.Id       AS MovementItemId
                     , MovementItem.ObjectId AS PositionId
                     , COALESCE (MILinkObject_PositionLevel.ObjectId,0) AS PositionLevelId
                     , ROW_NUMBER() OVER (PARTITION BY Movement.DepartmentId, Movement.UnitId, MovementItem.ObjectId, COALESCE (MILinkObject_PositionLevel.ObjectId,0)) AS Ord
                FROM tmpMovement AS Movement
                     LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
                     LEFT JOIN Object AS Object_Department ON Object_Department.Id = Movement.DepartmentId
                    
                     LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
            
                     LEFT JOIN tmpMILinkObject AS MILinkObject_PositionLevel
                                               ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                              AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                     )
  -- ���������
    SELECT Movement.Id                       ::Integer
         , Object_Department.Id                          AS DepartmentId
         , Object_Department.ValueData       ::TVarChar  AS DepartmentName      
         , Object_Unit.Id                    ::Integer   AS UnitId              
         , Object_Unit.ValueData             ::TVarChar  AS UnitName            
         , Object_Position.Id                ::Integer   AS PositionId          
         , Object_Position.ValueData         ::TVarChar  AS PositionName        
         , Object_PositionLevel.Id           ::Integer   AS PositionLevelId     
         , Object_PositionLevel.ValueData    ::TVarChar  AS PositionLevelName   
         , Object_PositionProperty.ValueData ::TVarChar  AS PositionPropertyName
         , Object_Personal.Id                ::Integer   AS PersonalId
         , Object_Personal.ValueData         ::TVarChar  AS PersonalName        
         , Object_StaffHoursDay.ValueData    ::TVarChar  AS StaffHoursDayName   
         , Object_StaffHours.ValueData       ::TVarChar  AS StaffHoursName      
    FROM tmpData AS Movement
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
         LEFT JOIN Object AS Object_Department ON Object_Department.Id = Movement.DepartmentId
         LEFT JOIN Object AS Object_Position ON Object_Position.Id = Movement.PositionId
         LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = Movement.PositionLevelId

         LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHoursDay
                                   ON MILinkObject_StaffHoursDay.MovementItemId = Movement.MovementItemId
                                  AND MILinkObject_StaffHoursDay.DescId = zc_MILinkObject_StaffHoursDay()
         LEFT JOIN Object AS Object_StaffHoursDay ON Object_StaffHoursDay.Id = MILinkObject_StaffHoursDay.ObjectId

         LEFT JOIN tmpMILinkObject AS MILinkObject_StaffHours
                                   ON MILinkObject_StaffHours.MovementItemId = Movement.MovementItemId
                                  AND MILinkObject_StaffHours.DescId = zc_MILinkObject_StaffHours()
         LEFT JOIN Object AS Object_StaffHours ON Object_StaffHours.Id = MILinkObject_StaffHours.ObjectId

         LEFT JOIN tmpMILinkObject AS MILinkObject_Personal
                                   ON MILinkObject_Personal.MovementItemId = Movement.MovementItemId
                                  AND MILinkObject_Personal.DescId = zc_MILinkObject_Personal()
         LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MILinkObject_Personal.ObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Position_PositionProperty
                              ON ObjectLink_Position_PositionProperty.ObjectId = Object_Position.Id
                             AND ObjectLink_Position_PositionProperty.DescId = zc_ObjectLink_Position_PositionProperty()
         LEFT JOIN Object AS Object_PositionProperty ON Object_PositionProperty.Id = ObjectLink_Position_PositionProperty.ChildObjectId

    ORDER BY Object_Department.ValueData
           , Object_Unit.ValueData  
           , Object_Position.ValueData
           , Object_PositionLevel.ValueData
    ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/* -------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 6.09.25         *
*/
-- ����
-- select * from gpSelect_StaffListChoice (inStartDate:= '26.09.2025'::TDateTime, inUnitId := 0 , inDepartmentId := 0 , inSession := '5');
DROP FUNCTION IF EXISTS gpSelect_Object_ReportSoldParams(TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportSoldParams(
    IN inPlanDate    TDateTime,     -- ����� �����
    IN inShowAll     Boolean,       -- True - �������� ��� � ��������� ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar
             , PlanDate TDateTime
             , PlanAmount TFloat
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- ���������
    IF  inShowAll = True
    THEN
        RETURN QUERY
            SELECT
                Object_ReportSoldParams.Id                 AS Id
               ,Object_Unit.Id                             AS UnitId
               ,Object_Unit.Code                           AS UnitCode
               ,Object_Unit.Name                           AS UnitName
               ,date_trunc('month', inPlanDate)::TDateTime AS PlanDate
               ,Object_ReportSoldParams.PlanAmount         AS PlanAmount
            FROM 
                Object_UNit_View AS Object_Unit
                LEFT OUTER JOIN Object_ReportSoldParams_View AS Object_ReportSoldParams
                                                             ON Object_Unit.Id = Object_ReportSoldParams.UnitId
                                                            AND Object_ReportSoldParams.PlanDate = date_trunc('month', inPlanDate)::TDateTime
            ORDER BY
                UnitName;
    ELSE
        RETURN QUERY
            SELECT
                Object_ReportSoldParams.Id         AS Id
               ,Object_ReportSoldParams.UnitId     AS UnitId
               ,Object_ReportSoldParams.UnitCode   AS UnitCode
               ,Object_ReportSoldParams.UnitName   AS UnitName
               ,Object_ReportSoldParams.PlanDate   AS PlanDate
               ,Object_ReportSoldParams.PlanAmount AS PlanAmount
            FROM 
                Object_ReportSoldParams_View AS Object_ReportSoldParams
            WHERE
                Object_ReportSoldParams.PlanDate = date_trunc('month', inPlanDate)::TDateTime
            ORDER BY
                UnitName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReportSoldParams(TDateTime, Boolean, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�. 
 29.08.15                                                         *
*/